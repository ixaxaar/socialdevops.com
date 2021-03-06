### LOCAL SERVER
# ██████████████████████████████████████████████████████████████████████

.ONESHELL:

local.install: ## Prepare local installation
	@curl -sSL https://get.haskellstack.org/ | sh
	@make local.build
	@docker volume create --name=socialdevops_db

local.build: ## Build project
	@stack build

local.start: ## Start the server on local
	@source .envrc
	@nodemon --watch src/ -e hs --signal SIGKILL --exec 'stack build && stack exec socialdevops-exe'

local.watch: venv ## Start and watch the server on local
	@make start

local.services: ## Start DB and other services
	@docker-compose -f ./docker-compose-dev.yml up

local.services.build: ## Build DB and other services
	@docker volume rm socialdevops_db
	@docker volume create --name=socialdevops_db
	@docker-compose -f ./docker-compose-dev.yml build
