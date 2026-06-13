#!/usr/bin/env bash
# validate.sh — post-run checks for demo4.
# Called by: make validate
# Exit 0 = all checks pass. Exit 1 = at least one check failed.

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
DEMO_DIR="$SCRIPT_DIR"

source "$REPO_ROOT/shared/narrator.sh"

PASS=0; FAIL=0

check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    ok "$label"
    PASS=$(( PASS + 1 ))
  else
    err "$label"
    FAIL=$(( FAIL + 1 ))
  fi
}

section "validate: demo4-wire-agents"

# Pre-seeded Wire artifacts exist
check "seed: .wire/engagement/context.md" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/.wire/engagement/context.md"
check "seed: status.md (design approved)" \
  grep -q "review: approved" "$REPO_ROOT/_seeds/demo4-wire-agents/.wire/releases/01-peak-retail-analytics/status.md"
check "seed: requirements.md" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/.wire/releases/01-peak-retail-analytics/artifacts/requirements/requirements.md"
check "seed: data_model.md" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/.wire/releases/01-peak-retail-analytics/artifacts/data_model/data_model.md"

# dbt project seed files
check "seed: dbt/dbt_project.yml" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/dbt/dbt_project.yml"
check "seed: dbt/models/_sources.yml" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/dbt/models/_sources.yml"
check "seed: shopify_orders.csv" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/dbt/seeds/shopify_orders.csv"
check "seed: ga4_sessions.csv" \
  test -f "$REPO_ROOT/_seeds/demo4-wire-agents/dbt/seeds/ga4_sessions.csv"

# Snapshot files for fast mode
check "snapshot: delegate_plan.txt" \
  test -f "$DEMO_DIR/snapshots/delegate_plan.txt"
check "snapshot: staging wave shows 3 parallel agents" \
  grep -q "staging 3/3" "$DEMO_DIR/snapshots/delegate_plan.txt"
check "snapshot: shows fan-out total of 6 agents" \
  grep -q "Total dbt-developer agents: 6" "$DEMO_DIR/snapshots/delegate_plan.txt"

# Step scripts exist and are executable
for n in 01 02 03 04 05 06 07; do
  check "step: ${n}*.sh exists" ls "$DEMO_DIR/steps/${n}"*.sh
done

# Source CSV rows are non-trivial
check "csv: shopify_orders has >10 rows" \
  bash -c "[ \$(wc -l < '$REPO_ROOT/_seeds/demo4-wire-agents/dbt/seeds/shopify_orders.csv') -gt 10 ]"
check "csv: klaviyo_events has >5 rows" \
  bash -c "[ \$(wc -l < '$REPO_ROOT/_seeds/demo4-wire-agents/dbt/seeds/klaviyo_events.csv') -gt 5 ]"

echo ""
printf "Results: ${PASS} passed, ${FAIL} failed\n"

if [ $FAIL -gt 0 ]; then
  exit 1
fi
exit 0
