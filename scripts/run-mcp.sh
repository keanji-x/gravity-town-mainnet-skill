#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "${PRIVATE_KEY:-}" ]]; then
  if [[ -z "${GRAVITY_TOWN_PRIVATE_KEY:-}" ]]; then
    echo "GRAVITY_TOWN_PRIVATE_KEY is required" >&2
    exit 1
  fi
  export PRIVATE_KEY="$GRAVITY_TOWN_PRIVATE_KEY"
fi

export RPC_URL="${RPC_URL:-https://mainnet-rpc.gravity.xyz}"
export ROUTER_ADDRESS="${ROUTER_ADDRESS:-0x4c2F6C0BAd768A75a67949b35feb094BAC4De03a}"
export CHAIN_ID="${CHAIN_ID:-127001}"
export GRAVITY_TOWN_ALLOW_WRITES="${GRAVITY_TOWN_ALLOW_WRITES:-}"
export GRAVITY_TOWN_READONLY="${GRAVITY_TOWN_READONLY:-}"

if [[ ! -f "$ROOT/mcp/dist/index.js" ]]; then
  echo "MCP server is not built. Run: cd $ROOT && npm install && npm run build" >&2
  exit 1
fi

exec node "$ROOT/mcp/dist/index.js"
