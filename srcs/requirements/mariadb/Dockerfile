FROM debian:bookworm-slim

ARG LOGIN

LABEL maintainer=$LOGIN
LABEL description="Custom image for Inception"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld \
    && chmod 755 /var/lib/mysql

RUN mysql_install_db -y --user=mysql --ldata=/var/lib/mysql

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY conf/my.cnf /etc/mysql/my.cnf

USER mysql

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
