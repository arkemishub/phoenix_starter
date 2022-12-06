#!/bin/bash
# migrate & start


MIGRATION_COMMAND="/app/bin/migrate"
echo "Running migration"
$MIGRATION_COMMAND
START_PHX_COMMAND="/app/bin/server"
echo "Starting server $START_PHX_COMMAND"
$START_PHX_COMMAND || exit 1