#!/usr/bin/env bash
# Step 5 — Execute Wave 2a: 3 parallel staging agents.
# In live mode: spawns 3 claude -p processes in background and waits.
# In fast mode: shows progress snapshot then reveals pre-baked staging SQL.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

DEMO_DIR_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"

section "Step 5 / 7 — Wave 2a: 3 staging agents running in parallel"

narrate_long <<'EOF'
Wave 2a dispatches 3 dbt-developer agents simultaneously. Each gets a
task_scope list — a specific subset of staging models to generate. They
read the same upstream artifacts but write to different files, so there
is no conflict.

Batch assignment:
  [staging 1/3]  stg_shopify__orders, stg_shopify__order_items,
                 stg_shopify__customers, stg_shopify__products  (+seeds)
  [staging 2/3]  stg_shopify__refunds, stg_netsuite__transactions,
                 stg_netsuite__items, stg_netsuite__customers
  [staging 3/3]  stg_klaviyo__events, stg_klaviyo__campaigns, stg_ga4__sessions
EOF
pause

mkdir -p "$DEMO_DIR/dbt/models/staging/shopify" \
         "$DEMO_DIR/dbt/models/staging/netsuite" \
         "$DEMO_DIR/dbt/models/staging/klaviyo" \
         "$DEMO_DIR/dbt/models/staging/ga4"

RELEASE=01-peak-retail-analytics
DATA_MODEL_PATH=".wire/releases/$RELEASE/artifacts/data_model/data_model.md"
CONTEXT_PATH=".wire/engagement/context.md"

STAGING_BASE_PROMPT="You are the dbt-developer specialist agent for Wire Framework.
Release: $RELEASE
Read: $DATA_MODEL_PATH and $CONTEXT_PATH
You are running in fan-out mode — generate ONLY the models listed in task_scope below.
Follow Wire dbt conventions exactly:
  - Staging model filename: stg_<source>__<entity>.sql
  - CTE pattern: source → renamed (with _pk, _fk, _ts, _amount suffixes)
  - Write to: dbt/models/staging/<source>/stg_<source>__<entity>.sql
  - Write schema.yml alongside with description + unique+not_null tests on PK
Use {{ source('<source>', '<table>') }} for source references.
Do not generate integration or warehouse models.
After writing all files, output a summary: '✓ [staging N/3] complete — N models written'
"

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — showing progress snapshot, then pre-baking staging SQL)"
  echo ""
  cat "$SCRIPT_DIR/../snapshots/staging_wave_progress.txt" | sed 's/^/   │ /'
  echo ""

  # Write pre-baked staging models so later steps can run dbt build
  bash "$SCRIPT_DIR/../_bake_staging_models.sh" 2>/dev/null || true

else
  narrate "Launching 3 staging agents in parallel..."
  echo ""

  # Agent 1: Shopify orders/items/customers/products + seeds
  SCOPE1="stg_shopify__orders, stg_shopify__order_items, stg_shopify__customers, stg_shopify__products (also register channel_types and product_categories seeds in dbt_project.yml)"
  LOG1="$DEMO_LOG_DIR/staging-1-$(date +%s).log"
  claude -p "${STAGING_BASE_PROMPT}
task_scope: $SCOPE1
Agent label: dbt-developer [staging 1/3]" \
    "${__CLAUDE_MODEL_FLAG[@]}" \
    --permission-mode acceptEdits \
    --strict-mcp-config \
    --mcp-config "$WIRE_DEMOS_ROOT/shared/mcp-empty.json" \
    >"$LOG1" 2>&1 &
  PID1=$!
  narrate "  [staging 1/3] launched (pid $PID1)"

  # Agent 2: Shopify refunds + NetSuite
  SCOPE2="stg_shopify__refunds, stg_netsuite__transactions, stg_netsuite__items, stg_netsuite__customers"
  LOG2="$DEMO_LOG_DIR/staging-2-$(date +%s).log"
  claude -p "${STAGING_BASE_PROMPT}
task_scope: $SCOPE2
Agent label: dbt-developer [staging 2/3]" \
    "${__CLAUDE_MODEL_FLAG[@]}" \
    --permission-mode acceptEdits \
    --strict-mcp-config \
    --mcp-config "$WIRE_DEMOS_ROOT/shared/mcp-empty.json" \
    >"$LOG2" 2>&1 &
  PID2=$!
  narrate "  [staging 2/3] launched (pid $PID2)"

  # Agent 3: Klaviyo + GA4
  SCOPE3="stg_klaviyo__events, stg_klaviyo__campaigns, stg_ga4__sessions"
  LOG3="$DEMO_LOG_DIR/staging-3-$(date +%s).log"
  claude -p "${STAGING_BASE_PROMPT}
task_scope: $SCOPE3
Agent label: dbt-developer [staging 3/3]" \
    "${__CLAUDE_MODEL_FLAG[@]}" \
    --permission-mode acceptEdits \
    --strict-mcp-config \
    --mcp-config "$WIRE_DEMOS_ROOT/shared/mcp-empty.json" \
    >"$LOG3" 2>&1 &
  PID3=$!
  narrate "  [staging 3/3] launched (pid $PID3)"

  narrate ""
  narrate "All 3 staging agents running in parallel. Waiting for Wave 2a to complete..."

  # Wait for all three and collect exit codes
  RC1=0; RC2=0; RC3=0
  wait $PID1 || RC1=$?
  wait $PID2 || RC2=$?
  wait $PID3 || RC3=$?

  echo ""
  [ $RC1 -eq 0 ] && ok "[staging 1/3] complete" || err "[staging 1/3] failed (rc=$RC1) — see $LOG1"
  [ $RC2 -eq 0 ] && ok "[staging 2/3] complete" || err "[staging 2/3] failed (rc=$RC2) — see $LOG2"
  [ $RC3 -eq 0 ] && ok "[staging 3/3] complete" || err "[staging 3/3] failed (rc=$RC3) — see $LOG3"

  if [ $RC1 -ne 0 ] || [ $RC2 -ne 0 ] || [ $RC3 -ne 0 ]; then
    warn "One or more staging agents did not complete cleanly."
    warn "Check logs above. Continuing — integration wave will use whatever was written."
  fi
fi

# Show what was written
STAGING_COUNT=$(find "$DEMO_DIR/dbt/models/staging" -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
narrate "Staging wave complete. SQL files written: $STAGING_COUNT"
echo ""
find "$DEMO_DIR/dbt/models/staging" -name "*.sql" 2>/dev/null | sort | sed 's/^/   /'
echo ""
pause
