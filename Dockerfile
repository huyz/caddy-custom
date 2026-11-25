FROM --platform=$TARGETPLATFORM caddy:2.11-builder-alpine@sha256:86e132d1d6db8850352b2dbc15f82a4cb25363ac305ee41e11405873e5931f37 AS builder

RUN xcaddy build \
  --with github.com/hslatman/caddy-crowdsec-bouncer/http \
  --with github.com/WeidiDeng/caddy-cloudflare-ip \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
  --with github.com/fvbommel/caddy-dns-ip-range \
  --with github.com/fvbommel/caddy-combine-ip-ranges \
  --with github.com/caddyserver/replace-response \
  --with github.com/caddyserver/cache-handler \
  --with github.com/mholt/caddy-l4 \
  --with github.com/mholt/caddy-webdav

FROM --platform=$TARGETPLATFORM caddy:2.11-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

HEALTHCHECK --interval=30s --timeout=5s --start-period=1m CMD wget -q --tries=1 --spider http://127.0.0.1:2019/metrics || exit 1
