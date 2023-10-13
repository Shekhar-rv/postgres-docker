DEV_DB_URI:=postgresql://postgres:dev@localhost:5444/
TEST_DB_URI:=postgresql://postgres:dev@localhost:5444/dev
STAGING_REPLICA_DB_URI:=postgresql://postgres:dev@localhost:5432/data_pipeline_backup

DEV_DB_URI_CONTAINER:=postgresql://postgres:dev@local-db-postgres:5432/data_pipeline
BACKUP_BUCKET=staging.audiens-rds-bk

DOCKER_COMPOSE_COMMAND:=docker compose


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
	@echo " ${BOLD}clean${NONE} : ${RED}Removes your database server ${UNDERLINE}including all your postgres data${NONE}"
	@echo ""