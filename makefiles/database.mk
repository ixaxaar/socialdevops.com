### DATABASE
# ██████████████████████████████████████████████████████████████████████

include .envrc

database.connect: ## Connect to database
	docker-compose -f ./docker-compose-dev.yml exec socialdevops-db psql -U ${PGUSER} --db ${PGDATABASE}

# TODO: haskell has shit support for basic shit like db migration management
# we cannot do upgrade/downgrades or maintain versions, as in alembic, go-pg, slick-forklift etc
