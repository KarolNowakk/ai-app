package test_test

//go:generate go run github.com/google/wire/cmd/wire@v0.5.0

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"testing"

	"github.com/spf13/viper"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/wait"

	"app1/src/app/application"
	"app1/src/test"
)

// TestMain used for setup and teardown
func TestMain(m *testing.M) {
	dbCleanUp, dbHost, dbPort := startUpDockerMySQL()

	setUpConfig(dbHost, dbPort)

	testApp, err := test.InitializeDependencyInjection()
	if err != nil {
		log.Fatalf("Error initializing dependencies: %v", err)
	}

	testApp.App.Start()
	testApp.App.SetupServeMux()

	// init db user and key for api calls
	testApp.Initializer.Init()

	port := viper.GetString("server.port")

	go func(app1 *application.App) {
		fmt.Printf("Starting server on port %s...\n", port)
		err = http.ListenAndServe(port, app1.GetRouter())
		if err != nil {
			fmt.Printf("Error starting server: %v\n", err)
		}
	}(testApp.App)

	result := m.Run()

	dbCleanUp()

	os.Exit(result)
}

func startUpDockerMySQL() (func(), string, string) {
	ctx := context.Background()
	req := testcontainers.ContainerRequest{
		Image:        "mysql:8.0",
		ExposedPorts: []string{"3306/tcp"},
		Env: map[string]string{
			"MYSQL_ROOT_PASSWORD": "root",
			"MYSQL_DATABASE":      "maindb",
		},
		WaitingFor: wait.ForAll(
			wait.ForLog("port: 3306  MySQL Community Server - GPL"),
			wait.ForListeningPort("3306/tcp"),
		),
	}

	mySQL, err := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: req,
		Started:          true,
	})
	if err != nil {
		panic(err)
	}

	port, err := mySQL.MappedPort(ctx, "3306")
	if err != nil {
		panic(err)
	}

	host, err := mySQL.Host(ctx)
	if err != nil {
		panic(err)
	}

	return func() { _ = mySQL.Terminate(ctx) }, host, port.Port()
}

func setUpConfig(dbHost, dbPort string) {
	viper.Set("server.port", ":3322")
	viper.Set("db.name", "maindb")
	viper.Set("db.user", "root")
	viper.Set("db.pass", "root")
	viper.Set("db.host", dbHost)
	viper.Set("db.port", dbPort)
	viper.Set("db.migration.run", true)
	viper.Set("db.migration.dir", "../../migrations")
	viper.Set("auth.github.authurl", "")
	viper.Set("auth.github.clientid", "")
	viper.Set("auth.github.clientsecret", "")
	viper.Set("auth.github.redirecturl", "")
	viper.Set("auth.github.tokenurl", "")
	viper.Set("auth.github.apibaseurl", "")
}
