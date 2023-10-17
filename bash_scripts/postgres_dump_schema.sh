#!/bin/sh

echo "dumping"
COMMAND="pg_dump -U postgres dev -f /var/lib/postgresql/dumps/dump.sql"
chmod +x bash_scripts/postgres_execute_command.sh
bash_scripts/postgres_execute_command.sh --command="${COMMAND}"
echo "done"
