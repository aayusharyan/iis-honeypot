# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aayush Sinha
#
# IIS Honeypot - Docker image
#
# Builds a lightweight OpenResty (nginx + LuaJIT) container that mimics a
# Microsoft IIS 8.0 server. The image serves static decoy pages and spoofs
# IIS-specific HTTP response headers so that automated scanners and
# opportunistic attackers believe they are interacting with a real Windows
# web server.
#
# Usage:
#   docker build -t iis-honeypot .
#   docker run -p 80:80 iis-honeypot

# ── Base image ────────────────────────────────────────────────────────────────
# openresty/openresty:alpine provides nginx with the ngx_headers_more module,
# which is required to forge the Server / X-Powered-By response headers that
# IIS emits.  The Alpine variant keeps the final image small.
FROM openresty/openresty:alpine

# ── Image metadata ────────────────────────────────────────────────────────────
LABEL version="0.1.0"

# ── Remove the default site configuration ────────────────────────────────────
# OpenResty ships with a catch-all default.conf that would conflict with the
# honeypot vhost configuration copied in below.
RUN rm -f /etc/nginx/conf.d/default.conf

# ── Copy application assets ───────────────────────────────────────────────────
# src/ contains the static HTML error pages (403, 404, 500), a fake web.config,
# and branding images that replicate the default IIS 8 welcome / error pages.
COPY src/  /var/www/html/

# nginx virtual-host configuration that:
#   • Spoofs IIS 8.0 Server and ASP.NET response headers
#   • Returns 404 for well-known IIS/Windows administrative paths
#   • Serves the decoy error pages for 400/403/404/500 responses
#   • Suppresses access and error logs to avoid disk I/O on the host
COPY nginx.conf /etc/nginx/conf.d/iis-honeypot.conf

# ── Network ───────────────────────────────────────────────────────────────────
# Expose the standard HTTP port.  Map to a host port at runtime with -p.
EXPOSE 80

# ── Entry point ───────────────────────────────────────────────────────────────
# Run OpenResty in the foreground so Docker can manage the process lifecycle.
CMD ["openresty", "-g", "daemon off;"]
