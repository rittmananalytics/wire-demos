#!/usr/bin/env bash
# Step 6 — Wave 2b (integration, 1 agent) then Wave 2c (warehouse, 2 parallel agents).

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

DEMO_DIR_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
RELEASE=01-peak-retail-analytics

mkdir -p "$DEMO_DIR/dbt/models/integration" \
         "$DEMO_DIR/dbt/models/warehouse"

# ── Wave 2b: Integration ──────────────────────────────────────────────────────

section "Step 6a — Wave 2b: integration layer (1 agent)"

narrate_long <<'EOF'
Integration models depend on staging — Wave 2b can only start once all
three staging agents from Wave 2a have completed. There are 3 integration
models, which is below the 5-model fan-out threshold, so a single agent
handles them all.
EOF
pause

INT_PROMPT="You are the dbt-developer specialist agent for Wire Framework.
Release: $RELEASE
Read: .wire/releases/$RELEASE/artifacts/data_model/data_model.md
      .wire/releases/$RELEASE/artifacts/conceptual_model/conceptual_model.md
      .wire/releases/$RELEASE/decisions.md
Generate ONLY the integration models listed in task_scope.
Wire conventions:
  - Integration model filename: int__<name>.sql
  - Use {{ ref() }} for staging model references
  - Write to: dbt/models/integration/int__<name>.sql
  - Write schema.yml with descriptions and tests
task_scope: int__customer_unified, int__order_financial, int__marketing_attribution
After writing, output: '✓ [integration 1/1] complete — 3 models written'"

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — pre-baking integration models)"
  bash "$SCRIPT_DIR/../_bake_integration_models.sh" 2>/dev/null || true
  ok "[integration 1/1] complete  — 3 models written"
else
  show_command "dbt-developer [integration 1/1] → int__customer_unified, int__order_financial, int__marketing_attribution"
  LOG_INT="$DEMO_LOG_DIR/integration-1-$(date +%s).log"
  if claude -p "$INT_PROMPT" \
      "${__CLAUDE_MODEL_FLAG[@]}" \
      --permission-mode acceptEdits \
      --strict-mcp-config \
      --mcp-config "$WIRE_DEMOS_ROOT/shared/mcp-empty.json" \
      >"$LOG_INT" 2>&1; then
    ok "[integration 1/1] complete"
    tail -n 5 "$LOG_INT" | sed 's/^/   │ /'
  else
    err "[integration 1/1] failed — see $LOG_INT"
  fi
fi

INT_COUNT=$(find "$DEMO_DIR/dbt/models/integration" -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
narrate "Integration wave complete. Models written: $INT_COUNT"
pause

# ── Wave 2c: Warehouse ────────────────────────────────────────────────────────

section "Step 6b — Wave 2c: warehouse layer (2 parallel agents)"

narrate_long <<'EOF'
9 warehouse models exceed the 5-model threshold → 2 parallel agents.
Both agents depend on the integration layer completing first.

  [warehouse 1/2]  customer_dim, product_dim, channel_dim, orders_fct, order_items_fct
  [warehouse 2/2]  daily_revenue_fct, email_performance_fct, marketing_spend_fct, customer_ltv_fct
EOF
pause

WH_BASE="You are the dbt-developer specialist agent for Wire Framework.
Release: $RELEASE
Read: .wire/releases/$RELEASE/artifacts/data_model/data_model.md
      .wire/releases/$RELEASE/artifacts/conceptual_model/conceptual_model.md
      .wire/releases/$RELEASE/decisions.md
Generate ONLY the warehouse models listed in task_scope.
Wire conventions:
  - Dimension filenames: <entity>_dim.sql  (materialised: table)
  - Fact filenames:      <entity>_fct.sql  (materialised: incremental, strategy: merge)
  - PKs via dbt_utils.generate_surrogate_key(); _pk suffix
  - Use {{ ref() }} for all upstream references
  - Write to: dbt/models/warehouse/<model>.sql
  - Write schema.yml with descriptions, unique+not_null tests on all PKs"

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — pre-baking warehouse models)"
  bash "$SCRIPT_DIR/../_bake_warehouse_models.sh" 2>/dev/null || true
  echo ""
  ok "[warehouse 1/2] complete  — customer_dim, product_dim, channel_dim, orders_fct, order_items_fct"
  ok "[warehouse 2/2] complete  — daily_revenue_fct, email_performance_fct, marketing_spend_fct, customer_ltv_fct"
else
  narrate "Launching 2 warehouse agents in parallel..."

  SCOPE_WH1="customer_dim, product_dim, channel_dim, orders_fct, order_items_fct"
  LOG_WH1="$DEMO_LOG_DIR/warehouse-1-$(date +%s).log"
  claude -p "${WH_BASE}
task_scope: $SCOPE_WH1
Agent label: dbt-developer [warehouse 1/2]" \
    "${__CLAUDE_MODEL_FLAG[@]}" \
    --permission-mode acceptEdits \
    --strict-mcp-config \
    --mcp-config "$WIRE_DEMOS_ROOT/shared/mcp-empty.json" \
    >"$LOG_WH1" 2>&1 &
  PID_WH1=$!
  narrate "  [warehouse 1/2] launched (pid $PID_WH1)"

  SCOPE_WH2="daily_revenue_fct, email_performance_fct, marketing_spend_fct, customer_ltv_fct"
  LOG_WH2="$DEMO_LOG_DIR/warehouse-2-$(date +%s).log"
  claude -p "${WH_BASE}
task_scope: $SCOPE_WH2
Agent label: dbt-developer [warehouse 2/2]" \
    "${__CLAUDE_MODEL_FLAG[@]}" \
    --permission-mode acceptEdits \
    --strict-mcp-config \
    --mcp-config "$WIRE_DEMOS_ROOT/shared/mcp-empty.json" \
    >"$LOG_WH2" 2>&1 &
  PID_WH2=$!
  narrate "  [warehouse 2/2] launched (pid $PID_WH2)"

  narrate "Waiting for both warehouse agents to complete..."
  RC_WH1=0; RC_WH2=0
  wait $PID_WH1 || RC_WH1=$?
  wait $PID_WH2 || RC_WH2=$?

  echo ""
  [ $RC_WH1 -eq 0 ] && ok "[warehouse 1/2] complete" || err "[warehouse 1/2] failed (rc=$RC_WH1)"
  [ $RC_WH2 -eq 0 ] && ok "[warehouse 2/2] complete" || err "[warehouse 2/2] failed (rc=$RC_WH2)"
fi

WH_COUNT=$(find "$DEMO_DIR/dbt/models/warehouse" -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
narrate "Warehouse wave complete. Models written: $WH_COUNT"
echo ""
find "$DEMO_DIR/dbt/models/warehouse" -name "*.sql" 2>/dev/null | sort | sed 's/^/   /'
echo ""
pause
