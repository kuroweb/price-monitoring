@_list:
	just -l

up:
	docker compose up -d

down:
	docker compose down

ps:
	docker compose ps

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
