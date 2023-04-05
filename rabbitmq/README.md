# RabbitMQ Stack

A complete RabbitMQ message broker setup with management interface.

## What's Included

- **RabbitMQ 3.12**: Advanced Message Queuing Protocol (AMQP) message broker
- **Management Plugin**: Web-based administration interface
- **Additional Plugins**: Prometheus metrics, STOMP, WebSTOMP

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
| RabbitMQ AMQP | localhost:5672 | 5672 | admin / admin |
| Management UI | http://localhost:15672 | 15672 | admin / admin |

## Default Configuration

- **Username**: admin
- **Password**: admin
- **Virtual Host**: /

## Volumes

- `rabbitmq_data`: RabbitMQ data and configuration persistence

## Health Checks

RabbitMQ includes a health check using `rabbitmq-diagnostics ping` to verify service availability.

## Custom Configuration

### Enabled Plugins

The following plugins are enabled by default:
- `rabbitmq_management`: Web management interface
- `rabbitmq_prometheus`: Prometheus metrics
- `rabbitmq_stomp`: STOMP protocol support
- `rabbitmq_web_stomp`: WebSTOMP support

### Configuration File

Custom RabbitMQ configuration is loaded from `config/rabbitmq.conf` with:
- Network settings
- Memory and disk thresholds
- Logging configuration
- Queue settings

## Connection Examples

### AMQP URL
```
amqp://admin:admin@localhost:5672/
```

### From Other Docker Services
```
amqp://admin:admin@rabbitmq:5672/
```

### Python (pika)
```python
import pika

connection = pika.BlockingConnection(
    pika.URLParameters('amqp://admin:admin@localhost:5672/')
)
channel = connection.channel()
```

### Node.js (amqplib)
```javascript
const amqp = require('amqplib');

const connection = await amqp.connect('amqp://admin:admin@localhost:5672/');
const channel = await connection.createChannel();
```

## Environment Variables

All configuration can be customized via the `.env` file:

```env
DB_USER=admin
DB_PASSWORD=admin
RABBITMQ_VHOST=/
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```