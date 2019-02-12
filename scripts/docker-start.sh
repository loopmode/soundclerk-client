#!/bin/bash

# runs the compiled production client on port 80 via nginx

source scripts/docker-require.sh
scripts/docker-prepare.sh

docker-compose -f ./client/app/docker-compose.yaml up "$@"

