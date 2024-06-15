# Traefik Stack

Modern reverse proxy and load balancer with automatic HTTPS and service discovery.

## What's Included

- **Traefik 3.0**: Cloud-native reverse proxy and load balancer
- **Dashboard**: Web-based administration interface
- **Whoami Service**: Example service for testing routing

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

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Traefik Dashboard | http://traefik.localhost | 8080 | Admin interface |
| HTTP | http://localhost | 80 | HTTP entrypoint |
| HTTPS | https://localhost | 443 | HTTPS entrypoint |
| Whoami Example | http://whoami.localhost | - | Test service |

## Default Configuration

- **Dashboard**: Enabled on port 8080
- **HTTPS**: Let's Encrypt integration ready
- **Service Discovery**: Docker provider enabled
- **Example Service**: whoami.localhost

## Volumes

- `traefik_letsencrypt`: Let's Encrypt certificates storage

## Health Checks

Traefik includes a health check using the built-in ping endpoint.

## Routing Services

### Adding Services

To add a service to Traefik routing, use Docker labels:

```yaml
services:
  my-app:
    image: nginx:alpine
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-app.rule=Host(`my-app.localhost`)"
      - "traefik.http.routers.my-app.entrypoints=web"
```

### HTTPS with Let's Encrypt

For production HTTPS:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.my-app.rule=Host(`example.com`)"
  - "traefik.http.routers.my-app.entrypoints=websecure"
  - "traefik.http.routers.my-app.tls.certresolver=letsencrypt"
```

### Load Balancing

For multiple instances:

```yaml
services:
  app:
    image: my-app:latest
    deploy:
      replicas: 3
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.app.rule=Host(`app.localhost`)"
      - "traefik.http.services.app.loadbalancer.server.port=8080"
```

## Custom Configuration

### Static Configuration

Edit `config/traefik.yml` for static configuration:

```yaml
api:
  dashboard: true
  insecure: false  # Secure dashboard in production

entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https

certificatesResolvers:
  letsencrypt:
    acme:
      httpChallenge:
        entryPoint: web
      email: your-email@example.com
      storage: /letsencrypt/acme.json
```

### Dynamic Configuration

Place dynamic configuration files in `config/dynamic/`:

```yaml
# config/dynamic/middlewares.yml
http:
  middlewares:
    auth:
      basicAuth:
        users:
          - "user:$2y$10$..."  # Use htpasswd to generate

    rate-limit:
      rateLimit:
        burst: 100
        average: 50
```

## Example Configurations

### WordPress with Database

```yaml
services:
  wordpress:
    image: wordpress:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wordpress.rule=Host(`blog.localhost`)"
      - "traefik.http.routers.wordpress.entrypoints=web"

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
```

### API with Path-based Routing

```yaml
services:
  api-v1:
    image: my-api:v1
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.api-v1.rule=Host(`api.localhost`) && PathPrefix(`/v1`)"

  api-v2:
    image: my-api:v2
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.api-v2.rule=Host(`api.localhost`) && PathPrefix(`/v2`)"
```

## Environment Variables

Configuration can be customized via the `.env` file:

```env
ADMIN_EMAIL=admin@localhost
ACME_STAGING=true  # Set to false for production certificates
```

## Local Development

Add these entries to your `/etc/hosts` file for local testing:

```
127.0.0.1 traefik.localhost
127.0.0.1 whoami.localhost
127.0.0.1 your-app.localhost
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys certificates)
docker compose down -v
```

## Production Checklist

For production deployment:
1. ✅ Set real domain names
2. ✅ Configure proper email for Let's Encrypt
3. ✅ Secure the dashboard (disable insecure mode)
4. ✅ Set up monitoring
5. ✅ Configure rate limiting
6. ✅ Review security headers
7. ✅ Set up log collection