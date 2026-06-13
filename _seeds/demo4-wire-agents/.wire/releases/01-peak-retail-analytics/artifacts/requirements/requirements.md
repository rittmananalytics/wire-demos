# Requirements — Peak Retail Data Foundation

**Status**: Approved 2026-06-03

## Business questions

| ID | Question | Priority |
|---|---|---|
| BQ-1 | What is daily and weekly revenue by channel (direct Shopify, wholesale, email-attributed)? | High |
| BQ-2 | Which Klaviyo campaigns drive the most attributable Shopify revenue? | High |
| BQ-3 | What is customer LTV by acquisition cohort and channel? | High |
| BQ-4 | Which products have the highest return rates and do they cluster by category? | Medium |
| BQ-5 | How does email engagement (open rate, click rate) vary by customer segment? | Medium |

## Functional requirements

| ID | Requirement |
|---|---|
| FR-1 | Daily revenue totals, net of refunds, by Shopify channel and wholesale flag |
| FR-2 | Klaviyo campaign attribution: revenue within 7-day click / 1-day open window |
| FR-3 | Customer LTV: cumulative gross revenue per customer from first order date |
| FR-4 | Cohort retention: percentage of customers placing a second order within 90 days |
| FR-5 | Product return rate: refund count / order item count by SKU and category |
| FR-6 | Email engagement metrics: sends, opens, clicks, unsubscribes per campaign |
| FR-7 | Cross-channel order count and revenue per customer across Shopify + NetSuite |

## Non-functional requirements

| ID | Requirement |
|---|---|
| NFR-1 | Data must refresh daily by 07:00 UK time |
| NFR-2 | Revenue figures must reconcile to NetSuite to within 0.5% |
| NFR-3 | All personally identifiable data (email, name) must be masked in non-production environments |

## Data sources confirmed in scope

- Shopify: orders, order_items, customers, products, refunds
- NetSuite: transactions, items, customers
- Klaviyo: events (email_sent, email_opened, email_clicked, email_unsubscribed), campaigns
- GA4: sessions (for channel attribution cross-reference)
