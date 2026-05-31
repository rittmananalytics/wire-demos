#!/usr/bin/env bash
# Step 2 — /wire:start to load engagement context and pick a release.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 2 / 9 — /wire:start"

narrate_long <<'EOF'
Every Wire session begins with /wire:start. It reads the engagement
context, lists active releases, and gives us the lay of the land before
we run any artifact commands.
EOF
pause

run_wire "/wire:start"
