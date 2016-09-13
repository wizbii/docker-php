FROM php:7-apache

# composer needs git and unzip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get update && \
    apt-get install -y git unzip && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y libssl-dev && \
    docker-php-ext-install bcmath && \
    pecl install mongodb && docker-php-ext-enable mongodb && \
    apt-get remove -y libssl-dev && \
    rm -rf /var/lib/apt/lists/*
