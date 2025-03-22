package db

import (
	"github.com/abdusss111/go-user-service_test-task/config"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"log"
)

var DB *sqlx.DB

func InitDB(cfg *config.Config) {
	var err error
	DB, err = sqlx.Connect("postgres", cfg.DBUrl)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
}
