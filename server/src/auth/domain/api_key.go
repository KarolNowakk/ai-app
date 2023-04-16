package domain

import (
	"context"
)

type (
	APIKey struct {
		Key    string
		UserID int64
	}

	APIKeyAdapter interface {
		CreateNew(ctx context.Context, key APIKey) error
		Verify(ctx context.Context, key string) (APIKey, error)
	}
)
