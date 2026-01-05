NAME			= inception
DOCKER_COMPOSE	= docker compose
DOCKER_FILE		= srcs/docker-compose.yml

BUILD			= up --build --force-recreate --remove-orphans
SHUT_DOWN		= down

CYAN			= "\033[36m"
RED				= "\033[31m"
GREEN			= "\033[32m"
RESET			= "\033[0m"

all: up

up:
	@echo "$(CYAN) $(NAME) turn on ... $(RESET)"
	@$(DOCKER_COMPOSE) -f $(DOCKER_FILE) $(BUILD)

down:
	@echo "$(CYAN)$(NAME) turn off ...$(RESET)"
	@$(DOCKER_COMPOSE) -f $(DOCKER_FILE) $(SHUT_DOWN)

fclean: down prune
	@echo "$(CYAN) custom Docker images removed...$(RESET)"
	@docker rmi my_nginx \
				my_wordpress \
				my_mariadb \
				2>/dev/null || true

prune:
	@echo "$(CYAN)Pruning Docker system...$(RESET)"
	@docker system prune -af
	@docker volume prune -f

re: fclean up

.PHONY: all up down fclean re prune