#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/config.env"
OUT_DIR="$ROOT_DIR/generated"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Missing $CONFIG_FILE"
  exit 1
fi

set -a
source "$CONFIG_FILE"
set +a

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

replace_file() {
  local src="$1"
  local rel="${src#$ROOT_DIR/}"
  local dest="$OUT_DIR/${rel%.tpl}"
  mkdir -p "$(dirname "$dest")"

  sed \
    -e "s|__NAMESPACE__|$NAMESPACE|g" \
    -e "s|__SPRINGBOOT_IMAGE__|$SPRINGBOOT_IMAGE|g" \
    -e "s|__REACT_IMAGE__|$REACT_IMAGE|g" \
    -e "s|__POSTGRES_IMAGE__|$POSTGRES_IMAGE|g" \
    -e "s|__SPRINGBOOT_PORT__|$SPRINGBOOT_PORT|g" \
    -e "s|__REACT_PORT__|$REACT_PORT|g" \
    -e "s|__POSTGRES_PORT__|$POSTGRES_PORT|g" \
    -e "s|__POSTGRES_DB__|$POSTGRES_DB|g" \
    -e "s|__POSTGRES_USER__|$POSTGRES_USER|g" \
    -e "s|__POSTGRES_PASSWORD__|$POSTGRES_PASSWORD|g" \
    -e "s|__SPRING_PROFILES_ACTIVE__|$SPRING_PROFILES_ACTIVE|g" \
    "$src" > "$dest"
}

while IFS= read -r -d '' file; do
  replace_file "$file"
done < <(find "$ROOT_DIR" -type f -name "*.tpl" -print0)

echo "Generated manifests in: $OUT_DIR"
