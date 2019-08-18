#!/bin/sh

set -eu

# Pull the `manifest-tool` binary from remote repo.
echo "Installing manifest-tool."
curl -sL https://github.com/estesp/manifest-tool/releases/download/v1.0.0-rc3/manifest-tool-linux-amd64 > /usr/bin/manifest-tool
chmod +x /usr/bin/manifest-tool
manifest-tool --version

echo "Authenticating with Docker hub."
echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin

echo "Pushing manifest for: $IMAGE_ID:$VERSION"
manifest-tool push from-args \
  --platforms linux/amd64,linux/arm,linux/arm64 \
  --template "$IMAGE_ID:$VERSION-ARCH" \
  --target "$IMAGE_ID:$VERSION"

if [ "${CIRCLE_BRANCH}" == 'master' ]; then
  manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64 \
    --template "$IMAGE_ID:$VERSION-ARCH" \
    --target "$IMAGE_ID:latest"
fi

manifest-tool inspect "$IMAGE_ID:$VERSION"
