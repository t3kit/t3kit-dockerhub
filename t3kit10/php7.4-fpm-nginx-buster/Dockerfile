###########################################################
# Web server docker image for t3kit project
# Web server docker image for TYPO3
#
# t3kit/10-php7.4-fpm-nginx-buster
#
# https://github.com/t3kit/t3kit-starter
# https://github.com/t3kit/t3kit-dockerhub
############################################################


# install ngx_brotli
############################################################
FROM nginx:1.18.0 AS build

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    git \
    gcc \
    cmake \
    make \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://nginx.org/download/nginx-"$NGINX_VERSION".tar.gz
RUN tar zxvf nginx-"$NGINX_VERSION".tar.gz
RUN git clone https://github.com/google/ngx_brotli.git
WORKDIR /tmp/ngx_brotli
RUN git submodule update --init
WORKDIR /tmp/nginx-"$NGINX_VERSION"
RUN ./configure --with-compat --add-dynamic-module=../ngx_brotli
RUN make modules
# ############################################################

# install composer
############################################################
FROM composer:2 AS composer
# ############################################################

FROM php:7.4-fpm-buster

LABEL os="debian:buster-slim"
LABEL php="7.4"
LABEL nginx="1.18.0"
LABEL support.t3kit="10"
LABEL support.typo3="10"
LABEL image.name="t3kit/10-php7.4-fpm-nginx-buster"

ENV NGINX_VERSION 1.18.0
ENV NJS_VERSION 0.4.3
ENV PKG_RELEASE 1~buster
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# PHP deps
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
    nano\
    git\
    ssh\
    graphicsmagick \
    mariadb-client \
    iputils-ping \
    locales \
    procps \
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

# PHP config
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY typo3.ini /usr/local/etc/php/conf.d/

# temp dir for nginx package
RUN mkdir -vp /tmp/nginx
WORKDIR /tmp/nginx

# instal nginx
# hadolint ignore=DL3008,SC2086
RUN apt-get update \
&& apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates \
&& apt-key adv --keyserver "ha.pool.sks-keyservers.net" --keyserver-options timeout=10 --recv-keys "573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62" \
&& apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/* \
&& nginxPackages=" \
    nginx=${NGINX_VERSION}-${PKG_RELEASE} \
    nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE} \
    nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE} \
    nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE} \
    nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-${PKG_RELEASE} \
" \
&& echo "deb https://nginx.org/packages/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list \
&& echo "deb-src https://nginx.org/packages/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list \
&& apt-get update \
&& apt-get build-dep -y $nginxPackages \
&& apt-get source --compile $nginxPackages \
&& apt-get install --no-install-recommends --no-install-suggests -y $nginxPackages gettext-base curl \
&& apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
&& apt-get purge -y --auto-remove && rm -rf "/tmp/nginx" \
&& ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

# Nginx config
COPY --from=build /tmp/nginx-$NGINX_VERSION/objs/*.so /etc/nginx/modules/
COPY configuration/nginx.conf /etc/nginx/
COPY configuration/conf.d/typo3.conf /etc/nginx/conf.d/default.conf

# Add Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN mkdir -vp /var/www/html/public
RUN touch  /var/www/html/public/index.html

ENV VIRTUAL_HOST_1=localhost
HEALTHCHECK CMD curl -fsSLI $VIRTUAL_HOST_1 || exit 1

ENV DEBIAN_FRONTEND=dialog

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
