FROM php:7.1-apache

RUN echo 'alias ll="ls -l"' > /etc/profile.d/wizbii.sh && \
    echo 'alias sudow="sudo -sHEu www-data"' >> /etc/profile.d/wizbii.sh && \
    # Install an acceptable nodejs version with npm
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb http://deb.nodesource.com/node_6.x jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        unzip \
        libxml2-utils \
        openjdk-7-jre \
        vim \
        openssh-client \
        sudo \
        less \
        locales \
	zip \
	nodejs \
	libmagickwand-dev \
	pdftk && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo 'memory_limit = -1' > /usr/local/etc/php/php.ini && \
    echo 'display_errors = Off' >> /usr/local/etc/php/php.ini && \
    curl -O -L https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz wkhtmltox/bin/wkhtmltopdf && \
    rm -rf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mv wkhtmltox/bin/* /usr/local/bin && rm -rf wkhtmltox


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
    apt-get install -y --no-install-recommends libssl-dev libpng12-dev libjpeg-dev libfreetype6-dev zlib1g-dev \
        libcurl4-openssl-dev libevent-dev libicu-dev libidn11-dev libidn2-0-dev libicu-dev && \
    docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu \
        --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu && \
    docker-php-ext-install bcmath opcache gd pdo_mysql exif intl zip && \
    pecl install mongodb && docker-php-ext-enable mongodb && \
    pecl install apcu  && docker-php-ext-enable apcu  && \
    pecl install raphf && docker-php-ext-enable raphf && \
    pecl install propro && docker-php-ext-enable propro && \
    pecl install pecl_http && docker-php-ext-enable http && \
    pecl install imagick && docker-php-ext-enable imagick && \
    apt-get remove -y libssl-dev libpng12-dev libjpeg62-turbo-dev libjpeg-dev libfreetype6-dev \
        zlib1g-dev libcurl4-openssl-dev libevent-dev libicu-dev libidn11-dev libidn2-0-dev libicu-dev && \
    rm -rf /var/lib/apt/lists/* \
    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp && rm -rf /tmp/blackfire-probe.tar.gz \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://10.1.1.1:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

RUN ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts  && \
    ssh-keyscan -t rsa bitbucket.org >> /etc/ssh/ssh_known_hosts

RUN chown www-data /var/www

RUN a2enmod rewrite headers
