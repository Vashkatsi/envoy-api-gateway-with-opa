
.PHONY: start, stop, restart, clean-hard

start:
	@echo "Starting Docker Compose order_microservice services..."
	docker compose -f docker-compose.yml up -d --build

stop:
	@echo "Stopping Docker Compose services..."
	docker compose down

restart: stop start
	@echo "Restarting Docker Compose services..."

clean-hard: stop
	@echo "Removing all the containers and images..."
	docker compose down -v --rmi all