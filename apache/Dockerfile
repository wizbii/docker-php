FROM php:7-apache

RUN sed 's/jessie/testing/' /etc/apt/sources.list > /etc/apt/sources.list.d/testing.list && \
    { \
      echo 'Package: *'; \
      echo 'Pin: release a=testing'; \
      echo 'Pin-Priority: -10'; \
      echo; \
      echo 'Package: git*'; \
      echo 'Pin: release a=testing'; \
      echo 'Pin-Priority: 990'; \
    }  > /etc/apt/preferences.d/git && \
    apt-get update && \
    apt-get install -y git unzip npm libxml2-utils wkhtmltopdf openjdk-7-jre vim && \
    rm -rf /var/lib/apt/lists/*
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \

RUN apt-get update && \
    apt-get install -y libssl-dev && \
    docker-php-ext-install bcmath && \
    pecl install mongodb && docker-php-ext-enable mongodb && \
    pecl install xdebug  && docker-php-ext-enable xdebug  && \
    apt-get remove -y libssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts && \
    chmod 600 /root/.ssh/known_hosts

RUN a2enmod rewrite
