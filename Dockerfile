FROM debian:buster
ENV AUTOINDEX=on

COPY ./srcs/nginx_init.sh ./
COPY ./srcs/nginx_config ./etc/nginx/sites-available/nginx_config
COPY ./srcs/wp-config.php /var/www/html/wp-config.php

RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    curl \
    nginx \
    openssl \
    wget \
    mariadb-server \
    php-fpm php-mysql \
    php7.3

RUN mkdir /etc/nginx/ssl && \
    openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out /etc/nginx/ssl/nginx_selfsigned.crt \
            -keyout /etc/nginx/ssl/nginx_selfsigned.key \
            -subj "/C=JP/ST=Tokyo/L=Minato/O=42Tokyo/CN=localhost"

RUN service mysql start && \
    mysql -e "CREATE DATABASE IF NOT EXISTS wddb;" && \
    mysql -e "CREATE USER IF NOT EXISTS 'user@localhost' IDENTIFIED BY 'password';" && \
    mysql -e "GRANT ALL ON wddb.* TO 'user@localhost'" && \
    mysql -e "FLUSH PRIVILEGES;"

RUN curl -OL --insecure https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz && \
    tar -zxvf phpMyAdmin-5.0.4-all-languages.tar.gz && \
    mv phpMyAdmin-5.0.4-all-languages /var/www/html/phpmyadmin

RUN curl -OL --insecure https://ja.wordpress.org/latest-ja.tar.gz && \
    tar -zxvf latest-ja.tar.gz && \
    mv wordpress /var/www/html/ && \
    mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php

RUN mkdir -p /var/www/html/test && \
    chown -R www-data:www-data /var/www/html/* && \
    find /var/www/html/ -type d -exec chmod 755 {} + && \
    find /var/www/html/ -type f -exec chmod 644 {} +

RUN ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled/nginx_config && \
    rm -rf /etc/nginx/sites-enabled/default

ENTRYPOINT ["bash", "./nginx_init.sh"]
