# fake-iis

A lightweight Docker image that serves a fake Microsoft IIS 8.0 website using OpenResty/nginx.

## How it works

- Serves a pixel-perfect replica of the IIS 8.0 default splash page
- Spoofs HTTP response headers (`Server: Microsoft-IIS/8.0`, `X-Powered-By: ASP.NET`, `X-AspNet-Version: 4.0.30319`)
- Exposes a `web.config` endpoint with the correct XML content-type
- Returns authentic IIS-styled 403, 404, and 500 error pages
- Silently drops all access and error logs

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
  --name fake-iis \
  --restart unless-stopped \
  --security-opt no-new-privileges:true \
  -p 8080:80 \
  ghcr.io/aayusharyan/fake-iis:latest
```

Replace `8080` with whichever host port you want to expose.

## Requirements

- Docker
- Docker Compose

## License

MIT
