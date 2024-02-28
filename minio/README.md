# MinIO Stack

S3-compatible object storage server for local development and testing.

## What's Included

- **MinIO**: High-performance S3-compatible object storage
- **MinIO Console**: Web-based administration interface
- **Bucket Creation**: Automated setup of default buckets

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
| MinIO API | http://localhost:9000 | 9000 | minioadmin / minioadmin |
| MinIO Console | http://localhost:9001 | 9001 | minioadmin / minioadmin |

## Default Configuration

- **Access Key**: minioadmin
- **Secret Key**: minioadmin
- **Default Buckets**: uploads, backups, assets (auto-created)

## Volumes

- `minio_data`: Object storage data

## Health Checks

MinIO includes a health check that verifies service availability.

## Default Buckets

The stack automatically creates three buckets:
- **uploads**: For file uploads (private)
- **backups**: For backup storage (private)
- **assets**: For public assets (public read access)

## Usage Examples

### AWS CLI

Configure AWS CLI to use MinIO:

```bash
# Configure AWS CLI
aws configure set aws_access_key_id minioadmin
aws configure set aws_secret_access_key minioadmin
aws configure set region us-east-1

# Use with custom endpoint
aws --endpoint-url http://localhost:9000 s3 ls
aws --endpoint-url http://localhost:9000 s3 cp file.txt s3://uploads/
```

### Python (boto3)

```python
import boto3

# Create S3 client
s3_client = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin',
    region_name='us-east-1'
)

# Upload file
s3_client.upload_file('local_file.txt', 'uploads', 'remote_file.txt')

# Download file
s3_client.download_file('uploads', 'remote_file.txt', 'downloaded_file.txt')
```

### Node.js (aws-sdk)

```javascript
const AWS = require('aws-sdk');

const s3 = new AWS.S3({
    endpoint: 'http://localhost:9000',
    accessKeyId: 'minioadmin',
    secretAccessKey: 'minioadmin',
    s3ForcePathStyle: true,
    signatureVersion: 'v4'
});

// Upload file
const uploadParams = {
    Bucket: 'uploads',
    Key: 'file.txt',
    Body: 'Hello MinIO!'
};

s3.upload(uploadParams, (err, data) => {
    if (err) console.error(err);
    else console.log('Upload successful:', data.Location);
});
```

### From Other Docker Services

When connecting from other Docker containers, use the service name:

```python
# Python example for Docker network
s3_client = boto3.client(
    's3',
    endpoint_url='http://minio:9000',  # Use service name
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin'
)
```

## MinIO Client (mc)

Use the MinIO client for administrative tasks:

```bash
# Install mc (MinIO client)
docker run --rm -it --network minio-network minio/mc:latest

# Configure alias
mc alias set localminio http://minio:9000 minioadmin minioadmin

# List buckets
mc ls localminio

# Create bucket
mc mb localminio/new-bucket

# Set bucket policy
mc policy set public localminio/new-bucket
```

## Environment Variables

Configuration can be customized via the `.env` file:

```env
ADMIN_EMAIL=minioadmin
ADMIN_PASSWORD=minioadmin
```

## Custom Bucket Setup

Edit `config/create-buckets.sh` to customize the initial bucket setup:

```bash
#!/bin/sh
mc alias set localminio http://minio:9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}

# Create custom buckets
mc mb localminio/my-bucket
mc policy set download localminio/my-bucket

echo "Custom buckets created"
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```

## Production Notes

For production use:
1. Change default credentials
2. Configure proper SSL/TLS
3. Set up backup strategies
4. Configure access policies
5. Monitor storage usage