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
build-all: build-backend build-backend-tor build-backend-playwright build-bff build-frontend

# Dockerイメージをプッシュする
push-all: push-backend push-backend-tor push-backend-playwright push-bff push-frontend

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
# backend-tor
#

backend_tor_tag := $(registry)/$(project)-backend-tor:$(tag_suffix)

build-backend-tor:
	docker build \
	-t $(backend_tor_tag) \
	-f containers/backend_tor/Dockerfile.prod volumes/backend_tor

push-backend-tor:
	docker push $(backend_tor_tag)

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
# bff
#

bff_tag := $(registry)/$(project)-bff:$(tag_suffix)

build-bff:
	docker build \
	-t $(bff_tag) \
	-f containers/bff/Dockerfile.prod volumes/bff

push-bff:
	docker push $(bff_tag)

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
