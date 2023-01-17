#!/bin/bash

# Docker entrypoint script.

echo $PGPASSWORD
echo $DB_HOSTNAME

# Wait until Postgres is ready.
while ! pg_isready -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -Atqc "\\list $DB_NAME"` ]]; then
    echo "Database $DB_NAME does not exist. Creating..."
    createdb -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -E UTF8 $DB_NAME -l en_US.UTF-8 -T template0
    echo "Database $DB_NAME created."
fi

SCHEMA_EXISTS=$(psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'arke_system');")
if [ $SCHEMA_EXISTS = "f" ]; then
    echo "Schema Arke system does not exist. Creating..."
    mix arke_postgres.init_db
    # mix run priv/repo/seeds.exs
    echo "Schema Arke system created."
fi

# if [[ -z `psql -c 'SELECT schema_name FROM information_schema.schemata WHERE schema_name =' /'/ 'arke_system;/'/ '` ]]; then
#     echo "Schema Arke system does not exist. Creating..."
#     mix arke_postgres.init_db
#     # mix run priv/repo/seeds.exs
#     echo "Schema Arke system created."
# fi

echo "Arke is ready"
exec mix phx.server