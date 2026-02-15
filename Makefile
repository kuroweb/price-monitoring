# ArgoCDによるGitOps用のMakefile

#
# config
#

registry := docker-registry.kuroweb.net
project := price-monitoring
tag_suffix := $(shell git rev-parse --short HEAD)
environment ?= production

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

backend_tag := $(registry)/$(project)-backend-$(environment):$(tag_suffix)
backend_dockerfile := containers/backend/Dockerfile.$(environment)

build-backend:
	docker build \
	-t $(backend_tag) \
	-f $(backend_dockerfile) volumes/backend

push-backend:
	docker push $(backend_tag)

#
# playwright
#

backend_playwright_tag := $(registry)/$(project)-backend-playwright-$(environment):$(tag_suffix)
backend_playwright_dockerfile := containers/backend_playwright/Dockerfile.$(environment)

build-backend-playwright:
	docker build \
	-t $(backend_playwright_tag) \
	-f $(backend_playwright_dockerfile) .

push-backend-playwright:
	docker push $(backend_playwright_tag)

#
# frontend
#

frontend_tag := $(registry)/$(project)-frontend-$(environment):$(tag_suffix)
frontend_dockerfile := containers/frontend/Dockerfile.$(environment)

build-frontend:
	docker build \
	-t $(frontend_tag) \
	-f $(frontend_dockerfile) volumes/frontend

push-frontend:
	docker push $(frontend_tag)
