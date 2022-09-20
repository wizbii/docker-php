FROM alpine:3.13 AS iconv-build
RUN apk add --no-cache gnu-libiconv

FROM php:8.1-fpm-alpine

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions
# See https://www.justinsilver.com/technology/linux/alpine-linux-php-iconv-fix/
COPY --from=iconv-build /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ENV FPM_MAX_CHILDREN=5
ENV FPM_START_SERVERS=2
ENV FPM_MIN_SPARE_SERVERS=1
ENV FPM_MAX_SPARE_SERVERS=3

RUN echo "## Installing dependencies" && \
    apk add --no-cache tini openssl-dev pcre-dev gnu-libiconv icu-dev git && \
    echo '## Installing PHP extensions' && \
    install-php-extensions bcmath \
        intl \
        calendar \
        opcache \
        zip \
        sockets \
        apcu \
        redis \
        mongodb \
        amqp \
        pcntl \
        gd \
        imagick && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    echo "## Checking iconv & symfony requirements" && \
    php -d zend.assertions=1 -r "assert(iconv('utf-8', 'us-ascii//TRANSLIT//IGNORE', 'éøà') !== false);" && \
    mkdir /tmp/requirements-check && cd /tmp/requirements-check && \
    composer req symfony/requirements-checker && \
    vendor/bin/requirements-checker  -v && \
    echo "## Validating PHP FPM config" && \
    php-fpm --test && \
    echo "PHP Version: " && php --version && \
    echo "PHP Modules: " && php -m && \
    echo "## Clean up build files" && \
    rm -rf /tmp/* /root/.composer

WORKDIR /usr/src/app

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["php-fpm"]

ONBUILD ARG PROJECT_NAME=unknown
ONBUILD ENV PROJECT_NAME=$PROJECT_NAME

