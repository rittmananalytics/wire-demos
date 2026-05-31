#!/usr/bin/env bash
# Step 4 — Run /wire:dbt-validate. Expect a failure.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 4 / 9 — /wire:dbt-validate (expecting a failure)"

narrate_long <<'EOF'
This is the command that flagged the issue. It runs the dbt-development
skill's battery of checks across the project — naming conventions,
testing coverage, documentation, model configuration — and produces a
severity-rated report.

Per status.md the validate is failing on the warehouse schema.yml.
Wire will say more — read the output carefully.
EOF
pause

# We deliberately don't fail the demo on a non-zero exit; the failure IS the demo.
run_wire "/wire:dbt-validate releases/01-marketing-mart" || true

echo ""
narrate "Step 5 will pull out the specific gap and quote the relevant Wire convention."
pause
