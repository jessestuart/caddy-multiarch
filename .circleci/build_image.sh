#!/bin/bash

if [ $GOARCH == 'amd64' ]; then
  touch qemu-amd64-static
else
  curl -sL "https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VERSION}/qemu-${QEMU_ARCH}-static.tar.gz" | tar xz
  docker run --rm --privileged multiarch/qemu-user-static:register
fi

docker build \
  -t "${IMAGE_ID}:${VERSION}-${GOARCH}" \
  --build-arg version=$VERSION \
  --build-arg target=$TARGET \
  --build-arg arch=$QEMU_ARCH \
  --build-arg goarch=$GOARCH .
