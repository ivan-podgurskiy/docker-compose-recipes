#!/bin/sh

# Wait for MinIO to be ready
sleep 5

# Set up MinIO client
mc alias set localminio http://minio:9000 ${MINIO_ROOT_USER:-minioadmin} ${MINIO_ROOT_PASSWORD:-minioadmin}

# Create default buckets
mc mb localminio/uploads
mc mb localminio/backups
mc mb localminio/assets

# Set public policy for assets bucket (optional)
mc policy set public localminio/assets

echo "Buckets created successfully"