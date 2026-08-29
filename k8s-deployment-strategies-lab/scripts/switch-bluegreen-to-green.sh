#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="$(grep '^NAMESPACE=' "$ROOT_DIR/config.env" | cut -d= -f2)"

kubectl patch service springboot-bluegreen-service -n "$NAMESPACE" \
  -p '{"spec":{"selector":{"app":"springboot-bg","version":"green"}}}'

kubectl patch service react-bluegreen-service -n "$NAMESPACE" \
  -p '{"spec":{"selector":{"app":"react-bg","version":"green"}}}'

echo "Blue/Green services now route to GREEN."
