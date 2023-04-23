#!bin/bash

sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = '$wp_port'/g' /etc/php/7.3/fpm/pool.d/www.conf

mkdir /var/www
mkdir /var/www/html

cd /var/www/html

chown -R www-data:www-data /var/www/html/

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i -r 's/database_name_here/'$db_name'/' /var/www/html/wp-config.php
sed -i -r 's/username_here/'$admin_name'/' /var/www/html/wp-config.php
sed -i 's/password_here/'$admin_pwd'/' /var/www/html/wp-config.php
sed -i 's/localhost/mariadb/' /var/www/html/wp-config.php


wp core install --url=$domain_name --title=$wp_title --admin_user=$wp_admin_name --admin_password=$wp_admin_pwd --admin_email=$wp_admin_mail --allow-root

wp user create $user_name $user_mail --role=author --user_pass=$user_pwd --allow-root

wp plugin install redis-cache --allow-root --path=/var/www/html/
wp plugin activate redis-cache --allow-root --path=/var/www/html/
wp config set WP_REDIS_HOST 'redis' --allow-root
wp config set WP_REDIS_PORT '6379' --allow-root
wp config set WP_CACHE 'true' --allow-root
wp redis enable --allow-root --path=/var/www/html/

mkdir /run/php

/usr/sbin/php-fpm7.3 -F



