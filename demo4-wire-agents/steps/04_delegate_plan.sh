#!/usr/bin/env bash
# Step 4 — Run /wire:delegate and show the fan-out plan.
# This is the centrepiece of the demo: the plan shows 6 dbt-developer agents
# across 3 sequential layer waves.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 4 / 7 — /wire:delegate: the fan-out plan"

narrate_long <<'EOF'
/wire:delegate reads status.md, identifies pending work, and computes the
execution plan. With 11 staging models and 9 warehouse models, the plan
fans out into parallel batches within each layer.

Staging (11 models) exceeds the 5-model threshold → 3 agents of 4/4/3
Warehouse (9 models) exceeds the threshold         → 2 agents of 5/4
Integration (3 models) is below the threshold      → 1 agent, no fan-out

Total dbt-developer agents: 6  (3 staging + 1 integration + 2 warehouse)
EOF
pause

show_command "/wire:delegate 01-peak-retail-analytics"

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — showing pre-rendered delegation plan)"
  echo ""
  cat "$SCRIPT_DIR/../snapshots/delegate_plan.txt" | sed 's/^/   │ /'
  echo ""
else
  narrate_long <<'EOF'
Running live. Wire will read status.md and compute the plan.
We pass 'yes' to auto-confirm so the demo doesn't pause for input.
In a real engagement you review and adjust the plan before confirming.
EOF
  run_wire "/wire:delegate 01-peak-retail-analytics

When you present the delegation plan, confirm it automatically — the demo operator approves.
Show the full plan including the multi-wave fan-out for the dbt-developer step.
After showing the plan, say 'Plan confirmed — proceeding with dispatch' then STOP.
Do not actually spawn subagents — the demo will execute the waves in the next steps."
fi

narrate_long <<'EOF'
The fan-out plan is the key thing to notice:
  - 3 staging agents run in parallel (Wave 2a)
  - 1 integration agent follows once all staging agents finish (Wave 2b)
  - 2 warehouse agents run in parallel after integration (Wave 2c)

The dependency chain is preserved. Models in the same layer are independent
of each other — they reference the same upstream sources but write different
output files, so there's no conflict.
EOF
pause
