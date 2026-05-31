#!/usr/bin/env bash
# reset.sh <demo-dir> — restore a demo's working state from its _seed/.
# Safe: only touches paths inside the named demo dir.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <demo-dir>" >&2
  echo "  e.g. $0 demo1-full-lifecycle" >&2
  exit 2
fi

DEMO_DIR_NAME="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
DEMO_DIR="$REPO_ROOT/$DEMO_DIR_NAME"
SEED_DIR="$REPO_ROOT/_seeds/$DEMO_DIR_NAME"

# Seeds live OUTSIDE the demo dir (at repo-root /_seeds/<demo>/) so Wire's
# engagement-context skill can't accidentally discover them and write back
# to the seed instead of the working copy.

if [ ! -d "$DEMO_DIR" ]; then
  echo "Error: demo dir not found: $DEMO_DIR" >&2
  exit 1
fi
if [ ! -d "$SEED_DIR" ]; then
  echo "Error: no seed dir at $SEED_DIR" >&2
  exit 1
fi

# Wipe runtime state but never escape the demo dir
cd "$DEMO_DIR"
rm -rf .wire dbt/target dbt/logs dbt/dbt_packages dashboards semantic_layer logs 2>/dev/null || true
# DuckDB files can land at the demo root OR inside dbt/ depending on where dbt was invoked.
rm -f warehouse.duckdb warehouse.duckdb.wal dbt/warehouse.duckdb dbt/warehouse.duckdb.wal 2>/dev/null || true
# Also wipe any dbt/ that's a copy from a previous run — restored fresh from seed below.
rm -rf dbt 2>/dev/null || true

# Restore from seed (read-only source of truth)
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude='.gitkeep' "$SEED_DIR/" "$DEMO_DIR/"
else
  (cd "$SEED_DIR" && find . -mindepth 1 -maxdepth 1 ! -name '.gitkeep' -exec cp -R {} "$DEMO_DIR/" \;) 2>/dev/null || true
fi

echo "Reset: $DEMO_DIR_NAME (from _seeds/$DEMO_DIR_NAME)"
