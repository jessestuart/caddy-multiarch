#!/bin/bash
apk update && apk add curl jq

VERSION=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/latest | jq -r ".tag_name")

echo "Installing manifest-tool."
curl -sLO https://github.com/estesp/manifest-tool/releases/download/v1.0.0-rc3/manifest-tool-linux-amd64 > /usr/bin/manifest-tool
chmod +x /usr/bin/manifest-tool
manifest-tool --version

echo "Authenticating with Docker hub."
echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin

echo "Pushing manifest for: $IMAGE"
if [ "${CIRCLE_BRANCH}" == 'master' ]; then
  manifest-tool push from-args \
    --platforms linux/amd64 \
    --template "$IMAGE:$VERSION-ARCH" \
    --target "$IMAGE:latest"
fi

manifest-tool push from-args \
  --platforms linux/amd64 \
  --template "$IMAGE:$VERSION-ARCH" \
  --target "$IMAGE:$VERSION"

manifest-tool inspect "$IMAGE:$VERSION"
