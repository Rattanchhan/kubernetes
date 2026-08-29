#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="$(grep '^NAMESPACE=' "$ROOT_DIR/config.env" | cut -d= -f2)"

kubectl delete namespace "$NAMESPACE" --ignore-not-found
