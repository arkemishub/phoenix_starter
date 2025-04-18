#!/bin/bash

# Wait until Postgres is ready.
while ! pg_isready -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -Atqc "\\list $DB_NAME"` ]]; then
    echo "Database $DB_NAME does not exist. Creating..."
    createdb -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -E UTF8 $DB_NAME -l en_US.UTF-8 -T template0 -w
    echo "Database $DB_NAME created."
    sleep 1000
fi

SCHEMA_EXISTS=$(psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'arke_system');")
if [ $SCHEMA_EXISTS = "f" ]; then
    echo "Schema Arke system does not exist. Creating..."
    # mix arke.init
    mix ecto.create -r ArkePostgres.Repo
    mix arke_postgres.create_project --id arke_system --label Arke System Project
    mix ecto.migrate -r ArkePostgres.Repo --prefix arke_system
    mix arke.seed_project --project arke_system
    # mix run priv/repo/seeds.exs
    echo "Schema Arke system created."
fi

PROJECT_SCHEMA_EXISTS=$(psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = '$PROJECT_ID');")
if [ $PROJECT_SCHEMA_EXISTS = "f" ]; then
    mix arke_postgres.create_project --id $PROJECT_ID
    mix arke.seed_project --project $PROJECT_ID
    mix arke_postgres.create_member --project $PROJECT_ID --username admin --password admin
    echo "Project $PROJECT_ID created."
fi

mix phx.server