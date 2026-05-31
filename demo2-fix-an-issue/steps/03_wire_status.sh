#!/usr/bin/env bash
# Step 3 — /wire:status to see where the release is stuck.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 3 / 9 — /wire:status releases/01-marketing-mart"

narrate_long <<'EOF'
Wire tracks every artifact's lifecycle in status.md. /wire:status reads
it and renders a readable summary. We're expecting to see requirements
and data_model approved, and dbt with a failing validate.
EOF
pause

run_wire "/wire:status releases/01-marketing-mart"

echo ""
narrate "And here's the status.md verbatim — the source of truth:"
show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/.wire/releases/01-marketing-mart/status.md"
pause
