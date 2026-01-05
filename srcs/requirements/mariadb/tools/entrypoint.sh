#!/bin/bash

set -e

MYSQL_ROOT_PASSWORD=$(cat /secrets/db_root_password.txt)
MYSQL_PASSWORD=$(cat /secrets/db_password.txt)

cat << EOF > /tmp/init.sql

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

exec mysqld --init-file=/tmp/init.sql
