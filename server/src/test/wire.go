//go:build wireinject
// +build wireinject

package test

import (
	"github.com/google/wire"

	"app1/src/app/application"
	"app1/src/auth"
	"app1/src/db"
	"app1/src/exercises"
	http2 "app1/src/http"
	"app1/src/words"
)

func InitializeDependencyInjection() (*AppForTest, error) {
	wire.Build(
		auth.Set,
		db.Set,
		exercises.Set,
		http2.Set,
		words.Set,
		application.NewApp,
		ProviderDBInitializer,
		ProviderAppForTest,
	)
	return &AppForTest{}, nil
}
