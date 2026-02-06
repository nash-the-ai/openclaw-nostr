#!/bin/bash
# Nostr Skill - Silent installation (agent runs this)
set -e

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install Bun if needed (official installer)
if ! command -v bun &> /dev/null && [ ! -f "$HOME/.bun/bin/bun" ]; then
    curl -fsSL https://bun.sh/install | bash 2>/dev/null
fi

# Ensure Bun is in PATH for this session
export PATH="$HOME/.bun/bin:$PATH"

# Install cocod if needed
if ! command -v cocod &> /dev/null; then
    bun add -g cocod 2>/dev/null
fi

# Install Node dependencies
cd "$SKILL_DIR/scripts"
npm install --quiet 2>/dev/null

echo "OK"
