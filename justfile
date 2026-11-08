@_list:
	just -l

prepare:
	docker compose run --rm backend bundle exec rails db:prepare
	docker compose run --rm auth-provider bundle exec rails db:prepare db:seed
	docker compose up -d

up:
	docker compose up -d

down:
	docker compose down

ps:
	docker compose ps

down-orphans:
	#!/usr/bin/env sh
	set -eu
	docker ps -a --format '{{{{.Label "com.docker.compose.project"}}	{{{{.Label "com.docker.compose.project.working_dir"}}	{{{{.Label "com.docker.compose.project.config_files"}}' \
		| sort -u \
		| while IFS='	' read -r project dir files; do
			case "$files" in *docker-compose.worktree.yml*) ;; *) continue ;; esac
			[ -d "$dir" ] && continue
			echo "down: $project ($dir)"
			docker compose -p "$project" down --remove-orphans
		done

url:
	#!/usr/bin/env sh
	set -eu
	config=$(docker compose config nginx)
	project=$(printf '%s\n' "$config" | sed -n 's/^name: //p')
	port=$(printf '%s\n' "$config" | sed -n 's/^ *NGINX_HTTPS_PORT: "*\([0-9]*\)"*$/\1/p')
	suffix=$([ "$port" = 443 ] && echo "" || echo ":$port")
	echo "project: $project"
	echo "app:     https://dev.price-monitoring.com$suffix/"
	echo "auth:    https://dev.auth-provider.com$suffix/"

restart-all:
	docker compose restart

restart container-name:
	docker compose restart {{container-name}}

attach container-name:
	docker attach $(docker compose ps -q {{container-name}})

logs:
	docker compose logs -f

rspec-backend *args:
	docker compose exec backend bundle exec rspec {{args}}

rspec-auth-provider *args:
	docker compose exec auth-provider bundle exec rspec {{args}}

[positional-arguments]
rubocop-backend *args:
	docker compose exec backend bundle exec rubocop "$@"

[positional-arguments]
rubocop-auth-provider *args:
	docker compose exec auth-provider bundle exec rubocop "$@"

test-frontend *args:
	docker compose exec frontend npm test -- {{args}}

test-frontend-watch *args:
	docker compose exec frontend npm run test:watch -- {{args}}

test-frontend-coverage *args:
	docker compose exec frontend npm run test:coverage -- {{args}}
