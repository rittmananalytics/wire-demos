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
check_cmd dbt      "Install dbt-duckdb: pip install dbt-duckdb"
check_cmd bash     "Run on macOS or Linux with bash 4+"

check_cmd_optional gh    "Install gh for repo operations: https://cli.github.com"
check_cmd_optional bat   "Install bat for prettier file rendering: brew install bat"
check_cmd_optional glow  "Install glow for markdown rendering: brew install glow"

# Wire plugin presence — best-effort check
if command -v claude >/dev/null 2>&1; then
  if claude -p "/help" 2>&1 | grep -qi "wire:" ; then
    ok "Wire plugin appears to be installed in Claude Code"
  else
    warn "Wire plugin not detected. Demo 1 will install it; for Demos 2 and 3 it must be present."
    WARN=$((WARN+1))
  fi
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
