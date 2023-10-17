#!/bin/sh
pendingMigrationCount=$(jq '[.migrations[] | select(.state | contains("Pending"))] | length' ./output.json)
if [ $pendingMigrationCount -gt 0 ]; then
  echo "There are ${pendingMigrationCount} pending migrations:"
else
  echo "There are no pending migrations"
fi

jq '[.migrations[] | select(.state | contains("Pending"))] | .[] | {description,version,filepath} ' ./output.json
