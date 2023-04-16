package exercises

import (
	"net/http"

	"github.com/google/wire"

	"app1/src/exercises/infrastructure"
	"app1/src/exercises/interfaces"
	httpInterfaces "app1/src/http/interfaces"
)

var Set = wire.NewSet(
	infrastructure.ProvideExerciseAdapter,
	interfaces.ProvideExercisesController,

	ProvideExercisesRoutes,
)

type Routes struct {
	c  *interfaces.Controller
	am *httpInterfaces.AuthMiddleware
}

func ProvideExercisesRoutes(
	viewController *interfaces.Controller,
	authMiddleware *httpInterfaces.AuthMiddleware,
) *Routes {
	return &Routes{c: viewController, am: authMiddleware}
}

func (r *Routes) RegisterRoutes(mux *http.ServeMux) *http.ServeMux {
	mux.Handle("/exercises/all", r.am.WithAuth(r.c.GetAll))
	mux.Handle("/exercises/create", r.am.WithAuth(r.c.Create))
	mux.Handle("/exercises/delete/", r.am.WithAuth(r.c.Delete))
	mux.Handle("/exercises/update", r.am.WithAuth(r.c.Update))

	return mux
}
