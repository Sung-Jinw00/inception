FROM debian:bookworm-slim

ARG LOGIN

LABEL maintainer=$LOGIN
LABEL description="Custom image for Inception"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    php8.2 php8.2-fpm php8.2-mysql curl mariadb-client less tar \
    && ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/wordpress

WORKDIR /var/www/wordpress

RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/setup.sh"]
