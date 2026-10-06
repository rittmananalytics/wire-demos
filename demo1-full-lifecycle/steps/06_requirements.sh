#!/usr/bin/env bash
# Step 6 — Requirements: generate (with its own check) → review.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"
source "$SCRIPT_DIR/../../shared/auto_approve.sh"

section "Step 6 / 20 — Requirements"

narrate_long <<'EOF'
Wire reads the SoW + call transcripts and writes a structured requirements
spec, checking it against its completeness rules as it goes. Then it
opens it for review.
EOF
pause

run_wire "/wire:requirements-generate releases/01-data-foundation"
echo ""


announce_auto_approve
run_wire "/wire:requirements-review releases/01-data-foundation"
