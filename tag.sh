#!/usr/bin/env bash

VERSION=$(grep -E '^version\s*=\s*"[0-9]+\.[0-9]+\.[0-9]+"$' Cargo.toml | awk '{split($0, a, "\""); print a[2]}')
if [ -z "$VERSION" ]; then
  echo "Could not find version in Cargo.toml"
  exit 1
fi

MATCHES=$(echo "$VERSION" | wc -l | xargs)
if [[ "$MATCHES" != "1" ]]; then
  echo "Error: Found $MATCHES versions in Cargo.toml"
  exit 1
fi

TAG="v$VERSION"
if [[ "$(git ls-remote --tags -q | grep -c "refs/tags/$TAG")" != "0" ]]; then
  echo "Tag '$TAG' already exists, will not tag again"
  exit 0
fi

git tag "$TAG"
git push origin "$TAG"
echo "$TAG"
exit 0
