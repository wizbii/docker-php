FROM php:7.2-alpine

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

RUN apk add --no-cache autoconf openssl-dev g++ make pcre-dev icu-dev && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    docker-php-ext-install pcntl bcmath intl opcache zip && \
    apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    apk del --purge autoconf g++ make

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN mkdir /ppm && cd /ppm && \
    composer require php-pm/php-pm && \
    composer require php-pm/httpkernel-adapter && \
    ln -s /ppm/vendor/bin/ppm /usr/local/bin/ppm

CMD ppm start --ansi --host 0.0.0.0 --app-env=prod --debug=0 --port=80 --logging=0
