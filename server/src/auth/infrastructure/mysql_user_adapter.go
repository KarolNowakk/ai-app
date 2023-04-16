package infrastructure

import (
	"context"
	"database/sql"

	"app1/src/auth/domain"
	"app1/src/db/infrastructure"
)

const (
	findByEmailQuery = "SELECT id, email, provider FROM users WHERE email = ?"
	createUserQuery  = "INSERT INTO users (email, provider) VALUES (?, ?)"
)

type MySQLUserAdapter struct {
	db      *sql.DB
	manager infrastructure.ConnManager
}

func ProvideUserAdapter(manager infrastructure.ConnManager) domain.UserAdapter {
	adapter := &MySQLUserAdapter{manager: manager}
	var err error
	adapter.db, err = manager.GetConnection()
	if err != nil {
		panic("database connection error: " + err.Error())
	}

	return adapter
}

func (a *MySQLUserAdapter) CreateIfNotExist(ctx context.Context, user domain.User) (domain.User, error) {
	var existingUser domain.User

	err := a.db.QueryRow(findByEmailQuery, user.Email).Scan(&existingUser.ID, &existingUser.Email, &existingUser.Provider)

	switch {
	case err == sql.ErrNoRows:
		res, insertErr := a.db.ExecContext(ctx, createUserQuery, user.Email, user.Provider)
		if insertErr != nil {
			return domain.User{}, insertErr
		}
		lastInsertID, idErr := res.LastInsertId()
		if idErr != nil {
			return domain.User{}, idErr
		}
		user.ID = lastInsertID
		return user, nil
	case err != nil:
		return domain.User{}, err
	default:
		return existingUser, nil
	}
}
