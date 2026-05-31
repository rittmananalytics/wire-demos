#!/usr/bin/env bash
# auto_approve.sh — sourced by the runner. Provides narration for the stubbed-review pattern.
# The actual auto-approve mechanism is in runner.sh's run_wire (it appends approval text to
# any -review command). This file exists so the narrator can announce the simulation once
# per demo.

if [ -n "${__WIRE_DEMOS_AUTO_APPROVE_LOADED:-}" ]; then return 0 2>/dev/null || exit 0; fi
__WIRE_DEMOS_AUTO_APPROVE_LOADED=1

# Announce the auto-approve convention once per demo.
__AUTO_APPROVE_ANNOUNCED=false
announce_auto_approve() {
  [ "$__AUTO_APPROVE_ANNOUNCED" = "true" ] && return 0
  __AUTO_APPROVE_ANNOUNCED=true
  source "$WIRE_DEMOS_ROOT/shared/narrator.sh"
  narrate_long <<'EOF'
A note on reviews — in a real engagement, your sponsor reviews each artifact
and either approves, requests changes, or asks for more discussion. For the
demo we auto-approve so the flow continues. Wire records the reviewer as
"demo operator" in the artifact's status entry.
EOF
}
