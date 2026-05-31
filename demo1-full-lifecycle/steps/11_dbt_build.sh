#!/usr/bin/env bash
# Step 11 — Build the dbt project against DuckDB.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 11 / 20 — Run the dbt project"

narrate_long <<'EOF'
Time to actually run the SQL Wire just wrote. The project is configured
for DuckDB, the seeds are in place, and the staging models reference
those seeds. `dbt build` loads the seeds, builds the staging views, and
runs any tests Wire emitted.
EOF
pause

cd "$DEMO_DIR/dbt"

# Wire's dbt models commonly reference dbt_utils — install packages first.
narrate "Installing dbt packages (dbt_utils etc.)..."
run_dbt deps
echo ""

run_dbt seed
echo ""
run_dbt build
