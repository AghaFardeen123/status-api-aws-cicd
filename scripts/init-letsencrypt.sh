#!/bin/bash
set -euo pipefail

if [ -z "${DOMAIN_NAME:-}" ] || [ -z "${CERTBOT_EMAIL:-}" ]; then
  echo "set DOMAIN_NAME and CERTBOT_EMAIL first (see .env)"
  exit 1
fi

mkdir -p certbot/conf certbot/www

mkdir -p "certbot/conf/live/$DOMAIN_NAME"
docker run --rm -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
  --entrypoint openssl elifesciences/openssl \
  req -x509 -nodes -newkey rsa:2048 -days 1 \
  -keyout "/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem" \
  -out "/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem" \
  -subj "/CN=localhost" 2>/dev/null || true

docker compose up -d nginx

sleep 3

rm -rf "certbot/conf/live/$DOMAIN_NAME"

docker compose run --rm certbot certonly \
  --webroot -w /var/www/certbot \
  -d "$DOMAIN_NAME" \
  --email "$CERTBOT_EMAIL" \
  --agree-tos \
  --no-eff-email

docker compose restart nginx

echo "cert issued for $DOMAIN_NAME, nginx restarted with real cert"
