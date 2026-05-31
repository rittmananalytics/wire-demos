.PHONY: help doctor demo1 demo2 demo3 reset reset-demo1 reset-demo2 reset-demo3 validate clean

SHELL := /bin/bash

help:
	@echo "Wire Framework Demos"
	@echo ""
	@echo "Targets:"
	@echo "  make doctor      Verify prereqs (claude, dbt, python, gh)"
	@echo "  make demo1       Run Demo 1 — Full lifecycle (~10 min)"
	@echo "  make demo2       Run Demo 2 — Fix an issue (~5 min)"
	@echo "  make demo3       Run Demo 3 — Dashboard-first (~14 min)"
	@echo "  make reset       Reset all three demos to starting state"
	@echo "  make validate    Run validate.sh on all three demos (CI)"
	@echo ""
	@echo "Environment:"
	@echo "  DEMO_MODE=interactive|auto|silent     (default: interactive)"
	@echo "  DEMO_SPEED=live|fast                  (default: live)"
	@echo "  DEMO_MODEL=haiku|sonnet|opus          (default: haiku)"
	@echo "  DEMO_RESET=true|false                 (default: true)"

doctor:
	@bash doctor.sh

demo1: doctor
	@bash demo1-full-lifecycle/demo1.sh

demo2: doctor
	@bash demo2-fix-an-issue/demo2.sh

demo3: doctor
	@bash demo3-dashboard-first/demo3.sh

reset: reset-demo1 reset-demo2 reset-demo3

reset-demo1:
	@bash shared/reset.sh demo1-full-lifecycle

reset-demo2:
	@bash shared/reset.sh demo2-fix-an-issue

reset-demo3:
	@bash shared/reset.sh demo3-dashboard-first

validate:
	@bash demo1-full-lifecycle/validate.sh
	@bash demo2-fix-an-issue/validate.sh
	@bash demo3-dashboard-first/validate.sh

clean: reset
	@rm -rf */logs */warehouse.duckdb
	@echo "Cleaned generated state across all demos"
