-- Source-system DDL for Acme Coffee Roasters
-- These are the schemas Wire's pipeline-design and dbt-generate commands
-- read as their source-of-truth for the staging layer.
-- All tables land in DuckDB during the demos as csv seeds (see sources/*/*.csv).

-- ─────────────────────────────────────────────────────────────────────────
-- Shopify
-- ─────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS shopify_customers (
  id              BIGINT PRIMARY KEY,
  email           VARCHAR,
  first_name      VARCHAR,
  last_name       VARCHAR,
  country_code    VARCHAR(2),
  accepts_marketing BOOLEAN,
  created_at      TIMESTAMP,
  updated_at      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shopify_orders (
  id              BIGINT PRIMARY KEY,
  customer_id     BIGINT,
  email           VARCHAR,            -- guest orders have customer_id NULL but email set
  order_number    VARCHAR,
  financial_status VARCHAR,
  fulfillment_status VARCHAR,
  total_price     DECIMAL(10,2),
  currency        VARCHAR(3),
  market          VARCHAR(20),        -- 'uk' | 'ie' | 'fr' | 'de'
  created_at      TIMESTAMP,
  updated_at      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shopify_order_lines (
  id              BIGINT PRIMARY KEY,
  order_id        BIGINT,
  product_id      BIGINT,
  variant_id      BIGINT,
  quantity        INTEGER,
  price           DECIMAL(10,2),
  total_discount  DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS shopify_products (
  id              BIGINT PRIMARY KEY,
  title           VARCHAR,
  product_type    VARCHAR,            -- 'coffee' | 'gift_box' | 'accessory' | 'subscription'
  vendor          VARCHAR,
  created_at      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shopify_subscriptions (
  id              BIGINT PRIMARY KEY,
  customer_id     BIGINT,
  product_id      BIGINT,
  status          VARCHAR,            -- 'active' | 'paused' | 'cancelled' | 'failed'
  frequency_weeks INTEGER,            -- 2 | 4 | 8
  started_at      TIMESTAMP,
  paused_at       TIMESTAMP,
  cancelled_at    TIMESTAMP,
  cancellation_reason_top VARCHAR,    -- 'price' | 'delivery' | 'consumption'
  cancellation_reason_sub VARCHAR
);

-- ─────────────────────────────────────────────────────────────────────────
-- Stripe
-- ─────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS stripe_customers (
  id              VARCHAR PRIMARY KEY,
  email           VARCHAR,
  shopify_customer_id BIGINT,         -- metadata link; NULL pre-2023
  created         TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stripe_charges (
  id              VARCHAR PRIMARY KEY,
  customer_id     VARCHAR,
  amount          DECIMAL(10,2),
  currency        VARCHAR(3),
  status          VARCHAR,            -- 'succeeded' | 'failed' | 'refunded'
  refunded        BOOLEAN,
  amount_refunded DECIMAL(10,2),
  created         TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stripe_subscriptions (
  id              VARCHAR PRIMARY KEY,
  customer_id     VARCHAR,
  status          VARCHAR,            -- 'active' | 'past_due' | 'canceled' | 'unpaid'
  current_period_start TIMESTAMP,
  current_period_end   TIMESTAMP,
  cancel_at_period_end BOOLEAN,
  canceled_at     TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stripe_invoices (
  id              VARCHAR PRIMARY KEY,
  customer_id     VARCHAR,
  subscription_id VARCHAR,
  amount_paid     DECIMAL(10,2),
  status          VARCHAR,
  created         TIMESTAMP
);

-- ─────────────────────────────────────────────────────────────────────────
-- Klaviyo
-- ─────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS klaviyo_events (
  id              VARCHAR PRIMARY KEY,
  user_id         VARCHAR,            -- maps to shopify_customers.id; NULL ~12% pre-2024
  event_name      VARCHAR,            -- 'Email Sent' | 'Opened Email' | 'Clicked Email' | etc
  campaign_id     VARCHAR,
  flow_id         VARCHAR,
  timestamp       TIMESTAMP
);

CREATE TABLE IF NOT EXISTS klaviyo_campaigns (
  id              VARCHAR PRIMARY KEY,
  name            VARCHAR,
  send_time       TIMESTAMP,
  channel         VARCHAR             -- 'email' | 'sms'
);

CREATE TABLE IF NOT EXISTS klaviyo_flows (
  id              VARCHAR PRIMARY KEY,
  name            VARCHAR,
  trigger_event   VARCHAR
);

CREATE TABLE IF NOT EXISTS klaviyo_lists (
  id              VARCHAR PRIMARY KEY,
  name            VARCHAR
);

-- ─────────────────────────────────────────────────────────────────────────
-- Shipstation
-- ─────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS shipstation_shipments (
  id              BIGINT PRIMARY KEY,
  order_id        BIGINT,             -- maps to shopify_orders.id
  tracking_number VARCHAR,
  carrier         VARCHAR,            -- 'royal_mail' | 'dpd' | 'dhl' | 'parcelforce'
  service_level   VARCHAR,            -- 'standard' | 'next_day' | 'express'
  shipped_at      TIMESTAMP,
  delivered_at    TIMESTAMP,
  created_at      TIMESTAMP           -- duplicates exist; dedupe on tracking_number, take min(created_at)
);

CREATE TABLE IF NOT EXISTS shipstation_tracking_events (
  id              BIGINT PRIMARY KEY,
  shipment_id     BIGINT,
  event_type      VARCHAR,            -- 'picked_up' | 'in_transit' | 'out_for_delivery' | 'delivered'
  event_at        TIMESTAMP
);

-- ─────────────────────────────────────────────────────────────────────────
-- GA4 (BigQuery export shape, simplified)
-- ─────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS ga4_sessions (
  session_id      VARCHAR PRIMARY KEY,
  user_id         VARCHAR,            -- NULL pre-2024
  session_start   TIMESTAMP,
  source          VARCHAR,            -- 'google' | 'meta' | 'klaviyo' | 'direct' | 'referral'
  medium          VARCHAR,            -- 'cpc' | 'organic' | 'email' | 'paid_social' | etc
  campaign        VARCHAR,
  device          VARCHAR             -- 'mobile' | 'desktop' | 'tablet'
);

CREATE TABLE IF NOT EXISTS ga4_events (
  event_id        VARCHAR PRIMARY KEY,
  session_id      VARCHAR,
  user_id         VARCHAR,
  event_name      VARCHAR,            -- 'page_view' | 'add_to_cart' | 'purchase' | etc
  event_timestamp TIMESTAMP,
  page_path       VARCHAR
);
