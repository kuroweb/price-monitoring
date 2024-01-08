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
build-all: build-backend build-tor build-playwright build-bff build-frontend

# Dockerイメージをプッシュする
push-all: push-backend push-tor push-playwright push-bff push-frontend

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
# tor
#

tor_tag := $(registry)/$(project)-backend-tor:$(tag_suffix)

build-tor:
	docker build \
	-t $(tor_tag) \
	-f containers/tor/Dockerfile.prod volumes/tor

push-tor:
	docker push $(tor_tag)

#
# playwright
#

playwright_tag := $(registry)/$(project)-backend-playwright:$(tag_suffix)

build-playwright:
	docker build \
	-t $(playwright_tag) \
	-f containers/playwright/Dockerfile .

push-playwright:
	docker push $(playwright_tag)

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
