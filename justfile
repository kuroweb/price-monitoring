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

test-frontend *args:
	docker compose exec frontend npm test -- {{args}}

test-frontend-watch *args:
	docker compose exec frontend npm run test:watch -- {{args}}

test-frontend-coverage *args:
	docker compose exec frontend npm run test:coverage -- {{args}}
