#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT_DIR/scripts/configure.sh"

kubectl apply -f "$ROOT_DIR/generated/namespace.yaml"
kubectl apply -f "$ROOT_DIR/generated/postgres/"
kubectl apply -f "$ROOT_DIR/generated/backend/springboot-configmap.yaml"
kubectl apply -f "$ROOT_DIR/generated/backend/springboot-secret.yaml"

echo
echo "Base infrastructure applied."
echo "Namespace + PostgreSQL + Spring Boot config/secret are ready."
