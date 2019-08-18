ARG target

# =======
# Builder
# =======
FROM jessestuart/caddy-builder as builder

ARG version
ARG plugins="cache,cloudflare,cors,expires,git,realip"
ARG enable_telemetry="true"

ARG goarch
ENV GOARCH $goarch

RUN go get -v -d github.com/abiosoft/parent
RUN go build -o /go/bin/parent github.com/abiosoft/parent

RUN \
  VERSION=${version} \
  PLUGINS=${plugins} \
  ENABLE_TELEMETRY=${enable_telemetry} \
  /bin/sh /usr/bin/builder.sh

# ===========
# Final stage
# ===========
FROM $target/alpine
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"
COPY qemu-* /usr/bin/

ARG version
LABEL caddy_version="$version"

# Let's Encrypt Agreement
ENV ACME_AGREE="true"

# Telemetry Stats
ENV ENABLE_TELEMETRY="true"

RUN apk add --no-cache \
  ca-certificates \
  git \
  mailcap \
  openssh-client \
  tzdata

# Install caddy.
COPY --from=builder /install/caddy /usr/bin/caddy
# Install process wrapper.
COPY --from=builder /go/bin/parent /bin/parent

# Validate install.
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
