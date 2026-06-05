#!/usr/bin/env node
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { mkdirSync } from "node:fs";

const [marketplacePathArg, pluginName] = process.argv.slice(2);

if (!marketplacePathArg || !pluginName) {
  console.error("Usage: update-marketplace.mjs <marketplace.json> <plugin-name>");
  process.exit(1);
}

const marketplacePath = resolve(marketplacePathArg);
mkdirSync(dirname(marketplacePath), { recursive: true });

const marketplace = existsSync(marketplacePath)
  ? JSON.parse(readFileSync(marketplacePath, "utf8"))
  : {
      name: "personal",
      interface: { displayName: "Personal" },
      plugins: [],
    };

if (!marketplace.name) marketplace.name = "personal";
if (!marketplace.interface) marketplace.interface = { displayName: "Personal" };
if (!Array.isArray(marketplace.plugins)) marketplace.plugins = [];

const entry = {
  name: pluginName,
  source: {
    source: "local",
    path: `./plugins/${pluginName}`,
  },
  policy: {
    installation: "AVAILABLE",
    authentication: "ON_INSTALL",
  },
  category: "Developer",
};

const idx = marketplace.plugins.findIndex((plugin) => plugin?.name === pluginName);
if (idx >= 0) {
  marketplace.plugins[idx] = entry;
} else {
  marketplace.plugins.push(entry);
}

writeFileSync(marketplacePath, `${JSON.stringify(marketplace, null, 2)}\n`);
