# Requirements Specification — Marketing Mart Extension

## Functional Requirements

| ID | Requirement | Source | Priority |
|---|---|---|---|
| FR-1 | Combine Shopify orders with Stripe payment status into a single fact table | SoW §1 | P0 |
| FR-2 | Attribute every order to a customer record (no orphan facts) | SoW §1 | P0 |
| FR-3 | Provide customer-level dimension with lifetime spend, order count, and signup channel | SoW §1 | P1 |
| FR-4 | Support filtering by market (UK / IE / FR / DE) | Discovery call 2026-04-10 | P1 |
| FR-5 | Daily refresh — incremental builds where practical | Engineering review | P2 |

## Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR-1 | All models follow Wire dbt naming conventions (`_pk`, `_fk`, `_ts`, `is_`/`has_`) |
| NFR-2 | Every PK has a unique + not_null test |
| NFR-3 | Every FK has a relationships test against the referenced PK |
| NFR-4 | All warehouse models documented in `schema.yml` |

## Acceptance Criteria

1. `dbt build` runs green against the bundled DuckDB warehouse.
2. `wire:dbt-validate` returns PASS.
3. `wire:dbt-review` records stakeholder sign-off.
