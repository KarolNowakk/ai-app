package http

import (
	"github.com/google/wire"

	"app1/src/auth"
	"app1/src/exercises"
	"app1/src/http/domain"
	"app1/src/http/interfaces"
	"app1/src/words"
)

var Set = wire.NewSet(
	ProvideAllControllers,
	interfaces.ProvideAuthMiddleware,
)

func ProvideAllControllers(
	authRoutes *auth.Routes,
	exercisesRoutes *exercises.Routes,
	wordsRoutes *words.Routes,

) []domain.Controller {
	return []domain.Controller{
		authRoutes,
		exercisesRoutes,
		wordsRoutes,
	}
}
