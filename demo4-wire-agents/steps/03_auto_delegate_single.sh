#!/usr/bin/env bash
# Step 3 — Show auto-delegation: what the consultant sees when /wire:dbt-generate is called.
# Both modes show the delegation handoff message; live mode has Claude produce it naturally.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 3 / 7 — Auto-delegation: one command, one specialist agent"

narrate_long <<'EOF'
Wire Agents activates automatically on every generate and validate command.
Run /wire:dbt-generate as normal — the main session detects the dbt-developer
agent definition, prints a brief handoff message, and delegates.

Review commands (/wire:*-review) always stay in the main session because
they need human input. Everything else delegates.

This is what the handoff looks like:
EOF
pause

show_command "/wire:dbt-generate 01-peak-retail-analytics"
echo ""

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  cat "$SCRIPT_DIR/../snapshots/auto_delegate_message.txt" | sed 's/^/   │ /'
else
  # In live mode: ask Claude to produce the delegation handoff message.
  # We deliberately do NOT run the full dbt-generate here — that would attempt
  # to generate 23 models against the demo's bare context, which would take
  # several minutes and may not complete cleanly. The delegation MESSAGE is what
  # we want to show; the actual model generation happens in steps 5–6.
  run_wire 'You are the Wire Framework main session. The consultant has just run
/wire:dbt-generate for release 01-peak-retail-analytics.

You have detected the dbt-developer agent definition at agents/dbt-developer/AGENT.md.
Print the auto-delegation handoff message that Wire shows before launching the agent.
It should cover:
- The "→ Delegating to dbt-developer agent" header
- Agent definition path
- What the dbt-developer agent will do (read upstream artifacts, generate 23 models,
  follow Wire 3-layer conventions, update status.md, append to decisions.md)
- "Launching dbt-developer agent..."
Keep it to 10-15 lines. Then STOP — do not generate any files or run any commands.'
fi

echo ""
narrate_long <<'EOF'
The same delegation pattern applies to every other generate command:
  /wire:pipeline-generate    → pipeline-engineer agent
  /wire:semantic_layer-generate → semantic-layer-developer agent
  /wire:data_quality-generate → data-quality-engineer agent

The consultant's session stays clean. Each agent executes in its own context
with its own focused brief.
EOF
pause
