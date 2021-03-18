#!/bin/sh

if [ "$AUTOINDEX" == "off" ]; then
    sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/nginx_config
fi

service mysql start
service nginx start
service php7.3-fpm start

tail -f /var/log/nginx/access.log
