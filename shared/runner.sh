#!/usr/bin/env bash
# runner.sh — sourced by every demo step.
# Provides: run_wire, run_dbt, demo_init, demo_log_dir.
# Wraps `claude -p` and `dbt` with logging, error handling, and model routing.

if [ -n "${__WIRE_DEMOS_RUNNER_LOADED:-}" ]; then return 0 2>/dev/null || exit 0; fi
__WIRE_DEMOS_RUNNER_LOADED=1

# Resolve repo root (parent of this script's parent)
__RUNNER_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WIRE_DEMOS_ROOT="$( cd "$__RUNNER_SCRIPT_DIR/.." && pwd )"
export WIRE_DEMOS_ROOT

# Source narrator (idempotent)
source "$__RUNNER_SCRIPT_DIR/narrator.sh"

# Activate the local venv if present so dbt and any Python tools are on PATH.
# Idempotent: re-sourcing the activate script is harmless.
if [ -f "$WIRE_DEMOS_ROOT/.venv/bin/activate" ] && [ -z "${VIRTUAL_ENV:-}" ]; then
  # shellcheck disable=SC1090,SC1091
  source "$WIRE_DEMOS_ROOT/.venv/bin/activate"
fi

# Model routing
DEMO_MODEL="${DEMO_MODEL:-haiku}"
case "$DEMO_MODEL" in
  haiku)  __CLAUDE_MODEL_FLAG=(--model claude-haiku-4-5-20251001) ;;
  sonnet) __CLAUDE_MODEL_FLAG=(--model claude-sonnet-4-6) ;;
  opus)   __CLAUDE_MODEL_FLAG=(--model claude-opus-4-7) ;;
  *)      __CLAUDE_MODEL_FLAG=() ;;
esac

# demo_init <demo_dir> — call once at the start of a demo's entry script.
# Sets DEMO_DIR + DEMO_LOG_DIR, optionally resets state, cds into the demo dir.
demo_init() {
  local demo_dir="$1"
  if [ -z "$demo_dir" ]; then err "demo_init requires demo dir"; return 1; fi
  if [ ! -d "$WIRE_DEMOS_ROOT/$demo_dir" ]; then err "demo dir not found: $demo_dir"; return 1; fi

  export DEMO_DIR="$WIRE_DEMOS_ROOT/$demo_dir"
  export DEMO_LOG_DIR="$DEMO_DIR/logs"
  mkdir -p "$DEMO_LOG_DIR"

  if [ "${DEMO_RESET:-true}" = "true" ]; then
    bash "$WIRE_DEMOS_ROOT/shared/reset.sh" "$demo_dir" >/dev/null
  fi

  cd "$DEMO_DIR" || return 1
  ok "Initialised demo: $demo_dir   (logs: $DEMO_LOG_DIR)"
}

demo_log_dir() {
  echo "${DEMO_LOG_DIR:-$WIRE_DEMOS_ROOT/logs}"
}

# run_wire <wire command + args> — execute a /wire:* command via claude -p
# Logs stdout+stderr to logs/step-<n>-<safe-name>.log
# Returns claude's exit code; on non-zero, prints the last 50 log lines.
__WIRE_STEP=0
run_wire() {
  __WIRE_STEP=$((__WIRE_STEP+1))
  local prompt="$*"
  local safe_name
  safe_name=$(echo "$prompt" | tr -c '[:alnum:]' '-' | cut -c1-60)
  local log="${DEMO_LOG_DIR:-/tmp}/step-$(printf '%02d' $__WIRE_STEP)-${safe_name}.log"

  show_command "claude -p \"$prompt\""

  # Append auto-approve text for -review commands
  if [[ "$prompt" == *-review* ]]; then
    prompt="$prompt

Approved by demo operator — no changes requested."
  fi

  if claude -p "$prompt" \
      "${__CLAUDE_MODEL_FLAG[@]}" \
      --permission-mode acceptEdits \
      --output-format stream-json \
      >"$log" 2>&1; then
    ok "claude completed   (log: $(basename "$log"))"
    return 0
  else
    local rc=$?
    err "claude exited with $rc — last 50 lines of $log:"
    tail -n 50 "$log" >&2
    return $rc
  fi
}

# run_dbt <dbt args> — run dbt against the bundled DuckDB profile
run_dbt() {
  local log="${DEMO_LOG_DIR:-/tmp}/dbt-$(date +%s).log"
  show_command "dbt $*"
  if dbt --profiles-dir "$WIRE_DEMOS_ROOT/shared/profiles" "$@" 2>&1 | tee "$log"; then
    ok "dbt completed"
    return 0
  else
    err "dbt failed — see $log"
    return 1
  fi
}
