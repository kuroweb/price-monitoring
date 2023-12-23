# Production用のDockerイメージをビルドする.

project := price-monitoring
registry := registry.local:5000

#
# util
#

all: build-all push-all
build-all: build-backend build-tor build-playwright build-bff build-frontend
push-all: push-backend push-tor push-playwright push-bff push-frontend

#
# backendコンテナ
#

backend_dockerfile_dir := containers/backend/Dockerfile.prod
backend_project_dir := volumes/backend
backend_tag := $(registry)/$(project)-backend

build-backend:
	docker build \
	-t $(backend_tag) \
	-f $(backend_dockerfile_dir) $(backend_project_dir)

push-backend:
	docker push $(backend_tag):latest

#
# torコンテナ
#

tor_dockerfile_dir := containers/tor/Dockerfile.prod
tor_project_dir := volumes/tor
tor_tag := $(registry)/$(project)-backend-tor

build-tor:
	docker build \
	-t $(tor_tag) \
	-f $(tor_dockerfile_dir) $(tor_project_dir)

push-tor:
	docker push $(tor_tag):latest

#
# playwrightコンテナ
#

playwright_dockerfile_dir := containers/playwright/Dockerfile
playwright_tag := $(registry)/$(project)-backend-playwright

build-playwright:
	docker build \
	-t $(playwright_tag) \
	-f $(playwright_dockerfile_dir) .

push-playwright:
	docker push $(playwright_tag):latest

#
# bffコンテナ
#

bff_dockerfile_dir := containers/bff/Dockerfile.prod
bff_project_dir := volumes/bff
bff_tag := $(registry)/$(project)-bff

build-bff:
	docker build \
	-t $(bff_tag) \
	-f $(bff_dockerfile_dir) $(bff_project_dir)

push-bff:
	docker push $(bff_tag):latest

#
# frontendコンテナ
#

frontend_dockerfile_dir := containers/frontend/Dockerfile.prod
frontend_project_dir := volumes/frontend
frontend_tag := $(registry)/$(project)-frontend

build-frontend:
	docker build \
	-t $(frontend_tag) \
	-f $(frontend_dockerfile_dir) $(frontend_project_dir)

push-frontend:
	docker push $(frontend_tag):latest
