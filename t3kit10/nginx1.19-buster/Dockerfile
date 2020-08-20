###########################################################
# nginx1 docker image for t3kit project
# nginx1 docker image for TYPO3
#
# t3kit/10-nginx1.19-buster
#
# https://github.com/t3kit/t3kit-starter
# https://github.com/t3kit/t3kit-dockerhub
############################################################

# install ngx_brotli
############################################################
FROM nginx:1.19.2 AS build

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

# RUN cd tmp
WORKDIR /tmp
RUN wget https://nginx.org/download/nginx-"$NGINX_VERSION".tar.gz
RUN tar zxvf nginx-"$NGINX_VERSION".tar.gz
RUN git clone https://github.com/google/ngx_brotli.git
WORKDIR /tmp/ngx_brotli
RUN git submodule update --init
WORKDIR /tmp/nginx-"$NGINX_VERSION"
RUN ./configure --with-compat --add-dynamic-module=../ngx_brotli
RUN make modules
############################################################


FROM nginx:1.19.2

LABEL os="debian:buster-slim"
LABEL http-server="nginx1.19"
LABEL support.t3kit="10"
LABEL support.typo3="10"
LABEL image.name="t3kit/10-nginx1.19-buster"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# hadolint ignore=DL3008
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    # Install tools
    nano \
    iputils-ping \
    mariadb-client \
&& rm -rf /var/lib/apt/lists/*

COPY --from=build /tmp/nginx-$NGINX_VERSION/objs/*.so /etc/nginx/modules/


COPY configuration/nginx.conf /etc/nginx/nginx.conf
COPY configuration/conf.d/typo3.conf /etc/nginx/conf.d/default.conf

# RUN mkdir -vp /etc/nginx/certs

RUN mkdir -vp /var/www/html/public

ENV VIRTUAL_HOST=localhost
HEALTHCHECK CMD curl -f $VIRTUAL_HOST || exit 1

ENV DEBIAN_FRONTEND=dialog

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html
EXPOSE 443

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
