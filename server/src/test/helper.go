package test

import (
	"context"

	"app1/src/app/application"
	"app1/src/auth/domain"
)

var TestApiKey = "dfunascknads989c9239uno2xnx389218xz3u2n3xscams9-12s"

type (
	AppForTest struct {
		App         *application.App
		Initializer *DBInitializer
	}

	DBInitializer struct {
		keyAdapter  domain.APIKeyAdapter
		userAdapter domain.UserAdapter
	}
)

func ProviderAppForTest(app *application.App, initializer *DBInitializer) *AppForTest {
	return &AppForTest{app, initializer}
}

func ProviderDBInitializer(keyAdapter domain.APIKeyAdapter, userAdapter domain.UserAdapter) *DBInitializer {
	return &DBInitializer{
		keyAdapter:  keyAdapter,
		userAdapter: userAdapter,
	}
}

func (i *DBInitializer) Init() {
	user := domain.User{
		Email:    "kasdodaks",
		Provider: "test",
	}

	user, err := i.userAdapter.CreateIfNotExist(context.Background(), user)
	if err != nil {
		panic("error creating user: " + err.Error())
	}

	key := domain.APIKey{
		Key:    TestApiKey,
		UserID: user.ID,
	}

	err = i.keyAdapter.CreateNew(context.Background(), key)
	if err != nil {
		panic("error creating user: " + err.Error())
	}
}
