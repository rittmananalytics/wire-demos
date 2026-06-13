#!/usr/bin/env bash
# Step 2 — Show the release status: design approved, development pending.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 2 / 7 — Release status: design approved, development ready"

narrate_long <<'EOF'
The demo starts at the beginning of Phase 3 (development). All four
design-phase artifacts — requirements, conceptual model, pipeline design,
and data model — are approved. The dbt, semantic layer, orchestration,
and dashboards artifacts are at not_started.

/wire:status shows this in one glance.
EOF
pause

show_command "/wire:status 01-peak-retail-analytics"

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — showing pre-rendered status)"
  cat <<'STATUSEOF'

Release: 01-peak-retail-analytics — Peak Retail Data Foundation
Phase: development

REQUIREMENTS       ✅ approved   2026-06-03
CONCEPTUAL MODEL   ✅ approved   2026-06-04
PIPELINE DESIGN    ✅ approved   2026-06-04
DATA MODEL         ✅ approved   2026-06-05
DBT                ○ not started
SEMANTIC LAYER     ○ not started
ORCHESTRATION      ○ not started
DASHBOARDS         ○ not started

Open questions: all resolved (OQ-1, OQ-2, OQ-3 closed)
Recommended action: /wire:delegate 01-peak-retail-analytics
STATUSEOF
else
  run_wire "/wire:status 01-peak-retail-analytics"
fi

narrate "Design phase complete. 4 development artifacts pending. Time to delegate."
pause
