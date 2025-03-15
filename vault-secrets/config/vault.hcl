# HashiCorp Vault Server Configuration

# Storage backend configuration
storage "postgresql" {
  connection_url = "postgres://vault:vault_postgres_password@vault-storage:5432/vault?sslmode=disable"
  table          = "vault_kv_store"
  max_parallel   = 128
}

# API listener configuration
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_disable   = true
  # For production, enable TLS:
  # tls_disable   = false
  # tls_cert_file = "/vault/config/vault.crt"
  # tls_key_file  = "/vault/config/vault.key"
}

# Enterprise license (if applicable)
# license_path = "/vault/config/vault.hclic"

# Seal configuration
# seal "awskms" {
#   region     = "us-west-2"
#   kms_key_id = "alias/vault-unseal-key"
# }

# UI configuration
ui = true

# Default and max lease TTL
default_lease_ttl = "168h"  # 1 week
max_lease_ttl     = "720h"  # 30 days

# Logging
log_level = "INFO"
log_format = "json"

# Disable memory lock for development
# Remove this for production
disable_mlock = true

# Cluster configuration (for HA setup)
# cluster_addr  = "https://127.0.0.1:8201"
# api_addr      = "https://127.0.0.1:8200"

# Performance and telemetry
# telemetry {
#   prometheus_retention_time = "30s"
#   disable_hostname = true
# }