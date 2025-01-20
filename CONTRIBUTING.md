# Contributing to Docker Compose Recipes

Thank you for your interest in contributing to Docker Compose Recipes! This guide will help you get started with contributing to this project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Stack Guidelines](#stack-guidelines)
- [Pull Request Process](#pull-request-process)
- [Development Setup](#development-setup)

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our commitment to providing a welcoming and inspiring community for all. Please be respectful and constructive in all interactions.

## 🚀 Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Create a new branch for your contribution
4. Make your changes
5. Test your changes
6. Submit a pull request

## 🛠 How to Contribute

### Types of Contributions

We welcome several types of contributions:

- **New stacks**: Add new Docker Compose stacks for popular tools
- **Stack improvements**: Enhance existing stacks with better configurations
- **Documentation**: Improve README files, add examples, fix typos
- **Bug fixes**: Fix issues in existing stacks
- **Testing**: Improve validation and testing workflows

### Before You Start

1. Check the [existing issues](https://github.com/your-repo/docker-compose-recipes/issues) to see if your idea is already being discussed
2. For major changes, please open an issue first to discuss the proposed changes
3. Make sure your contribution aligns with the project goals

## 📦 Stack Guidelines

When creating a new stack, please follow these guidelines:

### Stack Structure

Each stack should follow this structure:

```
stack-name/
├── docker-compose.yml    # Main compose file
├── .env.example         # Environment variables template
├── README.md           # Stack-specific documentation
└── config/             # Optional custom configurations
```

### Naming Conventions

- **Stack folders**: Use lowercase with hyphens (e.g., `postgres-pgadmin`)
- **Service names**: Use descriptive, lowercase names
- **Environment variables**: Use UPPER_CASE with underscores

### Docker Compose Best Practices

1. **Use specific image tags**: Avoid `latest` tags in production-ready stacks
2. **Include health checks**: Add health checks for critical services
3. **Use named volumes**: Prefer named volumes over bind mounts for data persistence
4. **Add restart policies**: Use `restart: unless-stopped` for production-like behavior
5. **Network isolation**: Use custom networks when appropriate
6. **Resource limits**: Consider adding resource limits for resource-intensive services

### Environment Variables

1. Provide sensible defaults in `docker-compose.yml`
2. Document all variables in `.env.example`
3. Use consistent variable naming across stacks
4. Never commit real credentials or secrets

### Example docker-compose.yml

```yaml
version: '3.8'

services:
  myservice:
    image: myservice:1.0.0
    container_name: myservice
    restart: unless-stopped
    environment:
      SERVICE_USER: ${SERVICE_USER:-defaultuser}
      SERVICE_PASSWORD: ${SERVICE_PASSWORD:-defaultpass}
    ports:
      - "8080:8080"
    volumes:
      - myservice_data:/data
      - ./config/myservice.conf:/etc/myservice.conf
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  myservice_data:
    driver: local

networks:
  default:
    name: myservice-network
```

### README Requirements

Each stack must include a comprehensive README.md with:

1. **Description**: What the stack includes and its purpose
2. **Quick Start**: Simple commands to get started
3. **Access Information**: URLs, ports, and default credentials
4. **Configuration**: Environment variables and customization options
5. **Usage Examples**: Code samples for connecting to services
6. **Volumes**: Description of persistent data
7. **Health Checks**: Information about service health monitoring

Use the existing stack READMEs as templates for consistency.

## 🔄 Pull Request Process

1. **Create a branch**: Use a descriptive branch name (e.g., `add-postgresql-stack`)

2. **Make your changes**: Follow the guidelines above

3. **Test locally**: Ensure your stack works correctly
   ```bash
   cd your-stack
   docker compose up -d
   docker compose ps
   docker compose down
   ```

4. **Validate configuration**: Use the Makefile to validate
   ```bash
   make validate s=your-stack
   ```

5. **Update documentation**:
   - Add your stack to the main README.md
   - Ensure your stack README is complete
   - Update any relevant documentation

6. **Commit your changes**: Use clear, descriptive commit messages
   ```bash
   git add .
   git commit -m "Add Redis + RedisInsight stack with monitoring"
   ```

7. **Push to your fork**:
   ```bash
   git push origin your-branch-name
   ```

8. **Create a pull request**: Provide a clear description of your changes

### Pull Request Template

When creating a pull request, please include:

- **What**: Brief description of the changes
- **Why**: Reason for the changes
- **How**: How the changes were implemented
- **Testing**: Steps you took to test the changes
- **Screenshots**: If applicable, screenshots of the running services

## 💻 Development Setup

### Prerequisites

- Docker and Docker Compose
- Make (for using the Makefile)
- Git

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/docker-compose-recipes.git
   cd docker-compose-recipes
   ```

2. Test existing stacks:
   ```bash
   make list
   make up s=postgres-pgadmin
   make ps s=postgres-pgladmin
   make down s=postgres-pgadmin
   ```

3. Validate all configurations:
   ```bash
   make validate-all
   ```

### Testing Your Changes

Before submitting a pull request:

1. **Functionality test**: Ensure services start and are accessible
2. **Configuration validation**: Run `docker compose config` without errors
3. **Health checks**: Verify health checks pass
4. **Documentation**: Ensure README is complete and accurate
5. **Environment variables**: Test with custom .env values

## 📝 Documentation Standards

- Use clear, concise language
- Include practical examples
- Keep formatting consistent with existing documentation
- Test all commands and examples
- Use proper markdown formatting

## 🐛 Reporting Issues

When reporting issues:

1. Use the issue template if available
2. Include steps to reproduce
3. Provide system information (OS, Docker version)
4. Include relevant logs or error messages
5. Specify which stack is affected

## ❓ Questions

If you have questions about contributing:

1. Check existing issues and discussions
2. Review the documentation
3. Open a new issue with the "question" label

## 🎉 Recognition

Contributors will be recognized in the project documentation. Thank you for helping make this project better for everyone!

---

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (MIT License).