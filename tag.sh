#!/usr/bin/env bash

VERSION=$(cat Cargo.toml | grep -E 'version = \"\d+\.\d+\.\d+\"' | awk '{split($0, a, "\""); print a[2]}')
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
if [[ "$(git tag -l | grep -c "$TAG")" != "0" ]]; then
  echo "Tag '$TAG' already exists, skipping release"
  exit 0
fi

git tag "$TAG"
git push origin "$TAG"
echo "$TAG"
exit 0
