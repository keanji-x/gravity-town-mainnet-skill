#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_NAME="gravity-town-mainnet"
PLUGIN_DEST="$HOME/plugins/$PLUGIN_NAME"
MARKETPLACE="$HOME/.agents/plugins/marketplace.json"

if ! command -v node >/dev/null 2>&1; then
  echo "node is required" >&2
  exit 1
fi

mkdir -p "$(dirname "$PLUGIN_DEST")"
rm -rf "$PLUGIN_DEST"
mkdir -p "$PLUGIN_DEST"

tar \
  --exclude='./mcp/node_modules' \
  --exclude='./mcp/dist' \
  --exclude='./node_modules' \
  --exclude='./.git' \
  -C "$ROOT" \
  -cf - . | tar -C "$PLUGIN_DEST" -xf -

npm --prefix "$PLUGIN_DEST/mcp" install
npm --prefix "$PLUGIN_DEST/mcp" run build
node "$PLUGIN_DEST/scripts/write-mcp-config.mjs" "$PLUGIN_DEST/.mcp.json" "$PLUGIN_DEST/scripts/run-mcp.sh"

mkdir -p "$(dirname "$MARKETPLACE")"

node "$PLUGIN_DEST/scripts/update-marketplace.mjs" "$MARKETPLACE" "$PLUGIN_NAME"

echo "Installed Codex plugin source to $PLUGIN_DEST"
echo "Updated personal marketplace at $MARKETPLACE"
echo "Before launching Codex, export GRAVITY_TOWN_PRIVATE_KEY=0x..."

if command -v codex >/dev/null 2>&1; then
  codex plugin add "$PLUGIN_NAME@personal" || true
  echo "If Codex was already running, start a new thread after plugin install."
else
  echo "codex CLI not found. In Codex, install plugin: $PLUGIN_NAME@personal"
fi
