# HashiCorp Vault Secrets Management Stack

Enterprise secrets management platform for secure storage, dynamic secrets generation, and encryption services.

## What's Included

- **HashiCorp Vault 1.15.2**: Core secrets management server
- **PostgreSQL 15**: Persistent storage backend
- **Automatic Initialization**: Vault setup with example policies and secrets
- **Web UI**: Management interface for secrets and policies
- **Audit Logging**: Comprehensive audit trail

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Start the stack
docker compose up -d

# Wait for initialization (about 30 seconds)
docker compose logs -f vault-init

# Access Vault UI at http://localhost:8200
```

## Access Information

| Service | URL | Port | Default Credentials |
|---------|-----|------|-------------------|
| Vault UI | http://localhost:8200 | 8200 | admin / admin123 |
| Vault API | http://localhost:8200 | 8200 | Token-based auth |
| PostgreSQL | localhost:5432 | 5432 | vault / (see .env) |

## Architecture Overview

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│    Apps     │────│   Vault API  │────│ PostgreSQL │
│ (Clients)   │    │   (Server)   │    │ (Storage)   │
└─────────────┘    └──────────────┘    └─────────────┘
                          │
                   ┌──────────────┐
                   │   Web UI     │
                   │ (Management) │
                   └──────────────┘
```

## Initial Setup

The stack automatically:
1. Initializes Vault with 5 key shares (threshold 3)
2. Unseals Vault automatically
3. Creates example policies and authentication
4. Sets up KV v2 secrets engine
5. Stores sample secrets for testing

## Authentication Methods

### Root Token Authentication
```bash
# Get root token from initialization
docker compose exec vault-server cat /vault/keys/init-keys.json

# Use root token
export VAULT_TOKEN="your-root-token"
vault status
```

### Username/Password Authentication
```bash
# Login with admin user
vault login -method=userpass username=admin password=admin123

# Login with app user (read-only)
vault login -method=userpass username=app-user password=app123
```

### Token-based Authentication
```bash
# Create token for application
vault token create -policy=app-readonly -ttl=24h

# Use token
export VAULT_TOKEN="your-token"
vault kv get secret/apps/database
```

## Secrets Management

### KV Secrets Engine

```bash
# Store a secret
vault kv put secret/apps/myapp \
  username=myuser \
  password=mypass \
  api_key=mykey123

# Retrieve a secret
vault kv get secret/apps/myapp

# Get specific field
vault kv get -field=password secret/apps/myapp

# List secrets
vault kv list secret/apps/

# Delete secret
vault kv delete secret/apps/myapp
```

### Dynamic Secrets

```bash
# Configure database connection
vault write database/config/my-postgresql-database \
  plugin_name=postgresql-database-plugin \
  connection_url="postgresql://{{username}}:{{password}}@postgres:5432/mydb?sslmode=disable" \
  allowed_roles="my-role" \
  username="vault" \
  password="vault-password"

# Create database role
vault write database/roles/my-role \
  db_name=my-postgresql-database \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="1h" \
  max_ttl="24h"

# Generate dynamic credentials
vault read database/creds/my-role
```

## Policy Management

### Example Policies

**Application Read-Only Policy:**
```hcl
# Allow reading application secrets
path "secret/data/apps/*" {
  capabilities = ["read"]
}

path "secret/metadata/apps/*" {
  capabilities = ["list"]
}
```

**Database Admin Policy:**
```hcl
# Full access to database secrets
path "secret/data/database/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Dynamic database credentials
path "database/creds/app-*" {
  capabilities = ["read"]
}
```

### Policy Commands

```bash
# Create policy
vault policy write my-policy policy.hcl

# List policies
vault policy list

# Read policy
vault policy read my-policy

# Delete policy
vault policy delete my-policy
```

## API Usage Examples

### REST API

```bash
# Authenticate via API
curl -X POST http://localhost:8200/v1/auth/userpass/login/admin \
  -d '{"password": "admin123"}'

# Store secret via API
curl -H "X-Vault-Token: your-token" \
  -X POST http://localhost:8200/v1/secret/data/myapp \
  -d '{"data": {"username": "user", "password": "pass"}}'

# Retrieve secret via API
curl -H "X-Vault-Token: your-token" \
  http://localhost:8200/v1/secret/data/myapp
```

### Application Integration

**Go Example:**
```go
import "github.com/hashicorp/vault/api"

config := api.DefaultConfig()
config.Address = "http://localhost:8200"
client, _ := api.NewClient(config)

client.SetToken("your-token")
secret, _ := client.Logical().Read("secret/data/myapp")
password := secret.Data["data"].(map[string]interface{})["password"]
```

**Python Example:**
```python
import hvac

client = hvac.Client(url='http://localhost:8200', token='your-token')
secret = client.secrets.kv.v2.read_secret_version(path='myapp')
password = secret['data']['data']['password']
```

## Security Features

### Audit Logging

```bash
# Enable file audit
vault audit enable file file_path=/vault/logs/vault-audit.log

# Enable syslog audit
vault audit enable syslog tag="vault" facility="AUTH"

# View audit logs
docker compose exec vault-server tail -f /vault/logs/vault-audit.log
```

### Encryption as a Service

```bash
# Enable transit engine
vault secrets enable transit

# Create encryption key
vault write -f transit/keys/my-key

# Encrypt data
vault write transit/encrypt/my-key plaintext=$(base64 <<< "my secret data")

# Decrypt data
vault write transit/decrypt/my-key ciphertext="vault:v1:encrypted-data"
```

### Auto-Unsealing (Production)

For production, configure auto-unsealing with cloud KMS:

```hcl
seal "awskms" {
  region     = "us-west-2"
  kms_key_id = "alias/vault-unseal-key"
}
```

## Backup and Recovery

### Backup Strategies

```bash
# Backup PostgreSQL data
docker compose exec vault-storage pg_dump -U vault vault > vault-backup.sql

# Backup Vault configuration
docker run --rm -v vault-secrets_vault_data:/source -v $(pwd):/backup alpine \
  tar czf /backup/vault-data-backup.tar.gz -C /source .

# Export secrets (for migration)
vault kv export secret/ > secrets-export.json
```

### Disaster Recovery

```bash
# Initialize new Vault with recovery keys
vault operator init -recovery-shares=5 -recovery-threshold=3

# Restore data from backup
docker compose down
docker volume rm vault-secrets_vault_postgres_data
# Restore volume from backup
docker compose up -d
```

## Monitoring and Maintenance

### Health Monitoring

```bash
# Check Vault status
vault status

# Check seal status
vault operator key-status

# Monitor via API
curl http://localhost:8200/v1/sys/health
```

### Performance Tuning

```hcl
# Vault configuration optimizations
default_lease_ttl = "168h"
max_lease_ttl = "720h"

storage "postgresql" {
  max_parallel = 128
  max_idle_connections = 10
}
```

## Environment Variables

Configuration via `.env` file:

```env
# Database
DB_PASSWORD=vault_postgres_password

# Vault server
VAULT_TOKEN=your_root_token_here
VAULT_ADDR=http://localhost:8200
VAULT_TLS_DISABLE=true

# For production TLS
VAULT_TLS_CERT_FILE=/vault/config/vault.crt
VAULT_TLS_KEY_FILE=/vault/config/vault.key
```

## Production Deployment

### Security Hardening

1. **Enable TLS encryption**
2. **Configure auto-unsealing with cloud KMS**
3. **Set up HA cluster with multiple nodes**
4. **Configure proper firewall rules**
5. **Enable comprehensive audit logging**
6. **Regular security scanning and updates**

### High Availability Setup

```yaml
# Example HA configuration
services:
  vault-1:
    image: hashicorp/vault:1.15.2
    environment:
      VAULT_CLUSTER_ADDR: https://vault-1:8201
      VAULT_API_ADDR: https://vault-1:8200

  vault-2:
    image: hashicorp/vault:1.15.2
    environment:
      VAULT_CLUSTER_ADDR: https://vault-2:8201
      VAULT_API_ADDR: https://vault-2:8200
```

## Troubleshooting

### Common Issues

1. **Vault sealed after restart**
   ```bash
   # Check seal status
   vault operator key-status

   # Unseal manually if needed
   vault operator unseal key1
   vault operator unseal key2
   vault operator unseal key3
   ```

2. **Authentication failures**
   ```bash
   # Check auth methods
   vault auth list

   # Test login
   vault login -method=userpass username=admin
   ```

3. **Permission denied errors**
   ```bash
   # Check token capabilities
   vault token capabilities secret/data/myapp

   # Review policies
   vault policy read app-readonly
   ```

## Stopping the Stack

```bash
# Stop services (keeps data)
docker compose down

# Stop and remove all data (⚠️ destroys secrets)
docker compose down -v
```

## Important Security Notes

- **Change default passwords** before production use
- **Store unseal keys securely** and separately
- **Enable TLS encryption** for production
- **Regular backup** of keys and data
- **Monitor audit logs** for suspicious activity
- **Use least privilege** access policies