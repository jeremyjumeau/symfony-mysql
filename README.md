# Overview
A docker image for Symfony 3 projects with MySQL

What's included?
* alpine distrib with acl and bash
* php-fpm **7.1 (latest)**
* composer
* php extensions:
    * apcu
    * imagick
    * intl
    * ldap
    * mbstring
    * mcrypt
    * opcache
    * pdo_mysql
    * sockets
    * zip
* wkhtmltopdf **0.12.4-dev (with patched qt)**

# Usage
## Docker-compose

```yaml
version: "3"

services:
    front:
        #...a front server like nginx or apache
        image: nginx
        # mount your symfony project files on front continer
        volumes:
            - .:/var/www:ro
            # set nginx conf file
            # http://symfony.com/doc/current/setup/web_server_configuration.html#nginx
            - ./docker/front/yoursite.conf:/etc/nginx/conf.d/default.conf:ro
    engine:
        image: jeremyjumeau/symfony-mysql
        environment:
            - SYMFONY_ENV
            - SYMFONY_SECRET
            - MYSQL_DATABASE
            - MYSQL_USER
            - MYSQL_ROOT_PASSWORD
        volumes:
            # mount your symfony project files on engine container
            - .:/var/www:rw
            # eventually mount the locale and the php.ini values
            #- /etc/localtime:/etc/localtime:ro
            #- ./docker/engine/php.ini:/usr/local/etc/php/conf.d/custom.ini:ro
            # log your bash commands in a dedicated dir
            - ./var/sessions/engine:/root:rw
    db:
        image: mysql
        environment:
            - MYSQL_DATABASE
            - MYSQL_USER
            - MYSQL_ROOT_PASSWORD
        volumes:
            # mount your data in the var/data dir
            - ./var/data:/var/lib/mysql:rw
            - ./var/dumps:/var/dumps:rw
            # log your bash commands/mysql instructions in a dedicated dir
            - ./var/sessions/mysql:/root:rw
```
