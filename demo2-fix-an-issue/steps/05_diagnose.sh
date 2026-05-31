#!/usr/bin/env bash
# Step 5 — Narrator quotes the Wire dbt-development convention.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 5 / 9 — Diagnose"

narrate_long <<'EOF'
Wire's dbt-development skill enforces a specific naming convention for
keys in the warehouse layer:

   • Primary keys end in _pk        (e.g. customer_pk, order_pk)
   • Foreign keys end in _fk        (e.g. customer_fk in a fact)
   • Timestamps end in _ts          (e.g. order_ts)
   • Booleans start with is_ or has_

In fct_orders.sql, the column that should be customer_fk has been
aliased to customer_id instead. That's the violation.

Let's look at the file directly:
EOF

show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt/models/warehouse/fct_orders.sql"

narrate "The offending line uses 'as customer_id' on the customer_fk column. We'll fix that in step 6."
pause
