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