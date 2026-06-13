#!/usr/bin/env bash
# Step 3 — Show auto-delegation: run /wire:dbt-generate and watch it hand off to the agent.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

DEMO_DIR_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"

section "Step 3 / 7 — Auto-delegation: one command, one specialist agent"

narrate_long <<'EOF'
Wire Agents activates automatically on every generate and validate command.
You don't have to do anything differently — run /wire:dbt-generate as normal
and the main session detects the dbt-developer agent definition, prints a
brief handoff message, and delegates.

Review commands (/wire:*-review) always stay in the main session because
they need human input. Everything else delegates.

Let's see it:
EOF
pause

show_command "/wire:dbt-generate 01-peak-retail-analytics"

if [ "${DEMO_SPEED:-live}" = "fast" ]; then
  narrate "(fast mode — showing the delegation handoff message)"
  echo ""
  cat "$SCRIPT_DIR/../snapshots/auto_delegate_message.txt" | sed 's/^/   │ /'
  echo ""
  narrate "In live mode this would run the full dbt-developer agent against the data model."
  narrate "We skip to /wire:delegate in this demo to show the fan-out plan instead."
else
  narrate_long <<'EOF'
Running live. This will auto-delegate to the dbt-developer agent and
generate all 23 models. Expect 3–6 minutes on Haiku. Watch the output
for the '→ Delegating to dbt-developer agent' message.
EOF
  run_wire "/wire:dbt-generate 01-peak-retail-analytics

Read .wire/releases/01-peak-retail-analytics/artifacts/data_model/data_model.md
and .wire/releases/01-peak-retail-analytics/artifacts/conceptual_model/conceptual_model.md.
Generate all dbt models into dbt/models/ per the Wire 3-layer conventions.
When you see this command you should announce you are delegating to the
dbt-developer specialist agent, then proceed to generate the models."
fi

pause
