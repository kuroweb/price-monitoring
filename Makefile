# Production用のDockerイメージをビルドする.

project := price-monitoring
registry := registry.local:5000

#
# backendコンテナのビルド
#

backend_dockerfile_dir := containers/backend/Dockerfile.prod
backend_project_dir := volumes/backend
backend_tag := $(registry)/$(project)-backend

build_backend:
	docker build \
	-t $(backend_tag) \
	-f $(backend_dockerfile_dir) $(backend_project_dir)

push:
	docker push $(backend_tag):latest
