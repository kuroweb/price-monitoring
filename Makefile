# ArgoCDによるGitOps用のMakefile

#
# config
#

registry := registry.local:5000

tag_prefix := price-monitoring
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
# backendコンテナ
#

backend_dockerfile_dir := containers/backend/Dockerfile.prod
backend_project_dir := volumes/backend
backend_tag := $(registry)/$(tag_prefix)-backend:$(tag_suffix)

build-backend:
	docker build \
	-t $(backend_tag) \
	-f $(backend_dockerfile_dir) $(backend_project_dir)

push-backend:
	docker push $(backend_tag)

#
# torコンテナ
#

tor_dockerfile_dir := containers/tor/Dockerfile.prod
tor_project_dir := volumes/tor
tor_tag := $(registry)/$(tag_prefix)-backend-tor:$(tag_suffix)

build-tor:
	docker build \
	-t $(tor_tag) \
	-f $(tor_dockerfile_dir) $(tor_project_dir)

push-tor:
	docker push $(tor_tag)

#
# playwrightコンテナ
#

playwright_dockerfile_dir := containers/playwright/Dockerfile
playwright_tag := $(registry)/$(tag_prefix)-backend-playwright:$(tag_suffix)

build-playwright:
	docker build \
	-t $(playwright_tag) \
	-f $(playwright_dockerfile_dir) .

push-playwright:
	docker push $(playwright_tag)

#
# bffコンテナ
#

bff_dockerfile_dir := containers/bff/Dockerfile.prod
bff_project_dir := volumes/bff
bff_tag := $(registry)/$(tag_prefix)-bff:$(tag_suffix)

build-bff:
	docker build \
	-t $(bff_tag) \
	-f $(bff_dockerfile_dir) $(bff_project_dir)

push-bff:
	docker push $(bff_tag)

#
# frontendコンテナ
#

frontend_dockerfile_dir := containers/frontend/Dockerfile.prod
frontend_project_dir := volumes/frontend
frontend_tag := $(registry)/$(tag_prefix)-frontend:$(tag_suffix)

build-frontend:
	docker build \
	-t $(frontend_tag) \
	-f $(frontend_dockerfile_dir) $(frontend_project_dir)

push-frontend:
	docker push $(frontend_tag)
