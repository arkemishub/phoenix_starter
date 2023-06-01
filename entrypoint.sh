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

DB_EXISTS=$(psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -Atqc "\\list $DB_NAME")
SCHEMA_EXISTS=$(psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USER -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'arke_system');")

if [ -z "$DB_EXISTS" ]  || [ "$SCHEMA_EXISTS" = "f" ] ; then
    mix arke_postgres.init_db
fi


echo "Arke is ready"
exec mix phx.server