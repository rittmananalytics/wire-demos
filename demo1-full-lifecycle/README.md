# Demo 1 — Full lifecycle

Runs the full Wire delivery lifecycle for Acme Coffee Roasters against a local DuckDB warehouse. The full step-by-step spec lives in [`wire/docs/wire-demos-build-playbook.md`](https://github.com/rittmananalytics/wire/blob/main/wire/docs/wire-demos-build-playbook.md) §5.

**Release type**: `full_platform`
**Time**: ~10 minutes
**Output**: a working dbt warehouse on DuckDB, LookML semantic layer, and a dashboard mockup HTML.

## Run it

```bash
make demo1
```

## Layout

```
demo1-full-lifecycle/
├── demo1.sh              # Entry point
├── steps/                # Per-step scripts (sourced in numeric order)
├── _seed/                # Empty starting state — reset.sh restores from here
├── expected_artifacts/   # Golden snapshot for validate.sh
└── validate.sh           # Post-run validation (existence + structure + dbt run-results)
```

## What's planted

Step 12 deliberately overwrites `models/staging/shopify/stg_shopify__orders.sql` with a version that has a `not_null` test on `email`. The seed data contains guest orders with NULL emails, so the test fails. Step 15 fixes it by either dropping the test or scoping it to non-guest orders.

This is announced in the narration — the fault is not pretending to be organic.
