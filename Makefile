# ArgoCDによるGitOps用のMakefile

#
# config
#

registry := docker-registry.kuroweb.net
project := price-monitoring
tag_suffix := $(shell git rev-parse --short HEAD)
environment ?= production
# CIでBuildKitのレジストリキャッシュを使う場合は cache=true を渡す
cache ?= false

# $(1): キャッシュを置くイメージ名（タグなし）
ifeq ($(cache),true)
cache_opts = --cache-from type=registry,ref=$(1):buildcache --cache-to type=registry,ref=$(1):buildcache,mode=max
endif

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

backend_image := $(registry)/$(project)-backend-$(environment)
backend_tag := $(backend_image):$(tag_suffix)
backend_dockerfile := containers/backend/Dockerfile.$(environment)

build-backend:
	docker buildx build --load $(call cache_opts,$(backend_image)) \
	-t $(backend_tag) \
	-f $(backend_dockerfile) volumes/backend

push-backend:
	docker push $(backend_tag)

#
# playwright
#

backend_playwright_image := $(registry)/$(project)-backend-playwright-$(environment)
backend_playwright_tag := $(backend_playwright_image):$(tag_suffix)
backend_playwright_dockerfile := containers/backend_playwright/Dockerfile.$(environment)

build-backend-playwright:
	docker buildx build --load $(call cache_opts,$(backend_playwright_image)) \
	-t $(backend_playwright_tag) \
	-f $(backend_playwright_dockerfile) .

push-backend-playwright:
	docker push $(backend_playwright_tag)

#
# camoufox
#

backend_camoufox_image := $(registry)/$(project)-backend-camoufox-$(environment)
backend_camoufox_tag := $(backend_camoufox_image):$(tag_suffix)
backend_camoufox_dockerfile := containers/backend_camoufox/Dockerfile.$(environment)

build-backend-camoufox:
	docker buildx build --load $(call cache_opts,$(backend_camoufox_image)) \
	-t $(backend_camoufox_tag) \
	-f $(backend_camoufox_dockerfile) .

push-backend-camoufox:
	docker push $(backend_camoufox_tag)

#
# frontend
#

frontend_image := $(registry)/$(project)-frontend-$(environment)
frontend_tag := $(frontend_image):$(tag_suffix)
frontend_dockerfile := containers/frontend/Dockerfile.$(environment)

build-frontend:
	docker buildx build --load $(call cache_opts,$(frontend_image)) \
	-t $(frontend_tag) \
	-f $(frontend_dockerfile) volumes/frontend

push-frontend:
	docker push $(frontend_tag)

#
# auth-provider
#

auth_provider_image := $(registry)/auth-provider-backend-$(environment)
auth_provider_tag := $(auth_provider_image):$(tag_suffix)
auth_provider_dockerfile := containers/auth-provider/Dockerfile.$(environment)

build-auth-provider:
	docker buildx build --load $(call cache_opts,$(auth_provider_image)) \
	-t $(auth_provider_tag) \
	-f $(auth_provider_dockerfile) volumes/auth-provider

push-auth-provider:
	docker push $(auth_provider_tag)
