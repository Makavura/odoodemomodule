#!/usr/bin/env bash
DB_NAME=db
IMAGE=odoo:16
DB_CONTAINER=db
DB_USER=postgres
DB_PASSWORD=odoo
DB_IMAGE=postgres:15
NETWORK_NAME=odoo-net
CONTAINER_NAME=odoo-dev
CUSTOM_ADDONS_PATH="/home/$(whoami)/code/odoo/odoodemomodule"
DB_VOLUME=odoo-db-data

if ! sudo docker network inspect ${NETWORK_NAME} >/dev/null 2>&1; then
    echo "Creating network: ${NETWORK_NAME}"
    sudo docker network create ${NETWORK_NAME}
fi

# Start or create DB container
if sudo docker container inspect ${DB_CONTAINER} >/dev/null 2>&1; then
    if [ "$(sudo docker inspect -f '{{.State.Running}}' ${DB_CONTAINER})" != "true" ]; then
        echo "Starting database container: ${DB_CONTAINER}"
        sudo docker start ${DB_CONTAINER}
    else
        echo "Database container already running: ${DB_CONTAINER}"
    fi
else
    echo "Creating and starting new database container: ${DB_CONTAINER}"
    sudo docker run -d \
        --name ${DB_CONTAINER} \
        --network ${NETWORK_NAME} \
        -e POSTGRES_DB=${DB_NAME} \
        -e POSTGRES_USER=${DB_USER} \
        -e POSTGRES_PASSWORD=${DB_PASSWORD} \
        -v ${DB_VOLUME}:/var/lib/postgresql/data \
        ${DB_IMAGE}
fi

if sudo docker container inspect ${CONTAINER_NAME} >/dev/null 2>&1; then
    echo "Removing existing Odoo container: ${CONTAINER_NAME}"
    sudo docker rm -f ${CONTAINER_NAME}
fi

echo "Creating and starting new Odoo container: ${CONTAINER_NAME}"
sudo docker run -p 8069:8069 \
    --name ${CONTAINER_NAME} \
    --network ${NETWORK_NAME} \
    -v "${CUSTOM_ADDONS_PATH}:/mnt/extra-addons" \
    -t \
    ${IMAGE} \
    --dev=all \
    -i base
