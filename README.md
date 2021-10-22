# t3kit-dockerhub

Docker images to run t3kit and TYPO3 locally

[![Code Guidelines](https://github.com/t3kit/t3kit-dockerhub/actions/workflows/code-guidelines.yml/badge.svg)](https://github.com/t3kit/t3kit-dockerhub/actions/workflows/code-guidelines.yml)
[![Build Docker images](https://github.com/t3kit/t3kit-dockerhub/actions/workflows/docker-images.yml/badge.svg)](https://github.com/t3kit/t3kit-dockerhub/actions/workflows/docker-images.yml)

## Table of contents

- [About](#about)
- [Required dependencies](#required-dependencies)
- [Image naming convention](#image-naming-convention)
- [File structure](#file-structure)
- [t3kit Docker images](#t3kit-docker-images)

### General info about t3kit project

- [Documentation](https://t3kit.gitbook.io/doc)
- [t3kit Roadmap](https://t3kit.gitbook.io/doc/t3kit-roadmap)
- [Versioning](https://t3kit.gitbook.io/doc/t3kit-versioning)
- [t3kit project structure](https://t3kit.gitbook.io/doc/t3kit-project-structure)
- [Contributing to t3kit](https://github.com/t3kit/.github/blob/master/CONTRIBUTING.md)
- [Code of Conduct](https://github.com/t3kit/.github/blob/master/CODE_OF_CONDUCT.md)
- [Support](https://github.com/t3kit/.github/blob/master/SUPPORT.md)
- [Security Policy](https://github.com/t3kit/.github/blob/master/SECURITY.md)

***

## About

**t3kit-dockerhub** is a bunch of Docker images to use with t3kit project and TYPO3 for local development and testing

## Required dependencies

- [Docker](https://docs.docker.com/install/) >= v20.10.8
- [Docker Compose](https://docs.docker.com/compose/cli-command/#installing-compose-v2) >= v2.0.0

## Image naming convention

_Example:_
`t3kit/10-php7.4-fpm-nginx-buster:1.0.0`

|t3kit version|PHP version|HTTP Server   |base OS|Image version (semver)|
|-------------|-----------|--------------|-------|----------------------|
|t3kit/10     |php7.4-fpm |nginx         |debian buster          |:1.0.0|

## File structure

```text
t3kit-dockerhub/
├── .github/             # github actions
├── nproxy/
│   ├── Dockerfile
│   └── nginx.tmpl       # nginx template
├── mkcert/
│   ├── Dockerfile
│   └── docker-entrypoint.sh
├── t3kit8.9/
│   └── php7.4-apache2.4-ubuntu18.04/
│       ├── Dockerfile
│       ├── typo3.conf     # TYPO3 apache virtual host config
│       └── typo3.ini      # TYPO3 php config
└── t3kit10/
    └── php7.4-fpm-nginx-buster/
        ├── docker-entrypoint.sh
        ├── Dockerfile
        ├── typo3.ini                # TYPO3 php config
        └── configuration/nginx.conf # nginx config
```

## t3kit Docker images

### t3kit/10-php7.4-fpm-nginx-buster

```shell
Docker image with nginx server and PHP-FPM preinstalled

os="debian:buster-slim"
php="7.4"
nginx="1.18.0"
support.t3kit="10"
support.typo3="10"
image.name="t3kit/10-php7.4-fpm-nginx-buster"
```

### t3kit/11-php8-fpm-nginx-buster

```shell
Docker image with nginx server and PHP-FPM preinstalled

os="debian:buster-slim"
php="8"
nginx="1.20.1"
support.t3kit="11"
support.typo3="11"
image.name="t3kit/11-php8-fpm-nginx-buster"
```

### nproxy

#### Nginx proxy to use with t3kit project

[Based on Automated Nginx Reverse Proxy for Docker](https://github.com/nginx-proxy/nginx-proxy)

Use it to handle several **t3kit** projects in one local machine. The main advantage of it is just to use one `VIRTUAL_HOST` env variable to separate it from other projects

**Setup**

1. Clone this repository
2. `cd nproxy`
3. `docker compose up -d` - run nproxy using docker compose

***

### mkcert

HTTPS Support for local development with Nginx proxy

We are using a Docker image to generate all needed keys and certificates.
This image is based on `mkcert` tool. It is also possible to use it without docker image, but you will need to install this tool into your system. [mkcert documentation](https://github.com/FiloSottile/mkcert)

#### Setup

1. Create a folder on the host where we will store our keys and certificates.

    ```shell
    mkdir ~/.certs
    ```

2. Create local CA and generate locally-trusted certificates based on local CA
    - `t3kit_first_setup` - create a root certificate for a local certificate authority and generate locally-trusted certificates for `*.t3.localhost` wildcard domains.

    ```shell
    docker run --rm -v ~/.certs:/certs t3kit/mkcert:1.0.1 t3kit_first_setup
    ```

    *Note:* With this wildcard based certificate we can have any amount of third-level domain virtual hosts without creating new certificates.

    - `add` - generate `.localhost` based locally-trusted certificates

    ```shell
    docker run --rm -v ~/.certs:/certs t3kit/mkcert:1.0.1 add test
    ```

    It will create a locally-trusted certificate for `test.localhost` domain

    - generate custom locally-trusted certificates

    ```shell
    docker run --rm -v ~/.certs:/certs t3kit/mkcert:1.0.1 mkcert newsite.local
    ```

    It will create a locally-trusted certificate for `newsite.local` domain

3. Install local CA in the system trust store

    Import and trust a self-signed CA certificate

    macOS:

    ```shell
    cd ~/.certs/ && sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "local_ca/rootCA.pem"
    ```

    Ubuntu:

    ```shell
    TBD
    ```

4. Configure the server to use the certificates.

***

Check [t3kit starter kit](https://github.com/t3kit/t3kit-starter) with all needed documentation to start a new project on t3kit basis.
