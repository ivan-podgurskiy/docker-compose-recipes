# MySQL + phpMyAdmin Stack

A complete MySQL database setup with phpMyAdmin web interface for database administration.

## What's Included

- **MySQL 8.0**: Latest MySQL database server
- **phpMyAdmin 5.2**: Web-based MySQL administration interface

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
| MySQL | localhost:3306 | 3306 | root / rootpassword |
| phpMyAdmin | http://localhost:8080 | 8080 | root / rootpassword |

## Default Configuration

- **Database Name**: mydb
- **Database User**: dbuser
- **Database Password**: dbpassword
- **Root Password**: rootpassword

## Volumes

- `mysql_data`: MySQL database files

## Health Checks

MySQL includes a health check that verifies database connectivity before starting phpMyAdmin.

## Custom Configuration

### MySQL Configuration

The stack includes a custom MySQL configuration file at `config/my.cnf` with optimized settings for development:

- UTF8MB4 character set
- Performance optimizations
- Security improvements

### Database Initialization

Place SQL scripts in `./config/init/` to run them during database initialization:

```bash
mkdir -p config/init
echo "CREATE TABLE test (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100));" > config/init/01-init.sql
```

## Environment Variables

All configuration can be customized via the `.env` file:

```env
DB_NAME=mydb
DB_USER=dbuser
DB_PASSWORD=dbpassword
DB_ROOT_PASSWORD=rootpassword
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```