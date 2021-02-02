#!/bin/sh

service mysql start

ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled/nginx_config
rm -rf /etc/nginx/sites-enabled/default

if [ "$AUTOINDEX" == "off" ]; then
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/nginx_config
fi

mkdir /etc/nginx/ssl && \
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out /etc/nginx/ssl/nginx_selfsigned.crt \
            -keyout /etc/nginx/ssl/nginx_selfsigned.key \
            -subj "/C=JP/ST=Tokyo/L=Minato/O=42Tokyo/CN=localhost"

mysql -e "CREATE DATABASE IF NOT EXISTS wddb;"
mysql -e "CREATE USER IF NOT EXISTS 'user@localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL ON wddb.* TO 'user@localhost'"
mysql -e "FLUSH PRIVILEGES;"

mkdir -p /var/www/html/phpmyadmin
wget -O phpmyadmin.tar.gz --no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
wget https://ja.wordpress.org/latest-ja.tar.gz
tar -xvf phpmyadmin.tar.gz -C /var/www/html/phpmyadmin --strip-components 1
rm -rf phpmyadmin.tar.gz

mkdir -p /var/www/html/wordpress
wget -O wordpress.tar.gz --no-check-certificate https://wordpress.org/latest.tar.gz
tar -xzf wordpress.tar.gz -C /var/www/html/wordpress --strip-components 1
rm -rf wordpress.tar.gz
mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php

mkdir -p /var/www/html/test
chown -R www-data:www-data /var/www/html/*
find /var/www/html/ -type d -exec chmod 755 {} +
find /var/www/html/ -type f -exec chmod 644 {} +

service nginx start
service php7.3-fpm start

tail -f /var/log/nginx/access.log
