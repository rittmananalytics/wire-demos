#!/usr/bin/env bash
# Step 6 — Fix the schema.yml gap via claude -p.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 6 / 9 — Fix the schema.yml gap"

narrate_long <<'EOF'
We'll ask Claude to add the missing customer_fk entry to schema.yml
with the required relationships test, leaving the rest of the file
alone.
EOF
pause

FIX_PROMPT='In dbt/models/warehouse/schema.yml, the fct_orders model only documents order_pk. Add a customer_fk column entry under fct_orders with: (a) a description noting it is the foreign key to dim_customer, (b) a not_null test, and (c) a relationships test against ref("dim_customer") on the customer_pk field. Make ONLY that addition; leave the dim_customer model entry and every other line unchanged. Remove the demo comments at the top of the file (the lines starting with "# NOTE FOR THE DEMO" and "# ↓ INCOMPLETE") since the schema is now complete.'

run_wire "$FIX_PROMPT"

echo ""
narrate "Let's see what the file looks like now:"
show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt/models/warehouse/schema.yml"
pause
