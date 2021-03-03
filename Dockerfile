FROM php:8.0.2-fpm-buster

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN echo "error_log = /code/var/log/php-error.log;" >> "$PHP_INI_DIR/conf.d/error_log.ini"

RUN apt update
RUN apt dist-upgrade -y

RUN apt-get install -y \
        wget curl apt-transport-https ca-certificates mc git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get install -y \
        libzip-dev

RUN docker-php-ext-install zip

#CHROMIUM & CHROMEDRIVER
RUN apt-get install chromium -y
RUN apt-get install chromium-driver

RUN pecl install redis-5.3.2 \
    && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer