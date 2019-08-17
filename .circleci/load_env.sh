#!/bin/bash

echo '
export DIR=`pwd`
export QEMU_VERSION=v4.0.0
export GITHUB_REPO=caddyserver/caddy
export GO_REPO=github.com/caddyserver/caddy
export VERSION=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/latest | jq -r ".tag_name")

export GOPATH="$HOME/go"
export GOROOT=/usr/local/go
export IMAGE=caddy
export REGISTRY=jessestuart
export PROJECT_PATH=$GOPATH/src/$GO_REPO
export IMAGE_ID="${REGISTRY}/${IMAGE}"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
' >>$BASH_ENV

source $BASH_ENV
