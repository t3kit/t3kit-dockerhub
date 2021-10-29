#!/usr/bin/env bash

set -e
set -o pipefail

# copy SSL certificates from container folder to volume folder to spread it between all containers inside nproxy docker network using shared volume
if [[ -d /nproxy/certs/ ]]
then
    cp -r /nproxy/certs/. /etc/nginx/certs/
fi

# shellcheck disable=SC1091
source /app/docker-entrypoint.sh
