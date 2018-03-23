FROM php:7.2-fpm-alpine

RUN apk add --no-cache autoconf openssl-dev g++ make pcre-dev && \
    pecl install mongodb && \
    docker-php-ext-install zip && \
    docker-php-ext-enable mongodb && \
    apk del --purge autoconf g++ make

LABEL org.label-schema.vcs-url="https://github.com/wizbii/docker-php" \
      org.label-schema.vendor="Wizbii" \
      org.label-schema.schema-version="1.0"
