#!/bin/bash

set -e

MYSQL_PASSWORD=$(cat /secrets/db_password.txt)
WP_ADMIN_PASSWORD=$(cat /secrets/wp_admin_password.txt)

sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --path=/var/www/wordpress \
        --allow-root --skip-check

    sed -i "/^\/\* That's all, stop editing! Happy publishing. \*\//i \
    define('WP_CACHE_KEY_SALT', '$DOMAIN_NAME');\n" /var/www/wordpress/wp-config.php

    until wp db check --path=/var/www/wordpress --allow-root >/dev/null 2>&1; do
        sleep 2
    done

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_SITE_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path=/var/www/wordpress \
        --allow-root

    wp plugin update --all --allow-root
fi

exec php-fpm -F
