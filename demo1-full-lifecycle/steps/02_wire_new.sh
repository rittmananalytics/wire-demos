#!/usr/bin/env bash
# Step 2 — /wire:new — create the engagement and first release.
# claude -p can't answer AskUserQuestion prompts interactively, so we
# pass all required values inline AND insist on the v3.5 two-tier layout.

set -uo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/../../shared/narrator.sh"
source "$SCRIPT_DIR/../../shared/runner.sh"

section "Step 2 / 20 — /wire:new — engagement setup"

narrate_long <<'EOF'
/wire:new scaffolds the engagement. It creates the .wire/ folder
structure, the engagement context, and the first release. Interactively
it asks ~9 questions; we'll provide all the answers up front so it can
run without prompting, and we'll insist on the v3.5 two-tier layout.
EOF
pause

NEW_PROMPT='Create a new Wire engagement using the v3.5+ two-tier layout. Do NOT use the pre-v3.4 flat .wire/<project_id>/ structure — use the new engagement/releases structure.

Specifically, create exactly this layout:

  .wire/
    engagement/
      context.md            ← engagement-level context (from TEMPLATES/engagement-context-template.md)
      sow.md                ← copy from shared/client/sow.md
      calls/.gitkeep
      org/.gitkeep
    releases/
      01-data-foundation/
        status.md           ← from TEMPLATES/status-template.md, type: full_platform
        requirements/.gitkeep
        design/.gitkeep
        dev/.gitkeep
        test/.gitkeep
        deploy/.gitkeep
        enablement/.gitkeep
        artifacts/.gitkeep
        planning/.gitkeep
    research/
      sessions/.gitkeep

Engagement values:
- client_name: Acme Coffee Roasters
- engagement_name: acme_coffee_data_platform
- engagement_lead: Mark Rittman (demo)
- repo_mode: combined
- release_id: 20260531
- release_name: 01-data-foundation
- release_type: full_platform

Skip the git branch check (do not create a feature branch — this is a demo). Skip Jira / Linear / Confluence / Notion. Skip /wire:new'\''s interactive prompts entirely; just write the files using Wire'\''s standard templates with the values above.

Do NOT create any .wire/<project_id>/ folder — that is the deprecated flat layout. Use ONLY the engagement/releases two-tier structure.

After you'\''re done, run `ls -laR .wire/` and show me the output.'

run_wire "$NEW_PROMPT"
