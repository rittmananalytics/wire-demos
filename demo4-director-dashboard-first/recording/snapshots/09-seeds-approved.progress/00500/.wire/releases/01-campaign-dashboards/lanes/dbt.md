# Lane: dbt

Release: 01-campaign-dashboards
Task: /wire:dbt-generate 01-campaign-dashboards, then /wire:dbt-validate 01-campaign-dashboards (dbt seed, dbt build on local DuckDB)
Owns: dbt/, .wire/releases/01-campaign-dashboards/dev/dbt_*.md, .wire/releases/01-campaign-dashboards/lanes/dbt.md
Dispatched: 2026-10-05 20:56 by orchestrator [910893ca]

## Items
- [ ] dbt project scaffold with DuckDB profile
- [ ] seeds copied from dev/seed_data
- [ ] staging models (2)
- [ ] warehouse models (5) with 18 tests
- [ ] dbt seed
- [ ] dbt build
- [ ] validate checks

state: dispatched, waiting for lane to start
