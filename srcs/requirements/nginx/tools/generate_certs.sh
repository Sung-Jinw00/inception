#!/bin/sh

set -e

mkdir -p /etc/nginx/certs

openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/certs/nginx.key \
    -out /etc/nginx/certs/nginx.crt \
    -subj "/C=FR/ST=42/L=Intra/O=42/CN=${DOMAINE_NAME}"