# Demo 2 — Fix an issue in an existing project

Picks up an in-flight engagement where one warehouse model has a Wire convention violation. Full spec in [`wire/docs/wire-demos-build-playbook.md`](https://github.com/rittmananalytics/wire/blob/main/wire/docs/wire-demos-build-playbook.md) §6.

**Release type**: `dbt_development`
**Time**: ~5 minutes
**Output**: a fixed `schema.yml`, a passing `dbt-validate`, and a green `dbt build`.

## Run it

```bash
make demo2
```

## Planted fault

In `dbt/models/schema.yml`, the order fact `wh_core__order_fact` has no entry for its foreign key `customer_fk`: no description and no `relationships` test against `wh_core__customer_dim.customer_pk`. Wire's dbt-development rules require both, so `/wire:dbt-validate` fails. The rest of the project meets Wire's rules, so after the fix the check passes.

The starting state lives in `_seeds/demo2-fix-an-issue/` at the repository root. `make reset-demo2` restores it.

## Recording

`make demo2` replays the recorded run in `recording/` when one exists. `make record-demo2` runs the demo live (with Opus by default) and saves a new recording. `DEMO_PLAYBACK=live make demo2` runs it live without saving.
