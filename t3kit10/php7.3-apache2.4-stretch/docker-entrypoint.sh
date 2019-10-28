#!/usr/bin/env bash

set -e
set -o pipefail

# Add VIRTUAL HOST to hosts file on web container
if [[ -n $VIRTUAL_HOST ]]
then
    if grep -q "$VIRTUAL_HOST" /etc/hosts
    then
        echo "$VIRTUAL_HOST already exists"
    else
        echo "127.0.0.1 ${VIRTUAL_HOST}" >> /etc/hosts
        echo "$VIRTUAL_HOST added succesfully"
    fi
fi

# set volume permissions
if [[ -d /var/www/html/var/ ]]
then
    chown www-data /var/www/html/var/
fi
if [[ -d /var/www/html/public/typo3temp/ ]]
then
    chown www-data /var/www/html/public/typo3temp/
fi

exec "$@"
