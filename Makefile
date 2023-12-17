# Production用のDockerイメージをビルドする.

project := price-monitoring
registry := registry.local:5000

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

tor_dockerfile_dir := containers/tor/Dockerfile
tor_project_dir := volumes/tor
tor_tag := $(registry)/$(project)-backend-tor

build-tor:
	docker build \
	-t $(tor_tag) \
	-f $(tor_dockerfile_dir) $(tor_project_dir)

push-tor:
	docker push $(tor_tag):latest
