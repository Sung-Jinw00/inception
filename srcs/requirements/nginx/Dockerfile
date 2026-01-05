FROM debian:bookworm-slim

ARG LOGIN

LABEL maintainer=$LOGIN
LABEL description="Custom image for Inception"

RUN apt-get update && apt-get install -y \
    nginx openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/ /etc/nginx/conf.d/
COPY tools/generate_certs.sh /generate_certs.sh

RUN chmod +x /generate_certs.sh && /generate_certs.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
