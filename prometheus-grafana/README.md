# Prometheus + Grafana Stack

A complete monitoring and visualization solution with Prometheus metrics collection and Grafana dashboards.

## What's Included

- **Prometheus 2.48**: Metrics collection and storage
- **Grafana 10.2**: Metrics visualization and dashboarding
- **Node Exporter 1.7**: System metrics collection

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
| Prometheus | http://localhost:9090 | 9090 | No authentication |
| Grafana | http://localhost:3000 | 3000 | admin / admin |
| Node Exporter | http://localhost:9100 | 9100 | Metrics endpoint |

## Default Configuration

- **Grafana Admin**: admin / admin
- **Data Retention**: 200 hours
- **Scrape Interval**: 15 seconds

## Volumes

- `prometheus_data`: Prometheus metrics storage
- `grafana_data`: Grafana dashboards, users, and settings

## Health Checks

Prometheus includes a health check that verifies service availability before starting Grafana.

## Monitoring Targets

### Default Targets

The stack monitors itself by default:
- Prometheus server metrics
- Node Exporter system metrics
- Grafana application metrics

### Adding Custom Targets

Edit `config/prometheus.yml` to add more targets:

```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['my-app:8080']
```

## Grafana Setup

### Initial Setup

1. Access Grafana at http://localhost:3000
2. Login with admin / admin
3. Prometheus datasource is pre-configured
4. Import dashboards or create your own

### Importing Dashboards

Popular community dashboards:
- **Node Exporter Full**: Dashboard ID 1860
- **Docker Monitoring**: Dashboard ID 893
- **Nginx Monitoring**: Dashboard ID 12559

```bash
# Import via Grafana UI: + → Import → Use dashboard ID
```

## Custom Configuration

### Prometheus Rules

Add alerting rules in `config/rules/`:

```yaml
# config/rules/alerts.yml
groups:
  - name: basic_alerts
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
```

### Grafana Provisioning

- **Datasources**: Auto-configured in `config/grafana/provisioning/datasources/`
- **Dashboards**: Place JSON files in `config/grafana/dashboards/`

## Environment Variables

Configuration can be customized via the `.env` file:

```env
ADMIN_EMAIL=admin
ADMIN_PASSWORD=admin
```

## Example Metrics Queries

### System Metrics
```promql
# CPU usage percentage
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage percentage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk usage percentage
100 - ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes)
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```