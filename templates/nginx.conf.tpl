server {
    listen 80;
    server_name $DOMAIN;

    # Let's Encrypt HTTP-01 challenge endpoint
    # Certbot will write challenge files into /var/www/certbot (shared volume)
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # Redirect all other HTTP traffic to HTTPS
    location / {
        return 301 https://\$host\$request_uri;
    }
}

# HTTPS server
server {
    listen 443 ssl;
    http2 on;
    server_name $DOMAIN;

    # SSL certificates from Let's Encrypt
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;


    sendfile    on;
    tcp_nopush  on;
    tcp_nodelay on;

    server_tokens off;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_types application/vnd.apple.mpegurl video/mp2t;

    # HLS
    types {
        application/vnd.apple.mpegurl m3u8;
        video/mp2t ts;
    }

    location / {
        root /tmp/hls;
        
        add_header Allow "GET, HEAD" always;
        if ( \$request_method !~ ^(GET|HEAD)$ ) {
            return 405;
        }

        # CORS
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET';
        add_header 'Access-Control-Allow-Headers' '*';

        # No cache segments
        add_header 'Cache-Control' 'no-cache';
        add_header 'Pragma' 'no-cache';
        add_header 'Expires' '0';

        access_log off;
    }
}
