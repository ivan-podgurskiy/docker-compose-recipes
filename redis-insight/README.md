# Redis + RedisInsight Stack

A complete Redis cache setup with RedisInsight web interface for Redis administration and monitoring.

## What's Included

- **Redis 7**: High-performance in-memory data structure store
- **RedisInsight**: Web-based Redis administration and monitoring interface

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Start the stack
docker compose up -d

# Check status
docker compose ps
```

## Access Information

| Service | URL | Port | Default Credentials |
|---------|-----|------|-------------------|
| Redis | localhost:6379 | 6379 | No password (default) |
| RedisInsight | http://localhost:8001 | 8001 | No login required |

## Volumes

- `redis_data`: Redis data persistence
- `redisinsight_data`: RedisInsight settings and configurations

## Health Checks

Redis includes a health check using `redis-cli ping` to verify service availability.

## Custom Configuration

### Redis Configuration

The stack includes a custom Redis configuration file at `config/redis.conf` with:

- Persistence settings (RDB + AOF)
- Memory optimization
- Security options (commented password)

### Enabling Password Protection

To enable Redis password protection:

1. Edit `config/redis.conf` and uncomment:
   ```
   requirepass yourpassword
   ```

2. Update your application connection strings to include the password.

## Connection Examples

### Redis CLI
```bash
# Connect to Redis
docker exec -it redis redis-cli

# With password (if enabled)
docker exec -it redis redis-cli -a yourpassword
```

### From Applications
```bash
# Without password
redis://localhost:6379

# With password
redis://:yourpassword@localhost:6379
```

### From Other Docker Services
```bash
# Without password
redis://redis:6379

# With password
redis://:yourpassword@redis:6379
```

## Environment Variables

Configuration can be customized via the `.env` file:

```env
# Uncomment to enable password protection
# REDIS_PASSWORD=yourpassword
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```