# Statement of Work — Marketing Mart Extension

**Client**: Acme Coffee Roasters Ltd
**Supplier**: Rittman Analytics Ltd
**Engagement**: Marketing Mart Extension (Phase 2 of the Acme data platform)
**Duration**: 4 weeks
**Total**: £40,000

## Scope

Add a marketing-focused warehouse mart on top of the existing Acme dbt project:

- New warehouse models: `wh_core__order_fact` (customer-attributed order facts), `wh_core__customer_dim` (extended customer dimension).
- Integration models: `int_core__order` (orders with customer attributes) and `int_core__customer` (customers with lifetime order totals).
- Tests: PK uniqueness, FK referential integrity, not-null on customer attribution columns.

## Out of scope
- New ingestion (uses the existing Shopify seeds).
- BI layer changes (a follow-on release).

## Acceptance criteria
1. All models compile and run on the local DuckDB warehouse.
2. `wire:dbt-validate` returns PASS (naming conventions, testing coverage, documentation).
3. `wire:dbt-review` records sign-off.

*Acme Coffee Roasters is a fictional client used in Wire Framework demos.*
