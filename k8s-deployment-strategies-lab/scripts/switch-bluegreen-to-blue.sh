#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="$(grep '^NAMESPACE=' "$ROOT_DIR/config.env" | cut -d= -f2)"

kubectl patch service springboot-bluegreen-service -n "$NAMESPACE" \
  -p '{"spec":{"selector":{"app":"springboot-bg","version":"blue"}}}'

kubectl patch service react-bluegreen-service -n "$NAMESPACE" \
  -p '{"spec":{"selector":{"app":"react-bg","version":"blue"}}}'

echo "Blue/Green services now route to BLUE."
