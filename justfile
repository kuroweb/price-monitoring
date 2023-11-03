@_list:
	just -l

up:
	docker compose up

up-d:
	docker compose up -d

down:
	docker compose down

down-up:
	docker compose down
	docker compose up

restart:
	docker compose restart

logs:
	docker compose logs -f

attach-frontend:
  docker attach $(docker compose ps -q frontend)

attach-bff:
  docker attach $(docker compose ps -q bff)

attach-backend:
  docker attach $(docker compose ps -q backend)
