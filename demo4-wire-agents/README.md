# Demo 4 — Wire Agents: Auto-delegation and Fan-out

Shows three Wire Agents capabilities in a single 7-step run against a DuckDB warehouse.

**Release type**: `full_platform`  
**Client**: Peak Retail Group (UK D2C outdoor apparel)  
**Time**: ~3 min (`DEMO_SPEED=fast`) / ~15 min (`DEMO_SPEED=live`, Haiku)

## Run it

```bash
make demo4
```

Fast mode (no LLM calls — shows plan + pre-rendered output):

```bash
DEMO_SPEED=fast make demo4
```

## What it shows

| Step | Feature | What you see |
|---|---|---|
| 1 | Intro | Wire Agents overview — 3 capabilities explained |
| 2 | Release state | `/wire:status` — 4 design artifacts approved, development pending |
| 3 | Auto-delegation | `/wire:dbt-generate` shows the "→ delegating to dbt-developer agent" handoff |
| 4 | Delegation plan | `/wire:delegate` computes the fan-out plan — 6 agents across 3 waves |
| 5 | Staging wave | 3 `dbt-developer` agents run **in parallel** (Wave 2a) |
| 6 | Integration + warehouse | 1 integration agent → then 2 warehouse agents in parallel (Waves 2b + 2c) |
| 7 | Results | Model count, `decisions.md` entries, `dbt build` confirmation |

## The fan-out arithmetic

With 11 staging models and 9 warehouse models:

```
Staging (11 > 5 threshold)   → 3 agents  [4 + 4 + 3 models]  ← run in parallel
Integration (3 ≤ threshold)  → 1 agent   [3 models]           ← runs after staging completes
Warehouse (9 > 5 threshold)  → 2 agents  [5 + 4 models]       ← run in parallel
─────────────────────────────────────────────────────────────────
Total dbt-developer agents: 6  (3 + 1 + 2)
```

## Layout

```
demo4-wire-agents/
├── demo4.sh              # Entry point
├── steps/                # 7 step scripts
├── snapshots/            # Pre-rendered output for DEMO_SPEED=fast
├── expected_artifacts/   # Golden snapshot for validate.sh
└── validate.sh           # Post-run validation

_seeds/demo4-wire-agents/
├── .wire/                # Pre-built design artifacts (approved)
│   ├── engagement/context.md
│   └── releases/01-peak-retail-analytics/
│       ├── status.md          (all design phases: approved)
│       ├── decisions.md       (2 pre-existing design decisions)
│       └── artifacts/
│           ├── requirements/requirements.md
│           ├── conceptual_model/conceptual_model.md
│           └── data_model/data_model.md
└── dbt/
    ├── dbt_project.yml
    ├── models/_sources.yml
    └── seeds/             (13 CSV files across Shopify, NetSuite, Klaviyo, GA4)
```

## Source data

13 seed CSVs covering 9 source tables. Row counts are small (10–20 rows per table)
to keep `dbt seed` fast. The data is fictional but internally consistent — FK references
between Shopify orders and order items, Klaviyo event → campaign → Shopify order chains,
and NetSuite transaction → Shopify order reconciliation all hold.

## Environment variables

| Variable | Default | Effect |
|---|---|---|
| `DEMO_SPEED` | `live` | `fast` skips LLM calls and shows snapshots; `live` runs real parallel agents |
| `DEMO_MODEL` | `haiku` | Model to use for live mode — `haiku` is fast, `sonnet` has higher fidelity |
| `DEMO_MODE` | `interactive` | `auto` removes pause prompts for CI/recording |
| `DEMO_RESET` | `true` | `false` preserves state between runs (useful for debugging) |
