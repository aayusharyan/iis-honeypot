# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aayush Sinha
#
# fake-iis - Docker image
#
# Builds a lightweight OpenResty (nginx + LuaJIT) container that serves a
# fake Microsoft IIS 8.0 website. The image serves static IIS-styled pages
# and sets IIS-specific HTTP response headers.
#
# Usage:
#   docker build -t fake-iis .
#   docker run -p 80:80 fake-iis

# ── Base image ────────────────────────────────────────────────────────────────
# openresty/openresty:alpine provides nginx with the ngx_headers_more module,
# which is required to forge the Server / X-Powered-By response headers that
# IIS emits.  The Alpine variant keeps the final image small.
FROM openresty/openresty:alpine

# ── Image metadata ────────────────────────────────────────────────────────────
LABEL version="1.1.0"

# ── Remove the default site configuration ────────────────────────────────────
# OpenResty ships with a catch-all default.conf that would conflict with the
# fake-iis vhost configuration copied in below.
RUN rm -f /etc/nginx/conf.d/default.conf

# ── Copy application assets ───────────────────────────────────────────────────
# src/ contains the static HTML error pages (403, 404, 500), a fake web.config,
# and branding images that replicate the default IIS 8 welcome / error pages.
COPY src/  /var/www/html/

# nginx virtual-host configuration that:
#   • Spoofs IIS 8.0 Server and ASP.NET response headers
#   • Returns 404 for well-known IIS/Windows administrative paths
#   • Serves the IIS-styled error pages for 400/403/404/500 responses
#   • Suppresses access and error logs to avoid disk I/O on the host
COPY nginx.conf /etc/nginx/conf.d/fake-iis.conf

# ── Network ───────────────────────────────────────────────────────────────────
# Expose the standard HTTP port.  Map to a host port at runtime with -p.
EXPOSE 80

# ── Entry point ───────────────────────────────────────────────────────────────
# Run OpenResty in the foreground so Docker can manage the process lifecycle.
CMD ["openresty", "-g", "daemon off;"]
