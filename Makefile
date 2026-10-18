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
build-all: build-backend build-backend-playwright build-backend-camoufox build-frontend build-auth-provider

# Dockerイメージをプッシュする
push-all: push-backend push-backend-playwright push-backend-camoufox push-frontend push-auth-provider

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
# camoufox
#

backend_camoufox_tag := $(registry)/$(project)-backend-camoufox-$(environment):$(tag_suffix)
backend_camoufox_dockerfile := containers/backend_camoufox/Dockerfile.$(environment)

build-backend-camoufox:
	docker build \
	-t $(backend_camoufox_tag) \
	-f $(backend_camoufox_dockerfile) .

push-backend-camoufox:
	docker push $(backend_camoufox_tag)

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

#
# auth-provider
#

auth_provider_tag := $(registry)/auth-provider-backend-$(environment):$(tag_suffix)
auth_provider_dockerfile := containers/auth-provider/Dockerfile.$(environment)

build-auth-provider:
	docker build \
	-t $(auth_provider_tag) \
	-f $(auth_provider_dockerfile) volumes/auth-provider

push-auth-provider:
	docker push $(auth_provider_tag)
