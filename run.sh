#!/bin/bash

# Export env vars
export $(grep -v '^#' .env | xargs)

mkdir -p ${BASE_PATH}/data
mkdir -p ${BASE_PATH}/logs
mkdir -p ${BASE_PATH}/vpn
mkdir -p ${DOWNLOAD_FOLDER_PATH}

docker-compose up -d
