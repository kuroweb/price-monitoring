package config

import "os"

type Config struct {
	Port          string
	AllowedOrigin string
	BackendUrl    string
}

func NewConfig() Config {
	return Config{
		Port:          port(),
		AllowedOrigin: allowedOrigin(),
		BackendUrl:    backendUrl(),
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
		allowedOrigin = "localhost"
	}

	return allowedOrigin
}

func backendUrl() string {
	backendUrl := os.Getenv("BACKEND_URL")
	if backendUrl == "" {
		backendUrl = "http://backend:3000"
	}

	return backendUrl
}
