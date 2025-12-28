#!/bin/bash

set -e

MYSQL_PASSWORD=$(cat /secrets/db_password.txt)
WP_ADMIN_PASSWORD=$(cat /secrets/wp_admin_password.txt)

sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

NEW_DOMAIN="https://$DOMAIN_NAME"
if [ -f /var/www/wordpress/wp-config.php ]; then
    CURRENT_DOMAIN=$(wp option get siteurl --path=/var/www/wordpress --allow-root 2>/dev/null || true)
    if [ -n "$CURRENT_DOMAIN" ] && [ "$CURRENT_DOMAIN" != "$NEW_DOMAIN" ]; then
        echo "Domain change detected : $CURRENT_DOMAIN -> $NEW_DOMAIN"

        wp option update siteurl "$NEW_DOMAIN" --path=/var/www/wordpress --allow-root
        wp option update home "$NEW_DOMAIN" --path=/var/www/wordpress --allow-root

        # Mise à jour des URLs dans le contenu (important)
        wp search-replace "$CURRENT_DOMAIN" "$NEW_DOMAIN" \
            --skip-columns=guid \
            --all-tables \
            --path=/var/www/wordpress \
            --allow-root
    fi
else
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
        --url="$NEW_DOMAIN" \
        --title="$WP_SITE_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path=/var/www/wordpress \
        --allow-root

    wp plugin update --all --allow-root
fi

exec php-fpm -F
