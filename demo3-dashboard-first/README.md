# Demo 3 — Dashboard-first

Inverted Wire workflow: mockups → viz catalog → data model → seed data → dbt → dashboards, then a refactor onto "real" data. Full spec in [`wire/docs/wire-demos-build-playbook.md`](https://github.com/rittmananalytics/wire/blob/main/wire/docs/wire-demos-build-playbook.md) §7.

**Release type**: `dashboard_first`
**Time**: ~14 minutes
**Output**: two dashboard HTMLs (`v1.html` on seed data, `v2.html` on real-shaped data), a `data_refactor` mapping document, and a dbt warehouse built against both seed sets.

## Run it

```bash
make demo3
```

## Two seed sets

`_seed/seed_data_v1/` is the synthetic data that backs the prototype. `_seed/seed_data_real/` is what "real" Shopify-exported data looks like, with three deliberate differences:

1. `customer_id` is renamed `cust_id`.
2. Order line items are nested as JSON instead of flat rows.
3. Dates arrive as ISO strings instead of timestamps.

These are realistic Shopify-export gotchas. `data_refactor-generate` produces the mapping; `dbt-generate --mode refactor` updates the staging models to handle them. The same dashboards then render against the refactored warehouse without change.
