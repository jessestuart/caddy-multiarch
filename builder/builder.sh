#!/bin/bash

VERSION=${VERSION:-"0.11.0"}
TELEMETRY=${ENABLE_TELEMETRY:-"true"}

git clone https://github.com/mholt/caddy $GOPATH/src/github.com/mholt/caddy
cd $GOPATH/src/github.com/mholt/caddy || exit 1

export PATH=$GOPATH/bin:$GOPATH/bin/linux_$GOARCH:$PATH

echo $PATH

# plugin helper
GOOS=linux GOARCH=$GOARCH go get -v github.com/abiosoft/caddyplug/caddyplug
ls -alh $GOPATH/bin
if [ $GOARCH == 'amd64' ]; then
  alias caddyplug="GOOS=linux GOARCH=$GOARCH $GOPATH/bin/caddyplug"
else
  alias caddyplug="GOOS=linux GOARCH=$GOARCH $GOPATH/bin/linux_$GOARCH/caddyplug"
fi

# telemetry
run_file="$GOPATH/src/github.com/mholt/caddy/caddy/caddymain/run.go"
line=$(awk '/const enableTelemetry = true/{print NR}' $run_file)
if [ "$line" ] && [ $TELEMETRY = "false" ]; then
    sed -i.bak -e "${line}d" $run_file
    cat > "$run_file.disablestats.go" <<EOF
    package caddymain
    import "os"
    var enableTelemetry = $TELEMETRY
    func init() {
        switch os.Getenv("ENABLE_TELEMETRY") {
        case "0", "false":
            enableTelemetry = false
        case "1", "true":
            enableTelemetry = true
        }
    }
EOF
fi

# plugins
for plugin in $(echo $PLUGINS | tr "," " "); do \
  GOOS=linux GOARCH=$GOARCH go get -v $(caddyplug package $plugin); \
  printf "package caddyhttp\nimport _ \"$(caddyplug package $plugin)\"" > \
      $GOPATH/src/github.com/mholt/caddy/caddyhttp/$plugin.go ; \
done

# builder dependency
git clone https://github.com/caddyserver/builds $GOPATH/src/github.com/caddyserver/builds

# build
cd $GOPATH/src/github.com/mholt/caddy/caddy \
  && GOOS=linux GOARCH=$GOARCH go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM \
  && mkdir -p /install \
  && mv caddy /install
