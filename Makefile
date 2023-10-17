DEV_DB_URI:=postgresql://postgres:dev@localhost:5432/data_pipeline
TEST_DB_URI:=postgresql://postgres:dev@localhost:5432/dev

DEV_DB_URI_CONTAINER:=postgresql://postgres:dev@local-db-postgres:5432/data_pipeline

DOCKER_COMPOSE_COMMAND:=docker compose
NETWORK_NAME=local

# formatting
NONE=\033[00m
RED=\033[01;31m
GREEN=\033[01;32m
YELLOW=\033[01;33m
PURPLE=\033[01;35m
CYAN=\033[01;36m
WHITE=\033[01;37m
BOLD=\033[1m
UNDERLINE=\033[4m

help:
	@echo ""
	@echo "Please use ${BOLD}'make <target>'${NONE}  where ${BOLD}<target>${NONE} is one of"
	@echo ""
	@echo " ${BOLD}create${NONE} : ${GREEN}Creates a database server and restores the data from staging into it${NONE}"
	@echo " ${BOLD}resume${NONE} : ${GREEN}Resumes your existing database server${NONE}"
	@echo " ${BOLD}stop${NONE} : ${GREEN}Stops your database server without losing data${NONE}"
	@echo " ${BOLD}details${NONE} : ${GREEN}Gives you the connection details for postgres and pgadmin${NONE}"
	@echo " ${BOLD}backup${NONE} : ${GREEN}Creates a backup of your database${NONE}"
	@echo " ${BOLD}restore-from-backup${NONE} : ${GREEN}Restores a backup of your database${NONE}"
	@echo " ${BOLD}clean${NONE} : ${RED}Removes your database server ${UNDERLINE}including all your postgres data${NONE}"
	@echo ""

# restores a backup into the database server
restore-from-backup:
	echo "restoring from backup..."
	chmod u+x bash_scripts/postgres_restore_backup_file.sh
	bash_scripts/postgres_restore_backup_file.sh

dump-postgres-schema: test-db
	bash_scripts/postgres_dump_schema.sh

# starts the container (ignoring its state)
resume: development-db
	${MAKE} details

development-db:
	@echo "starting database infrastructure..."
	docker network create ${NETWORK_NAME} || true
	COMPOSE_DOCKER_CLI_BUILD=1 ${DOCKER_COMPOSE_COMMAND} -f docker/docker-compose.yml up -d ${WAIT_OPTION}
	@echo "starting database infrastructure...${GREEN}done${NONE}"

# will only be successful if user says yes
check-clean:
	@echo "${RED} Are you sure - this will delete all your data (including pgdata and local backups) ${NONE}? [y/n] " && read ans && [ $${ans:-N} = y ]

# Removes existing containers, backup directories and local pg data (starts from a fresh)
force-clean:
	@echo "removing existing database infrastructure..."
	${DOCKER_COMPOSE_COMMAND} -f ./docker/docker-compose.yml down -v
	rm -rf ${PWD}/logs/*
	# rm -rf ${PWD}/backups/*
	docker network rm -f ${NETWORK_NAME} || true
	@echo "removing existing database infrastructure...${GREEN}done${NONE}"

# checks the user wants to clean, then forces the clean
clean: check-clean force-clean

check-requirements:
	@echo "checking requirements..."
	chmod u+x bash_scripts/check-requirements.sh
	bash_scripts/check-requirements.sh
	@echo "checking requirements...${GREEN}you're good!${NONE}"

backup:
	@echo "backing up database..."
	chmod u+x bash_scripts/postgres_create_backup_file.sh
	bash_scripts/postgres_create_backup_file.sh
	@echo "backing up database...${GREEN}done${NONE}"

details:
	@echo ""
	@echo "${GREEN} ------ Completed ------ ${NONE}"
	@echo "You can access you database server using the following uri:"
	@echo "${BOLD}${YELLOW} ${DEV_DB_URI} ${NONE}"
	@echo ""
	@echo "You can access pgadmin using the following uri:"
	@echo "${BOLD}${YELLOW} http://localhost:8090/ ${NONE}  user: ${UNDERLINE}admin@admin.com${NONE}, password: ${UNDERLINE}secret${NONE}"
	@echo "(note: You should use: ${DEV_DB_URI_CONTAINER} for the connection)"
	@echo ""
	@echo "Import logs can be found: /logs/postgres-import.log"
	@echo "Error logs can be found: /logs/postgres-import-error.log"

# Gives you a fresh development machine from a staging snapshot
create: check-requirements force-clean development-db restore-from-backup
	${MAKE} details

# Stops your database server but keeps your data intact
stop:
	COMPOSE_DOCKER_CLI_BUILD=1 ${DOCKER_COMPOSE_COMMAND} -f ./docker/docker-compose.yml stop

.PHONY: help restore-from-backup resume development-db test-db clean check-clean force-clean fetch-staging-backup check-requirements details create stop clean-backup-files
