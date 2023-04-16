package application

import (
	"database/sql"
	"fmt"

	"github.com/pressly/goose"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"

	"app1/src/db/infrastructure"
)

type (
	// MySQLMigration creates new tables
	MySQLMigration struct {
		connManager  infrastructure.ConnManager
		migrationDir string
	}
)

// ProvideMysqlMigrate provides a MySQLMigration instance
func ProvideMysqlMigrate(connManager infrastructure.ConnManager) *MySQLMigration {
	migrationDir := viper.GetString("db.migration.dir")
	return &MySQLMigration{
		connManager:  connManager,
		migrationDir: migrationDir,
	}
}

// ExecuteMigration runs database upgrades
func (migration *MySQLMigration) ExecuteMigration() error {
	database, err := migration.connManager.GetConnection()
	if err != nil {
		return logAndWrapError("failed to migrate database", "migrate", err)
	}
	defer func(db *sql.DB) {
		//_ = db.Close()
	}(database)
	if err := goose.SetDialect("mysql"); err != nil {
		return logAndWrapError("failed to migrate database", "migrate", err)
	}

	if err := goose.Up(database, migration.migrationDir); err != nil {
		return logAndWrapError("migration error", "migrate", err)
	}

	return nil
}

func logAndWrapError(message, field string, err error) error {
	wrappedErr := fmt.Errorf("%s: %w", message, err)
	logrus.WithField("service", field).Error(wrappedErr.Error())
	return wrappedErr
}
