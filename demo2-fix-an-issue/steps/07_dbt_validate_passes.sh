#!/usr/bin/env bash
# Step 7 — Re-run /wire:dbt-validate. Expect PASS.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 7 / 9 — Re-run /wire:dbt-validate"

narrate_long <<'EOF'
Same command as step 4. This time the naming check should pass.
EOF
pause

run_wire "/wire:dbt-validate releases/01-marketing-mart"
