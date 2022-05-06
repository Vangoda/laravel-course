# Dev image with apache php 7.4, git, composer, xdebug and npm
FROM php:7.4-apache

# COPY apache2 conf
COPY ./apache2.conf /etc/apache2/apache2.conf

# Add mlocatis php extension installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Make it executable
RUN chmod +x /usr/local/bin/install-php-extensions \
# Disable interactive apt
# Install git, nodejs, postfix, curl and npm
  && apt -y update \
  && DEBIAN_FRONTEND=noninteractive apt -y install git nodejs npm postfix curl libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
  && npm install gulp -g\
  && npm install gulp --save-dev\
# PHP  extensions and composer using mlocati/docker-php-extension-installer
  && install-php-extensions xdebug pdo_mysql gd @composer \
  && a2enmod rewrite \
  && service apache2 restart \
#   Configure xdebug
  && { \
    echo "xdebug.mode=debug,profile,trace"; \
    echo "xdebug.client_host=127.0.0.1"; \
    echo "xdebug.client_port=9003"; \
  } > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && chown -R www-data:www-data /var/www
#   Copy the application
# COPY src/ /var/www/html/