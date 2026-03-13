#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v zip >/dev/null 2>&1; then
  echo "[package_mods] Error: 'zip' is required but not installed."
  exit 1
fi

echo "[package_mods] Rebuilding mods..."
bash "$ROOT_DIR/build_mods.sh"

mkdir -p "$ROOT_DIR/dist"
rm -f "$ROOT_DIR"/dist/*.zip

shopt -s nullglob
mod_dirs=("$ROOT_DIR"/mods/*/)

if [ ${#mod_dirs[@]} -eq 0 ]; then
  echo "[package_mods] Error: no mod directories found in ./mods"
  exit 1
fi

echo "[package_mods] Creating zip files..."
for mod_dir in "${mod_dirs[@]}"; do
  mod_name="$(basename "$mod_dir")"
  zip_path="$ROOT_DIR/dist/${mod_name}.zip"

  (
    cd "$ROOT_DIR/mods"
    zip -rq "$zip_path" "$mod_name"
  )

  echo "[package_mods] Created dist/${mod_name}.zip"
done

echo "[package_mods] Done. Packaged ${#mod_dirs[@]} mod(s)."
