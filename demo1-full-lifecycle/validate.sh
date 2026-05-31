#!/usr/bin/env bash
# validate.sh — post-run validation for Demo 1.
# Structure-tolerant: checks existence + dbt run-results, not LLM-generated prose.

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
source "$REPO_ROOT/shared/narrator.sh"

section "Validating Demo 1"

FAIL=0

assert_file() {
  if [ -f "$1" ]; then ok "$1"; else err "missing: $1"; FAIL=$((FAIL+1)); fi
}

assert_dir() {
  if [ -d "$1" ] && [ -n "$(ls -A "$1" 2>/dev/null)" ]; then ok "$1 (non-empty)"; else err "missing or empty: $1"; FAIL=$((FAIL+1)); fi
}

# These checks become real once the demo steps land. For the scaffold the demo
# entry script exits before producing artifacts, so validate.sh is permissive.
if [ ! -d "$SCRIPT_DIR/.wire" ]; then
  warn "Scaffold mode — no .wire/ yet. Skipping artifact checks."
  exit 0
fi

assert_file "$SCRIPT_DIR/.wire/engagement/context.md"
assert_file "$SCRIPT_DIR/.wire/releases/01-data-foundation/status.md"
assert_file "$SCRIPT_DIR/.wire/releases/01-data-foundation/planning/delivery_playbook.md"
assert_dir  "$SCRIPT_DIR/.wire/releases/01-data-foundation/requirements"
assert_dir  "$SCRIPT_DIR/.wire/releases/01-data-foundation/design"
assert_dir  "$SCRIPT_DIR/dbt/models/staging"
assert_file "$SCRIPT_DIR/warehouse.duckdb"
assert_file "$SCRIPT_DIR/dashboards/mockup.html"

if [ -f "$SCRIPT_DIR/dbt/target/run_results.json" ]; then
  if grep -q '"status": "error"' "$SCRIPT_DIR/dbt/target/run_results.json"; then
    err "dbt run_results.json contains errors"
    FAIL=$((FAIL+1))
  else
    ok "dbt run_results.json clean"
  fi
fi

if [ $FAIL -eq 0 ]; then
  ok "Demo 1 validation passed"
  exit 0
else
  err "Demo 1 validation: $FAIL check(s) failed"
  exit 1
fi
