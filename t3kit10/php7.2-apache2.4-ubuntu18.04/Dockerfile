############################################################
# Web server docker image for t3kit project
# Web server docker image for TYPO3
#
# t3kit/10-ubuntu18.04-php7.2-apache2.4
#
# https://github.com/t3kit/t3kit-starter
# https://github.com/t3kit/t3kit-dockerhub
############################################################

FROM ubuntu:18.04

LABEL os="ubuntu:18.04"
LABEL http-server="apache2.4"
LABEL php="7.2"
LABEL support.t3kit="10"
LABEL support.typo3="10"
LABEL image.name="t3kit/10-ubuntu18.04-php7.2-apache2.4"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y --no-install-recommends\
    # Install tools
    apt-utils=1.6.* \
    openssl=1.1.* \
    nano=2.9.* \
    curl=7.58.* \
    graphicsmagick=1.3.* \
    imagemagick=8:6.* \
    mysql-client=5.7.* \
    iputils-ping=3:* \
    locales=2.* \
    # Install apache
    apache2=2.4.* \
    libapache2-mod-php7.2=7.2.* \
    # Install php
    php7.2-cli=7.2.* \
    php7.2-json=7.2.* \
    php7.2-curl=7.2.* \
    php7.2-fpm=7.2.*\
    php7.2-gd=7.2.* \
    php7.2-ldap=7.2.* \
    php7.2-mbstring=7.2.* \
    php7.2-mysql=7.2.* \
    php7.2-soap=7.2.* \
    php7.2-xml=7.2.* \
    php7.2-zip=7.2.* \
    php7.2-intl=7.2.* \
    php-imagick=3.4.* \
&& rm -rf /var/lib/apt/lists/*


# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 sv_SE.UTF-8 de_DE.UTF-8 da_DK.UTF-8 fr_FR.UTF-8 es_ES.UTF-8 it_IT.UTF-8 fi_FI.UTF-8

COPY typo3.ini /etc/php/7.2/mods-available/
COPY typo3.conf /etc/apache2/sites-available/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Configure PHP for TYPO3
RUN phpenmod typo3; \
    # Apache + PHP requires preforking Apache for best results
    a2dismod mpm_event && a2enmod mpm_prefork; \
    a2enmod rewrite expires; \
    echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf; \
    a2enconf servername; \
    # Configure vhost for t3kit
    a2dissite 000-default; \
    a2ensite typo3.conf; \
    # Apache logs should go to stdout / stderr
    ln -sf /dev/stderr /var/log/apache2/error.log; \
    ln -sf /dev/stdout /var/log/apache2/access.log

WORKDIR /var/www/html

RUN mkdir -vp /var/www/html/public

EXPOSE 80

HEALTHCHECK CMD curl -f http://localhost || exit 1

ENV DEBIAN_FRONTEND=dialog

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]
