#!/usr/bin/env bash
# Step 5 — Narrator quotes the Wire dbt-development testing convention.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 5 / 9 — Diagnose"

narrate_long <<'EOF'
Wire's dbt-development skill enforces a testing convention for the
warehouse layer:

   • Every primary key has unique + not_null tests
   • Every foreign key has a relationships test against the referenced PK
   • Every column documented in schema.yml with a description

In warehouse/schema.yml, fct_orders is missing the customer_fk column
entry entirely — no description, no relationships test pointing at
dim_customer.customer_pk. That's the gap.

Let's look at the file as it stands:
EOF

show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt/models/warehouse/schema.yml"

narrate "fct_orders only has the order_pk entry. We'll add customer_fk with a relationships test in step 6."
pause
