#!/usr/bin/env bash
# Step 6 — Fix the model via claude -p.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 6 / 9 — Fix the convention violation"

narrate_long <<'EOF'
We'll ask Claude to make a focused edit: rename the offending alias so the
foreign key keeps Wire's _fk suffix. Nothing else in the file should change.
EOF
pause

FIX_PROMPT="In dbt/models/warehouse/fct_orders.sql, the line that reads \`customer_fk         as customer_id,\` violates Wire's dbt naming convention — foreign keys must end in \`_fk\`. Remove the rename so the column stays named \`customer_fk\` in the final select. Make ONLY that change; leave every other line of the file alone. Do not modify schema.yml or any other file."

run_wire "$FIX_PROMPT"

echo ""
narrate "Let's see what the file looks like now:"
show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt/models/warehouse/fct_orders.sql"
pause
