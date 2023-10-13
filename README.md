# Postgres Docker

## Description

This is a docker image for postgres. It is based on the official postgres image, but adds some additional features:

* It is configured to run as a non-root user
* It is set up to run database backups and database migrations, check the make file for details

## Setup

Ensure you have an up to date version of docker. Specificially that support docker compose --wait

Copy .env.aws.dist to .env.aws and input your credentials into the file.

Then run:

```bash
make help
```


### Things to do next

* Create docker-compose file to run the database
* Create script to create a database dump
* Create script to restore a backup
* Create script to run migrations
* Go through make file in db-utils and see what you can incorporate
* Check if you can host a postgres database on the home server
* What is pg_admin?