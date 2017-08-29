FROM php:fpm-alpine

ENV TERM="xterm"
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APCU_VERSION 5.1.8

MAINTAINER Jeremy Jumeau <jumeau.jeremy@gmail.com>

# Minimal packages
RUN apk add --no-cache --virtual .persistent-deps \
	acl \
        bash \
        icu-libs \
        zlib \
    # fix www-data uid
    && sed -ri 's/^www-data:x:82:82:/www-data:x:1000:50:/' /etc/passwd

# PHP extensions
RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        imagemagick-dev \
        libmcrypt-dev \
        libtool \
        openldap-dev \
        openssl-dev \
        zlib-dev \
    && pecl install imagick-beta \
	&& docker-php-ext-install \
        intl \
        ldap \
        mbstring \
        mcrypt \
        opcache \
        pdo_mysql \
        sockets \
        zip \
	&& pecl install \
        apcu-${APCU_VERSION} \
    && docker-php-ext-enable \
        apcu \
        opcache \
        imagick \
    && runDeps="$( \
		scanelf --needed --nobanner --recursive \
			/usr/local/lib/php/extensions \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --virtual .phpexts-rundeps $runDeps \
	&& apk del .build-deps

# Composer
COPY install-composer.sh /usr/local/bin/docker-app-install-composer
RUN set -xe \
    && chmod +x /usr/local/bin/docker-app-install-composer \
	&& apk add --no-cache --virtual .composer-deps \
        openssl \
	&& docker-app-install-composer \
	&& mv composer.phar /usr/local/bin/composer \
	&& apk del .composer-deps

WORKDIR /var/www
