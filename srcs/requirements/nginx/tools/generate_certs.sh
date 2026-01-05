#!/bin/bash
set -e

CERT_DIR=/etc/ssl/certs
CERT_NAME=locagnio.42.fr

# Create directory if it doesn't exist
mkdir -p $CERT_DIR

# Check if the certificate already exists
if [ ! -f "$CERT_DIR/${CERT_NAME}.pem" ] || [ ! -f "$CERT_DIR/${CERT_NAME}-key.pem" ]; then
    echo "Generating certificate for $CERT_NAME ..."
    
    # Generate self-signed certificate
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERT_DIR/${CERT_NAME}-key.pem" \
        -out "$CERT_DIR/${CERT_NAME}.pem" \
        -subj "/C=FR/ST=42/L=Intra/O=42/CN=${CERT_NAME}"
else
    echo "Certificate already exists: $CERT_NAME"
fi

echo "Certificate and key generated in $CERT_DIR"
