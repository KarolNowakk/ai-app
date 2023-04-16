package application

import (
	"net/http"

	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"

	"app1/src/db/application"
	"app1/src/http/domain"
)

type (
	App struct {
		controllers   []domain.Controller
		migrations    *application.MySQLMigration
		mux           *http.ServeMux
		runMigrations bool
	}
)

func NewApp(controllers []domain.Controller, migrations *application.MySQLMigration) *App {
	return &App{
		mux:           http.NewServeMux(),
		controllers:   controllers,
		migrations:    migrations,
		runMigrations: viper.GetBool("db.migration.run"),
	}
}

func (a *App) Start() {
	if a.runMigrations {
		err := a.migrations.ExecuteMigration()
		if err != nil {
			logrus.Fatal("error running db migrations: " + err.Error())
		}
	}
}

func (a *App) SetupServeMux() {
	for _, controller := range a.controllers {
		a.mux = controller.RegisterRoutes(a.mux)
	}
}

func (a *App) GetRouter() *http.ServeMux {
	return a.mux
}
