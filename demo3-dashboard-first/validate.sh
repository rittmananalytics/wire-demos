#!/usr/bin/env bash
# validate.sh — post-run validation for Demo 3.

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
source "$REPO_ROOT/shared/narrator.sh"

section "Validating Demo 3"

if [ ! -d "$SCRIPT_DIR/.wire" ]; then
  warn "Scaffold mode — no .wire/ yet. Skipping artifact checks."
  exit 0
fi

FAIL=0

assert_file() {
  [ -f "$1" ] && ok "$1" || { err "missing: $1"; FAIL=$((FAIL+1)); }
}

assert_file "$SCRIPT_DIR/dashboards/mockup.html"
assert_file "$SCRIPT_DIR/dashboards/v1.html"
assert_file "$SCRIPT_DIR/dashboards/v2.html"
assert_file "$SCRIPT_DIR/.wire/releases/01-revenue-dashboards/design/viz_catalog.md"
assert_file "$SCRIPT_DIR/.wire/releases/01-revenue-dashboards/design/data_refactor_mapping.md"

[ $FAIL -eq 0 ] && { ok "Demo 3 validation passed"; exit 0; } || { err "$FAIL check(s) failed"; exit 1; }
