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
    echo 'alias ll="ls -l"' > /etc/profile.d/wizbii.sh && \ 
    echo 'alias sudow="sudo -sHEu www-data"' >> /etc/profile.d/wizbii.sh && \
    # Install an acceptable nodejs version with npm
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb http://deb.nodesource.com/node_6.x jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        unzip \
        libxml2-utils \
        wkhtmltopdf \
        openjdk-7-jre \
        vim \
        openssh-client \
        sudo \
        less \
        locales \
	nodejs && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN	   echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen \
        && echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "it_IT.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "nl_NL.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "pt_PT.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen

RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl-dev libpng12-dev libjpeg62-turbo-dev && \
    docker-php-ext-install bcmath opcache gd pdo_mysql && \
    pecl install mongodb && docker-php-ext-enable mongodb && \
    pecl install apcu  && docker-php-ext-enable apcu  && \
    apt-get remove -y libssl-dev libpng12-dev libjpeg62-turbo-dev&& \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts  && \
    ssh-keyscan -t rsa bitbucket.org >> /etc/ssh/ssh_known_hosts

RUN chown www-data /var/www
    
RUN a2enmod rewrite
