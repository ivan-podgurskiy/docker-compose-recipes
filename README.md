# Docker Compose Recipes

> One-command dev environment stacks. Copy, paste, docker compose up.

A collection of ready-to-use Docker Compose configurations for common development environments and tools. Each stack is designed to be self-contained and can be launched with a single command.

## Quick Start

1. Clone this repository
2. Navigate to any stack directory
3. Copy the `.env.example` to `.env` and customize if needed
4. Run `docker compose up -d`

## Available Stacks

### Database Stacks
| Stack | Description | Ports | Default Credentials |
|-------|-------------|-------|-------------------|
| [postgres-pgadmin](./postgres-pgadmin) | PostgreSQL 16 + pgAdmin 4 | 5432, 5050 | See stack README |
| [mysql-phpmyadmin](./mysql-phpmyadmin) | MySQL 8 + phpMyAdmin | 3306, 8080 | See stack README |
| [mongodb-express](./mongodb-express) | MongoDB 7 + Mongo Express | 27017, 8081 | See stack README |

### Cache & Message Queues
| Stack | Description | Ports | Default Credentials |
|-------|-------------|-------|-------------------|
| [redis-insight](./redis-insight) | Redis 7 + RedisInsight | 6379, 8001 | See stack README |
| [rabbitmq](./rabbitmq) | RabbitMQ with management UI | 5672, 15672 | See stack README |

### Observability
| Stack | Description | Ports | Default Credentials |
|-------|-------------|-------|-------------------|
| [elk](./elk) | Elasticsearch + Logstash + Kibana | 9200, 9300, 5601 | See stack README |
| [prometheus-grafana](./prometheus-grafana) | Prometheus + Grafana | 9090, 3000 | See stack README |

### Dev Tools
| Stack | Description | Ports | Default Credentials |
|-------|-------------|-------|-------------------|
| [mailpit](./mailpit) | Local SMTP trap for email testing | 1025, 8025 | See stack README |
| [minio](./minio) | S3-compatible local storage | 9000, 9001 | See stack README |
| [traefik](./traefik) | Reverse proxy with auto-SSL | 80, 443, 8080 | See stack README |

## Usage

### Basic Usage
```bash
cd postgres-pgadmin
cp .env.example .env
docker compose up -d
```

### Using the Makefile
```bash
# Start a specific stack
make up s=postgres-pgadmin

# Stop a specific stack
make down s=postgres-pgadmin

# View logs
make logs s=postgres-pgadmin
```

## Stack Structure

Each stack follows this consistent structure:
```
stack-name/
├── docker-compose.yml    # Main compose file
├── .env.example         # Environment variables template
├── README.md           # Stack-specific documentation
└── config/             # Optional custom configurations
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.