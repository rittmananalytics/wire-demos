#!/usr/bin/env bash
# Step 4 — Show the /wire:delegate fan-out plan.
# This is the centrepiece of the demo.
#
# In live mode we ask Claude to read the release artifacts and compute the plan
# directly — this works regardless of which version of the Wire plugin is installed,
# and produces authentic output from the real project files.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 4 / 7 — /wire:delegate: the fan-out plan"

narrate_long <<'EOF'
/wire:delegate reads status.md, identifies pending artifacts, and computes
the execution plan. With 11 staging models and 9 warehouse models in scope,
the plan fans out into parallel batches within each layer:

  Staging (11 models)     → 3 agents of 4/4/3  ← exceeds 5-model threshold
  Integration (3 models)  → 1 agent             ← below threshold, no fan-out
  Warehouse (9 models)    → 2 agents of 5/4     ← exceeds 5-model threshold

  Total dbt-developer agents: 6  (3 + 1 + 2)
EOF
pause

show_command "/wire:delegate 01-peak-retail-analytics"
echo ""

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — showing pre-rendered plan)"
  echo ""
  cat "$SCRIPT_DIR/../snapshots/delegate_plan.txt" | sed 's/^/   │ /'
else
  narrate_long <<'EOF'
Running live. Claude reads the release status and data model directly to
compute the plan. We do this as a direct prompt rather than a Wire plugin
command so the demo works regardless of the installed plugin version.
EOF

  run_wire "You are the Wire delegate orchestrator for release 01-peak-retail-analytics.

Read these files:
  .wire/releases/01-peak-retail-analytics/status.md
  .wire/releases/01-peak-retail-analytics/artifacts/data_model/data_model.md
  .wire/engagement/context.md

Apply Wire fan-out rules for dbt-developer:
  - batch_size = 5 models per agent
  - batch_count per layer = min(ceil(model_count / 5), 8)
  - only fan-out when batch_count > 1 (i.e. layer has >5 models)
  - layer order is strictly: staging → integration → warehouse
  - within each layer all batch agents run in parallel

Produce the full delegation plan. Format it exactly like this example:

  Delegation plan — <engagement_name> / <release_folder>
  ─────────────────────────────────────────────
  Step 1 (sequential): pipeline-engineer → pipeline-generate
  Step 2 (multi-wave fan-out, starts after Step 1):
    Wave 2a — Staging layer (N parallel agents):
      dbt-developer [staging 1/N] → model1, model2, ...
      dbt-developer [staging 2/N] → model3, model4, ...
      ...
    Wave 2b — Integration layer (M agents, starts after Wave 2a):
      dbt-developer [integration 1/M] → ...
    Wave 2c — Warehouse layer (P parallel agents, starts after Wave 2b):
      dbt-developer [warehouse 1/P] → ...
    Total dbt-developer agents: N+M+P
  Step 3 (parallel, starts after Step 2):
    3a  orchestration-engineer → orchestration-generate
    3b  semantic-layer-developer → semantic_layer-generate
  Total: X specialist agents across Y execution stages.

Use the actual model names from data_model.md when listing each batch.
End with: Plan confirmed — proceeding with dispatch
Then STOP. Do not spawn any agents or generate any files."
fi

echo ""
narrate_long <<'EOF'
Key things to notice in the plan:
  - Wave 2a: all 3 staging agents start simultaneously — no ordering between them
  - Wave 2b only starts once every staging agent in Wave 2a has finished
  - Wave 2c only starts once Wave 2b is done
  - Step 3 (orchestration + semantic layer) runs in parallel after all dbt work

The layer gates are the guarantee that downstream models never start before
their upstream sources exist. Within each layer, agents write independent files.
EOF
pause
