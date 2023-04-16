package main

//go:generate go run github.com/google/wire/cmd/wire@v0.5.0

import (
	"fmt"
	"log"
	"net/http"

	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"

	"app1/src/app/application"
)

func main() {
	application.LoadConfig()

	app, err := InitializeDependencyInjection()
	if err != nil {
		log.Fatalf("Error initializing dependencies: %v", err)
	}

	logrus.SetLevel(logrus.InfoLevel)
	logrus.SetFormatter(&logrus.TextFormatter{
		FullTimestamp: true,
	})

	app.Start()
	app.SetupServeMux()

	port := viper.GetString("server.port")
	fmt.Printf("Starting server on port %s...\n", port)
	err = http.ListenAndServe(port, app.GetRouter())
	if err != nil {
		fmt.Printf("Error starting server: %v\n", err)
	}
}
