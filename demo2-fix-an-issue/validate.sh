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

# After Demo 2 runs, fct_orders.sql should reference customer_fk (not customer_id)
if grep -q "customer_fk" "$SCRIPT_DIR/dbt/models/warehouse/fct_orders.sql" 2>/dev/null; then
  ok "fct_orders.sql uses customer_fk (Fault A fixed)"
else
  err "fct_orders.sql still uses customer_id — fix didn't land"
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
