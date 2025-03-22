package config

import (
	"os"
)

type Config struct {
	DBUrl string
}

func LoadConfig() *Config {
	return &Config{
		DBUrl: os.Getenv("DATABASE_URL"),
	}
}
