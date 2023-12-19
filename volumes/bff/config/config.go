package config

import "os"

type Config struct {
	Port          string
	AllowedOrigin string
}

func NewConfig() Config {
	return Config{
		Port:          port(),
		AllowedOrigin: allowedOrigin(),
	}
}

func port() string {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	return port
}

func allowedOrigin() string {
	allowedOrigin := os.Getenv("ALLOWED_ORIGIN")
	if allowedOrigin == "" {
		allowedOrigin = "http://localhost:8080"
	}

	return allowedOrigin
}

