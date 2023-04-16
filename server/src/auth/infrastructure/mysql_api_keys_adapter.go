package infrastructure

import (
	"context"
	"database/sql"

	"app1/src/auth/domain"
	"app1/src/db/infrastructure"
)

const (
	createAPIKeyQuery      = "INSERT INTO api_keys (`key`, user_id) VALUES (?, ?)"
	findAPIKeyByValueQuery = "SELECT `key`, user_id FROM api_keys WHERE `key` = ?"
)

type MySQLAPIKeyAdapter struct {
	db      *sql.DB
	manager infrastructure.ConnManager
}

func ProvideAPIKeyAdapter(manager infrastructure.ConnManager) domain.APIKeyAdapter {
	adapter := &MySQLAPIKeyAdapter{manager: manager}
	var err error
	adapter.db, err = manager.GetConnection()
	if err != nil {
		panic("database connection error: " + err.Error())
	}

	return adapter
}

func (a *MySQLAPIKeyAdapter) CreateNew(ctx context.Context, key domain.APIKey) error {
	_, err := a.db.ExecContext(ctx, createAPIKeyQuery, key.Key, key.UserID)
	return err
}

func (a *MySQLAPIKeyAdapter) Verify(ctx context.Context, keyValue string) (domain.APIKey, error) {
	var apiKey domain.APIKey
	err := a.db.QueryRowContext(ctx, findAPIKeyByValueQuery, keyValue).Scan(&apiKey.Key, &apiKey.UserID)
	if err != nil {
		return domain.APIKey{}, err
	}
	return apiKey, nil
}
