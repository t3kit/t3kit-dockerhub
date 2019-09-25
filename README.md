# t3kit-dockerhub

Docker images to run t3kit and TYPO3 locally placed on Docker Hub

![](https://github.com/t3kit/t3kit-dockerhub/workflows/Code%20Guidelines/badge.svg)
![](https://github.com/t3kit/t3kit-dockerhub/workflows/Docker%20images/badge.svg)

## Table of contents

- [About](#about)
- [Required dependencies](#required-dependencies)
- [Docker images](#docker-images)

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

**t3kit-dockerhub** is a bunch of Docker images to use with t3kit project for local development and testing

## Required dependencies

- [Docker](https://docs.docker.com/install/) >= v19.03.1
- [Docker Compose](https://docs.docker.com/compose/install/) >= v1.24.1

## Docker images

### ubuntu18.04-php7.2-apache2.4

```shell
ubuntu18.04/php7.2-apache2.4/Dockerfile
```

Docker image with HTTP server and PHP preinstalled

- Ubuntu18.04
- php7.2
- apache2.4

### ubuntu18.04-php7.3-apache2.4

```shell
ubuntu18.04/php7.3-apache2.4/Dockerfile
```

Docker image with HTTP server and PHP preinstalled

- Ubuntu18.04
- php7.3
- apache2.4

### nproxy

```shell
nproxy/Dockerfile
```

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
