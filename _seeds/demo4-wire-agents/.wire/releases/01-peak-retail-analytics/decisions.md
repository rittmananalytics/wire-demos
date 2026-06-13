# Decisions — 01-peak-retail-analytics

<!-- Agent decisions append here as the release progresses. -->

[2026-06-05] data-designer: Shopify customer_id chosen as canonical identity key.
NetSuite customer_id stored as netsuite_customer_id_fk in int__customer_unified
for reconciliation. Rationale: Shopify is the order-of-record system; NetSuite
records are created retroactively by the finance team and are not guaranteed
to exist for every Shopify customer.

[2026-06-05] data-designer: Attribution window set to 7-day click / 1-day open
per OQ-2 resolution. int__marketing_attribution filters klaviyo_events to the
resolved window before joining to orders. Window is stored as a model variable
so the marketing team can adjust without schema changes.
