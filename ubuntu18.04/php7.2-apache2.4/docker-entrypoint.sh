#!/usr/bin/env bash

set -e
set -o pipefail

# Make www-data user use id from hosts user to make shared folder writable. (!!!Only for Ubuntu)
if [ -z "$USER_ID" ]
then
    echo "USER_ID variable is not set."
else
    # fetch current userid and groupid for user www-data
    WWW_DATA_USERID=$(id -u www-data)
    # if current userid doesn't equal the one from .env, force id of user to the one from .env
    if [ "$WWW_DATA_USERID" -ne "${USER_ID}" ];then
        echo "usermod -u ${USER_ID} www-data"
        usermod -u "${USER_ID}" www-data
    fi
fi
echo id www-data

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
