#!/bin/bash

set -euo pipefail

source ./config.sh

# Ensure certbot directories exist so the volume mounts don't cause surprises
mkdir -p ./certbot/conf ./certbot/www ./certbot/logs

if [ ! -d "./certbot/conf/live/$DOMAIN" ]; then
  echo "No certificate found for $DOMAIN, generating new one with standalone mode..."
  echo "Make sure nothing else is listening on port 80 on the host."
  # Use standalone HTTP-01 challenge. We map host port 80 -> container 80 so
  # Let's Encrypt can reach the temporary webserver started by certbot.
  
  docker compose run --rm --entrypoint certbot -p 80:80 certbot certonly \
    --standalone \
    --preferred-challenges http \
    -d "$DOMAIN" \
    --email "$EMAIL" \
    --agree-tos \
    --non-interactive

  if [ ! -f "./certbot/conf/live/$DOMAIN/fullchain.pem" ] || [ ! -f "./certbot/conf/live/$DOMAIN/privkey.pem" ]; then
    echo "ERROR: Let's Encrypt certificate acquisition failed for $DOMAIN."
    echo "Check certbot logs in ./certbot/logs or your network/firewall settings."
    exit 1
  fi

  cat ./certbot/conf/live/$DOMAIN/fullchain.pem ./certbot/conf/live/$DOMAIN/privkey.pem > ./certbot/conf/icecast.pem
fi

docker compose up -d
