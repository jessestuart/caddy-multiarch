ARG target

# =======
# Builder
# =======
FROM abiosoft/caddy:builder as builder

ARG plugins="git,cors,realip,expires,cache,cloudflare"

ARG goarch
ENV GOARCH $goarch
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH "$GOROOT/bin:$GOPATH/bin:$GOPATH/linux_$GOARCH/bin:$PATH"

# process wrapper
RUN go get -v github.com/abiosoft/parent && \
      (cp /go/bin/**/parent /bin/parent || \
       cp -f /go/bin/parent /bin/parent) &>/dev/null

RUN rm -rf /usr/bin/builder.sh
COPY builder/builder.sh /usr/bin/builder.sh

ARG version
RUN VERSION=${version} PLUGINS=${plugins} GOARCH=${goarch} /bin/sh /usr/bin/builder.sh

# ===========
# Final stage
# ===========
FROM $target/alpine
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"
LABEL caddy_version="$version"

COPY qemu-* /usr/bin/

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

# Let's Encrypt Agreement
ENV ACME_AGREE="true"

RUN apk add --no-cache openssh-client git

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN caddy -version && caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile

# install process wrapper
COPY --from=builder /bin/parent /bin/parent

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
