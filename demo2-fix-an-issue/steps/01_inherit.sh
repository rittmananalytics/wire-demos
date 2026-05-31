#!/usr/bin/env bash
# Step 1 — Inherit the in-flight project.
# reset.sh has already restored _seed/.wire and _seed/dbt into the demo dir.
# This step just narrates what we just inherited and shows the file tree.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 1 / 9 — Inherit the in-flight project"

narrate_long <<'EOF'
You've just walked into an Acme Coffee Roasters engagement that's already
in flight. The previous consultant generated a dbt project and ran the Wire
validator, which flagged something. We're going to investigate, fix it,
and sign off.

Here's what was already on disk before we started:
EOF

echo ""
echo "  .wire/"
echo "    engagement/        — context + signed SoW"
echo "    releases/01-marketing-mart/"
echo "      status.md        — release tracking"
echo "      requirements/    — approved spec"
echo "      design/          — approved data model"
echo "      execution_log.md — every command run on this release"
echo ""
echo "  dbt/"
echo "    dbt_project.yml"
echo "    models/staging/shopify/      — 2 staging models"
echo "    models/integration/          — 1 integration model"
echo "    models/warehouse/            — dim_customer + fct_orders"
echo "    seeds/                       — 10 customers, 20 orders"
echo ""

pause
