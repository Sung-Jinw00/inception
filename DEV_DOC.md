# Developer Documentation — Inception

## Prerequisites

Before working on this project, ensure the following tools and dependencies are installed on your system:

- Docker
- Docker Compose
- Debian-based environment
- PHP 8.2
- PHP-FPM 8.2
- PHP MySQL extension
- MariaDB server and client
- NGINX
- curl
- tar
- less
- openssl

---

## Project Overview

This project uses Docker and Docker Compose to deploy a small web infrastructure composed of three services:

- NGINX (HTTPS entrypoint)
- WordPress with PHP-FPM
- MariaDB database

Each service runs in its own container, built from a custom Dockerfile based on Debian `bookworm-slim`.

---

## Environment Setup from Scratch

### 1. Clone the repository

```bash
git clone <repository_url>
cd inception
```

### 2. Environment variables

Create a .env file in the srcs/ directory:

```env
LOGIN=your_login
DOMAIN_NAME=your_login.42.fr
MYSQL_HOST=mariadb
MYSQL_USER=wpuser
MYSQL_DATABASE=wordpress
WP_SITE_TITLE=lol
WP_ADMIN_USER=wpa
WP_ADMIN_EMAIL=wae
```

⚠️ Never commit .env or credentials to Git.
Sensitive data must be stored in the secrets/ directory and ignored by Git.

## Building and Launching the Project

The project is managed using a Makefile.

```bash
make/make up        # Build and start all containers
make down           # Stop all containers
make fclean         # Stop containers and remove custom images
make prune          # Remove unused Docker resources and volumes
make re             # Full rebuild and restart
```

Docker Compose is called internally by the Makefile using:

```bash
docker compose -f srcs/docker-compose.yml
```

## Containers Description
### NGINX (my_nginx)

- Listens on port 443 only
- Handles TLSv1.2 / TLSv1.3
- Acts as the single entrypoint to the infrastructure
- Proxies requests to the WordPress container

### WordPress (my_wordpress)

- Runs WordPress with PHP-FPM
- No NGINX inside the container
- Uses WP-CLI for installation and configuration
- Connects to MariaDB through the Docker network

### MariaDB (my_mariadb)

- Database backend for WordPress
- Initialized via custom entrypoint script
- Uses persistent volume for data storage

## Docker Network and Volumes
### Docker Network

srcs_inception — Custom Docker bridge network allowing communication between containers

Check networks:

```bash
docker network ls
```

### Docker Volumes

srcs_mariadb_data — Stores MariaDB database files

srcs_wordpress_data — Stores WordPress website files

Check volumes:

```bash
docker volume ls
```

Volumes are mapped on the host under:

```
    /home/<login>/data/
```

## Managing Containers
```bash
docker ps # Check running containers
docker logs <container_name> # Inspect container logs
docker exec -it <container_name> /bin/sh # Access a running container
docker exec -it my_wordpress cat /var/log/php8.2-fpm.log # Check PHP-FPM logs
```

## Data Persistence

- Database data persists inside srcs_mariadb_data
- WordPress files persist inside srcs_wordpress_data
- Containers can be destroyed and rebuilt without data loss
⚠️ Avoid editing volume files manually on the host.

## Development Notes

- Each container has its own Dockerfile.
- No infinite loops or hacky commands (tail -f, sleep infinity, etc.).
- Containers respect Docker best practices and PID 1 behavior.
- NGINX is the only public-facing service.
- Any change to .env requires restarting the stack:

```bash
make re
```

## Troubleshooting

- Containers fail to start

```bash
docker logs <container_name> # Check logs
```

- Verify volumes and environment variables

```bash
make re # Restart the stack
```

- WordPress admin inaccessible

```bash
docker ps | grep my_wordpress # Confirm WordPress container is running
```

- Verify credentials in secrets/credentials.txt
- Check PHP-FPM logs inside the container

## Notes

- Docker containers are not virtual machines.
- Never expose internal container ports.
- HTTPS (port 443) is the only allowed entrypoint.
- Secrets must never be committed to the repository.
- All containers are configured with a restart policy to ensure availability in case of crash.

