#!/usr/bin/env bash
# demo2.sh — Wire Framework Demo 2: Fix an issue in an existing project

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

source "$REPO_ROOT/shared/narrator.sh"
source "$REPO_ROOT/shared/runner.sh"
source "$REPO_ROOT/shared/auto_approve.sh"

section "Wire Framework — Demo 2: Fix an issue"
narrate_long <<'EOF'
This demo picks up an in-flight engagement (same Acme client, dbt-only
release) where one warehouse model has a Wire convention violation:
fct_orders.sql uses customer_id where it should use customer_fk. The demo
runs /wire:start, /wire:dbt-validate (which catches the issue), fixes it
via Claude, re-validates, and re-builds.

Estimated time: ~5 minutes.
EOF
pause

demo_init demo2-fix-an-issue

shopt -s nullglob
STEPS=("$SCRIPT_DIR"/steps/*.sh)
shopt -u nullglob

if [ ${#STEPS[@]} -eq 0 ]; then
  warn "No step scripts found in steps/.  This is a scaffold — see the build playbook."
  echo ""
  narrate "Planned 9-step flow:"
  cat <<'EOF'

   1. Inherit the in-flight project from _seed/
   2. /wire:start — pick the release
   3. /wire:status — see what's failing
   4. /wire:dbt-validate — naming convention violation surfaces
   5. Narrator quotes the _fk convention from wire/skills/dbt-development/SKILL.md
   6. claude -p — rename customer_id → customer_fk and update downstream refs
   7. /wire:dbt-validate — PASS
   8. dbt build — confirm runtime still works
   9. /wire:dbt-review — sign off

Implementation lands in build day 2. See wire/docs/wire-demos-build-playbook.md.
EOF
  exit 0
fi

for step in "${STEPS[@]}"; do
  bash "$step"
done

section "Demo 2 complete"
ok "Fault fixed; release approved."
