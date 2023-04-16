package infrastructure

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"errors"
	"io"
	"log"
	"net/http"
	"net/url"

	"github.com/spf13/viper"

	"app1/src/auth/application"
)

var (
	// state -> will fix this later
	state = ""
)

type (
	OAuthGithubAdapter struct {
		client           *http.Client
		authorizationURL string
		clientID         string
		redirectURL      string
		clientSecret     string
		tokenURL         string
		apiBaseURL       string
	}
)

func ProvideOAuthAdapter() application.OAuthAdapter {
	authurl := viper.GetString("auth.github.authurl")
	clientid := viper.GetString("auth.github.clientid")
	clientsecret := viper.GetString("auth.github.clientsecret")
	tokenurl := viper.GetString("auth.github.tokenurl")
	apibaseurl := viper.GetString("auth.github.apibaseurl")
	redirecturl := viper.GetString("auth.github.redirecturl")

	return &OAuthGithubAdapter{
		authorizationURL: authurl,
		clientID:         clientid,
		redirectURL:      redirecturl,
		clientSecret:     clientsecret,
		tokenURL:         tokenurl,
		apiBaseURL:       apibaseurl,
		client:           http.DefaultClient,
	}
}

func (a *OAuthGithubAdapter) GetAuthorizationURL() (*url.URL, error) {
	authURL, err := url.Parse(a.authorizationURL)
	if err != nil {
		return nil, err
	}

	state = generateState()

	query := authURL.Query()
	query.Set("client_id", a.clientID)
	query.Set("redirect_uri", a.redirectURL)
	query.Set("state", state)
	query.Set("allow_signup", "true")
	authURL.RawQuery = query.Encode()

	return authURL, nil
}

func (a *OAuthGithubAdapter) GetAccessToken(code, stateFromResp string) (string, error) {
	if stateFromResp != state {
		return "", errors.New("invalid state")
	}

	data := url.Values{}
	data.Set("client_id", a.clientID)
	data.Set("client_secret", a.clientSecret)
	data.Set("code", code)
	data.Set("redirect_uri", a.redirectURL)

	parsedURL, err := url.Parse(a.tokenURL)
	if err != nil {
		return "", err
	}
	parsedURL.RawQuery = data.Encode()

	req, err := http.NewRequest("POST", parsedURL.String(), nil)
	if err != nil {
		return "", err
	}

	// Set the content type and accept headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	// Execute the request
	resp, err := a.client.Do(req)
	if err != nil {
		return "", err
	}

	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	tokenResponse := struct {
		AccessToken string `json:"access_token"`
	}{}

	err = json.Unmarshal(body, &tokenResponse)
	if err != nil {
		return "", err
	}

	return tokenResponse.AccessToken, nil
}

func (a *OAuthGithubAdapter) GetUser(accessToken string) (string, error) {
	req, err := http.NewRequest("GET", a.apiBaseURL+"/user", nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("Authorization", "Bearer "+accessToken)

	resp, err := a.client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", errors.New("failed to fetch user information")
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	type User struct {
		Login string `json:"login"`
	}

	user := &User{}
	err = json.Unmarshal(body, &user)
	if err != nil {
		return "", err
	}

	return user.Login, nil
}

func generateState() string {
	bytes := make([]byte, 32)
	_, err := rand.Read(bytes)
	if err != nil {
		log.Fatalf("Error generating state: %v", err)
	}
	return base64.URLEncoding.EncodeToString(bytes)
}
