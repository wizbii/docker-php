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
    apt-get install -y --no-install-recommends git unzip npm libxml2-utils wkhtmltopdf openjdk-7-jre vim openssh-client sudo && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl-dev libpng12-dev libjpeg62-turbo-dev && \
    docker-php-ext-install bcmath opcache gd && \
    pecl install mongodb && docker-php-ext-enable mongodb && \
    pecl install xdebug  && docker-php-ext-enable xdebug  && \
    pecl install apcu  && docker-php-ext-enable apcu  && \
    apt-get remove -y libssl-dev libpng12-dev libjpeg62-turbo-dev&& \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts  && \
    ssh-keyscan -t rsa bitbucket.org >> /etc/ssh/ssh_known_hosts

RUN chown www-data /var/www
    
RUN a2enmod rewrite
