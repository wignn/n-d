.DEFAULT_GOAL := help
.PHONY: help build up down restart logs clean test start-load-test rebuild dev prod status

DOCKER_COMPOSE := docker compose
DOCKER := docker
PROJECT_NAME := novel-api

help: 
	@echo ""
	@echo "[Docker Operations]"
	@echo "  build               - Build all Docker containers"
	@echo "  up                  - Start all containers in detached mode"
	@echo "  down                - Stop and remove all containers"
	@echo "  restart             - Restart all containers"
	@echo "  rebuild             - Rebuild and restart all containers"
	@echo "  logs                - Show container logs (Ctrl+C to exit)"
	@echo "  status              - Show status of all containers"
	@echo ""
	@echo "[Development]"
	@echo "  dev                 - Start development environment"
	@echo "  prod                - Start production environment"
	@echo ""
	@echo "[Testing]"
	@echo "  start-load-test     - Run k6 load test with InfluxDB output"
	@echo "  test                - Run application tests"
	@echo ""
	@echo "[Cleanup]"
	@echo "  clean               - Remove all containers, volumes, images"
	@echo "  prune               - Remove unused Docker resources"
	@echo ""
	@echo "[Database]"
	@echo "  db-migrate          - Run database migrations"
	@echo "  db-reset            - Reset database (DESTROYS ALL DATA!)"
	@echo ""
	@echo "[Utility]"
	@echo "  shell               - Open a shell in the API container"
	@echo "  fmt                 - Format Rust code"
	@echo "  lint                - Run Rust linter"
	@echo ""

build: 
	@echo "Building containers..."
	@$(DOCKER_COMPOSE) build
	@echo "[SUCCESS] Build completed successfully!"

up:
	@echo "Starting containers..."
	@$(DOCKER_COMPOSE) up -d
	@echo "[SUCCESS] Containers started successfully!"
	@echo "[INFO] Run 'make logs' to view container logs"

down:
	@echo "Stopping containers..."
	@$(DOCKER_COMPOSE) down
	@echo "[SUCCESS] Containers stopped successfully!"

restart:
	@echo "Restarting containers..."
	@$(DOCKER_COMPOSE) restart
	@echo "[SUCCESS] Containers restarted successfully!"

rebuild:
	@echo "Rebuilding containers..."
	@$(MAKE) down
	@$(MAKE) build
	@$(MAKE) up
	@echo "[SUCCESS] Rebuild completed successfully!"

logs:
	@$(DOCKER_COMPOSE) logs -f

status:
	@echo "Container Status:"
	@$(DOCKER_COMPOSE) ps


dev: 
	@echo "Starting development environment..."
	@$(DOCKER_COMPOSE) up

prod:
	@echo "Starting production environment..."
	@$(DOCKER_COMPOSE) -f compose.yml up -d

start-load-test:
	@echo "Starting load test..."
	@k6 run --out influxdb=http://localhost:8086/k6 load-test.js
	@echo "[SUCCESS] Load test completed!"

test:
	@echo "Running tests..."
	@cd novel-api && cargo test
	@echo "[SUCCESS] Tests completed!"

clean: 
	@echo "[WARNING] This will remove all containers, volumes, and images!"
	@echo "Press Ctrl+C to cancel, or"
	@$(DOCKER_COMPOSE) down -v --rmi all
	@echo "[SUCCESS] Cleanup completed!"

prune:
	@echo "[INFO] Pruning unused Docker resources..."
	@$(DOCKER) system prune -f
	@echo "[SUCCESS] Prune completed!"

db-migrate: 
	@echo "[INFO] Running database migrations..."
	@cd novel-api && sqlx migrate run
	@echo "[SUCCESS] Migrations completed!"

db-reset: 
	@echo "[WARNING] This will destroy all database data!"
	@echo "Press Ctrl+C to cancel within 5 seconds..."
	@sleep 5
	@cd novel-api && sqlx database reset
	@echo "[SUCCESS] Database reset completed!"

shell: 
	@$(DOCKER_COMPOSE) exec api sh

fmt:
	@echo "[INFO] Formatting code..."
	@cd novel-api && cargo fmt
	@echo "[SUCCESS] Formatting completed!"

lint:
	@echo "[INFO] Running linter..."
	@cd novel-api && cargo clippy
	@echo "[SUCCESS] Linting completed!"