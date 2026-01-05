# User Documentation — Inception

## Starting and Stopping the Stack

Use the provided `Makefile` to manage the stack:

```bash
make/make up       # Build and start all containers
make down           # Stop all containers
make fclean         # Stop containers and remove custom images
make re             # Rebuild and restart containers
make prune          # Remove all unused Docker objects (containers, networks, images, volumes)
```

## Accessing the Website and WordPress Admin

- Open your browser and navigate to:  
  `https://<DOMAIN_NAME>(:external_port)` or `https://localhost(:external_port)`
- To access the WordPress admin panel:  
  `https://<DOMAIN_NAME>(:external_port)/wp-admin`  
  Use the administrator credentials stored in the `secrets/` folder.

## Managing and Locating Credentials

- **Secrets directory**: Contains important credentials. Example files:  
  - `db_root_password.txt` — MariaDB root password  
  - `db_password.txt` — WordPress database user password  
  - `wp_admin_password.txt` — WordPress admin user credentials  

> ⚠️ Never commit secrets to Git.

## Checking Service Status

You can verify that all services are running:

```bash
docker ps          # Lists running containers
docker logs <name> # Shows logs for a specific container
```

## Containers included

- `my_nginx` — NGINX container, handles HTTPS traffic on port 443 and serves as the only entrypoint to the stack.
- `my_wordpress` — WordPress + PHP-FPM container, connects to MariaDB, served via NGINX.
- `my_mariadb` — MariaDB container, provides the database backend for WordPress, with persistent volume for data storage.

## Verifying Volumes and Network

- Check Docker volumes:

```bash
docker volume ls    # Lists all Docker volumes
```

## Check Docker networks

```bash
docker network ls   # Lists all Docker networks
```

## Ensure that the following are present

```
volumes:
  - srcs_mariadb_data: "stores MariaDB database data"
  - srcs_wordpress_data: "stores WordPress website files"

network:
  - srcs_inception: "custom Docker network connecting all containers"
```

## Troubleshooting

```
if_containers_fail:
  - inspect_logs:
      command: "docker logs <container_name>"
  - verify_volumes: "Ensure volumes are mounted correctly"
  - check_env: "Verify that environment variables in srcs/.env are correctly configured"
  - restart_stack:
      command: "make re"

if_wordpress_admin_inaccessible:
  - confirm_container_running:
      command: "docker ps | grep my_wordpress"
  - verify_credentials: "Check secrets/credentials.txt for correct admin credentials"
  - check_php_fpm_logs:
      command: "docker exec -it my_wordpress cat /var/log/php8.2-fpm.log"
```

## Notes

```
notes:
  - "The NGINX container is the only entrypoint to your infrastructure via HTTPS (port 443). Do not attempt to access WordPress directly on its container port."
  - "Any changes to the .env file require restarting the stack using make re."
  - "Avoid modifying volumes manually to prevent data corruption."
```