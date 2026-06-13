#!/usr/bin/env bash
# Step 7 — Show results: model count, dbt seed + build, decisions.md.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

RELEASE=01-peak-retail-analytics

section "Step 7 / 7 — Results: 6 agents, 23 models, dbt build"

narrate_long <<'EOF'
6 dbt-developer agents ran across 3 sequential waves. Let's count what
they produced, check decisions.md, and run dbt seed + build to confirm
the warehouse is clean.
EOF
pause

# ── Model count ───────────────────────────────────────────────────────────────
STAGING_COUNT=$(find "$DEMO_DIR/dbt/models/staging"     -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
INT_COUNT=$(    find "$DEMO_DIR/dbt/models/integration"  -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
WH_COUNT=$(     find "$DEMO_DIR/dbt/models/warehouse"    -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
TOTAL=$(( STAGING_COUNT + INT_COUNT + WH_COUNT ))

narrate "Model inventory:"
echo ""
printf "   Staging models:      %s\n" "$STAGING_COUNT"
printf "   Integration models:  %s\n" "$INT_COUNT"
printf "   Warehouse models:    %s\n" "$WH_COUNT"
printf "   ──────────────────────────\n"
printf "   Total:               %s\n" "$TOTAL"
echo ""

if [ "$TOTAL" -ge 20 ]; then
  ok "All 23 expected models written (or close to it)"
else
  warn "Fewer models than expected — some agents may not have completed cleanly"
fi
pause

# ── decisions.md ──────────────────────────────────────────────────────────────
narrate "decisions.md — entries appended by each wave:"
echo ""
if [ -f "$DEMO_DIR/.wire/releases/$RELEASE/decisions.md" ]; then
  show_file "$DEMO_DIR/.wire/releases/$RELEASE/decisions.md"
else
  warn "decisions.md not found at expected path"
fi
pause

# ── dbt seed + build ──────────────────────────────────────────────────────────
narrate_long <<'EOF'
Running dbt seed (loads CSVs into DuckDB) then dbt build (compile + run + test).
A clean build proves the generated models are syntactically valid and that all
foreign key refs resolve.
EOF
pause

show_command "dbt seed --profiles-dir ../../shared/profiles --project-dir dbt/"
cd "$DEMO_DIR"
if dbt seed --profiles-dir "$WIRE_DEMOS_ROOT/shared/profiles" --project-dir dbt/ 2>&1 | tee "$DEMO_LOG_DIR/dbt-seed-$(date +%s).log" | tail -5; then
  ok "dbt seed complete"
else
  warn "dbt seed had warnings — check the log"
fi
echo ""

show_command "dbt build --profiles-dir ../../shared/profiles --project-dir dbt/"
if dbt build --profiles-dir "$WIRE_DEMOS_ROOT/shared/profiles" --project-dir dbt/ 2>&1 | tee "$DEMO_LOG_DIR/dbt-build-$(date +%s).log" | tail -20; then
  ok "dbt build passed — warehouse is clean"
else
  warn "dbt build had failures — check the log for detail"
fi

pause

narrate_long <<'EOF'
Summary:
  - 6 dbt-developer agents ran: 3 parallel in staging, 1 in integration, 2 parallel in warehouse
  - Each agent worked from the same upstream artifacts but generated independent model files
  - decisions.md captured non-obvious choices from each wave
  - dbt build confirmed the output is structurally correct against the DuckDB seed data

Next: /wire:semantic_layer-generate → auto-delegates to semantic-layer-developer agent
      /wire:orchestration-generate  → auto-delegates to orchestration-engineer agent
EOF
