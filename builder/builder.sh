#!/bin/sh

VERSION=${VERSION:-"0.11.5"}
TELEMETRY=${ENABLE_TELEMETRY:-"true"}

# add `v` prefix for version numbers
checkout_tag=false
[ "$(echo $VERSION | cut -c1)" -ge 0 ] 2>/dev/null && VERSION="v$VERSION" && checkout_tag=true

# plugin helper
GOOS=linux GOARCH=$GOARCH go get -v github.com/abiosoft/caddyplug/caddyplug
if [ $GOARCH == 'amd64' ]; then
  alias caddyplug="GO111MODULE=off GOOS=linux GOARCH=$GOARCH $GOPATH/bin/caddyplug"
else
  alias caddyplug="GO111MODULE=off GOOS=linux GOARCH=$GOARCH $GOPATH/bin/linux_$GOARCH/caddyplug"
fi

# check for modules support
go_mod=false
[ -f /go/src/github.com/mholt/caddy/go.mod ] && export GO111MODULE=on && go_mod=true

# telemetry
run_file="/go/src/github.com/mholt/caddy/caddy/caddymain/run.go"
if [ "$TELEMETRY" = "false" ]; then
  cat >"$run_file.disablestats.go" <<EOF
    package caddymain
    import "os"
    func init() {
        switch os.Getenv("ENABLE_TELEMETRY") {
        case "0", "false":
            EnableTelemetry = false
        case "1", "true":
            EnableTelemetry = true
        }
    }
EOF
fi

# plugins
for plugin in $(echo $PLUGINS | tr "," " "); do
  package=$(caddyplug package $plugin)
  $go_mod || go get -v "$package" # not needed for modules
  printf "package caddyhttp\nimport _ \"$package\"" >/go/src/github.com/mholt/caddy/caddyhttp/$plugin.go \
    ;
done

# builder dependency, not needed for modules
$go_mod || git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds

# build
cd /go/src/github.com/mholt/caddy/caddy &&
  GOOS=linux GOARCH=amd64 go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM &&
  mkdir -p /install &&
  mv caddy /install
