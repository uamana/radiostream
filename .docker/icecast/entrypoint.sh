#!/bin/sh
set -e

ICECAST_CMD="/usr/bin/icecast -n -c /etc/icecast.xml"
ICECAST_CERT_CHECK_INTERVAL="${ICECAST_CERT_CHECK_INTERVAL:-12h}"

cleanup_ran=0
cleanup() {
  [ "$cleanup_ran" -eq 1 ] && return
  cleanup_ran=1    
  echo "Shutting down background processes..."
  kill 0  # Sends SIGINT to all processes in the current process group
  wait    # Wait for all background processes to terminate
  echo "All processes stopped."
  exit 0
}
trap 'cleanup' INT TERM

echo "Starting Icecast..."
# Start Icecast in the background so we can supervise it
$ICECAST_CMD &
ICECAST_PID=$!

LAST_CERT_RENEWAL=$(stat -c %Y /usr/share/icecast/icecast.pem 2>/dev/null || echo "")
echo "Last certificate renewal: $LAST_CERT_RENEWAL"

# Background timer that will request a restart once a day
(
  while :; do
    sleep "${ICECAST_CERT_CHECK_INTERVAL}"
    NEW_CERT_RENEWAL=$(stat -c %Y /usr/share/icecast/icecast.pem 2>/dev/null || echo "")
    if [ "$NEW_CERT_RENEWAL" -gt "$LAST_CERT_RENEWAL" ]; then
      echo "Certificate renewed; restarting Icecast"
      LAST_CERT_RENEWAL=$NEW_CERT_RENEWAL
      if kill -0 "$ICECAST_PID" 2>/dev/null; then
        kill "$ICECAST_PID" || true
      else
        # Icecast already stopped; exit helper
        exit 0
      fi
    else
      echo "Certificate not renewed; wait ..."
    fi
  done
) &

# Wait for Icecast to exit (either by crash, manual stop, or daily SIGTERM)
echo "Waiting for Icecast to exit..."
wait "$ICECAST_PID"
