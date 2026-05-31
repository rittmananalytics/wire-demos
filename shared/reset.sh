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

if [ ! -d "$DEMO_DIR" ]; then
  echo "Error: demo dir not found: $DEMO_DIR" >&2
  exit 1
fi
if [ ! -d "$DEMO_DIR/_seed" ]; then
  echo "Error: no _seed in $DEMO_DIR" >&2
  exit 1
fi

# Wipe runtime state but never escape the demo dir
cd "$DEMO_DIR"
rm -rf .wire dbt/target dbt/logs dbt/dbt_packages dashboards semantic_layer warehouse.duckdb warehouse.duckdb.wal logs 2>/dev/null || true

# Restore from seed
# rsync preserves _seed contents into the demo root without copying _seed itself
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude='.gitkeep' "$DEMO_DIR/_seed/" "$DEMO_DIR/"
else
  # POSIX fallback
  (cd "$DEMO_DIR/_seed" && find . -mindepth 1 -maxdepth 1 ! -name '.gitkeep' -exec cp -R {} "$DEMO_DIR/" \;) 2>/dev/null || true
fi

echo "Reset: $DEMO_DIR_NAME"
