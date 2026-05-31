#!/usr/bin/env bash
# doctor.sh — verify prereqs before running any demo.
# Exits 0 if everything is in place, 1 otherwise. Always prints a report.

set -uo pipefail

# Locate ourselves
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/shared/narrator.sh"

FAIL=0
WARN=0

section "Wire Demos — Doctor"

check_cmd() {
  local cmd="$1"
  local hint="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    local version
    version="$($cmd --version 2>&1 | head -n1 || echo 'unknown')"
    ok "$cmd  ($version)"
  else
    err "$cmd  — not found.  $hint"
    FAIL=$((FAIL+1))
  fi
}

check_cmd_optional() {
  local cmd="$1"
  local hint="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd  (optional, found)"
  else
    warn "$cmd  — not found (optional).  $hint"
    WARN=$((WARN+1))
  fi
}

check_cmd claude   "Install Claude Code: https://docs.claude.com/en/docs/claude-code"
check_cmd python3  "Install Python 3.11+"
check_cmd bash     "Run on macOS or Linux with bash 4+"

check_cmd_optional gh    "Install gh for repo operations: https://cli.github.com"
check_cmd_optional bat   "Install bat for prettier file rendering: brew install bat (run \`./setup.sh\`)"
check_cmd_optional glow  "Install glow for markdown rendering: brew install glow (run \`./setup.sh\`)"

# dbt — check venv first, then system
VENV_DBT="$SCRIPT_DIR/.venv/bin/dbt"
if [ -x "$VENV_DBT" ]; then
  DBT_V=$("$VENV_DBT" --version 2>&1 | grep -m1 -i 'core' || echo "unknown")
  ok "dbt  (venv: $DBT_V)"
elif command -v dbt >/dev/null 2>&1; then
  DBT_V=$(dbt --version 2>&1 | grep -m1 -i 'core' || echo "unknown")
  ok "dbt  (system: $DBT_V)"
  warn "dbt is installed system-wide rather than in .venv/.  Run \`./setup.sh\` to set up the recommended local venv."
  WARN=$((WARN+1))
else
  err "dbt — not found.  Run \`./setup.sh\` to install dbt-duckdb into a local venv."
  FAIL=$((FAIL+1))
fi

# Wire plugin presence — file-system check (more reliable than greping /help)
PLUGIN_CACHE_DIR="${HOME}/.claude/plugins/cache"
if [ -d "$PLUGIN_CACHE_DIR" ] && find "$PLUGIN_CACHE_DIR" -maxdepth 4 -type d -name "wire" 2>/dev/null | grep -q .; then
  ok "Wire plugin found in $PLUGIN_CACHE_DIR"
else
  warn "Wire plugin not detected in $PLUGIN_CACHE_DIR.  Demo 1 will install it; Demos 2 and 3 require it pre-installed."
  WARN=$((WARN+1))
fi

echo ""
section "Summary"
if [ $FAIL -eq 0 ]; then
  ok "All required tools present.  $WARN optional warnings."
  exit 0
else
  err "$FAIL required tool(s) missing.  Fix the items above and re-run \`make doctor\`."
  exit 1
fi
