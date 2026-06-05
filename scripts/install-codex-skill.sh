#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${CODEX_HOME:-$HOME/.codex}/skills/gravity-town-mainnet"

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
mkdir -p "$DEST"

cp "$ROOT/SKILL.md" "$DEST/SKILL.md"
mkdir -p "$DEST/agents"
cp "$ROOT/agents/openai.yaml" "$DEST/agents/openai.yaml"

echo "Installed Codex skill to $DEST"
echo "Restart Codex to pick up the skill."
echo "MCP tools still need configuration; use install-codex-plugin.sh for skill + MCP together."
