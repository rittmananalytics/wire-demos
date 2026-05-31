#!/usr/bin/env bash
# setup.sh — install all prereqs for the Wire demos.
# Idempotent: safe to re-run. Creates a local .venv/ with dbt-duckdb,
# installs optional rendering tools (bat, glow) if Homebrew is available,
# and offers to install the Wire plugin into Claude Code.

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

source "$SCRIPT_DIR/shared/narrator.sh"

section "Wire Demos — Setup"

FAIL=0

# ─────────────────────────────────────────────────────────────────────────
# 1. Python venv + Python dependencies
# ─────────────────────────────────────────────────────────────────────────

if ! command -v python3 >/dev/null 2>&1; then
  err "python3 not found. Install Python 3.11+ before running setup."
  exit 1
fi

PY_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
ok "python3 $PY_VERSION"

VENV_DIR="$SCRIPT_DIR/.venv"
if [ ! -d "$VENV_DIR" ]; then
  narrate "Creating local virtualenv at .venv/"
  python3 -m venv "$VENV_DIR" || { err "venv creation failed"; exit 1; }
  ok "Created .venv/"
else
  ok ".venv/ already exists"
fi

# Activate for the rest of the script
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

narrate "Upgrading pip in venv"
python -m pip install --quiet --upgrade pip || warn "pip upgrade had warnings (proceeding)"

narrate "Installing Python dependencies from requirements.txt"
if pip install --quiet -r "$SCRIPT_DIR/requirements.txt"; then
  ok "Python dependencies installed"
else
  err "pip install failed — see output above"
  FAIL=$((FAIL+1))
fi

# Verify dbt-duckdb
if dbt --version >/dev/null 2>&1; then
  DBT_V=$(dbt --version 2>&1 | grep -m1 -i 'core' || true)
  ok "dbt installed in venv  ${DBT_V}"
else
  err "dbt not callable from venv after install"
  FAIL=$((FAIL+1))
fi

deactivate 2>/dev/null || true

# ─────────────────────────────────────────────────────────────────────────
# 2. Optional rendering tools (bat, glow) via Homebrew
# ─────────────────────────────────────────────────────────────────────────

OS=$(uname -s)

install_brew_pkg() {
  local pkg="$1"
  if command -v "$pkg" >/dev/null 2>&1; then
    ok "$pkg already installed"
    return 0
  fi
  if command -v brew >/dev/null 2>&1; then
    narrate "Installing $pkg via Homebrew"
    if brew install "$pkg" >/dev/null 2>&1; then
      ok "$pkg installed"
    else
      warn "brew install $pkg failed (optional — demos still work)"
    fi
  else
    warn "$pkg not installed and Homebrew not available (optional — skipping)"
  fi
}

install_apt_pkg() {
  local pkg="$1"
  if command -v "$pkg" >/dev/null 2>&1; then
    ok "$pkg already installed"
    return 0
  fi
  if command -v apt-get >/dev/null 2>&1; then
    narrate "Installing $pkg via apt"
    if sudo apt-get install -y "$pkg" >/dev/null 2>&1; then
      ok "$pkg installed"
    else
      warn "apt install $pkg failed (optional — demos still work)"
    fi
  else
    warn "$pkg not installed and apt not available (optional — skipping)"
  fi
}

if [ "$OS" = "Darwin" ]; then
  install_brew_pkg bat
  install_brew_pkg glow
elif [ "$OS" = "Linux" ]; then
  install_apt_pkg bat
  install_apt_pkg glow
else
  warn "Unrecognised OS ($OS) — skipping optional render tools (bat, glow)"
fi

# ─────────────────────────────────────────────────────────────────────────
# 3. Claude Code presence + Wire plugin
# ─────────────────────────────────────────────────────────────────────────

if ! command -v claude >/dev/null 2>&1; then
  err "Claude Code is not installed.  Install it from https://docs.claude.com/en/docs/claude-code before running demos."
  FAIL=$((FAIL+1))
else
  CLAUDE_V=$(claude --version 2>&1 | head -n1)
  ok "claude  ($CLAUDE_V)"
fi

# Wire plugin — best-effort check (Claude Code stores plugins under ~/.claude/plugins/)
PLUGIN_CACHE_DIR="${HOME}/.claude/plugins/cache"
if [ -d "$PLUGIN_CACHE_DIR" ] && find "$PLUGIN_CACHE_DIR" -maxdepth 4 -type d -name "wire" 2>/dev/null | grep -q .; then
  ok "Wire plugin appears to be installed in Claude Code"
else
  warn "Wire plugin not detected in $PLUGIN_CACHE_DIR"
  narrate_long <<'EOF'
Demo 1 installs the Wire plugin as its first step, so this isn't required
for Demo 1. For Demos 2 and 3, install it manually in Claude Code:

    /plugin marketplace add rittmananalytics/wire-plugin
    /plugin install wire@rittman-analytics
    /reload-plugins
EOF
fi

# ─────────────────────────────────────────────────────────────────────────
# 4. Summary
# ─────────────────────────────────────────────────────────────────────────

echo ""
section "Setup Summary"
if [ $FAIL -eq 0 ]; then
  ok "Setup complete.  Run \`make doctor\` to verify, then \`make demo1\`."
  echo ""
  narrate "Tip: the runner activates .venv/ automatically when calling dbt."
  exit 0
else
  err "$FAIL required item(s) failed.  Fix the issues above and re-run \`./setup.sh\`."
  exit 1
fi
