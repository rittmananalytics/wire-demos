-- Target Warehouse DDL: Campaign Performance and Audience Engagement (Phase 1)
-- Client: Claybrook Media Group
-- Release: 01-campaign-dashboards (dashboard_first, seeded)
-- Generated: 2026-10-05
-- Dialect: BigQuery
--
-- The dimensional model the dbt warehouse layer builds and the LookML explores read.
-- Three dimensions (campaign_dim, content_dim, date_dim) and two facts
-- (campaign_performance_fct, page_engagement_fct). The two facts share date_dim
-- but have no join path to each other (Phase 1 scope boundary).
-- Calculated measures (fill_rate_pct, cpm_gbp, active_campaign_count,
-- avg_time_on_page_seconds) are defined in the semantic layer, not stored here.

-- =============================================================================
-- campaign_dim  -- one row per campaign
-- Built from the campaign seed. publication is carried as an independent attribute
-- here and on content_dim (no shared publication dimension in Phase 1).
-- =============================================================================
CREATE TABLE IF NOT EXISTS campaign_dim (
    campaign_pk            STRING    NOT NULL,   -- surrogate key: md5(campaign_id)
    campaign_id            STRING    NOT NULL,   -- natural key
    campaign               STRING    NOT NULL,
    advertiser             STRING    NOT NULL,
    agency                 STRING,
    campaign_status        STRING    NOT NULL,   -- Active, Paused, Completed, Pending
    publication            STRING    NOT NULL,
    booking_start_date     DATE      NOT NULL,
    booking_end_date       DATE      NOT NULL,
    booked_impression_goal INT64     NOT NULL,
    rate_card_cpm_gbp      NUMERIC(10,2) NOT NULL,
    dbt_updated_at         TIMESTAMP NOT NULL
);

-- =============================================================================
-- content_dim  -- one row per article
-- Page is the grain of engagement (R-8); article-level reporting rolls the
-- page-grain fact up to the article. No separate Page entity.
-- =============================================================================
CREATE TABLE IF NOT EXISTS content_dim (
    content_pk     STRING    NOT NULL,   -- surrogate key: md5(article_id)
    article_id     STRING    NOT NULL,   -- natural key
    article        STRING    NOT NULL,
    publication    STRING    NOT NULL,
    section        STRING    NOT NULL,
    author         STRING,
    publish_date   DATE      NOT NULL,
    dbt_updated_at TIMESTAMP NOT NULL
);

-- =============================================================================
-- date_dim  -- one row per calendar day
-- Generated date spine over the seed date range (no seed file).
-- week_start_date backs the week-grain campaign trend charts.
-- =============================================================================
CREATE TABLE IF NOT EXISTS date_dim (
    date_day           DATE      NOT NULL,   -- primary key
    day_of_week        STRING    NOT NULL,
    day_of_week_number INT64     NOT NULL,
    week_start_date    DATE      NOT NULL,   -- Monday of the week
    iso_week           INT64     NOT NULL,
    month              INT64     NOT NULL,
    month_name         STRING    NOT NULL,
    quarter            INT64     NOT NULL,
    year               INT64     NOT NULL,
    dbt_updated_at     TIMESTAMP NOT NULL
);

-- =============================================================================
-- campaign_performance_fct  -- one row per campaign per day
-- Stores measure components only. fill_rate_pct and cpm_gbp are semantic-layer
-- calculated measures (aggregate-aware, computed from summed components).
-- =============================================================================
CREATE TABLE IF NOT EXISTS campaign_performance_fct (
    campaign_performance_pk STRING    NOT NULL,   -- surrogate key: md5(campaign_id, date)
    campaign_fk             STRING    NOT NULL,   -- FK -> campaign_dim.campaign_pk
    date_day                DATE      NOT NULL,   -- FK -> date_dim.date_day
    impressions_delivered   INT64     NOT NULL,
    impressions_eligible    INT64     NOT NULL,
    revenue_gbp             NUMERIC(12,2) NOT NULL,
    dbt_updated_at          TIMESTAMP NOT NULL
);

-- =============================================================================
-- page_engagement_fct  -- one row per article page per day
-- Stores total_time_on_page_seconds (numerator) and page_views (denominator) so
-- avg_time_on_page_seconds is a weighted ratio in the semantic layer.
-- unique_readers is a daily per-page count; summing it gives a daily-unique upper
-- bound, not true distinct readers.
-- =============================================================================
CREATE TABLE IF NOT EXISTS page_engagement_fct (
    page_engagement_pk         STRING    NOT NULL,   -- surrogate key: md5(article_id, date)
    content_fk                 STRING    NOT NULL,   -- FK -> content_dim.content_pk
    date_day                   DATE      NOT NULL,   -- FK -> date_dim.date_day
    page_views                 INT64     NOT NULL,
    sessions                   INT64     NOT NULL,
    unique_readers             INT64     NOT NULL,
    total_time_on_page_seconds INT64     NOT NULL,
    dbt_updated_at             TIMESTAMP NOT NULL
);
