#!/usr/bin/env bash
# Step 8 — Pipeline design: generate → validate → review.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 8 / 20 — Pipeline design"

narrate_long <<'EOF'
Pipeline design covers what lands where: source systems, ingestion
cadence, the landing zone, transformation tooling, and the data flow
diagram. Wire reads the requirements + source DDL and produces a
pipeline architecture document with a DFD.
EOF
pause

run_wire "/wire:pipeline_design-generate releases/01-data-foundation"
echo ""
run_wire "/wire:pipeline_design-validate releases/01-data-foundation" || true
echo ""
run_wire "/wire:pipeline_design-review releases/01-data-foundation"
