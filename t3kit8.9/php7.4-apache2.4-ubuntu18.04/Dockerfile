############################################################
# Web server docker image for t3kit project v8.9
# Web server docker image for TYPO3
#
# t3kit/8.9-php7.4-apache2.4-ubuntu18.04
#
############################################################

FROM ubuntu:18.04

LABEL os="ubuntu:18.04"
LABEL http-server="apache2.4"
LABEL php="7.4"
LABEL support.t3kit="8.9"
LABEL support.typo3="9"
LABEL image.name="t3kit/8.9-php7.4-apache2.4-ubuntu18.04"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update \
&& apt-get install software-properties-common=0.96.24.* -y --no-install-recommends \
&& add-apt-repository ppa:ondrej/php -y \
&& apt-get install -y --no-install-recommends\
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
    libapache2-mod-php7.4=7.4.* \
    # Install php
    php7.4-cli=7.4.* \
    php7.4-json=7.4.* \
    php7.4-curl=7.4.* \
    php7.4-fpm=7.4.* \
    php7.4-gd=7.4.* \
    php7.4-ldap=7.4.* \
    php7.4-mbstring=7.4.* \
    php7.4-mysql=7.4.* \
    php7.4-soap=7.4.* \
    php7.4-xml=7.4.* \
    php7.4-zip=7.4.* \
    php7.4-intl=7.4.* \
    php7.4-imagick=7.4.* \
&& rm -rf /var/lib/apt/lists/*


# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 sv_SE.UTF-8 de_DE.UTF-8 da_DK.UTF-8 fr_FR.UTF-8 es_ES.UTF-8 it_IT.UTF-8 fi_FI.UTF-8

COPY typo3.ini /etc/php/7.4/mods-available/
COPY typo3.conf /etc/apache2/sites-available/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Configure PHP for TYPO3
RUN phpenmod typo3; \
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

RUN mkdir -vp /var/www/html/web

RUN rm index.html

EXPOSE 80 443

ENV DEBIAN_FRONTEND=dialog

CMD ["apache2ctl", "-D", "FOREGROUND"]
