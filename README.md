# t3kit-dockerhub

Docker images to run t3kit and TYPO3 locally

![](https://github.com/t3kit/t3kit-dockerhub/workflows/Code%20Guidelines/badge.svg)
![](https://github.com/t3kit/t3kit-dockerhub/workflows/Docker%20images/badge.svg)

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

- [Docker](https://docs.docker.com/install/) >= v19.03.1

## Image naming convention

_Example:_
`t3kit/10-php7.3-apache2.4-ubuntu18.04:1.0.0`

|t3kit version|PHP version|Apache version|base OS|Image version (semver)|
|-------------|-----------|--------------|-------|----------------------|
|t3kit/10     |php7.3     |apache2.4     |ubuntu18.04            |:1.0.0|

## File structure

```text
t3kit-dockerhub/
├── .github/       # github actions
├── nproxy/
│   ├── Dockerfile
│   └── nginx.tmpl       # nginx template
└── t3kit10/
    ├── php7.2-apache2.4-ubuntu18.04/
    │   ├── docker-entrypoint.sh
    │   ├── Dockerfile
    │   ├── typo3.conf       # TYPO3 apache virtual host config
    │   └── typo3.ini       # TYPO3 php config
    ├── php7.3-apache2.4-stretch/
    │   ├── docker-entrypoint.sh
    │   ├── Dockerfile
    │   ├── typo3.conf
    │   └── typo3.ini
    └── php7.3-apache2.4-ubuntu18.04/
        ├── docker-entrypoint.sh
        ├── Dockerfile
        ├── typo3.conf
        └── typo3.ini
```

## t3kit Docker images

### t3kit/10-php7.2-apache2.4-ubuntu18.04

```shell
Docker image with HTTP server and PHP preinstalled

os="ubuntu:18.04"
http-server="apache2.4"
php="7.2"
support.t3kit="10"
support.typo3="10"
image.name="t3kit/10-php7.2-apache2.4-ubuntu18.04"
```

### t3kit/10-php7.3-apache2.4-ubuntu18.04

```shell
Docker image with HTTP server and PHP preinstalled

os="ubuntu:18.04"
http-server="apache2.4"
php="7.3"
support.t3kit="10"
support.typo3="10"
image.name="t3kit/10-php7.3-apache2.4-ubuntu18.04"
```

### t3kit/10-php7.3-apache2.4-stretch

```shell
Docker image with HTTP server and PHP preinstalled

os="debian:stretch-slim"
http-server="apache2.4"
php="7.3"
support.t3kit="10"
support.typo3="10"
image.name="t3kit/10-php7.3-apache2.4-stretch"
```

### nproxy

#### Nginx proxy to use with t3kit project

[Based on Automated Nginx Reverse Proxy for Docker](https://github.com/jwilder/nginx-proxy)

Use it to handle several **t3kit** projects in one local machine. The main advantage of it is just to use one `VIRTUAL_HOST` env variable to separate it from other projects

#### Quick start

```shell
docker network create nproxy
docker run -d -p=80:80 --name=nproxy --restart=unless-stopped --network=nproxy -v=/var/run/docker.sock:/tmp/docker.sock:ro t3kit/nproxy:1.0.0
```

***

Check [t3kit starter kit](https://github.com/t3kit/t3kit-starter) with all needed documentation to start a new project on t3kit basis.
