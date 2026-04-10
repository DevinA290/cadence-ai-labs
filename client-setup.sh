#!/usr/bin/env bash
# client-setup.sh — Cadence AI Labs client onboarding script
# Version: 1.0.0
# Date: 2026-04-10

set -e

# ── Helpers ──────────────────────────────────────────────────────────────────

print_header() {
  echo ""
  echo "╔══════════════════════════════════════════╗"
  echo "║   🤖 Cadence AI Labs — Agent Setup       ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
}

# Ensure Homebrew is on PATH for Apple Silicon (/opt/homebrew) and Intel (/usr/local)
setup_brew_path() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# ── 1. Welcome ────────────────────────────────────────────────────────────────

print_header

# ── 2. Homebrew ───────────────────────────────────────────────────────────────

setup_brew_path

if command -v brew &>/dev/null; then
  echo "✓ Homebrew already installed"
else
  echo "⏳ Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  setup_brew_path
  echo "✓ Homebrew installed"
fi

# ── 3. Node.js v18+ ───────────────────────────────────────────────────────────

if command -v node &>/dev/null; then
  NODE_MAJOR=$(node -e "process.stdout.write(String(process.versions.node.split('.')[0]))")
  if [[ "$NODE_MAJOR" -ge 18 ]]; then
    echo "✓ Node.js already installed ($(node --version))"
  else
    echo "⏳ Node.js version too old ($NODE_MAJOR), upgrading via Homebrew..."
    brew install node
    echo "✓ Node.js installed ($(node --version))"
  fi
else
  echo "⏳ Installing Node.js..."
  brew install node
  echo "✓ Node.js installed ($(node --version))"
fi

# ── 4. OpenClaw ───────────────────────────────────────────────────────────────

if command -v openclaw &>/dev/null; then
  echo "✓ OpenClaw already installed ($(openclaw --version 2>/dev/null || echo 'version unknown'))"
else
  echo "⏳ Installing OpenClaw..."
  npm install -g openclaw
  echo "✓ OpenClaw installed"
fi

# ── 5. Workspace directory ────────────────────────────────────────────────────

echo "⏳ Creating workspace directory..."
mkdir -p ~/.openclaw/workspace
echo "✓ Workspace ready at ~/.openclaw/workspace"

# ── 6. Base config files ──────────────────────────────────────────────────────

BASE_URL="https://raw.githubusercontent.com/DevinA290/cadence-ai-labs/main/client-configs"
WORKSPACE="$HOME/.openclaw/workspace"

for config in AGENTS.md SOUL.md HEARTBEAT.md; do
  echo "⏳ Downloading $config..."
  if curl -fsSL "$BASE_URL/$config" -o "$WORKSPACE/$config"; then
    echo "✓ $config saved"
  else
    echo "❌ Failed to download $config" >&2
    exit 1
  fi
done

# ── 7. Start gateway ──────────────────────────────────────────────────────────

echo "⏳ Starting OpenClaw gateway..."
openclaw gateway start
sleep 3
echo "⏳ Checking status..."
openclaw status
echo "✓ Gateway is running"

# ── 8. Done ───────────────────────────────────────────────────────────────────

echo ""
echo "✅ Setup complete! Your agent software is installed and running."
echo "   Next step: Let Devin know you're ready — he'll connect your agent to Slack."
echo ""
