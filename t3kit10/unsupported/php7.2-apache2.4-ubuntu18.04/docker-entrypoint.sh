#!/usr/bin/env bash

set -e
set -o pipefail

# Make www-data user use id from hosts user to make shared folder writable.
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
id www-data

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
# var
if [[ -d /var/www/html/var/ ]]
then
    chown www-data /var/www/html/var/
fi
# typo3temp
if [[ -d /var/www/html/public/typo3temp/ ]]
then
    chown www-data /var/www/html/public/typo3temp/
fi
# fileadmin
if [[ -d /var/www/html/public/fileadmin/ ]]
then
    chown www-data /var/www/html/public/fileadmin/
fi

# setup apache2 envvars
: "${APACHE_CONFDIR:=/etc/apache2}"
: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"
if [[ -f "$APACHE_ENVVARS" ]]
then
    # shellcheck source=/etc/apache2/envvars
    # shellcheck disable=SC1091
    . "$APACHE_ENVVARS"
fi

# run apache2 using "exec form" with PID 1
exec apache2 -DFOREGROUND
