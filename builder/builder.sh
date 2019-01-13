#!/bin/sh

export VERSION=${VERSION:-"0.11.0"}
export TELEMETRY=${ENABLE_TELEMETRY:-"true"}

export PATH="/usr/bin:$GOPATH/bin:$GOPATH/bin/linux_$GOARCH:$GOROOT/bin:$PATH"

# caddy
CADDY_ROOT=/go/src/github.com/mholt/caddy
mkdir -p $CADDY_ROOT
git clone https://github.com/mholt/caddy -b "v$VERSION" /go/src/github.com/mholt/caddy
cd /go/src/github.com/mholt/caddy || return 1
git checkout -b "v${VERSION}"

echo "==================================="
echo "PATH:"
echo $PATH
echo "==================================="

# plugin helper
GOOS=linux GOARCH=${GOARCH} go get -v github.com/abiosoft/caddyplug/caddyplug
GOOS=linux GOARCH=${GOARCH} go install -v github.com/abiosoft/caddyplug/caddyplug
echo "caddyplug: $(which caddyplug)"
command -v caddyplug
ls -alh /usr/bin/
alias caddyplug="GOOS=linux GOARCH=${GOARCH} caddyplug"

# telemetry
# run_file="/go/src/github.com/mholt/caddy/caddy/caddymain/run.go"
# if [ "$TELEMETRY" = "false" ]; then
#     cat > "$run_file.disablestats.go" <<EOF
#     package caddymain
#     import "os"
#     func init() {
#         switch os.Getenv("ENABLE_TELEMETRY") {
#         case "0", "false":
#             EnableTelemetry = false
#         case "1", "true":
#             EnableTelemetry = true
#         }
#     }
# EOF
# fi

# plugins
for plugin in $(echo $PLUGINS | tr "," " "); do
  go get -v $(caddyplug package $plugin)
  printf "package caddyhttp\nimport _ \"$(caddyplug package $plugin)\"" >/go/src/github.com/mholt/caddy/caddyhttp/$plugin.go \
    ;
done

# builder dependency
git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds

# build
cd /go/src/github.com/mholt/caddy/caddy && \
  GOOS=linux GOARCH=${GOARCH} go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM && \
  ls -alhR . && \
  mkdir -p /install && \
  mv caddy /install
