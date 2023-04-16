package infrastructure

import (
	"context"

	"app1/src/auth/domain"
)

var _ AuthService = &DefaultAuthService{}

type (
	AuthService interface {
		GetUserID(ctx context.Context, token string) (int64, error)
	}

	DefaultAuthService struct {
		adapter domain.APIKeyAdapter
	}
)

func ProvideAuthService(adapter domain.APIKeyAdapter) AuthService {
	return &DefaultAuthService{adapter: adapter}
}

func (d *DefaultAuthService) GetUserID(ctx context.Context, token string) (int64, error) {
	key, err := d.adapter.Verify(ctx, token)
	if err != nil {
		return 0, err
	}

	return key.UserID, nil
}
