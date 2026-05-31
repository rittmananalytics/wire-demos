#!/usr/bin/env bash
# Step 1 — Wire install narration.
# The plugin is verified by doctor before the demo runs; this step is
# narrative + a sanity check that Wire is reachable.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 1 / 20 — Install Wire from scratch"

narrate_long <<'EOF'
A fresh consultant would install Wire in three lines from inside Claude Code:

   /plugin marketplace add rittmananalytics/wire-plugin
   /plugin install wire@rittman-analytics
   /reload-plugins

`make doctor` already verified Wire is installed on this machine, so we'll
skip the live install — but everything from here on uses the plugin via
`claude -p` headless mode.
EOF

if [ -d "${HOME}/.claude/plugins/cache" ] && find "${HOME}/.claude/plugins/cache" -maxdepth 4 -type d -name "wire" 2>/dev/null | grep -q .; then
  ok "Wire plugin found in ${HOME}/.claude/plugins/cache"
else
  err "Wire plugin not detected — Demo 1 cannot continue."
  err "Install it first via: /plugin marketplace add rittmananalytics/wire-plugin"
  exit 1
fi

pause
