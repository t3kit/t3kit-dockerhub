###########################################################
# Web server docker image for t3kit project
# Web server docker image for TYPO3
#
# t3kit/10-php7.3-apache2.4-stretch
#
# https://github.com/t3kit/t3kit-starter
# https://github.com/t3kit/t3kit-dockerhub
############################################################

FROM php:7.3-apache-stretch

LABEL os="debian:stretch-slim"
LABEL http-server="apache2.4"
LABEL php="7.3"
LABEL support.t3kit="10"
LABEL support.typo3="10"
LABEL image.name="t3kit/10-php7.3-apache2.4-stretch"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# hadolint ignore=DL3008
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    # Install libs
    libxml2-dev \
    libfreetype6-dev\
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    # Install tools
    nano=2.7.* \
    graphicsmagick=1.3.* \
    imagemagick=8:6.* \
    mysql-client=5.5.* \
    iputils-ping=3:* \
    locales=2.24-* \
&& rm -rf /var/lib/apt/lists/*

# Set locales
# hadolint ignore=SC2129
RUN echo "en_US.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "en_GB.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "sv_SE.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "de_DE.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "da_DK.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "fr_FR.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "es_ES.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "it_IT.UTF-8 UTF-8">> /etc/locale.gen; \
    echo "fi_FI.UTF-8 UTF-8">> /etc/locale.gen; \
    locale-gen

COPY typo3.ini /usr/local/etc/php/conf.d/
COPY typo3.conf /etc/apache2/sites-available/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
    ; \
    docker-php-ext-install -j "$(nproc)" \
        mysqli \
        gd \
        zip \
        opcache \
        intl \
    ; \
    a2enmod rewrite expires; \
    # Set the 'ServerName' directive globally to suppress a message:
    # ---"Could not reliably determine the server's fully qualified domain name"---
    echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf; \
    a2enconf servername; \
    # Configure vhost for t3kit
    a2dissite 000-default; \
    a2ensite typo3.conf

RUN mkdir -vp /var/www/html/public

HEALTHCHECK CMD curl -f http://localhost || exit 1

ENV DEBIAN_FRONTEND=dialog

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
