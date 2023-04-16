package words

import (
	"net/http"

	"github.com/google/wire"

	httpInterfaces "app1/src/http/interfaces"
	"app1/src/words/infrastructure"
	"app1/src/words/interfaces"
)

var Set = wire.NewSet(
	infrastructure.ProvideMySQLWordAdapter,
	interfaces.ProvideWordController,
	ProvideRoutes,
)

type Routes struct {
	c  *interfaces.Controller
	am *httpInterfaces.AuthMiddleware
}

func ProvideRoutes(
	viewController *interfaces.Controller,
	authMiddleware *httpInterfaces.AuthMiddleware,
) *Routes {
	return &Routes{c: viewController, am: authMiddleware}
}

func (r *Routes) RegisterRoutes(mux *http.ServeMux) *http.ServeMux {
	mux.Handle("/words/all", r.am.WithAuth(r.c.GetAll))
	mux.Handle("/words/create", r.am.WithAuth(r.c.Create))
	mux.Handle("/words/delete/", r.am.WithAuth(r.c.Delete))
	mux.Handle("/words/update", r.am.WithAuth(r.c.Update))

	return mux
}
