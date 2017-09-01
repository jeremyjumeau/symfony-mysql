FROM jeremyjumeau/symfony-mysql

MAINTAINER Jeremy Jumeau <jumeau.jeremy@gmail.com>

# Wkhtmltopdf
RUN set -xe \
    && curl -LO https://github.com/madnight/docker-alpine-wkhtmltopdf/raw/846f9133cc89d83e017119e74652d0e77ccfb54b/wkhtmltopdf \
    && mv wkhtmltopdf /usr/local/bin/wkhtmltopdf \
    && chmod +x /usr/local/bin/wkhtmltopdf \
    && apk add --no-cache \
		glib \
		libintl \
        libgcc \
		libstdc++ \
		libx11 \
		libxext \
		libxrender
