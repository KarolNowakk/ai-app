//go:build wireinject
// +build wireinject

package main

import (
	"github.com/google/wire"

	"app1/src/app/application"
	"app1/src/auth"
	"app1/src/db"
	"app1/src/exercises"
	http2 "app1/src/http"
	"app1/src/words"
)

func InitializeDependencyInjection() (*application.App, error) {
	wire.Build(
		auth.Set,
		db.Set,
		exercises.Set,
		words.Set,
		http2.Set,
		application.NewApp,
	)
	return &application.App{}, nil
}
