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

FIX_PROMPT='In dbt/models/schema.yml, the wh_core__order_fact model has no entry for its customer_fk column. Add one directly after order_pk, in the same style as the other columns: (a) description "{{ doc('"'"'customer_fk'"'"') }}" (the doc block already exists in models/field_descriptions.md), (b) a not_null test, and (c) a relationships test against ref('"'"'wh_core__customer_dim'"'"') on the customer_pk field, using the same arguments: form as the other relationships tests in the file. Make ONLY that addition; leave every other line unchanged.'

run_wire "$FIX_PROMPT"

echo ""
narrate "Let's see what the file looks like now:"
show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt/models/schema.yml"
pause
