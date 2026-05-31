#!/usr/bin/env bash
# narrator.sh — sourced by every demo step.
# Provides: narrate, narrate_long, pause, show_file, show_command, section, ok, warn, err.
# Honours DEMO_MODE: interactive (pause after narration), auto (no pause), silent (no narration output).

# Guard against double-sourcing
if [ -n "${__WIRE_DEMOS_NARRATOR_LOADED:-}" ]; then return 0 2>/dev/null || exit 0; fi
__WIRE_DEMOS_NARRATOR_LOADED=1

# Colours (ANSI; works in tmux/screen/piped output if -t isn't a tty we drop them)
if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
  C_RESET='\033[0m'
  C_CYAN='\033[0;36m'
  C_YELLOW='\033[0;33m'
  C_GREEN='\033[0;32m'
  C_RED='\033[0;31m'
  C_DIM='\033[2m'
  C_BOLD='\033[1m'
  C_BLUE='\033[0;34m'
  C_MAGENTA='\033[0;35m'
else
  C_RESET=''; C_CYAN=''; C_YELLOW=''; C_GREEN=''; C_RED=''; C_DIM=''; C_BOLD=''; C_BLUE=''; C_MAGENTA=''
fi

DEMO_MODE="${DEMO_MODE:-interactive}"

# section — big banner
section() {
  [ "$DEMO_MODE" = "silent" ] && return 0
  local title="$1"
  echo ""
  printf "${C_BLUE}${C_BOLD}━━━ %s ━━━${C_RESET}\n" "$title"
  echo ""
}

# narrate — one or more short lines of commentary
narrate() {
  [ "$DEMO_MODE" = "silent" ] && return 0
  printf "${C_CYAN}»${C_RESET}  %b\n" "$*"
}

# narrate_long — multi-line commentary read from stdin
# Usage: narrate_long <<'EOF'
#   First line
#   Second line
# EOF
narrate_long() {
  [ "$DEMO_MODE" = "silent" ] && { cat >/dev/null; return 0; }
  local line
  while IFS= read -r line; do
    printf "${C_CYAN}»${C_RESET}  %s\n" "$line"
  done
}

# pause — wait for enter in interactive mode, return immediately otherwise
pause() {
  if [ "$DEMO_MODE" = "interactive" ]; then
    printf "${C_DIM}   (press enter to continue)${C_RESET} "
    read -r _
  fi
}

# show_file — pretty-print a file's content; prefer bat/glow if available, fall back to cat
show_file() {
  local f="$1"
  [ "$DEMO_MODE" = "silent" ] && return 0
  if [ ! -f "$f" ]; then
    err "show_file: $f not found"
    return 1
  fi
  echo ""
  printf "${C_DIM}── %s ──${C_RESET}\n" "$f"
  if [[ "$f" == *.md ]] && command -v glow >/dev/null 2>&1; then
    glow -s dark "$f" 2>/dev/null || cat "$f"
  elif command -v bat >/dev/null 2>&1; then
    bat --plain --color=always "$f" 2>/dev/null || cat "$f"
  else
    cat "$f"
  fi
  echo ""
}

# show_command — print a command in a yellow box before running it
show_command() {
  [ "$DEMO_MODE" = "silent" ] && return 0
  printf "${C_YELLOW}\$ %s${C_RESET}\n" "$*"
}

# Status helpers
ok()   { printf "${C_GREEN}✓${C_RESET} %b\n"   "$*"; }
warn() { printf "${C_YELLOW}⚠${C_RESET} %b\n" "$*"; }
err()  { printf "${C_RED}✗${C_RESET} %b\n"     "$*" >&2; }
