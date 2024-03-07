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

#
# Restart
#

restart:
	docker compose restart

restart-f: down up

restart-backend:
	docker compose restart backend

restart-backend-batch:
	docker compose restart backend-batch

restart-backend-playwright:
	docker compose restart backend-playwright

restart-bff:
	docker compose restart bff

restart-frontend:
	docker compose restart frontend

#
# Attach
#

attach-backend:
	docker attach $(docker compose ps -q backend)

attach-backend-batch:
	docker attach $(docker compose ps -q backend-batch)

attach-backend-playwright:
	docker attach $(docker compose ps -q backend-playwright)

attach-bff:
	docker attach $(docker compose ps -q bff)

attach-frontend:
	docker attach $(docker compose ps -q frontend)

#
# Log
#

logs:
	docker compose logs -f
