#!/usr/bin/env bash
# Step 9 — /wire:dbt-review to record sign-off.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"
source "$SCRIPT_DIR/../../shared/auto_approve.sh"

section "Step 9 / 9 — /wire:dbt-review"

# Announce the auto-approve simulation
announce_auto_approve

narrate_long <<'EOF'
With validate green and the build clean, the release is ready for review.
In real life this is where the sponsor reviews the artifact and approves
(or sends it back). The runner auto-approves so the demo finishes.
EOF
pause

run_wire "/wire:dbt-review releases/01-marketing-mart"
