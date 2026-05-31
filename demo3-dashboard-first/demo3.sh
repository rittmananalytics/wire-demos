#!/usr/bin/env bash
# demo3.sh — Wire Framework Demo 3: Dashboard-first

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

source "$REPO_ROOT/shared/narrator.sh"
source "$REPO_ROOT/shared/runner.sh"
source "$REPO_ROOT/shared/auto_approve.sh"

section "Wire Framework — Demo 3: Dashboard-first"
narrate_long <<'EOF'
This demo runs the inverted Wire workflow: dashboards first, then the data
model, then dbt against synthetic seed data. Finally it swaps in a "real"
seed set (different column names, different shape) and uses
/wire:data_refactor to map the prototype onto real data without changing
the dashboards.

Estimated time: ~14 minutes.
EOF
pause

demo_init demo3-dashboard-first

shopt -s nullglob
STEPS=("$SCRIPT_DIR"/steps/*.sh)
shopt -u nullglob

if [ ${#STEPS[@]} -eq 0 ]; then
  warn "No step scripts found in steps/.  This is a scaffold — see the build playbook."
  echo ""
  narrate "Planned 14-step flow:"
  cat <<'EOF'

   1. /wire:new — type=dashboard_first
   2. /wire:mockups-generate from bundled spec
   3. open dashboards/mockup.html
   4. /wire:viz_catalog-generate
   5. /wire:data_model-generate (derived from what dashboards need)
   6. /wire:seed_data-generate → -validate
   7. /wire:dbt-generate → dbt seed + build on synthetic data
   8. /wire:semantic_layer-generate
   9. /wire:dashboards-generate — re-render mockup against seed data
  10. open dashboards/v1.html — live charts on synthetic data
  11. Drop in "real" data (alternate seed set with different shape)
  12. /wire:data_refactor-generate → -validate → -review (mapping doc)
  13. /wire:dbt-generate --mode refactor → dbt build on real-shaped seeds
  14. Re-open dashboard — same charts, real-shaped data

Implementation lands in build day 5. See wire/docs/wire-demos-build-playbook.md.
EOF
  exit 0
fi

for step in "${STEPS[@]}"; do
  bash "$step"
done

section "Demo 3 complete"
ok "Dashboards rendered against both seed and real data."
