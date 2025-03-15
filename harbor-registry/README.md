# Harbor Container Registry Stack

Enterprise-grade container registry with vulnerability scanning and web UI for secure image management and distribution.

## What's Included

- **Docker Registry 2.8**: Core OCI-compliant container registry
- **Registry Web UI**: Modern interface for registry management
- **PostgreSQL 15**: Metadata and configuration storage
- **Redis 7**: Caching and session management
- **Trivy Scanner**: Vulnerability scanning for container images
- **Nginx Proxy**: Load balancing and SSL termination

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
| Registry API | http://localhost:5000 | 5000 | admin / Harbor12345 |
| Web Interface | http://localhost:5001 | 5001 | Browse only |
| Trivy Scanner | http://localhost:8080 | 8080 | API access |

## Default Configuration

- **Registry Admin**: admin / Harbor12345
- **Database**: PostgreSQL with persistent storage
- **Vulnerability Scanning**: Trivy integration enabled
- **Image Deletion**: Enabled via API and UI

## Architecture Overview

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Docker    │────│    Nginx     │────│  Registry   │
│   Client    │    │    Proxy     │    │    Core     │
└─────────────┘    └──────────────┘    └─────────────┘
                          │                    │
                   ┌──────────────┐    ┌─────────────┐
                   │   Web UI     │    │    Redis    │
                   │   (Browse)   │    │   (Cache)   │
                   └──────────────┘    └─────────────┘
                                              │
                   ┌──────────────┐    ┌─────────────┐
                   │    Trivy     │    │ PostgreSQL │
                   │  (Scanner)   │    │ (Metadata) │
                   └──────────────┘    └─────────────┘
```

## Usage Examples

### Docker Client Configuration

```bash
# Login to registry
docker login localhost:5000
# Username: admin
# Password: Harbor12345

# Tag and push image
docker tag nginx:alpine localhost:5000/library/nginx:latest
docker push localhost:5000/library/nginx:latest

# Pull image
docker pull localhost:5000/library/nginx:latest
```

### Registry API Usage

```bash
# List repositories
curl -u admin:Harbor12345 http://localhost:5000/v2/_catalog

# List tags for repository
curl -u admin:Harbor12345 http://localhost:5000/v2/library/nginx/tags/list

# Get image manifest
curl -u admin:Harbor12345 \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  http://localhost:5000/v2/library/nginx/manifests/latest
```

### Vulnerability Scanning

```bash
# Scan image with Trivy
curl -X POST http://localhost:8080/scan \
  -H "Content-Type: application/json" \
  -d '{"image":"localhost:5000/library/nginx:latest"}'

# Get scan results
curl http://localhost:8080/scan/results/nginx:latest
```

## Security Configuration

### User Management

Add users to `config/auth/htpasswd`:

```bash
# Generate password hash
htpasswd -Bb config/auth/htpasswd newuser newpassword

# Restart registry to apply changes
docker compose restart harbor-registry
```

### SSL/TLS Setup

For production, configure SSL certificates:

1. Place certificates in `config/ssl/`
2. Update nginx configuration
3. Update Docker daemon configuration for insecure registries

### Registry Configuration

Advanced registry settings via environment variables:

```env
# Storage configuration
REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry
REGISTRY_STORAGE_DELETE_ENABLED=true

# Authentication
REGISTRY_AUTH=htpasswd
REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd

# HTTP settings
REGISTRY_HTTP_SECRET=your_secret_key_here
```

## Monitoring and Maintenance

### Health Checks

All services include health checks:
- PostgreSQL: Database connectivity
- Redis: Cache availability
- Registry: API responsiveness

### Backup Strategy

```bash
# Backup registry data
docker run --rm -v harbor-registry_harbor_registry:/source -v $(pwd):/backup alpine tar czf /backup/registry-backup.tar.gz -C /source .

# Backup database
docker compose exec harbor-db pg_dump -U postgres registry > registry-backup.sql

# Backup Redis cache (optional)
docker compose exec harbor-redis redis-cli BGSAVE
```

### Log Management

```bash
# View registry logs
docker compose logs -f harbor-registry

# View all service logs
docker compose logs -f

# Check nginx access logs
docker compose exec harbor-proxy cat /var/log/nginx/access.log
```

## Environment Variables

Configuration via `.env` file:

```env
# Harbor Configuration
HARBOR_ADMIN_PASSWORD=Harbor12345
REGISTRY_SECRET=harbor_registry_secret

# Database
DB_PASSWORD=harbor_db_password

# Network
HARBOR_HOSTNAME=harbor.localhost

# Trivy Scanner
TRIVY_GITHUB_TOKEN=your_github_token_for_better_rate_limits
```

## Production Deployment

### Prerequisites

- SSL certificates for HTTPS
- DNS configuration for registry hostname
- Firewall configuration for ports 5000, 5001
- Docker daemon configured for registry

### Production Checklist

- [ ] Change default passwords
- [ ] Configure SSL/TLS certificates
- [ ] Set up DNS records
- [ ] Configure firewall rules
- [ ] Set up log rotation
- [ ] Configure backup procedures
- [ ] Set up monitoring and alerting
- [ ] Review security policies

## Integration Examples

### CI/CD Pipeline Integration

```yaml
# Example GitHub Actions
- name: Build and push to Harbor
  env:
    REGISTRY: harbor.company.com:5000
    REPOSITORY: project/app
  run: |
    docker login $REGISTRY -u admin -p ${{ secrets.HARBOR_PASSWORD }}
    docker build -t $REGISTRY/$REPOSITORY:$GITHUB_SHA .
    docker push $REGISTRY/$REPOSITORY:$GITHUB_SHA
```

### Kubernetes Integration

```yaml
# Example Kubernetes deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  template:
    spec:
      imagePullSecrets:
      - name: harbor-registry-secret
      containers:
      - name: app
        image: harbor.company.com:5000/project/app:latest
```

## Troubleshooting

### Common Issues

1. **Push fails with authentication error**
   - Verify credentials in htpasswd file
   - Check Docker client login status

2. **Images not visible in UI**
   - Check nginx proxy configuration
   - Verify registry API accessibility

3. **Vulnerability scanning not working**
   - Check Trivy service status
   - Verify GitHub token for rate limiting

### Debug Commands

```bash
# Test registry connectivity
curl -v http://localhost:5000/v2/

# Check service health
docker compose ps
docker compose logs harbor-registry

# Verify authentication
curl -u admin:Harbor12345 http://localhost:5000/v2/_catalog
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```