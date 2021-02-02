FROM	debian:buster

ENV AUTOINDEX=on

RUN apt-get update && apt-get install -y --no-install-recommends \
	vim \
	curl \
	nginx \
	openssl \
	wget \
	mariadb-server \
	php-fpm php-mysql \
	php7.3

COPY ./srcs/nginx_init.sh ./
COPY ./srcs/nginx_config ./etc/nginx/sites-available/nginx_config
COPY ./srcs/wp-config.php /var/www/html/wp-config.php

ENTRYPOINT ["bash", "./nginx_init.sh"]
