# MongoDB + Mongo Express Stack

A complete MongoDB database setup with Mongo Express web interface for database administration.

## What's Included

- **MongoDB 7.0**: Modern MongoDB database
- **Mongo Express 1.0**: Web-based MongoDB administration interface

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
| MongoDB | localhost:27017 | 27017 | dbuser / dbpassword |
| Mongo Express | http://localhost:8081 | 8081 | admin / admin |

## Default Configuration

- **Database Name**: mydb
- **Database User**: dbuser
- **Database Password**: dbpassword
- **Mongo Express User**: admin
- **Mongo Express Password**: admin

## Volumes

- `mongodb_data`: MongoDB database files
- `mongodb_config`: MongoDB configuration files

## Health Checks

MongoDB includes a health check using `mongosh` to verify database connectivity before starting Mongo Express.

## Custom Configuration

### Database Initialization

Place JavaScript initialization scripts in `./config/init/` to run them during database startup:

```bash
mkdir -p config/init
cat > config/init/01-init.js << 'EOF'
db = db.getSiblingDB('mydb');
db.createCollection('users');
db.users.insertOne({name: 'John Doe', email: 'john@example.com'});
EOF
```

## Connection Strings

### From Applications
```
mongodb://dbuser:dbpassword@localhost:27017/mydb
```

### From Other Docker Services
```
mongodb://dbuser:dbpassword@mongodb:27017/mydb
```

## Environment Variables

All configuration can be customized via the `.env` file:

```env
DB_NAME=mydb
DB_USER=dbuser
DB_PASSWORD=dbpassword
ADMIN_EMAIL=admin
ADMIN_PASSWORD=admin
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys data)
docker compose down -v
```