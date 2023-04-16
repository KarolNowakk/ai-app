package db

import (
	"github.com/google/wire"

	"app1/src/db/application"
	"app1/src/db/infrastructure"
)

var Set = wire.NewSet(
	infrastructure.ProvideConnManager,
	application.ProvideMysqlMigrate,
)
