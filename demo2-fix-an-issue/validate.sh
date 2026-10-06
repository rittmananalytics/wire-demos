#!/usr/bin/env bash
# validate.sh — post-run validation for Demo 2.

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
source "$REPO_ROOT/shared/narrator.sh"

section "Validating Demo 2"

if [ ! -d "$SCRIPT_DIR/.wire" ]; then
  warn "Scaffold mode — no .wire/ yet. Skipping artifact checks."
  exit 0
fi

FAIL=0

# After Demo 2 runs, the order fact's entry in schema.yml should list customer_fk
if sed -n '/name: wh_core__order_fact/,$p' "$SCRIPT_DIR/dbt/models/schema.yml" 2>/dev/null | grep -q "name: customer_fk"; then
  ok "schema.yml documents and tests wh_core__order_fact.customer_fk (fault fixed)"
else
  err "schema.yml still has no customer_fk entry for wh_core__order_fact — fix didn't land"
  FAIL=$((FAIL+1))
fi

if [ -f "$SCRIPT_DIR/dbt/target/run_results.json" ]; then
  if grep -q '"status": "error"' "$SCRIPT_DIR/dbt/target/run_results.json"; then
    err "dbt run failed"
    FAIL=$((FAIL+1))
  else
    ok "dbt run clean"
  fi
fi

[ $FAIL -eq 0 ] && { ok "Demo 2 validation passed"; exit 0; } || { err "$FAIL check(s) failed"; exit 1; }
