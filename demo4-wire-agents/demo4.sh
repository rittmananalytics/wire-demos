#!/usr/bin/env bash
# demo4.sh — Wire Agents: Auto-delegation and Fan-out
# Run with: make demo4
# See ../README.md for environment variables (DEMO_MODE, DEMO_SPEED, DEMO_MODEL).

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

source "$REPO_ROOT/shared/narrator.sh"
source "$REPO_ROOT/shared/runner.sh"
source "$REPO_ROOT/shared/auto_approve.sh"

section "Wire Framework — Demo 4: Wire Agents"
narrate_long <<'EOF'
Three Wire Agents capabilities in one demo:
  1. Auto-delegation — individual /wire:generate commands hand off to specialist agents
  2. /wire:delegate — batch dispatch with fan-out plan shown before any agent starts
  3. Fan-out — multiple dbt-developer agents per layer running in parallel

Client: Peak Retail Group (UK D2C outdoor apparel)
Start: Phase 3 — design complete, development pending
Models: 11 staging / 3 integration / 9 warehouse → 6 dbt-developer agents total

Estimated time: DEMO_SPEED=fast ~3 min | DEMO_SPEED=live ~15 min (Haiku)
EOF
pause

demo_init demo4-wire-agents

shopt -s nullglob
STEPS=("$SCRIPT_DIR"/steps/*.sh)
shopt -u nullglob

if [ ${#STEPS[@]} -eq 0 ]; then
  err "No step scripts found."
  exit 1
fi

for step in "${STEPS[@]}"; do
  bash "$step"
done

section "Demo 4 complete"
ok "Wire Agents demo finished"
ok "Models generated: $(find "$DEMO_DIR/dbt/models" -name '*.sql' 2>/dev/null | wc -l | tr -d ' ')"
ok "Logs: $(demo_log_dir)"
