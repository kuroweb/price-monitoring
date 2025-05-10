# ArgoCDによるGitOps用のMakefile

#
# config
#

registry := registry.local:5000
project := price-monitoring
tag_suffix := $(shell git rev-parse --short HEAD)

#
# util
#

# すべて実行する
all: build-all push-all

# Dockerイメージをビルドする
build-all: build-backend build-backend-playwright build-frontend build-auth-provider

# Dockerイメージをプッシュする
push-all: push-backend push-backend-playwright push-frontend push-auth-provider

#
# backend
#

backend_tag := $(registry)/$(project)-backend:$(tag_suffix)

build-backend:
	docker build \
	-t $(backend_tag) \
	-f containers/backend/Dockerfile.prod volumes/backend

push-backend:
	docker push $(backend_tag)

#
# playwright
#

backend_playwright_tag := $(registry)/$(project)-backend-playwright:$(tag_suffix)

build-backend-playwright:
	docker build \
	-t $(backend_playwright_tag) \
	-f containers/backend_playwright/Dockerfile .

push-backend-playwright:
	docker push $(backend_playwright_tag)

#
# frontend
#

frontend_tag := $(registry)/$(project)-frontend:$(tag_suffix)

build-frontend:
	docker build \
	-t $(frontend_tag) \
	-f containers/frontend/Dockerfile.prod volumes/frontend

push-frontend:
	docker push $(frontend_tag)

#
# auth-provider
#

auth_provider_tag := $(registry)/$(project)-auth-provider:$(tag_suffix)

build-auth-provider:
	docker build \
	-t $(auth_provider_tag) \
	-f containers/auth_provider/Dockerfile.prod volumes/auth_provider

push-auth-provider:
	docker push $(auth_provider_tag)
