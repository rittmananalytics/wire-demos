#!/usr/bin/env bash
# Step 4 — Run /wire:dbt-validate. Expect a failure.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 4 / 9 — /wire:dbt-validate (expecting a failure)"

narrate_long <<'EOF'
This is the command that flagged the issue. It runs a battery of checks
against the dbt project — naming conventions, testing coverage,
documentation, model configuration — and produces a severity-rated
report. We expect it to fail because the status.md said so.

Watch the output for which model and which check failed.
EOF
pause

# We deliberately don't fail the demo on a non-zero exit; the failure IS the demo.
run_wire "/wire:dbt-validate releases/01-marketing-mart" || true

echo ""
narrate "Step 5 will diagnose what Wire just told us."
pause
