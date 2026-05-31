# Wire Framework Demos

Three self-contained demos of the [Wire Framework](https://github.com/rittmananalytics/wire-plugin). Each one runs locally against a bundled DuckDB warehouse, drives Claude Code headlessly, and narrates itself as it goes.

| Demo | Release type | Time | What it shows |
|---|---|---|---|
| [Demo 1 — Full lifecycle](demo1-full-lifecycle/) | `full_platform` | ~10 min | Install → engagement setup → playbook → requirements → design → dbt → planted fault → fix → semantic layer → dashboard mockup |
| [Demo 2 — Fix an issue](demo2-fix-an-issue/) | `dbt_development` | ~5 min | `/wire:start` on an in-flight project → `dbt-validate` catches a Wire convention violation → fix → re-validate |
| [Demo 3 — Dashboard-first](demo3-dashboard-first/) | `dashboard_first` | ~14 min | Mockups → viz catalog → data model → seed data → dbt → semantic layer → dashboards → real-data refactor |

The full design spec for these demos lives in the Wire framework repo at [`wire/docs/wire-demos-build-playbook.md`](https://github.com/rittmananalytics/wire/blob/main/wire/docs/wire-demos-build-playbook.md).

---

## Prerequisites

| Tool | Version | Purpose |
|---|---|---|
| [Claude Code](https://docs.claude.com/en/docs/claude-code) | Latest | Runs Wire commands headlessly via `claude -p` |
| Wire plugin | `@3.5.4` (pinned) | The framework itself; installed by Demo 1 |
| Python | 3.11+ | Seed data generator |
| [dbt-duckdb](https://github.com/duckdb/dbt-duckdb) | 1.8+ | Local warehouse engine |
| `bash` | 4+ | Runner / narrator scripts |
| `gh` (optional) | Latest | For cloning if you don't already have the repo |
| `bat` or `glow` (optional) | Any | Prettier file rendering during narration |

Run `make doctor` to verify everything is in place before starting a demo.

---

## Quick start

```bash
git clone https://github.com/rittmananalytics/wire-demos.git
cd wire-demos
make doctor       # Verify prereqs
make demo1        # Run the full-lifecycle demo
```

Each demo is fully isolated under its own folder and re-runnable. `make reset` wipes generated state and restores starting conditions.

---

## Environment variables

| Variable | Default | Effect |
|---|---|---|
| `DEMO_MODE` | `interactive` | `interactive` pauses after each narrator block; `auto` runs straight through; `silent` skips narration |
| `DEMO_SPEED` | `live` | `live` runs every Wire command; `fast` uses pre-generated artifacts for slow design steps |
| `DEMO_MODEL` | `haiku` | Routes `claude -p` through Haiku 4.5 by default for speed/cost; set to `sonnet` for higher fidelity |
| `DEMO_RESET` | `true` | Reset working state at start of each demo; `false` to keep state between runs (useful for debugging) |

Example — running Demo 1 in headless CI mode:

```bash
DEMO_MODE=auto DEMO_SPEED=fast make demo1
```

---

## Repo layout

```
wire-demos/
├── shared/                   # Narrator, runner, DuckDB profile, Acme client materials
├── demo1-full-lifecycle/     # Full platform demo
├── demo2-fix-an-issue/       # Existing-project fix demo
└── demo3-dashboard-first/    # Dashboard-first demo
```

See each demo folder's README for step-by-step detail.

---

## The synthesized client — Acme Coffee Roasters

All three demos run against the same fictional D2C subscription coffee business. Five source systems (Shopify, Stripe, Klaviyo, Shipstation, GA4), ~115k rows of seed data, deterministically generated. Full SoW, three call transcripts, and a stakeholder map ship in `shared/client/`.

---

## Telemetry note

These demos call `claude -p`, which emits prompt telemetry to the `ra-development` project (the same source that powers Wire usage reviews). If you don't want demo runs in that telemetry, set `DEMO_TELEMETRY=false` before running — the runner will set the relevant env var that disables the Wire logging hook.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `claude: command not found` | Claude Code not installed or not on PATH | Install Claude Code, then `which claude` to confirm |
| `Wire plugin not found` | Marketplace not added, or different plugin version | `/plugin marketplace add rittmananalytics/wire-plugin && /plugin install wire@rittman-analytics` |
| `dbt: connection failed` | Wrong profile path | The Makefile sets `--profiles-dir shared/profiles` automatically; check that file isn't missing |
| Demo hangs on a review step | Auto-approve isn't intercepting | Run with `DEMO_MODE=auto`; check `shared/auto_approve.sh` is sourced |
| LLM output looks different from `expected_artifacts/` | LLM nondeterminism — expected | Validation is structure-tolerant. Run `validate.sh` rather than diffing files directly |

---

## Licence

MIT.
