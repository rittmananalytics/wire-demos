---
engagement_name: "claybrook_media_group"
client_name: "Claybrook Media Group"
created_date: "2026-10-05"
engagement_lead: "Mark Rittman"
repo_mode: "combined"  # combined | dedicated_delivery

# If repo_mode is dedicated_delivery, provide client repo details:
client_repo:
  github_url: null
  local_path: null
  default_branch: "main"

docstore:
  provider: null  # confluence | notion | both | null
  confluence:
    space_key: null
    parent_page_url: null
  notion:
    parent_page_url: null

data_model_registry:
  vertical: null  # any directory name under the registry's verticals/ (13 at the time
                  # of writing). Run `ls ~/.wire/data-model-registry/verticals/` for
                  # the current set, or leave null.
                  # May be a confident match, or the closest adjacent match when no vertical is an
                  # exact industry fit (e.g. subscription-commerce for a SaaS client's MRR/NRR model).
                  # Advisory only — see wire/schemas/data-model-registry.md. null (the default)
                  # means data_model-generate/validate behave exactly as if this didn't exist.
  cross_vertical_schemas: []  # e.g. [crm_identity_resolution, finance_revenue_recognition] — accepted independently
                  # of any vertical match; a client can need these whether or not `vertical` above is set.

# How Wire is driven on this engagement (specs/utils/director_operating_model.md).
#   orchestrated — the release-director skill turns your direction into Wire
#                  command runs, dispatches lanes, and stops at decisions. The
#                  default on Claude Code. Typed commands keep working.
#   manual       — today's behaviour: /wire:start prints the next action and
#                  stops, you type the commands. Use it for client-side teams
#                  and regulated engagements.
# Per-session override: say "you drive" to hand control back for that session.
# Gemini CLI resolves to manual regardless: it has no skills or agents.
orchestration:
  mode: orchestrated  # orchestrated | manual

fathom_sync:
  enabled: false  # true | false — resolved at /wire:new Step 2 from the client domain given;
                  # false if no domain was given, or if the domain/client_name looked like an internal RA
                  # engagement (Fathom Sync refuses to enable itself in that case — see fathom_sync.md).
  client_domain: null  # required for enabled: true — matches calendar invitees on each
                  # call, so only meetings this specific client attended get pulled in. Never rittmananalytics.com.
  last_synced: null    # ISO date; updated automatically after each sync, drives the incremental --after window
---

# Engagement Context: claybrook_media_group

**Client**: Claybrook Media Group
**Engagement Lead**: Mark Rittman
**Created**: 2026-10-05
**Repo mode**: combined

---

## Engagement Overview

Claybrook Media Group is a media publisher with an advertising sales team. It has no data platform today.

Phase 1 delivers campaign performance and audience engagement dashboards in Looker, built on seed data. The commercial director must approve the dashboard mockups in writing before any dbt or LookML work starts.

Phase 2 (a separate SOW) will move the seed layer to live Google Ad Manager (GAM) and Google Analytics 4 (GA4) data through Fivetran.

## Business Objectives

1. Give the advertising sales team campaign performance dashboards (delivery, fill rate, CPM).
2. Give the team audience engagement dashboards at article and page level.
3. Prepare a seed-to-source mapping so Phase 2 can switch to live GAM and GA4 data without redesign.

## Key Stakeholders

| Name | Role | Responsibilities | Contact |
|------|------|------------------|---------|
| TBC | Commercial director, Claybrook | Approves mockups in writing; sole sign-off authority | TBC |
| Mark Rittman | Engagement lead, Rittman Analytics | Release director; delivery and approvals routing | mark.rittman@rittmananalytics.com |

## Current State Architecture

No data platform exists. Assumed available before Day 6: a Looker instance, a BigQuery project and a dbt Cloud account.

**Key systems**:
- Google Ad Manager: ad serving source for Phase 2
- Google Analytics 4: web engagement source for Phase 2

## Engagement Releases

| # | Release Name | Type | Status | Start | End |
|---|-------------|------|--------|-------|-----|
| 01 | campaign-dashboards | dashboard_first (seeded) | In progress | 2026-10-05 | |

## SOW Reference

Statement of Work: `engagement/sow.md`

- Time and materials, 10 working days.
- Up to 3 mockup review rounds, one business day turnaround each.
- Acceptance: written mockup approval before build; `dbt seed && dbt run` with zero errors and all 18 dbt tests passing; Looker dashboards match the approved mockups; Phase 2 scope agreed before close.
- Out of scope: Fivetran setup, live GAM and GA4 data, end-user training and documentation, CMS integration.

## Working Agreements

- **Delivery mode**: orchestrated. Each piece of work runs as a lane visible in Wire Studio; the orchestrator stops at each approval point.
- **Issue tracking**: none (status.md only). No Jira, Linear, document store or Fathom sync.
- **Sample data**: all advertiser and publication names in mockups and seed data are made up (ruling R-1, `releases/01-campaign-dashboards/decisions.md`).
- **Primary contact**: commercial director (name TBC).

## Client Repo Details

This engagement uses the combined client + delivery repo. The `.wire/` folder lives directly in the client's code repo.

## Notes

None yet.
