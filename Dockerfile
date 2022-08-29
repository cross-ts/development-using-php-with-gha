ARG PHP_VERSION=8.0.22
ARG COMPOSER_VERSION=latest

FROM composer:${COMPOSER_VERSION} AS composer
FROM php:${PHP_VERSION}
RUN apt update \
 && apt install -y \
      zip
WORKDIR /app
COPY --from=composer /usr/bin/composer /usr/bin/
COPY composer.json composer.lock /app/
RUN composer install
