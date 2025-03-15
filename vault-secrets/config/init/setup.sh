#!/bin/sh

# Vault Initial Setup Script
# This script initializes Vault policies and secret engines

set -e

echo "=== Vault Initial Configuration ==="

# Wait for Vault to be ready and unsealed
until vault status | grep -q "Sealed.*false"; do
  echo "Waiting for Vault to be unsealed..."
  sleep 5
done

echo "Vault is ready. Setting up initial configuration..."

# Enable audit logging
echo "Enabling audit logging..."
vault audit enable file file_path=/vault/logs/vault-audit.log

# Enable KV v2 secrets engine
echo "Enabling KV v2 secrets engine..."
vault secrets enable -path=secret kv-v2

# Enable database secrets engine
echo "Enabling database secrets engine..."
vault secrets enable database

# Create example policies
echo "Creating example policies..."

# Read-only policy for applications
vault policy write app-readonly - <<EOF
# Allow reading from secret/data/apps/*
path "secret/data/apps/*" {
  capabilities = ["read"]
}

# Allow listing secrets
path "secret/metadata/apps/*" {
  capabilities = ["list"]
}
EOF

# Admin policy for operators
vault policy write admin - <<EOF
# Full access to secret engine
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage auth methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage tokens
path "auth/token/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

# Enable userpass authentication
echo "Enabling userpass authentication..."
vault auth enable userpass

# Create example users
echo "Creating example users..."
vault write auth/userpass/users/admin \
  password=admin123 \
  policies=admin

vault write auth/userpass/users/app-user \
  password=app123 \
  policies=app-readonly

# Store some example secrets
echo "Storing example secrets..."
vault kv put secret/apps/database \
  username=dbuser \
  password=dbpass123 \
  host=database.internal \
  port=5432

vault kv put secret/apps/api-keys \
  stripe_key=sk_test_example \
  github_token=ghp_example \
  jwt_secret=your-jwt-secret-here

echo "=== Initial Vault setup complete ==="
echo ""
echo "Access Information:"
echo "  - Vault UI: http://localhost:8200"
echo "  - Admin user: admin / admin123"
echo "  - App user: app-user / app123"
echo ""
echo "Example commands:"
echo "  vault login -method=userpass username=admin"
echo "  vault kv get secret/apps/database"
echo "  vault kv list secret/apps"