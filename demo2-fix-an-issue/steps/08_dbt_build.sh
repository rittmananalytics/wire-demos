#!/usr/bin/env bash
# Step 8 — Confirm dbt build runs green after the fix.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 8 / 9 — dbt build"

narrate_long <<'EOF'
Wire validates conventions; dbt validates that the SQL still works. Both
have to be green for the release to ship. The build runs against the
bundled DuckDB warehouse.
EOF
pause

cd "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt"
run_dbt build
