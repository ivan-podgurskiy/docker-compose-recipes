# PostgreSQL + pgAdmin Stack

A complete PostgreSQL database setup with pgAdmin web interface for database administration.

## What's Included

- **PostgreSQL 16**: Modern PostgreSQL database with Alpine Linux base
- **pgAdmin 4**: Web-based PostgreSQL administration interface

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
| PostgreSQL | localhost:5432 | 5432 | dbuser / dbpassword |
| pgAdmin | http://localhost:5050 | 5050 | admin@localhost / admin |

## Default Configuration

- **Database Name**: mydb
- **Database User**: dbuser
- **Database Password**: dbpassword
- **pgAdmin Email**: admin@localhost
- **pgAdmin Password**: admin

## Volumes

- `postgres_data`: PostgreSQL database files
- `pgadmin_data`: pgAdmin settings and configurations

## Health Checks

PostgreSQL includes a health check that verifies database connectivity before starting dependent services.

## Custom Configuration

### Database Initialization

Place SQL scripts in `./config/init/` to run them during database initialization:

```bash
mkdir -p config/init
echo "CREATE TABLE test (id SERIAL PRIMARY KEY, name VARCHAR(100));" > config/init/01-init.sql
```

### pgAdmin Server Configuration

The stack includes a pre-configured server connection in `config/servers.json` that automatically connects pgAdmin to the PostgreSQL instance.

## Environment Variables

All configuration can be customized via the `.env` file:

```env
DB_NAME=mydb
DB_USER=dbuser
DB_PASSWORD=dbpassword
DB_ROOT_PASSWORD=rootpassword
ADMIN_EMAIL=admin@localhost
ADMIN_PASSWORD=admin
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```