# Mailpit Stack

A local SMTP testing server that captures emails for development and testing purposes.

## What's Included

- **Mailpit 1.12**: Local SMTP server with web interface for email testing

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
| SMTP Server | localhost:1025 | 1025 | SMTP endpoint for applications |
| Web Interface | http://localhost:8025 | 8025 | Email viewing interface |

## Default Configuration

- **Max Messages**: 5000 emails stored
- **Authentication**: Accepts any credentials
- **SSL/TLS**: Disabled (development mode)

## Volumes

- `mailpit_data`: Email storage and Mailpit database

## Health Checks

Mailpit includes a health check that verifies the web interface availability.

## Usage Examples

### SMTP Configuration

Configure your applications to use Mailpit as the SMTP server:

#### Environment Variables
```env
SMTP_HOST=localhost
SMTP_PORT=1025
SMTP_USER=any_username
SMTP_PASSWORD=any_password
SMTP_SECURE=false
```

#### PHP (Laravel)
```env
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=test
MAIL_PASSWORD=test
MAIL_ENCRYPTION=null
```

#### Node.js (Nodemailer)
```javascript
const transporter = nodemailer.createTransporter({
  host: 'localhost',
  port: 1025,
  secure: false,
  auth: {
    user: 'any_user',
    pass: 'any_password'
  }
});
```

#### Python (Django)
```python
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'localhost'
EMAIL_PORT = 1025
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
EMAIL_USE_TLS = False
```

### From Other Docker Services

When connecting from other Docker containers:

```env
SMTP_HOST=mailpit
SMTP_PORT=1025
```

### Testing Email Delivery

```bash
# Send test email via command line
echo "Subject: Test Email
From: test@example.com
To: recipient@example.com

This is a test email." | nc localhost 1025
```

## Web Interface Features

Access http://localhost:8025 to:
- View all captured emails
- Search emails by sender, recipient, or subject
- Preview HTML and text versions
- Download email attachments
- View email headers and source
- Delete emails or clear all

## Environment Variables

Configuration can be customized via the `.env` file:

```env
# Maximum number of messages to store
MP_MAX_MESSAGES=5000

# SMTP authentication settings
MP_SMTP_AUTH_ACCEPT_ANY=1
MP_SMTP_AUTH_ALLOW_INSECURE=1
```

## API Access

Mailpit provides a REST API for programmatic access:

```bash
# Get all messages
curl http://localhost:8025/api/v1/messages

# Get specific message
curl http://localhost:8025/api/v1/message/{id}

# Delete all messages
curl -X DELETE http://localhost:8025/api/v1/messages
```

## Stopping the Stack

```bash
# Stop services
docker compose down

# Stop and remove volumes (⚠️ destroys emails)
docker compose down -v
```