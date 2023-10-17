#!/bin/bash

# Database connection information
DB_HOST="localhost"  # Replace with your database host
DB_PORT="5432"      # Replace with your database port
DB_NAME="data_pipeline"  # Replace with the name of your database
DB_USER="postgres"      # Replace with your database username
DB_PASSWORD="dev"  # Replace with your database password (if needed)

# Output file name and location
BACKUP_DIR="./docker/backups"

# Get the filename as an optional command-line argument
if [ -n "$1" ]; then
    # Use the provided filename if one is specified
    backup_file="$1"
else
    # Search for the latest backup file with "_latest" at the end
    backup_file=$(find "$BACKUP_DIR" -type f -name "*_latest.sql" -print -quit)
fi

if [ -n "$backup_file" ]; then
    # Restore the database from the specified backup file
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$backup_file"
    
    if [ $? -eq 0 ]; then
        echo "Database restored successfully from $backup_file"
    else
        echo "Error restoring the database."
    fi
else
    echo "No suitable backup file found in the backup directory."
fi