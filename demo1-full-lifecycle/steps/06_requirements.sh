#!/usr/bin/env bash
# Step 6 — Requirements: generate → validate → review.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"
source "$SCRIPT_DIR/../../shared/auto_approve.sh"

section "Step 6 / 20 — Requirements"

narrate_long <<'EOF'
Wire reads the SoW + call transcripts and writes a structured requirements
spec. Then it validates the spec against its completeness checks, then
opens it for review.
EOF
pause

run_wire "/wire:requirements-generate releases/01-data-foundation"
echo ""

run_wire "/wire:requirements-validate releases/01-data-foundation" || true
echo ""

announce_auto_approve
run_wire "/wire:requirements-review releases/01-data-foundation"
