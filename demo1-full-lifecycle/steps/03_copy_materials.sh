#!/usr/bin/env bash
# Step 3 — Copy the synthesized client materials into the engagement.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 3 / 20 — Collect the required materials"

narrate_long <<'EOF'
In a real engagement these are the artifacts the consultant brings into
.wire/engagement/ — the signed SoW, call transcripts, stakeholder notes,
source-system DDL. Wire's commands read from here.
EOF
pause

# Copy from the shared synthesized client into the engagement
CLIENT_SRC="$WIRE_DEMOS_ROOT/shared/client"
ENG_DIR="$DEMO_DIR/.wire/engagement"

mkdir -p "$ENG_DIR/calls" "$ENG_DIR/org" "$ENG_DIR/sources"
cp -R "$CLIENT_SRC/calls/." "$ENG_DIR/calls/"
cp -R "$CLIENT_SRC/org/." "$ENG_DIR/org/"
cp -R "$CLIENT_SRC/sources/." "$ENG_DIR/sources/"
cp "$CLIENT_SRC/sow.md" "$ENG_DIR/sow.md"

show_command "cp -R shared/client/* .wire/engagement/"
ok "Copied SoW, 3 call transcripts, stakeholder map, and 5-system DDL into the engagement"
echo ""
echo "  .wire/engagement/"
( cd "$ENG_DIR" && find . -maxdepth 2 -type f | grep -v gitkeep | sort | sed 's|^\./|    |' )
pause
