package application

import (
	"net/url"
)

type (
	OAuthAdapter interface {
		GetAuthorizationURL() (*url.URL, error)
		GetAccessToken(code, state string) (string, error)
		GetUser(accessToken string) (string, error)
	}
)
