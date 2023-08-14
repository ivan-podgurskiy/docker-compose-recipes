# ELK Stack (Elasticsearch + Logstash + Kibana)

A complete logging and analytics solution with Elasticsearch, Logstash, and Kibana.

## What's Included

- **Elasticsearch 8.11**: Distributed search and analytics engine
- **Logstash 8.11**: Data processing pipeline
- **Kibana 8.11**: Data visualization and exploration platform

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
| Elasticsearch | http://localhost:9200 | 9200, 9300 | REST API |
| Kibana | http://localhost:5601 | 5601 | Web UI |
| Logstash | localhost:5044 | 5044, 5000, 9600 | Log ingestion |

## Default Configuration

- **Security**: Disabled for development (no passwords required)
- **Memory**: 512MB for Elasticsearch, 256MB for Logstash
- **Index Pattern**: `logs-YYYY.MM.dd`

## Volumes

- `elasticsearch_data`: Elasticsearch indices and data

## Health Checks

Elasticsearch includes a health check that verifies cluster health before starting dependent services.

## Log Ingestion

### Logstash Inputs

The stack accepts logs via multiple inputs:
- **Beats**: Port 5044 (Filebeat, Metricbeat, etc.)
- **TCP**: Port 5000
- **UDP**: Port 5000

### Example: Send logs via TCP

```bash
# Send a test log
echo '{"message": "Hello ELK!", "level": "info"}' | nc localhost 5000
```

### Example: Configure Filebeat

```yaml
# filebeat.yml
output.logstash:
  hosts: ["localhost:5044"]

filebeat.inputs:
- type: log
  paths:
    - /var/log/*.log
  fields:
    logtype: system
```

## Custom Configuration

### Logstash Pipeline

Edit `config/logstash/pipeline/logstash.conf` to customize log processing:

```ruby
filter {
  if [fields][logtype] == "nginx" {
    grok {
      match => { "message" => "%{NGINXACCESS}" }
    }
  }
}
```

### Kibana

Access Kibana at http://localhost:5601 and:
1. Go to **Management** → **Stack Management** → **Index Patterns**
2. Create index pattern: `logs-*`
3. Select timestamp field: `@timestamp`

## Environment Variables

Configuration can be customized via the `.env` file:

```env
ELASTIC_VERSION=8.11.0
ES_MEM_LIMIT=512
LS_MEM_LIMIT=256
KB_MEM_LIMIT=256
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```

## Security Note

This development stack has security features disabled. For production use:
1. Enable X-Pack security
2. Configure authentication
3. Set up TLS/SSL
4. Restrict network access