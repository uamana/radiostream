#!/bin/sh
set -e

ICECAST_PEM_PATH="/etc/letsencrypt/icecast.pem"
LIVE_BASE="/etc/letsencrypt/live"
CERTBOT_RENEW_INTERVAL="${CERTBOT_RENEW_INTERVAL:-1d}"

build_icecast_pem() {
  # Use the first domain directory that has both fullchain and privkey
  if [ ! -d "${LIVE_BASE}" ]; then
    return 0
  fi

  for d in "${LIVE_BASE}"/*; do
    [ -d "$d" ] || continue
    if [ -f "$d/fullchain.pem" ] && [ -f "$d/privkey.pem" ]; then
      cat "$d/fullchain.pem" "$d/privkey.pem" > "${ICECAST_PEM_PATH}"
      chmod 600 "${ICECAST_PEM_PATH}" || true
      echo "Rebuilt ${ICECAST_PEM_PATH} from $d/fullchain.pem and $d/privkey.pem"
      return 0
    fi
  done
}

while :; do
  sleep "${CERTBOT_RENEW_INTERVAL}"
  echo "Renewing certificates..."
  certbot renew --webroot -w /var/www/certbot --non-interactive --quiet || true

  echo "Rebuilding icecast.pem..."
  build_icecast_pem || true
done
