ARG target

# =======
# Builder
# =======
FROM abiosoft/caddy:builder as builder

ARG version="1.0.0"
ARG plugins="cache,cloudflare,cors,expires,git,realip"
ARG goarch

ENV GO111MODULE on
ENV GOARCH $goarch

COPY builder/builder.sh /usr/bin/builder.sh
# Process wrapper.
RUN export GOARCH=$GOARCH && \
    go get -v github.com/abiosoft/parent && \
    VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=true /usr/bin/builder.sh

# ===========
# Final stage
# ===========
FROM $target/alpine:3.9
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"

ARG version="1.0.0"
LABEL caddy_version="$version"

# Let's Encrypt Agreement
ENV ACME_AGREE="true"

# Telemetry Stats
ENV ENABLE_TELEMETRY="true"

RUN apk add --no-cache openssh-client git

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

# install process wrapper
COPY --from=builder /go/bin/parent /bin/parent

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
