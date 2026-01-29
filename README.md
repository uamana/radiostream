# Radio HLS Streaming with Docker

A Docker-based radio streaming solution.

## Features

- **Icecast (HTTP) Streaming**: Icecast 2.4.4 with SSL support
- **HLS Streaming**: Liquidsoap as HLS segment generator, Nginx as HTTP(S) server
- **Auto HTTPS**: with Let's encrypt and certbot

## Prerequisites

- Docker and Docker Compose installed [How to install](https://docs.docker.com/compose/install/)
- Domain name pointing to your server
- Ports 80 and 443 open in your firewall
- Email address for Let's Encrypt notifications


## Usage

### Set defaults in config.sh 
See comments in file.

```bash
nano config.sh
```

### Run gen_config.sh
```bash
./gen_config.sh
```

### Start services
```bash
./start.sh
```

### Stop services
```bash
docker compose down
```

### View logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f liquidsoap
docker compose logs -f nginx
docker compose logs -f certbot
```

### Restart a service
```bash
docker compose restart nginx
```

### Check certificate status
```bash
docker compose exec certbot certbot certificates
```

### Manually renew certificates
```bash
docker compose run --rm certbot renew
docker compose exec nginx nginx -s reload
```
