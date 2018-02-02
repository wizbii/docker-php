FROM php:7.2-fpm-alpine

RUN apk add --no-cache autoconf openssl-dev g++ make pcre-dev && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    apk del --purge autoconf g++ make
