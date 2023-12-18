# Production用のDockerイメージをビルドする.

project := price-monitoring
registry := registry.local:5000

#
# util
#

all: build-all push-all
build-all: build-backend build-tor build-playwright
push-all: push-backend push-tor push-playwright

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
