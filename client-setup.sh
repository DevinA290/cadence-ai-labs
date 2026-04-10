#!/usr/bin/env bash
# client-setup.sh — Cadence AI Labs client onboarding script
# Version: 1.2.0
# Date: 2026-04-10

set -e

# ── Helpers ───────────────────────────────────────────────────────────────────

print_header() {
  echo ""
  echo "╔══════════════════════════════════════════╗"
  echo "║   🤖 Cadence AI Labs — Agent Setup       ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
}

setup_brew_path() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# ── 1. Welcome ────────────────────────────────────────────────────────────────

print_header

# ── 2. Check for Xcode Command Line Tools ─────────────────────────────────────

if ! xcode-select -p &>/dev/null; then
  echo ""
  echo "⚠️  One more step before we can continue."
  echo ""
  echo "   Your Mac needs 'Command Line Tools' installed."
  echo "   A pop-up window should appear asking you to install them."
  echo "   Click 'Install' and wait for it to finish (takes a few minutes)."
  echo ""
  echo "   If no pop-up appears, run this command:"
  echo "   xcode-select --install"
  echo ""
  echo "   Once the install finishes, re-run this setup command:"
  echo "   curl -fsSL https://raw.githubusercontent.com/DevinA290/cadence-ai-labs/main/client-setup.sh | bash"
  echo ""
  xcode-select --install 2>/dev/null || true
  exit 0
fi

echo "✓ Command Line Tools ready"

# ── 3. Homebrew ───────────────────────────────────────────────────────────────

setup_brew_path

if command -v brew &>/dev/null; then
  echo "✓ Homebrew already installed"
else
  echo ""
  echo "⏳ Installing Homebrew (you may be asked for your Mac password)..."
  echo ""
  echo "   ┌─────────────────────────────────────────────────────────┐"
  echo "   │  💡 PASSWORD TIP: When you type your password, nothing  │"
  echo "   │  will appear on screen — no dots, no stars. That's      │"
  echo "   │  normal and secure. Just type it and press Enter.        │"
  echo "   └─────────────────────────────────────────────────────────┘"
  echo ""
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  setup_brew_path
  echo "✓ Homebrew installed"
fi

# ── 4. Node.js v18+ ───────────────────────────────────────────────────────────

if command -v node &>/dev/null; then
  NODE_MAJOR=$(node -e "process.stdout.write(String(process.versions.node.split('.')[0]))")
  if [[ "$NODE_MAJOR" -ge 18 ]]; then
    echo "✓ Node.js already installed ($(node --version))"
  else
    echo "⏳ Upgrading Node.js..."
    brew install node
    echo "✓ Node.js upgraded ($(node --version))"
  fi
else
  echo "⏳ Installing Node.js..."
  brew install node
  echo "✓ Node.js installed ($(node --version))"
fi

# ── 5. OpenClaw ───────────────────────────────────────────────────────────────

if command -v openclaw &>/dev/null; then
  echo "✓ OpenClaw already installed ($(openclaw --version 2>/dev/null || echo 'version unknown'))"
else
  echo "⏳ Installing OpenClaw..."
  npm install -g openclaw
  echo "✓ OpenClaw installed"
fi

# ── 6. Workspace directory ────────────────────────────────────────────────────

mkdir -p ~/.openclaw/workspace
echo "✓ Workspace ready"

# ── 7. Base config files ──────────────────────────────────────────────────────

BASE_URL="https://raw.githubusercontent.com/DevinA290/cadence-ai-labs/main/client-configs"
WORKSPACE="$HOME/.openclaw/workspace"

for config in AGENTS.md SOUL.md HEARTBEAT.md; do
  if curl -fsSL "$BASE_URL/$config" -o "$WORKSPACE/$config"; then
    echo "✓ $config downloaded"
  else
    echo "❌ Failed to download $config" >&2
    exit 1
  fi
done

# ── 8. Install gateway as LaunchAgent (auto-start on login/reboot) ───────────

echo "⏳ Installing agent to start automatically on login..."
openclaw gateway install 2>/dev/null || true
echo "✓ Agent will start automatically when your Mac starts"

# ── 9. Start gateway now ──────────────────────────────────────────────────────

echo "⏳ Starting your agent..."
openclaw gateway start 2>/dev/null || true
sleep 3
openclaw status 2>/dev/null || true
echo "✓ Agent is running"

# ── 10. Watchdog cron (auto-restart if Slack connection dies) ─────────────────

echo "⏳ Setting up connection watchdog..."
openclaw cron add \
  --name "agent-watchdog" \
  --every 30m \
  --description "Restart gateway if Slack connection has gone silent" \
  --system-event "Check if the agent is healthy by running: openclaw status. If the gateway is not running or sessions show no recent activity, run: openclaw gateway restart. Then reply HEARTBEAT_OK." \
  2>/dev/null || true
echo "✓ Watchdog active — agent will self-heal if connection drops"

# ── 11. Done ──────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ✅ Setup complete! Your agent software is installed.        ║"
echo "║                                                              ║"
echo "║  Next step: Let Devin know you're ready.                     ║"
echo "║  He'll connect your agent to Slack — about 20 min.           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
