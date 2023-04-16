package domain

import (
	"context"
)

const GithubProvider = "github"

type (
	User struct {
		ID       int64
		Email    string
		Provider string
	}

	UserAdapter interface {
		CreateIfNotExist(ctx context.Context, user User) (User, error)
	}
)
