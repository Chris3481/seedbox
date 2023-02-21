#!/bin/bash

# Export env vars
export $(grep -v '^#' .env | xargs)

mkdir -p ${BASE_PATH}/data
mkdir -p ${BASE_PATH}/logs
mkdir -p ${BASE_PATH}/vpn
mkdir -p ${DOWNLOAD_FOLDER_PATH}

docker-compose -f docker-vpn-service.yml -f docker-local-services.yml -f docker-seedbox-services.yml  up -d
