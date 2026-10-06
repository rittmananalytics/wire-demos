.PHONY: help setup doctor demo1 demo2 demo4 record-demo1 record-demo2 reset reset-demo1 reset-demo2 reset-demo4 validate clean

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
	@echo "  make demo4       Demo 4 — Release director, dashboard first, with Wire Studio (~20 min)"
	@echo ""
	@echo "Demos 1 and 2 replay a recorded run when one exists. To record again:"
	@echo "  make record-demo1  Run Demo 1 live and save every claude and dbt call"
	@echo "  make record-demo2  Run Demo 2 live and save every claude and dbt call"
	@echo ""
	@echo "Maintenance:"
	@echo "  make reset       Reset all demos to starting state"
	@echo "  make validate    Run validate.sh on demos 1 and 2 (CI)"
	@echo "  make clean       Reset + remove warehouse files and logs"
	@echo ""
	@echo "Environment:"
	@echo "  DEMO_MODE=interactive|auto|silent     (default: interactive)"
	@echo "  DEMO_SPEED=live|fast                  (default: live)"
	@echo "  DEMO_MODEL=haiku|sonnet|opus          (default: haiku)"
	@echo "  DEMO_RESET=true|false                 (default: true)"
	@echo "  DEMO_PLAYBACK=replay|live|record      (default: replay if recorded, else live)"
	@echo "  DEMO_REPLAY_SPEED=1|2|4               (default: 1, higher waits less)"

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

record-demo1: doctor
	@rm -rf demo1-full-lifecycle/recording
	@DEMO_PLAYBACK=record DEMO_MODE=auto DEMO_MODEL=$${DEMO_MODEL:-opus} bash demo1-full-lifecycle/demo1.sh

record-demo2: doctor
	@rm -rf demo2-fix-an-issue/recording
	@DEMO_PLAYBACK=record DEMO_MODE=auto DEMO_MODEL=$${DEMO_MODEL:-opus} bash demo2-fix-an-issue/demo2.sh

demo4: .venv
	@.venv/bin/python demo4-director-dashboard-first/demo.py play

reset: reset-demo1 reset-demo2 reset-demo4

reset-demo1:
	@bash shared/reset.sh demo1-full-lifecycle

reset-demo2:
	@bash shared/reset.sh demo2-fix-an-issue

reset-demo4:
	@.venv/bin/python demo4-director-dashboard-first/demo.py reset

validate:
	@bash demo1-full-lifecycle/validate.sh
	@bash demo2-fix-an-issue/validate.sh

clean: reset
	@rm -rf */logs */warehouse.duckdb */warehouse.duckdb.wal
	@echo "Cleaned generated state across all demos"
