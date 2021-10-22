#!/usr/bin/env bash

set -e
set -o pipefail

# set the folder where mkcert will place the local CA
# https://github.com/FiloSottile/mkcert#changing-the-location-of-the-ca-files
export CAROOT=/certs/local_ca
export TRUST_STORES="system"

# check if the first argument = t3kit_first_setup
if [[ -n "$1" && $1 = "t3kit_first_setup" ]]; then
    set -- mkcert -install && mkcert -cert-file t3.localhost.crt -key-file t3.localhost.key t3.localhost "*.t3.localhost"

# check if the first argument = create_ca
elif [[ -n "$1" && $1 = "local_ca" ]]; then
    set -- mkcert -install

# check if the first argument = t3_localhost
elif [[ -n "$1" && $1 = "t3_localhost" ]]; then
    set -- mkcert -cert-file t3.localhost.crt -key-file t3.localhost.key t3.localhost "*.t3.localhost"

# check if the first argument = add
elif [[ -n "$1" && $1 = "add" ]]; then
    set -- mkcert -cert-file "$2".localhost.crt -key-file "$2".localhost.key "$2".localhost "*.$2.localhost"

# check if the first letter in argument = "-"
elif [ "$(printf %c "$1")" = '-' ]; then
    set -- mkcert "$@"

# check if the first argument = mkcert
elif [ "$1" = 'mkcert' ]; then
    set -- "$@"
fi

exec "$@"
