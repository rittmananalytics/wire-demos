.PHONY: help setup doctor demo1 demo2 demo3 demo4 reset reset-demo1 reset-demo2 reset-demo3 reset-demo4 validate clean

SHELL := /bin/bash

help:
	@echo "Wire Framework Demos"
	@echo ""
	@echo "First-time setup:"
	@echo "  make setup       Install all prereqs (Python venv + dbt-duckdb + optional tools)"
	@echo "  make doctor      Verify prereqs are in place"
	@echo ""
	@echo "Run a demo:"
	@echo "  make demo1       Demo 1 — Full lifecycle (~10 min)"
	@echo "  make demo2       Demo 2 — Fix an issue (~5 min)"
	@echo "  make demo3       Demo 3 — Dashboard-first (~14 min)"
	@echo "  make demo4       Demo 4 — Wire Agents: auto-delegation and fan-out (~3/15 min)"
	@echo ""
	@echo "Maintenance:"
	@echo "  make reset       Reset all three demos to starting state"
	@echo "  make validate    Run validate.sh on all three demos (CI)"
	@echo "  make clean       Reset + remove warehouse files and logs"
	@echo ""
	@echo "Environment:"
	@echo "  DEMO_MODE=interactive|auto|silent     (default: interactive)"
	@echo "  DEMO_SPEED=live|fast                  (default: live)"
	@echo "  DEMO_MODEL=haiku|sonnet|opus          (default: haiku)"
	@echo "  DEMO_RESET=true|false                 (default: true)"

setup:
	@bash setup.sh

# doctor depends on setup having been run (idempotent — setup is fast if already done)
doctor: .venv
	@bash doctor.sh

# .venv is the sentinel that proves setup has run successfully
.venv:
	@echo "▸ .venv/ not present — running setup first"
	@bash setup.sh

demo1: doctor
	@bash demo1-full-lifecycle/demo1.sh

demo2: doctor
	@bash demo2-fix-an-issue/demo2.sh

demo3: doctor
	@bash demo3-dashboard-first/demo3.sh

demo4: doctor
	@bash demo4-wire-agents/demo4.sh

reset: reset-demo1 reset-demo2 reset-demo3 reset-demo4

reset-demo1:
	@bash shared/reset.sh demo1-full-lifecycle

reset-demo2:
	@bash shared/reset.sh demo2-fix-an-issue

reset-demo3:
	@bash shared/reset.sh demo3-dashboard-first

reset-demo4:
	@bash shared/reset.sh demo4-wire-agents

validate:
	@bash demo1-full-lifecycle/validate.sh
	@bash demo2-fix-an-issue/validate.sh
	@bash demo3-dashboard-first/validate.sh
	@bash demo4-wire-agents/validate.sh

clean: reset
	@rm -rf */logs */warehouse.duckdb */warehouse.duckdb.wal
	@echo "Cleaned generated state across all demos"
