FROM php:7.2-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache autoconf openssl-dev g++ make pcre-dev icu-dev && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    docker-php-ext-install bcmath intl opcache zip && \
    apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk del --purge autoconf g++ make

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

LABEL org.label-schema.vcs-url="https://github.com/wizbii/docker-php" \
      org.label-schema.vendor="Wizbii" \
      org.label-schema.schema-version="1.0"
