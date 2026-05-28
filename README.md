# iis-honeypot

A lightweight Docker honeypot that mimics Microsoft IIS 8.0 using OpenResty/nginx. Designed to attract and observe automated scanners and bots probing for Windows web server vulnerabilities.

## How it works

- Serves a pixel-perfect replica of the IIS 8.0 default splash page
- Spoofs HTTP response headers (`Server: Microsoft-IIS/8.0`, `X-Powered-By: ASP.NET`, `X-AspNet-Version: 4.0.30319`)
- Exposes a `web.config` endpoint - a classic IIS artifact that scanners probe for.
- Returns authentic IIS-styled 403, 404, and 500 error pages
- Silently drops all access and error logs (no noise) - Use your own IDS.

## Usage

### Docker Compose

Copy the example compose file and adjust ports as needed:

```bash
cp docker-compose-example.yml docker-compose.yml
docker compose up -d
```

The container listens on port `80`. The example maps it to host port `8080` — change the left side to suit your setup.

### GHCR (no build required)

Pull the pre-built image directly from the GitHub Container Registry:

```bash
docker run -d \
  --name iis-honeypot \
  --restart unless-stopped \
  --security-opt no-new-privileges:true \
  -p 8080:80 \
  ghcr.io/aayusharyan/iis-honeypot:latest
```

Replace `8080` with whichever host port you want to expose.

## Requirements

- Docker
- Docker Compose

## License

MIT
