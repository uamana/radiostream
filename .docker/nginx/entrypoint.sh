#!/bin/sh
set -e

NGINX_CERT_CHECK_INTERVAL="${NGINX_CERT_CHECK_INTERVAL:-12h}"

# Background loop to reload nginx every 12h to pick up renewed certs
(
  while :; do
    sleep "${NGINX_CERT_CHECK_INTERVAL}"
    nginx -s reload || true
  done
) &

# Run nginx in foreground
exec nginx -g 'daemon off;'
