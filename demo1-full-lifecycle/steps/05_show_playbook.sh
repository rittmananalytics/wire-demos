#!/usr/bin/env bash
# Step 5 — Display the playbook so the viewer sees the BPMN roadmap.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 5 / 20 — Show the delivery playbook"

PLAYBOOK="$DEMO_DIR/.wire/releases/01-data-foundation/planning/delivery_playbook.md"

if [ -f "$PLAYBOOK" ]; then
  narrate "Wire's BPMN roadmap for this release:"
  show_file "$PLAYBOOK"
else
  # Wire may use a slightly different filename; try a couple of common variants
  ALT=$(find "$DEMO_DIR/.wire/releases/01-data-foundation" -maxdepth 3 -name "*playbook*.md" 2>/dev/null | head -1)
  if [ -n "$ALT" ]; then
    narrate "Wire's BPMN roadmap for this release (located at $ALT):"
    show_file "$ALT"
  else
    warn "Playbook file not found at the expected path; check Wire's output above."
  fi
fi

pause
