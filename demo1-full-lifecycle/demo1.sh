#!/usr/bin/env bash
# demo1.sh — Wire Framework Demo 1: Full lifecycle
# Run with: make demo1
# See ../README.md for environment variables (DEMO_MODE, DEMO_SPEED, DEMO_MODEL).

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

source "$REPO_ROOT/shared/narrator.sh"
source "$REPO_ROOT/shared/runner.sh"
source "$REPO_ROOT/shared/auto_approve.sh"

section "Wire Framework — Demo 1: Full Lifecycle"
narrate_long <<'EOF'
This demo runs the full Wire delivery lifecycle for a fictional client
(Acme Coffee Roasters) against a local DuckDB warehouse. It installs Wire,
sets up an engagement, generates a delivery playbook as the demo's own
roadmap, then walks through every artifact phase — requirements, design,
dbt, semantic layer, dashboards — including a planted failure that the
team diagnoses and fixes.

Estimated time: ~10 minutes.
EOF
pause

demo_init demo1-full-lifecycle

# Steps are sourced in numeric order. Each step file sources narrator + runner
# and provides its own narration. Missing step files are tolerated for now;
# build days 3-4 fill them in per the build playbook.

shopt -s nullglob
STEPS=("$SCRIPT_DIR"/steps/*.sh)
shopt -u nullglob

if [ ${#STEPS[@]} -eq 0 ]; then
  warn "No step scripts found in steps/.  This is a scaffold — see the build playbook."
  echo ""
  narrate "Planned 20-step flow:"
  cat <<'EOF'

   1. Install Wire from scratch
   2. /wire:new — engagement setup
   3. Copy synthesized client materials into .wire/engagement/
   4. /wire:playbook-generate — produce the demo's own BPMN roadmap
   5. Display the playbook on screen (the table of contents for the rest)
   6. /wire:requirements-generate → -validate → -review
   7. /wire:conceptual_model-generate → -validate → -review
   8. /wire:pipeline_design-generate → -validate → -review
   9. /wire:data_model-generate → -validate → -review
  10. /wire:dbt-generate (staging layer)
  11. dbt deps + seed + build (real DuckDB warehouse)
  12. Plant a deliberate failure (one not_null test will fail)
  13. /wire:dbt-validate flags the failure
  14. Narrator quotes Wire's dbt convention to diagnose
  15. claude -p fixes the failing model
  16. /wire:dbt-validate passes
  17. dbt build — all green
  18. /wire:semantic_layer-generate (LookML)
  19. /wire:looker-dashboard-mockup renders the dashboard as HTML
  20. open dashboards/mockup.html

Implementation lands in build days 3 and 4. See wire/docs/wire-demos-build-playbook.md.
EOF
  exit 0
fi

for step in "${STEPS[@]}"; do
  bash "$step"
done

section "Demo 1 complete"
ok "Generated artifacts in .wire/releases/01-data-foundation/"
ok "dbt warehouse: warehouse.duckdb"
ok "Logs: $(demo_log_dir)"
