#!/usr/bin/env bash
# Step 4 — /wire:playbook-generate produces the BPMN delivery playbook
# that becomes the demo's own table of contents.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 4 / 20 — /wire:playbook-generate — the demo's own roadmap"

narrate_long <<'EOF'
Before any artifacts get generated, Wire produces a step-by-step BPMN
delivery playbook for the release. It is a mermaid flowchart of every
artifact you'll touch, in order, with the human-in-the-loop review gates
marked.

You can read this as the table of contents for the rest of the demo —
the steps that follow will trace a path through it.
EOF
pause

run_wire "/wire:playbook-generate releases/01-data-foundation"
