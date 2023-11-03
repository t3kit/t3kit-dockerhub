###########################################################
# Web server docker image for t3kit project
# Web server docker image for TYPO3
#
# t3kit/11-php8-fpm-nginx-buster
#
# https://github.com/t3kit/t3kit-starter
# https://github.com/t3kit/t3kit-dockerhub
############################################################



# install ngx_brotli
############################################################
# FROM nginx:1.24.0 AS build
FROM nginx:1.22.1 AS build

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
RUN wget -q https://nginx.org/download/nginx-"$NGINX_VERSION".tar.gz \
&& tar zxvf nginx-"$NGINX_VERSION".tar.gz \
&& git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli

WORKDIR /tmp/ngx_brotli/deps/brotli
RUN mkdir out && cd out \
&& cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed .. \
&& cmake --build . --config Release --target brotlienc

WORKDIR /tmp/nginx-"$NGINX_VERSION"
RUN ./configure --with-compat --add-dynamic-module=/tmp/ngx_brotli && make modules \
&& ls -lah
# ############################################################



# install composer
############################################################
FROM composer:2.1 AS composer
# ############################################################



# PHP-FPM
############################################################
FROM php:8.2.12-fpm-bookworm

LABEL os="debian:bookworm-slim"
LABEL php="8"
LABEL nginx="1.22.1"
LABEL support.t3kit="12"
LABEL support.typo3="12"
LABEL image.name="t3kit/12-php8-fpm-nginx-bookworm"

ENV NGINX_VERSION 1.22.1
ENV NJS_VERSION 0.8.2
ENV PKG_RELEASE 9~bookworm
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
    unzip\
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

# update

# instal nginx
# hadolint ignore=DL3008,SC2086
RUN apt-get update \
&& apt-get install --no-install-recommends --no-install-suggests -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring \
&& apt install --no-install-recommends --no-install-suggests -y nginx libnginx-mod-http-geoip libnginx-mod-http-xslt-filter libnginx-mod-http-image-filter libnginx-mod-http-js libnginx-mod-stream-js \
&& apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
&& apt-get purge -y --auto-remove && rm -rf "/tmp/nginx" \
&& ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

# Nginx config
COPY --from=build /tmp/nginx-$NGINX_VERSION/objs/*.so /usr/lib/nginx/modules/
COPY configuration/nginx.conf /etc/nginx/
COPY configuration/conf.d/typo3.conf /etc/nginx/conf.d/default.conf

# Add Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN mkdir -vp /var/www/html/public \
&& touch /var/www/html/public/index.html

ENV VIRTUAL_HOST_1=localhost
HEALTHCHECK CMD curl -fsSLI $VIRTUAL_HOST_1 || exit 1

ENV DEBIAN_FRONTEND=dialog

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
