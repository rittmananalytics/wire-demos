#!/usr/bin/env bash
# Step 7 — Conceptual model: generate → validate → review.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 7 / 20 — Conceptual model"

narrate_long <<'EOF'
The conceptual model is the entity-relationship view the team agrees on
before any SQL is written. Wire produces a mermaid ERD plus a narrative
covering grain, conformed dimensions, and integration risk.
EOF
pause

run_wire "/wire:conceptual_model-generate releases/01-data-foundation"
echo ""
run_wire "/wire:conceptual_model-validate releases/01-data-foundation" || true
echo ""
run_wire "/wire:conceptual_model-review releases/01-data-foundation"
