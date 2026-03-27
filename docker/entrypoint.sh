#!/bin/sh
set -e

# Fix volume ownership (may be root-owned from prior deploys)
chown -R node:node /paperclip 2>/dev/null || true

# Seed Codex auth from env var (ChatGPT Pro subscription, $0 cost)
if [ -n "$CODEX_AUTH_JSON" ]; then
  mkdir -p /paperclip/.codex
  echo "$CODEX_AUTH_JSON" > /paperclip/.codex/auth.json
  echo "[entrypoint] Seeded Codex auth.json"
fi

# Drop to node user for the server (Claude Code refuses root)
exec gosu node node --import ./server/node_modules/tsx/dist/loader.mjs server/dist/index.js
