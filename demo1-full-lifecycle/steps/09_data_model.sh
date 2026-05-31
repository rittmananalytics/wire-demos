#!/usr/bin/env bash
# Step 9 — Data model: generate → validate → review.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 9 / 20 — Data model"

narrate_long <<'EOF'
The data model is the physical design — staging → integration →
warehouse layer-by-layer, with PKs, FKs, conformed dimensions, and
materialisation strategy. This is the spec the dbt models will be
generated from.
EOF
pause

run_wire "/wire:data_model-generate releases/01-data-foundation"
echo ""
run_wire "/wire:data_model-validate releases/01-data-foundation" || true
echo ""
run_wire "/wire:data_model-review releases/01-data-foundation"
