*This project has been created as part of the 42 curriculum by locagnio.*

# Inception

## Description
Inception is a project that consists of setting up a small infrastructure composed of different services under specific rules. The goal is to deploy a web stack using Docker Compose with multiple dedicated containers.  

The project includes:
- An NGINX container with TLSv1.2 or TLSv1.3.
- A WordPress container with PHP-FPM, without NGINX.
- A MariaDB container, without NGINX.
- Persistent volumes for the WordPress database and website files.
- A Docker network connecting all containers.

This setup must be done without using pre-built images except Debian/Alpine and must use environment variables for any sensitive information.

## Instructions
To run the project:
1. Clone the repository.
2. Create a `.env` file in `srcs/` with the required variables (e.g., `DOMAIN_NAME`, `MYSQL_USER`, `MYSQL_PASSWORD`, etc.).
3. Use the provided `Makefile` to build and launch the stack:
   ```bash
   make up        # Builds and runs containers
   make down      # Stops containers
   make fclean    # Removes containers and custom images
   make re        # Rebuilds and restarts containers
    ```
4. Access the website at `https://<DOMAIN_NAME>` or `https://localhost`.

## Resources
- [Tuto Grademe Inception](https://tuto.grademe.fr/inception/)
- AI assistance was used to help debug Dockerfiles, understand service interactions, and create the .md files.

## Technical Choices

- **Base OS**: Debian slim for minimal footprint and familiarity from previous projects.
- **VM vs Docker**:
  - **VM**: Full isolation, heavier resource usage.
  - **Docker**: Lightweight, fast deployment, container-level isolation.
- **Secrets vs Environment Variables**:
  - `.env` files for non-sensitive variables.
  - Docker secrets for passwords and credentials.
- **Docker Network vs Host Network**:
  - Custom Docker network ensures container isolation and communication.
- **Docker Volumes vs Bind Mounts**:
  - Volumes used for persistent data; safer and easier to manage than direct host mount.

## Project Structure

Structure of the project:

```text
.
├── Makefile
├── README.md
├── secrets
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── wp_admin_password.txt
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── mariadb
        │   ├── Dockerfile
        │   ├── conf
        │   |   └── my.cnf
        │   └── tools
        │       └── entrypoint.sh
        ├── nginx
        │   ├── Dockerfile
        │   ├── tools
        │   │   └── generate_certs.sh
        |   └── conf
        │       └── default.conf
        └── wordpress
            ├── Dockerfile
            └── tools
                ├── entrypoint.sh
                └── setup.sh
```

- **`srcs/.env`**: Stores environment variables like `DOMAIN_NAME`, `MYSQL_USER`, `MYSQL_PASSWORD`.  
- **`srcs/requirements`**: Contains Dockerfiles and configuration for each service.  
- **`secrets/`**: Stores confidential credentials (should never be pushed to Git).  

---

## Containers Overview

- **NGINX**: Handles HTTPS on port 443, only entrypoint to the stack.  
- **WordPress**: Runs PHP-FPM, connects to MariaDB, served via NGINX.  
- **MariaDB**: Provides database backend for WordPress, with persistent volume.  

---

## Accessing the Services

- Website: `https://<DOMAIN_NAME>` or `https://localhost`.  
- WordPress Admin: `https://<DOMAIN_NAME>/wp-admin` (use admin credentials stored in secrets).  

---

## Verifying Services

To check if containers are running:

```bash
docker ps          # Lists running containers
docker logs <name> # Check logs for each container
```