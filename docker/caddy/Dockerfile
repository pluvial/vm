# FROM caddy:2.8.4-builder AS builder
FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddyserver/nginx-adapter

# FROM caddy:2.8.4
FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
