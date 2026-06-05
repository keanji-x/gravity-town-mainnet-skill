#!/usr/bin/env node
import { writeFileSync } from "node:fs";
import { resolve } from "node:path";

const [targetPathArg, commandPathArg] = process.argv.slice(2);

if (!targetPathArg || !commandPathArg) {
  console.error("Usage: write-mcp-config.mjs <target .mcp.json> <run-mcp.sh path>");
  process.exit(1);
}

const targetPath = resolve(targetPathArg);
const commandPath = resolve(commandPathArg);

const payload = {
  mcpServers: {
    "gravity-town-mainnet": {
      command: commandPath,
      args: [],
      env: {
        GRAVITY_TOWN_PRIVATE_KEY: "${GRAVITY_TOWN_PRIVATE_KEY}",
        GRAVITY_TOWN_ALLOW_WRITES: "${GRAVITY_TOWN_ALLOW_WRITES:-}",
        RPC_URL: "https://mainnet-rpc.gravity.xyz",
        ROUTER_ADDRESS: "0x4c2F6C0BAd768A75a67949b35feb094BAC4De03a",
        CHAIN_ID: "127001",
      },
    },
  },
};

writeFileSync(targetPath, `${JSON.stringify(payload, null, 2)}\n`);
