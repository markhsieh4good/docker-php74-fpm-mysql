FROM php:7.4.24-fpm
# base on
# debian:bullseye-slim

LABEL maintainer="Mark.Hsieh"

# Locales
RUN apt-get update \
	&& apt-get install -y locales
    
RUN dpkg-reconfigure locales \
	&& locale-gen C.UTF-8 \
	&& /usr/sbin/update-locale LANG=C.UTF-8

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen
    
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Dev Utility
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y -q \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libssl-dev \
    libmemcached-dev \
    libz-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libxml2-dev \
    libcurl3-dev \
    libedit-dev \
    libpspell-dev \
    libldap2-dev \
    unixodbc-dev \
    libpq-dev
    
# Common App.
RUN apt-get install --no-install-recommends --no-install-suggests -y -q \
    wget \
    vim \
    git \
    net-tools \
    curl \
    supervisor \
    tofrodos \
    zip \
    unzip \
    procps \
    logrotate
    
# Nginx
RUN apt-get install -y \
    openssl \
    libzip-dev \
    nginx

## install php 7.4 extension by pecl
##
RUN pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug

# Clean
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

## Please check https://github.com/mlocati/docker-php-extension-installer first
## For PHP < 7.3, you then need to
#RUN docker-php-ext-configure zip --with-libzip
## For PHP >= 7.3, you just need to install zip
## normal install (check the avaliable package.)
RUN docker-php-ext-install zip json mysqli pdo pdo_mysql

## use php install extend tool
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync
RUN install-php-extensions protobuf swoole openssl redis

## Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUN composer --version

## Others 
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d 

RUN mkdir -p /opt/service 
RUN mkdir -p /opt/app

WORKDIR /var/www/html

COPY ./entrypoint.sh /opt/
RUN chmod +rw /opt/entrypoint.sh
RUN fromdos -d /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

COPY ./php-fpm.conf /etc/supervisor/conf.d/
RUN chmod +r /etc/supervisor/conf.d/php-fpm.conf

EXPOSE 80 443 18440 18441
CMD [ "/bin/bash", "/opt/entrypoint.sh" ]
