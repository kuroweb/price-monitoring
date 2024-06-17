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
build-all: build-backend build-backend-playwright build-frontend

# Dockerイメージをプッシュする
push-all: push-backend push-backend-playwright push-frontend

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
