#!/bin/bash

# stop execution if any commands fail
set -e

# generate database.yml
cp /app/sinatra-docker/config/database.example.yml /app/sinatra-docker/config/database.yml

# prepare log and tmp directories
mkdir -p /app/sinatra-docker/tmp/log
cd /app/sinatra-docker

exec "$@"