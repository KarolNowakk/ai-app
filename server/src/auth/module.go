package auth

import (
	"net/http"

	"github.com/google/wire"

	"app1/src/auth/infrastructure"
	interfaces2 "app1/src/auth/interfaces"
	"app1/src/http/domain"
)

var Set = wire.NewSet(
	infrastructure.ProvideAuthService,
	infrastructure.ProvideOAuthAdapter,
	infrastructure.ProvideUserAdapter,
	infrastructure.ProvideAPIKeyAdapter,

	interfaces2.ProvideOAuthController,
	interfaces2.ProvideAPIKeyController,

	ProvideRoutes,
)

var _ domain.Controller = &Routes{}

type Routes struct {
	authController   *interfaces2.OAuthController
	apiKeyController *interfaces2.APIKeyController
}

func ProvideRoutes(authController *interfaces2.OAuthController, apiKeyController *interfaces2.APIKeyController) *Routes {
	return &Routes{
		authController:   authController,
		apiKeyController: apiKeyController,
	}
}

func (r *Routes) RegisterRoutes(mux *http.ServeMux) *http.ServeMux {
	mux.HandleFunc("/github/authorize", r.authController.Authorize)
	mux.HandleFunc("/github/callback", r.authController.Callback)

	mux.HandleFunc("/key/createpage", r.apiKeyController.RenderCreatePage)
	mux.HandleFunc("/key/create", r.apiKeyController.CreateAPIKey)

	return mux
}
