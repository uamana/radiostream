# Domain used for HTTPS certificate and Icecast hostname
DOMAIN="your.domain.com"
# Email used for Let's Encrypt certificate and Icecast admin email
EMAIL="your@email.com"

# Liquidsoap (HLS)config
# See https://www.liquidsoap.info/doc-2.4.2/hls_output.html for more details

SAMPLE_RATE=44100 # HLS audio sample rate

# bitrates
HIFI_BITRATE="160k"  # HiFi stream bitrate
LOFI_BITRATE="64k"   # LoFi stream bitrate
MIDFI_BITRATE="128k" # MidFi stream bitrate

# Enable MidFi stream, use true to enable, false to disable
NEED_MIDFI="true" 

# HLS segments
SEGMENTS=5           # number of segments to keep
SEGMENT_DURATION=5.0 # duration of each segment
SEGMENT_OVERHEAD=5   # extra segments for buffering

# Stream names
# Stream path will be https://<DOMAIN>/<stream_name>/<stream_name>.m3u8
STREAMS=(
    "roks"
)

# Stream sources
# Prefix with HARBOR_ or ICECAST_ to use harbor or icecast source

# HARBOR_<stream_name>="mount:port:password"
#HARBOR_radio_a="live:8000:password"

# ICECAST_<stream_name>="http[s]://<host>:<port>/<stream_name>"
ICECAST_roks="http://stream.roks.com:8000/live_hd"

# Harbor bind address (used for internal Icecast compatible server)
HARBOR_BIND_ADDR="0.0.0.0"

# IceCast config
# You MUST change passwords!!!
ICECAST_LOCATION="Location"      # Location of the radio station
ICECAST_ADMIN="${EMAIL}"         # Admin email
ICECAST_CLIENTS=1000             # Maximum number of clients
ICECAST_SOURCES=8                # Maximum number of sources
ICECAST_SOURCE_PASSWORD=hackme   # Source password (you MUST change it!!!)
ICECAST_RELAY_PASSWORD=hackme    # Relay password (you MUST change it!!!)
ICECAST_ADMIN_PASSWORD=hackme    # Admin password (you MUST change it!!!)
ICECAST_HOSTNAME="${DOMAIN}"     # Hostname

# templates
TEMPLATE_ICECAST="templates/icecast.xml.tpl"
TEMPLATE_NGINX="templates/nginx.conf.tpl"
TEMPLATE_LQ_SETTINGS="templates/settings.liq.tpl"

# Containers settings
CONTAINER_TMPFS_SIZE="16m"

CERTBOT_RENEW_INTERVAL="1d"
ICECAST_CERT_CHECK_INTERVAL="12h"
NGINX_CERT_CHECK_INTERVAL="12h"