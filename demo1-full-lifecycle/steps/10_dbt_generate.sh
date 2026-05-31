#!/usr/bin/env bash
# Step 10 — Generate dbt staging models from the data model.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 10 / 20 — Generate dbt staging models"

narrate_long <<'EOF'
With the data model approved, Wire generates dbt model files. For Demo 1
we'll generate just the staging layer first so we can confirm the build
works end-to-end before producing the integration and warehouse layers.

Wire writes models into the existing dbt/ project at the demo root
(dbt_project.yml + seeds are already in place).
EOF
pause

run_wire "/wire:dbt-generate releases/01-data-foundation. Generate the STAGING LAYER ONLY for now (do not generate integration or warehouse layers in this run). Write model files into the dbt/models/staging/ directory at the demo root, not inside .wire/. The dbt project is already set up: dbt/dbt_project.yml exists, profile is 'acme', and seeds/ has shopify_customers and shopify_orders CSVs already loaded as ref-able seeds. For the demo, only generate staging models for the Shopify source (stg_shopify__customers and stg_shopify__orders). Use {{ ref('shopify_customers') }} not {{ source(...) }} because the source data lives as dbt seeds in this demo. Follow Wire's dbt naming conventions: _pk for primary keys, _fk for foreign keys, _ts for timestamps. CRITICAL: the warehouse target is DuckDB, not BigQuery — use DuckDB-compatible SQL types (DOUBLE, VARCHAR, INTEGER, BIGINT, TIMESTAMP, BOOLEAN, DATE) and NOT BigQuery-specific types (float64, string, int64, datetime). For any casts, use DuckDB types only. Also CRITICAL on schema.yml: do not use \`- not_null: false\` to mark a column as nullable — that is invalid dbt syntax. If a column is nullable, simply OMIT the not_null test entirely. Only add a not_null test when you want it enforced."
