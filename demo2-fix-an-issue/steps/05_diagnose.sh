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
   • Every warehouse column documented with a description

In models/schema.yml, wh_core__order_fact is missing the customer_fk
column entry entirely: no description, and no relationships test
pointing at wh_core__customer_dim.customer_pk. That's the gap.

Let's look at the file as it stands:
EOF

show_file "$WIRE_DEMOS_ROOT/demo2-fix-an-issue/dbt/models/schema.yml"

narrate "wh_core__order_fact lists every column except customer_fk. We'll add it, with a relationships test, in step 6."
pause
