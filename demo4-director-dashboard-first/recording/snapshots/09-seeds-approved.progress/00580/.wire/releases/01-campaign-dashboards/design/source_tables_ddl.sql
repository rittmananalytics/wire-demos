-- Source Tables DDL: Campaign Performance and Audience Engagement (Phase 1)
-- Client: Claybrook Media Group
-- Release: 01-campaign-dashboards (dashboard_first, seeded)
-- Generated: 2026-10-05
-- Dialect: BigQuery
--
-- These four tables are the Phase 1 seed files (campaign.csv, campaign_performance.csv,
-- article.csv, page_engagement.csv). They are loaded as dbt seeds, not live sources.
-- Phase 2 maps each to a live source (noted per table); that mapping is out of scope here.
-- All advertiser, agency, campaign, publication and article names are made up (R-1).

-- =============================================================================
-- campaign.csv  -- Campaign master
-- Phase 2 source: Google Ad Manager (orders / line items)
-- Grain: one row per campaign
-- =============================================================================
CREATE TABLE IF NOT EXISTS campaign (
    campaign_id            STRING    NOT NULL,   -- natural key
    campaign               STRING    NOT NULL,   -- campaign name (R-1)
    advertiser             STRING    NOT NULL,   -- advertiser name (R-1), attribute of campaign
    agency                 STRING,               -- agency name (R-1), attribute of campaign
    campaign_status        STRING    NOT NULL,   -- enum: Active, Paused, Completed, Pending
    publication            STRING    NOT NULL,   -- publication the campaign ran against (R-1)
    booking_start_date     DATE      NOT NULL,
    booking_end_date       DATE      NOT NULL,
    booked_impression_goal INT64     NOT NULL,
    rate_card_cpm_gbp      NUMERIC(10,2) NOT NULL  -- GBP
);

-- =============================================================================
-- campaign_performance.csv  -- Daily campaign delivery
-- Phase 2 source: Google Ad Manager (delivery report)
-- Grain: one row per campaign per day
-- References campaign.csv on campaign_id (FR-6, NFR-5)
-- =============================================================================
CREATE TABLE IF NOT EXISTS campaign_performance (
    campaign_id            STRING    NOT NULL,   -- FK -> campaign.campaign_id
    date                   DATE      NOT NULL,   -- delivery date
    impressions_delivered  INT64     NOT NULL,   -- non-negative
    impressions_eligible   INT64     NOT NULL,   -- non-negative; >= delivered for a valid fill rate
    revenue_gbp            NUMERIC(12,2) NOT NULL  -- GBP
);

-- =============================================================================
-- article.csv  -- Article master
-- Phase 2 source: content management system / GA4 content
-- Grain: one row per article
-- =============================================================================
CREATE TABLE IF NOT EXISTS article (
    article_id             STRING    NOT NULL,   -- natural key
    article                STRING    NOT NULL,   -- article title (R-1)
    publication            STRING    NOT NULL,   -- publication name (R-1)
    section                STRING    NOT NULL,   -- content section, attribute of article
    author                 STRING,
    publish_date           DATE      NOT NULL
);

-- =============================================================================
-- page_engagement.csv  -- Daily page engagement
-- Phase 2 source: Google Analytics 4
-- Grain: one row per article page per day (page is the grain, no Page entity, R-8)
-- References article.csv on article_id (FR-6, NFR-5)
-- Stores total_time_on_page_seconds (total, not a pre-computed average) and
-- page_views (the denominator), so the semantic layer computes a weighted average.
-- unique_readers is a daily per-page count; it must not be summed across days or
-- pages to give true unique readers (see data_model_specification.md section 4).
-- =============================================================================
CREATE TABLE IF NOT EXISTS page_engagement (
    article_id                 STRING  NOT NULL,   -- FK -> article.article_id
    date                       DATE    NOT NULL,   -- engagement date
    page_views                 INT64   NOT NULL,   -- non-negative
    sessions                   INT64   NOT NULL,   -- non-negative
    unique_readers             INT64   NOT NULL,   -- daily per-page count (upper bound if summed)
    total_time_on_page_seconds INT64   NOT NULL    -- total time, numerator for average time on page
);
