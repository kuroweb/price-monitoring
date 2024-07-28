@_list:
	just -l

up:
	docker compose up

up-d:
	docker compose up -d

down:
	docker compose down

ps:
	docker compose ps

restart:
	docker compose restart

attach container-name:
	docker attach $(docker compose ps -q {{container-name}})

logs:
	docker compose logs -f
