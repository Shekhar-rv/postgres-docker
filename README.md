# Postgres Docker

## Description

This is project combines 3 services such as the official postgres image to be paired with pgAdmin for the GUI and flyway schema for running migrations. The following are the features that I aim to explore:

* Configuring a docker-compose file with postgres database with pgAdmin and flyway schema.
* Run database backups and database migrations, check the make file for details (This is currently using pg_dump until I explore flyway schema).

## Setup

Ensure you have an up to date version of docker. Specificially that support docker compose --wait

Then run the following command to show the help menu:

```bash
make help
```

You would need to configure the server on pgAdmin to connect to the database. The following are the details:


### Things to do next

* Check how to get .pgpass working
* Create script to run migrations
* Go through make file in db-utils and see what you can incorporate
* Check if you can host a postgres database on the home server