#!/bin/bash

# Database connection information
DB_HOST="localhost"  # Replace with your database host
DB_PORT="5432"      # Replace with your database port
DB_NAME="data_pipeline"  # Replace with the name of your database
DB_USER="postgres"      # Replace with your database username
DB_PASSWORD="dev"  # Replace with your database password (if needed)

PGPASSFILE=".pgpass"

# Output file name and location
BACKUP_DIR="./docker/backups"
TAG=$(date +"%Y%m%d%H%M")_latest
# Define the latest and oldest backup file names
BACKUP_FILE="$BACKUP_DIR/db_backup_$TAG.sql"

# Check if a file with _latest exists in the backup directory
latest_backup_file=$(find "$BACKUP_DIR" -type f -name "*_latest.sql" -print -quit)

if [ -n "$latest_backup_file" ]; then
    # Remove _latest from the file name
    new_backup_file="${latest_backup_file%_latest.sql}.sql"

    # Rename the file
    mv "$latest_backup_file" "$new_backup_file"
    pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$BACKUP_FILE"
else
    pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$BACKUP_FILE"
fi


# Check the exit status of pg_dump
if [ $? -eq 0 ]; then
    echo "Database dump created successfully: $BACKUP_FILE"
else
    echo "Error creating the database dump."
fi