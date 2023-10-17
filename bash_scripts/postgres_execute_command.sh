#!/bin/sh
for i in "$@"; do
  case $i in
  -c=* | --command=*)
    COMMAND="${i#*=}"
    shift # past argument=value
    ;;
  -* | --*)
    echo "Unknown option $i"
    exit 1
    ;;
  *) ;;
  esac
done

mkdir -p logs
touch logs/postgres.log
touch logs/postgres-error.log
docker exec -i local-db-postgres bash -c "$COMMAND;(exit \$?)" >logs/postgres.log 2>logs/postgres-error.log
