###########################################################
# php docker image for t3kit project
# php docker image for TYPO3
#
# t3kit/10-php7.4-fpm-buster
#
# https://github.com/t3kit/t3kit-starter
# https://github.com/t3kit/t3kit-dockerhub
############################################################

FROM php:7.4-fpm-buster

LABEL os="debian:buster-slim"
LABEL php="7.4"
LABEL support.t3kit="10"
LABEL support.typo3="10"
LABEL image.name="t3kit/10-php7.4-fpm-buster"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# hadolint ignore=DL3008
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    # Install libs
    libfreetype6-dev\
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    # Install tools
    nano=3.2-* \
    graphicsmagick=1.4* \
    mariadb-client=1:10.3* \
    iputils-ping=3:* \
    locales=2.28-* \
    procps=2:3.3* \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j"$(nproc)" gd \
    mysqli \
    zip \
    opcache \
    intl

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

RUN mkdir -vp /var/www/html/public

ENV DEBIAN_FRONTEND=dialog

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
