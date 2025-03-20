# Docker Compose Recipes Makefile
# Usage: make COMMAND s=STACK_NAME

.PHONY: help up down restart logs ps clean validate list

# Default target
help:
	@echo "Docker Compose Recipes - Available Commands:"
	@echo ""
	@echo "  make up s=STACK        Start a stack (e.g., make up s=postgres-pgadmin)"
	@echo "  make down s=STACK      Stop a stack"
	@echo "  make restart s=STACK   Restart a stack"
	@echo "  make logs s=STACK      View stack logs"
	@echo "  make ps s=STACK        Show stack status"
	@echo "  make clean s=STACK     Stop stack and remove volumes (⚠️  destroys data)"
	@echo "  make validate s=STACK  Validate stack configuration"
	@echo "  make list              List all available stacks"
	@echo ""
	@echo "Available stacks:"
	@echo "  Database:     postgres-pgadmin, mysql-phpmyadmin, mongodb-express"
	@echo "  Cache/Queue:  redis-insight, rabbitmq"
	@echo "  Observability: elk, prometheus-grafana"
	@echo "  Dev Tools:    mailpit, minio, traefik"
	@echo "  Enterprise:   harbor-registry, vault-secrets"

# Check if stack parameter is provided
check-stack:
	@if [ -z "$(s)" ]; then \
		echo "Error: Stack parameter required. Use: make COMMAND s=STACK_NAME"; \
		echo "Example: make up s=postgres-pgadmin"; \
		exit 1; \
	fi
	@if [ ! -d "$(s)" ]; then \
		echo "Error: Stack '$(s)' not found."; \
		echo "Available stacks: postgres-pgadmin mysql-phpmyadmin mongodb-express redis-insight rabbitmq elk prometheus-grafana mailpit minio traefik harbor-registry vault-secrets"; \
		exit 1; \
	fi

# Start a stack
up: check-stack
	@echo "Starting stack: $(s)"
	@cd $(s) && docker compose up -d
	@echo "Stack $(s) started successfully!"
	@echo "Check status with: make ps s=$(s)"

# Stop a stack
down: check-stack
	@echo "Stopping stack: $(s)"
	@cd $(s) && docker compose down
	@echo "Stack $(s) stopped successfully!"

# Restart a stack
restart: check-stack
	@echo "Restarting stack: $(s)"
	@cd $(s) && docker compose restart
	@echo "Stack $(s) restarted successfully!"

# View logs
logs: check-stack
	@echo "Showing logs for stack: $(s)"
	@cd $(s) && docker compose logs -f

# Show status
ps: check-stack
	@echo "Status for stack: $(s)"
	@cd $(s) && docker compose ps

# Clean up (remove volumes)
clean: check-stack
	@echo "⚠️  Warning: This will stop the stack and remove all data!"
	@read -p "Are you sure you want to continue? (y/N): " confirm && \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		cd $(s) && docker compose down -v; \
		echo "Stack $(s) cleaned successfully!"; \
	else \
		echo "Operation cancelled."; \
	fi

# Validate configuration
validate: check-stack
	@echo "Validating stack configuration: $(s)"
	@cd $(s) && docker compose config --quiet && echo "✅ Configuration is valid" || echo "❌ Configuration has errors"

# List all available stacks
list:
	@echo "Available Docker Compose stacks:"
	@echo ""
	@echo "📊 Database Stacks:"
	@echo "  • postgres-pgadmin     PostgreSQL 16 + pgAdmin 4"
	@echo "  • mysql-phpmyadmin     MySQL 8 + phpMyAdmin"
	@echo "  • mongodb-express      MongoDB 7 + Mongo Express"
	@echo ""
	@echo "⚡ Cache & Message Queues:"
	@echo "  • redis-insight        Redis 7 + RedisInsight"
	@echo "  • rabbitmq             RabbitMQ with management UI"
	@echo ""
	@echo "📈 Observability:"
	@echo "  • elk                  Elasticsearch + Logstash + Kibana"
	@echo "  • prometheus-grafana   Prometheus + Grafana + Node Exporter"
	@echo ""
	@echo "🛠️  Dev Tools:"
	@echo "  • mailpit             Local SMTP trap for email testing"
	@echo "  • minio               S3-compatible local storage"
	@echo "  • traefik             Reverse proxy with auto-SSL"
	@echo ""
	@echo "🏢 Enterprise Infrastructure:"
	@echo "  • harbor-registry     Container registry with vulnerability scanning"
	@echo "  • vault-secrets       HashiCorp Vault secrets management"

# Validate all stacks
validate-all:
	@echo "Validating all stack configurations..."
	@failed=0; \
	for stack in postgres-pgadmin mysql-phpmyadmin mongodb-express redis-insight rabbitmq elk prometheus-grafana mailpit minio traefik harbor-registry vault-secrets; do \
		echo -n "  $$stack: "; \
		if cd $$stack && docker compose config --quiet 2>/dev/null; then \
			echo "✅ Valid"; \
		else \
			echo "❌ Invalid"; \
			failed=$$((failed + 1)); \
		fi; \
	done; \
	if [ $$failed -eq 0 ]; then \
		echo "All stacks are valid! 🎉"; \
	else \
		echo "$$failed stack(s) have configuration errors."; \
		exit 1; \
	fi

# Show stack info
info: check-stack
	@echo "Stack Information: $(s)"
	@echo "=================="
	@if [ -f "$(s)/README.md" ]; then \
		head -20 $(s)/README.md | grep -E "^#|^-|Port|URL|Credentials" || echo "See $(s)/README.md for details"; \
	else \
		echo "README not found"; \
	fi