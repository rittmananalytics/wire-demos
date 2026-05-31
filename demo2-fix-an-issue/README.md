# Demo 2 — Fix an issue in an existing project

Picks up an in-flight engagement where one warehouse model has a Wire convention violation. Full spec in [`wire/docs/wire-demos-build-playbook.md`](https://github.com/rittmananalytics/wire/blob/main/wire/docs/wire-demos-build-playbook.md) §6.

**Release type**: `dbt_development`
**Time**: ~5 minutes
**Output**: a fixed dbt model, a passing `dbt-validate`, and a green `dbt build`.

## Run it

```bash
make demo2
```

## Planted fault (default — Fault A)

`models/warehouse/fct_orders.sql` uses `customer_id` as the foreign key column where Wire's dbt-development convention requires `customer_fk`. `wire:dbt-validate` catches this in its naming check.

## Fault library

The repo can re-run with other planted faults by swapping `_seed/dbt/` for one of the variants:

| ID | Fault | Caught by |
|---|---|---|
| A (default) | `customer_id` instead of `customer_fk` in `fct_orders.sql` | `dbt-validate` naming check |
| B | Missing `not_null` test on PK in `dim_customer.yml` | `dbt-validate` testing-coverage check |
| C | `int_orders.sql` references a non-existent column | `dbt-validate` compilation step |

To switch fault: `cp _seed/faults/B/* _seed/dbt/` (etc.) then `make reset-demo2`.
