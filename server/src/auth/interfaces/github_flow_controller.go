package interfaces

import (
	"net/http"
	"time"

	"app1/src/auth/application"
	"app1/src/auth/domain"
)

type OAuthController struct {
	adapter     application.OAuthAdapter
	userAdapter domain.UserAdapter
}

func ProvideOAuthController(adapter application.OAuthAdapter, userAdapter domain.UserAdapter) *OAuthController {
	return &OAuthController{
		adapter:     adapter,
		userAdapter: userAdapter,
	}
}

func (c *OAuthController) Authorize(w http.ResponseWriter, r *http.Request) {
	authURL, err := c.adapter.GetAuthorizationURL()
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}

	http.Redirect(w, r, authURL.String(), http.StatusFound)
}

func (c *OAuthController) Callback(w http.ResponseWriter, r *http.Request) {
	code := r.URL.Query().Get("code")
	state := r.URL.Query().Get("state")

	accessToken, err := c.adapter.GetAccessToken(code, state)
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}

	email, err := c.adapter.GetUser(accessToken)
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}

	user := domain.User{Provider: domain.GithubProvider, Email: email}
	user, err = c.userAdapter.CreateIfNotExist(r.Context(), user)
	if err != nil {
		internalServerErrorResponse(w, err.Error())
		return
	}

	simpleSession[accessToken] = user
	SetSessionCookie(accessToken, w)

	successResponse(w, accessToken)
}

func unauthorizedResponse(w http.ResponseWriter, errMsg string) {
	w.WriteHeader(http.StatusUnauthorized)
	w.Write([]byte(errMsg))
}

func internalServerErrorResponse(w http.ResponseWriter, errMsg string) {
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(errMsg))
}

func successResponse(w http.ResponseWriter, body string) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(body))
}

func SetSessionCookie(key string, w http.ResponseWriter) {
	cookie := http.Cookie{
		Name:    "ses",
		Path:    "/",
		Expires: time.Now().Add(24 * time.Hour),
		Value:   key,
	}

	http.SetCookie(w, &cookie)
}
