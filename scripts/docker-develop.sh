#!/bin/bash

# Starts the development environment inside a Docker container

source scripts/docker-require.sh
scripts/docker-prepare.sh

docker-compose -f ./client/app/dev.docker-compose.yaml up "$@"

