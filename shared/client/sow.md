# Statement of Work — Acme Coffee Roasters Ltd

**Supplier**: Rittman Analytics Ltd
**Client**: Acme Coffee Roasters Ltd (company no. 09876543)
**Engagement**: Acme Data Platform — Foundation Build
**Date**: 20 January 2026

---

## 1. Background

Acme Coffee Roasters is a D2C subscription coffee business based in Hove, founded in 2018. The business has grown from £400k revenue in 2019 to £8M ARR in 2025 across three product lines (subscriptions, gift boxes, wholesale) and four markets (UK, Ireland, France, Germany). Data lives in five source systems (Shopify, Stripe, Klaviyo, Shipstation, GA4) with no central reporting. Decisions are made from a mix of platform-native dashboards, weekly CSV exports, and gut feel.

Acme's board has set 2026 targets that require unified reporting: subscription retention is the single biggest driver of revenue, and the current Shopify/Stripe split makes cohort and churn analysis unreliable.

## 2. Objectives

1. Unified analytics warehouse covering Shopify, Stripe, Klaviyo, Shipstation, and GA4.
2. Subscription metrics that the board can trust — MRR, gross/net churn, cohort retention, LTV.
3. Marketing attribution joining Klaviyo + GA4 events to Stripe revenue.
4. A daily-refreshed executive dashboard for the CEO and head of finance.
5. A semantic layer that lets the marketing team self-serve from Looker without engineering involvement.

## 3. Scope (in)

| Domain | Sources | Outputs |
|---|---|---|
| Customers | Shopify, Stripe | `dim_customer`, `dim_address` |
| Orders | Shopify | `fct_order_line`, `dim_product` |
| Subscriptions | Stripe, Shopify | `fct_subscription_event`, `dim_subscription`, MRR/churn marts |
| Payments | Stripe | `fct_payment`, refund reconciliation |
| Marketing | Klaviyo, GA4 | `fct_marketing_event`, attribution mart |
| Fulfilment | Shipstation | `fct_shipment`, on-time-delivery mart |

| Layer | Deliverable |
|---|---|
| Pipelines | Fivetran-equivalent ingestion via dbt seeds (demo) / Cloud Functions (production) |
| Warehouse | BigQuery, Wire 3-layer dbt (staging / integration / warehouse) |
| Semantic | Looker — 1 model file, ~20 view files, 6 explores |
| Dashboards | 4 dashboards — Exec, Subscriptions, Marketing, Fulfilment |
| Enablement | Training for the marketing team (2 sessions) + technical handover docs |

## 4. Scope (out)

- Finance ERP (Xero) — already covered by the client's existing reporting and out of scope here.
- Customer support tickets (Zendesk) — deferred to a future engagement.
- Web personalisation, A/B testing platforms, or recommendation engines.

## 5. Open Questions

| ID | Question | Owner | Status |
|---|---|---|---|
| OQ-1 | Are guest checkouts (no customer record) in scope for revenue reporting? | Becky / Mark | Open |
| OQ-2 | Which subscription state machine takes precedence — Shopify or Stripe? They disagree on ~3% of subscriptions | Steph / Acme ops | Open |
| OQ-3 | **Build-blocker**: cancellation reason taxonomy — Shopify has 8 reasons, Stripe has 4, Acme's CS team uses 14. Need one canonical list before subscription churn mart can be built | Steph / Cathy | **Open — blocks build** |
| OQ-4 | GA4 → Stripe identity resolution — what's the canonical join key? | Marketing / data | Open |
| OQ-5 | How do we treat wholesale (B2B) orders in the subscription marts? | Finance / Mark | Open |
| OQ-6 | Refund treatment in MRR — net or gross? | Finance | Open |
| OQ-7 | **Build-blocker**: which markets are in scope for v1 vs phased? Pricing model differs across markets | Becky | **Open — blocks build** |
| OQ-8 | Klaviyo event taxonomy — do we keep all 40+ event types or consolidate? | Marketing | Open |
| OQ-9 | Subscription pause vs cancel — same churn or different? | Steph / ops | Open |
| OQ-10 | Looker user licences — who gets edit vs view? | IT / Becky | Open |
| OQ-11 | Historical backfill — how far back? Shopify goes to 2018, GA4 only to 2023 | Mark / Becky | Open |
| OQ-12 | Shipstation API rate limit on backfill — workable in one pass? | Engineering | Open |

## 6. Data Quality Concerns

| ID | Concern |
|---|---|
| DQ-1 | Stripe customer email mismatches Shopify customer email in ~4% of joined records |
| DQ-2 | Klaviyo events missing user_id for ~12% of pre-2024 events (pre-identity-resolution rollout) |
| DQ-3 | Shipstation has duplicate shipment records (same `tracking_number`, different `created_at`) for ~0.5% of shipments — needs deduplication rule |
| DQ-4 | GA4 timestamps occasionally arrive out-of-order by several hours; need late-arrival handling |

## 7. Stakeholders

| Name | Role | Org |
|---|---|---|
| Becky Hartmann | Head of Data | Acme (sponsor) |
| Steph Owens | Senior Analyst | Acme |
| Cathy Marsh | Customer Success Lead | Acme |
| Jordan Park | Head of Marketing | Acme |
| Priya Sharma | Engineering Lead | Acme |
| Mark Rittman | Engagement Lead | RA |
| Lydia Blackley | Head of Delivery | RA |
| Lewis Baker | CRO / commercial | RA |

## 8. Acceptance criteria

1. Every named dashboard renders with non-empty data on the bundled seed dataset.
2. dbt builds green on the full pipeline (`dbt build` zero failures).
3. Wire's `dbt-validate` produces a PASS report against the warehouse models.
4. Semantic layer LookML compiles syntactically (validated by the demo's LookML check).
5. Marketing team can answer five named questions from the Looker explores without engineering help.

## 9. Commercial

| Item | Value |
|---|---|
| Duration | 12 weeks (start 27 January 2026, end 17 April 2026) |
| Hours | 1,080 (Principal 240 + Senior ×2 600 + Consultant 240) |
| Base cost | £180,000 |
| Contingency | 15% (£27,000) |
| Total | £207,000 |
| Invoicing | 25% on signature, 25% at week 4, 25% at week 8, 25% at week 12 |

---

*This SoW is fictional. Acme Coffee Roasters is a synthesized client used in the Wire Framework demos.*
