package interfaces

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"html/template"
	"net/http"
	"time"

	"app1/src/auth/application"
	"app1/src/auth/domain"
)

type APIKeyController struct {
	adapter     domain.APIKeyAdapter
	authAdapter application.OAuthAdapter
}

var simpleSession = map[string]domain.User{}

var tmpl = template.Must(template.New("createApiKey").Parse(`
<!DOCTYPE html>
<html>
<head>
	<title>Create API Key</title>
</head>
<body>
	<form method="POST" action="/key/create">
		<button type="submit">Generate API Key</button>
	</form>
</body>
</html>
`))

func ProvideAPIKeyController(adapter domain.APIKeyAdapter, authAdapter application.OAuthAdapter) *APIKeyController {
	c := new(APIKeyController)
	c.adapter = adapter
	c.authAdapter = authAdapter

	return c
}

func (c *APIKeyController) RenderCreatePage(w http.ResponseWriter, r *http.Request) {
	_, err := c.auth(r)
	if err != nil {
		unauthorizedResponse(w, err.Error())
		return
	}

	err = tmpl.Execute(w, nil)
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}
}

func (c *APIKeyController) CreateAPIKey(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	user, err := c.auth(r)
	if err != nil {
		unauthorizedResponse(w, err.Error())
		return
	}

	// Generate a new API key
	apiKey, err := generateAPIKey(32)
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}

	// Save the API key using the adapter
	err = c.adapter.CreateNew(ctx, domain.APIKey{Key: apiKey, UserID: user.ID})
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}

	successResponse(w, "your api key is: "+apiKey)
}

func generateAPIKey(length int) (string, error) {
	keyBytes := make([]byte, length)
	_, err := rand.Read(keyBytes)
	if err != nil {
		return "", err
	}

	return base64.URLEncoding.EncodeToString(keyBytes), nil
}

type Res struct {
	tmpl *template.Template
}

func (r *Res) Apply(c context.Context, w http.ResponseWriter) error {
	return r.tmpl.Execute(w, nil)
}

type KeyRes struct {
	key string
}

func (r *KeyRes) Apply(c context.Context, w http.ResponseWriter) error {
	cookie := http.Cookie{
		Name:    "ses",
		Path:    "/",
		Expires: time.Now().Add(24 * time.Hour),
		Value:   r.key,
	}

	http.SetCookie(w, &cookie)

	return nil
}

func (c *APIKeyController) auth(r *http.Request) (domain.User, error) {
	keyCookie, err := r.Cookie("ses")
	if err != nil {
		return domain.User{}, err
	}
	_ = keyCookie

	_, err = c.authAdapter.GetUser(keyCookie.Value)
	if err != nil {
		return domain.User{}, err
	}

	user, ok := simpleSession[keyCookie.Value]
	if !ok {
		return domain.User{}, errors.New("user not found")
	}

	return user, nil
}
