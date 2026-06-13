#!/usr/bin/env bash
# Step 1 — Introduce Wire Agents and the demo scenario.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 1 / 7 — Wire Agents: Auto-delegation and Fan-out"

narrate_long <<'EOF'
Wire Agents (introduced in v3.9) replaces the single-agent delivery model
with twelve named specialist agents — each with a focused brief and
defined out-of-scope declarations.

Three capabilities are visible in this demo:

  1. AUTO-DELEGATION
     Any individual /wire:generate command delegates automatically to the
     appropriate specialist agent. The main session launches the subagent
     and returns control only after it completes.

  2. /wire:delegate — BATCH DISPATCH
     Reads status.md, identifies all pending artifacts, computes a
     parallel/sequential plan, and presents it for approval before
     spawning any agents.

  3. FAN-OUT FOR LARGE MODEL SETS
     When a dbt layer has more than 5 models, /wire:delegate splits the
     layer into batches of 5 and runs one dbt-developer agent per batch
     in parallel. Layers remain sequential; within each layer, every
     batch agent runs concurrently.

The client is Peak Retail Group — a UK D2C outdoor apparel retailer.
We start after the design phase: requirements, conceptual model, pipeline
design, and data model are all approved. 23 models await generation across
staging (11), integration (3), and warehouse (9) layers. That is enough
to trigger fan-out in both the staging and warehouse layers.
EOF

pause
