"""Deterministic seed-data generator for the Acme Coffee Roasters demo client.

Produces CSV files in each sources/<system>/ folder matching ddl.sql.
Seeded with a fixed RNG so every clone of the repo gets the same data.

Build-day work: implement the full generator. For now this is a placeholder
that documents the shape and row counts expected per the playbook.
"""

from __future__ import annotations

import argparse
import random
from pathlib import Path

# Fixed seed so data is identical on every run
RNG = random.Random(20260120)

# Row count targets per the playbook §3.1
TARGETS = {
    "shopify_customers": 3000,
    "shopify_orders": 10000,
    "shopify_order_lines": 25000,
    "shopify_products": 40,
    "shopify_subscriptions": 4500,
    "stripe_customers": 3000,
    "stripe_charges": 12000,
    "stripe_subscriptions": 4500,
    "stripe_invoices": 18000,
    "klaviyo_events": 30000,
    "klaviyo_campaigns": 120,
    "klaviyo_flows": 8,
    "klaviyo_lists": 6,
    "shipstation_shipments": 10000,
    "shipstation_tracking_events": 35000,
    "ga4_sessions": 50000,
    "ga4_events": 200000,
}


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate Acme seed data")
    parser.add_argument("--output", type=Path, default=Path(__file__).parent,
                        help="Output root (default: this file's directory)")
    args = parser.parse_args()

    # TODO (build day 1): implement full generation matching ddl.sql
    # For each table:
    #   1. Generate rows using RNG (no external randomness)
    #   2. Honour the DQ-* deliberate quality issues from sow.md
    #      - DQ-1: ~4% Stripe ↔ Shopify email mismatch
    #      - DQ-2: ~12% Klaviyo events with NULL user_id (pre-2024 only)
    #      - DQ-3: ~0.5% Shipstation duplicate tracking_numbers
    #      - DQ-4: ~1% GA4 events with timestamps out-of-order by hours
    #   3. Write CSV to args.output / <system> / <table>.csv

    print("generate.py is a placeholder — implementation lands in build day 1.")
    print(f"Targets: {sum(TARGETS.values()):,} rows across {len(TARGETS)} tables.")
    print(f"Would write to: {args.output}")


if __name__ == "__main__":
    main()
