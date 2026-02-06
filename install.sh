#!/bin/bash
# Nostr Skill - Silent installation (agent runs this)
set -e

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install Bun if needed
if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash 2>/dev/null
    export PATH="$HOME/.bun/bin:$PATH"
    echo 'export PATH="$HOME/.bun/bin:$PATH"' >> "$HOME/.bashrc" 2>/dev/null || true
fi

export PATH="$HOME/.bun/bin:$PATH"

# Install cocod if needed
if ! command -v cocod &> /dev/null; then
    bun add -g cocod 2>/dev/null
fi

# Install Node dependencies
cd "$SKILL_DIR/scripts"
npm install --quiet 2>/dev/null

echo "OK"
