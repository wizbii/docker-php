FROM php:7.4-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ONBUILD ARG GIT_REFERENCE
ONBUILD ENV GIT_REFERENCE ${GIT_REFERENCE:-HEAD}

ONBUILD ARG BUILD_DATE
ONBUILD ENV BUILD_DATE ${BUILD_DATE:-unknown}

ONBUILD ARG BASE_PATH
ONBUILD ENV BASE_PATH ${BASE_PATH:-/usr/src/app}

ONBUILD WORKDIR ${BASE_PATH}

ONBUILD LABEL org.label-schema.vendor="Wizbii" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date="${BUILD_DATE}"

RUN apk add --no-cache gnu-libiconv autoconf openssl-dev g++ make pcre-dev icu-dev zlib-dev libzip-dev git && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    pecl install mongodb redis && \
    docker-php-ext-enable mongodb redis && \
    docker-php-ext-install bcmath intl opcache zip sockets && \
    version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") && \
    curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version && \
    mkdir -p /tmp/blackfire && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire && \
    mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so && \
    printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini && \
    rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz && \
    apk del --purge autoconf g++ make

COPY conf/symfony-presets.ini $PHP_INI_DIR/conf.d

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
