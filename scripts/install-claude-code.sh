#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCOPE="${1:-local}"
INSTALL_DIR="${GRAVITY_TOWN_INSTALL_DIR:-$HOME/.local/share/gravity-town-mainnet-skill}"

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found in PATH" >&2
  exit 1
fi

case "$SCOPE" in
  local|project|user) ;;
  *)
    echo "Usage: $0 [local|project|user]" >&2
    exit 1
    ;;
esac

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

tar \
  --exclude='./.git' \
  --exclude='./mcp/node_modules' \
  --exclude='./mcp/dist' \
  --exclude='./node_modules' \
  --exclude='./dist' \
  -C "$ROOT" \
  -cf - . | tar -C "$INSTALL_DIR" -xf -

npm --prefix "$INSTALL_DIR/mcp" install
npm --prefix "$INSTALL_DIR/mcp" run build

claude mcp remove gravity-town-mainnet --scope "$SCOPE" >/dev/null 2>&1 || true
claude mcp add \
  --transport stdio \
  --scope "$SCOPE" \
  gravity-town-mainnet \
  -- "$INSTALL_DIR/scripts/run-mcp.sh"

echo "Installed Claude Code MCP server: gravity-town-mainnet ($SCOPE scope)"
echo "Before launching Claude Code, export GRAVITY_TOWN_PRIVATE_KEY=0x..."
echo "Writes are hidden by default. To enable transactions, also export GRAVITY_TOWN_ALLOW_WRITES=1"
