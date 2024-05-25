@_list:
	just -l

#
# Launch
#

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

#
# Attach
#

attach-backend:
	docker attach $(docker compose ps -q backend)

attach-backend-batch-1:
	docker attach $(docker compose ps -q backend-batch-1)

attach-backend-batch-2:
	docker attach $(docker compose ps -q backend-batch-2)

attach-backend-playwright:
	docker attach $(docker compose ps -q backend-playwright)

attach-bff:
	docker attach $(docker compose ps -q bff)

attach-frontend:
	docker attach $(docker compose ps -q frontend)

attach-remix:
	docker attach $(docker compose ps -q remix)

#
# Log
#

logs:
	docker compose logs -f
