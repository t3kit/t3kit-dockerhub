#!/usr/bin/env bash

set -e
set -o pipefail

# Make www-data user use id from hosts user to make shared folder writable.
# Only for Linux.
if [ -z "$USER_ID" ]
then
    echo "USER_ID variable is not set"
else
    echo "USER_ID = $USER_ID"
    if [ "$USER_ID" = "mac" ]
    then
        echo "Host OS = macOS"
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
fi

# Add VIRTUAL HOST to hosts file on web container
if [[ -z $COMPOSER_MODE ]]
then
    if [[ -n $VIRTUAL_HOST ]]
    then
        IFS=', ' read -r -a hosts <<< "$VIRTUAL_HOST"
        for host in "${hosts[@]}"
        do
            if grep -q "$host" /etc/hosts
            then
                echo "$host already exists"
            else
                echo "127.0.0.1 ${host}" >> /etc/hosts
                echo "$host added succesfully"
            fi
        done
    fi
fi

if [[ -z "$SKIP_FOLDER_PERMISSIONS" && -z "$COMPOSER_MODE" ]]
then
    # set folder permissions
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
    echo "Folder permissions updated succesfully"
fi

if [[ -z "$SKIP_PHP_FPM" && -z "$COMPOSER_MODE" ]]
then
    echo "Start PHP-FPM"
    php-fpm -D
fi

if [[ -n "$GITHUB_TOKEN" ]]
then
    # COMPOSER_AUTH
    export COMPOSER_AUTH="{\"github-oauth\":{\"github.com\":\"$GITHUB_TOKEN\"}}"
fi

exec "$@"
