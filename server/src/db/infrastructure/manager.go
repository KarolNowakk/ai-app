package infrastructure

import (
	"database/sql"
	"fmt"
	"sync"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

type (
	ConnManager interface {
		GetConnection() (*sql.DB, error)
		Close() error
	}

	// MySQLConnManager implements the ConnManager
	MySQLConnManager struct {
		mysqlConfig MySQLConfig
		mu          sync.RWMutex
		db          *sql.DB
	}

	MySQLConfig struct {
		user     string
		password string
		host     string
		port     string
		dbName   string
		maxIdle  int
		maxOpen  int
	}
)

var (
	defaultMaxIdleTime = 3 * time.Minute
	maxConnections     = 10
)

func ProvideConnManager() ConnManager {
	manager := new(MySQLConnManager)
	user := viper.GetString("db.user")
	password := viper.GetString("db.pass")
	host := viper.GetString("db.host")
	port := viper.GetString("db.port")
	dbName := viper.GetString("db.name")

	manager.mysqlConfig = MySQLConfig{
		user:     user,
		password: password,
		host:     host,
		port:     port,
		dbName:   dbName,
	}

	return manager
}

func (m *MySQLConnManager) GetConnection() (*sql.DB, error) {
	m.mu.RLock()
	if m.db != nil {
		err := m.db.Ping()
		if err == nil {
			defer m.mu.RUnlock()

			return m.db, nil
		}
	}

	m.mu.RUnlock()
	m.mu.Lock()
	defer m.mu.Unlock()

	db, err := m.createConnection()
	if err != nil {
		m.db = nil

		return nil, fmt.Errorf("failed to open database connection: %w", err)
	}

	m.db = db

	return m.db, nil
}

func (m *MySQLConnManager) createConnection() (*sql.DB, error) {
	db, err := sql.Open("mysql", m.mysqlConfig.connectionString())
	if err != nil {
		return nil, fmt.Errorf("failed to open database connection: %w", err)
	}

	db.SetConnMaxIdleTime(defaultMaxIdleTime)
	db.SetMaxIdleConns(maxConnections)

	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("failed to open database connection: %w", err)
	}

	return db, nil
}

// Close the db connection
func (m *MySQLConnManager) Close() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.db == nil {
		// no db connection to close
		return nil
	}

	logrus.WithField("service", "MySQLConnManager").Info("closing db connection")

	err := m.db.Close()
	if err != nil {
		logrus.WithField("service", "MySQLConnManager").Error("error closing the db connection")

		return fmt.Errorf("failed to close db connection: %w", err)
	}

	return nil
}

// provideMySQLConfig generates mysql configuration
func (mc MySQLConfig) provideMySQLConfig() mysql.Config {
	return mysql.Config{
		User:                    mc.user,
		Passwd:                  mc.password,
		Net:                     "tcp",
		Addr:                    fmt.Sprintf("%s:%s", mc.host, mc.port),
		DBName:                  mc.dbName,
		AllowCleartextPasswords: true,
		AllowNativePasswords:    true,
	}
}

// connectionString generates mysql connection string
func (mc MySQLConfig) connectionString() string {
	config := mc.provideMySQLConfig()
	config.ParseTime = true
	config.ParseTime = true

	return config.FormatDSN()
}

//
//import (
//	"database/sql"
//	"fmt"
//	"sync"
//	"time"
//
//	"github.com/go-sql-driver/mysql"
//	"github.com/sirupsen/logrus"
//	"github.com/spf13/viper"
//)
//
//type (
//	ConnectionManager interface {
//		GetConnection() (*sql.DB, error)
//		Close() error
//	}
//
//	// MySQLManager implements the ConnectionManager
//	MySQLManager struct {
//		mysqlConfig MysqlConfig
//		mu          sync.RWMutex
//		db          *sql.DB
//	}
//
//	MysqlConfig struct {
//		user     string
//		password string
//		host     string
//		port     string
//		dbName   string
//		maxIdle  int
//		maxOpen  int
//	}
//)
//
//var (
//	defaultMaxIdleTime = 3 * time.Minute
//	maxConnections     = 10
//)
//
//func ProvideConnectionManager() ConnectionManager {
//	manager := new(MySQLManager)
//	user := viper.GetString("db.user")
//	password := viper.GetString("db.pass")
//	host := viper.GetString("db.host")
//	port := viper.GetString("db.port")
//	dbName := viper.GetString("db.name")
//
//	manager.mysqlConfig = MysqlConfig{
//		user:     user,
//		password: password,
//		host:     host,
//		port:     port,
//		dbName:   dbName,
//	}
//
//	return manager
//}
//
//func (m *MySQLManager) GetConnection() (*sql.DB, error) {
//	m.mu.RLock()
//
//	if m.db != nil {
//		err := m.db.Ping()
//		if err == nil {
//			defer m.mu.RUnlock()
//
//			return m.db, nil
//		}
//	}
//
//	m.mu.RUnlock()
//	m.mu.Lock()
//	defer m.mu.Unlock()
//
//	db, err := m.makeNewConnection()
//	if err != nil {
//		m.db = nil
//
//		return nil, fmt.Errorf("failed to open database connection: %w", err)
//	}
//
//	m.db = db
//
//	return m.db, nil
//}
//
//func (m *MySQLManager) makeNewConnection() (*sql.DB, error) {
//	db, err := sql.Open("mysql", m.mysqlConfig.connectionString())
//	if err != nil {
//		return nil, fmt.Errorf("failed to open database connection: %w", err)
//	}
//
//	db.SetConnMaxIdleTime(defaultMaxIdleTime)
//	db.SetMaxIdleConns(maxConnections)
//
//	err = db.Ping()
//	if err != nil {
//		return nil, fmt.Errorf("failed to open database connection: %w", err)
//	}
//
//	return db, nil
//}
//
//// Close the db connection
//func (m *MySQLManager) Close() error {
//	m.mu.Lock()
//	defer m.mu.Unlock()
//
//	if m.db == nil {
//		// no db connection to close
//		return nil
//	}
//
//	logrus.WithField("service", "MySQLManager").Info("closing db connection")
//
//	err := m.db.Close()
//	if err != nil {
//		logrus.WithField("service", "MySQLManager").Error("error closing the db connection")
//
//		return fmt.Errorf("failed to close db connection: %w", err)
//	}
//
//	return nil
//}
//
//// DSN generates mysql connectionString
//func (mc MysqlConfig) provideConfig() mysql.Config {
//	return mysql.Config{
//		User:                    mc.user,
//		Passwd:                  mc.password,
//		Net:                     "tcp",
//		Addr:                    fmt.Sprintf("%s:%s", mc.host, mc.port),
//		DBName:                  mc.dbName,
//		AllowCleartextPasswords: true,
//		AllowNativePasswords:    true,
//	}
//}
//
//// connectionString generates mysql connection string
//func (mc MysqlConfig) connectionString() string {
//	config := mc.provideConfig()
//	config.ParseTime = true
//
//	a := config.FormatDSN()
//
//	return a
//}
