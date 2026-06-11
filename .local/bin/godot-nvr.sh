#!/usr/bin/env bash
# Godot -> Neovim launcher with GUI terminal focus.
# Usage:
#   godot-nvr.sh [terminal_name] +{line} {file} [--tab|--vsplit]

DEFAULT_TERMINAL="ghostty"
ARG0="${1:-}"

if [[ -n "$ARG0" && "$ARG0" != +* && "$ARG0" != --* && ! -f "$ARG0" ]]; then
  GODOT_TERMINAL="$ARG0"
  shift
else
  GODOT_TERMINAL="$DEFAULT_TERMINAL"
fi

SOCKET="${GODOT_NVIM_SOCKET:-/tmp/godot.nvim}"
NVR="${NVR:-nvr}"

if ! command -v "$NVR" >/dev/null 2>&1; then
  echo "nvr not found in PATH (set NVR=/path/to/nvr)" >&2
  exit 1
fi

OPEN_MODE="window"
LINE=""
FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tab) OPEN_MODE="tab"; shift ;;
    --vsplit) OPEN_MODE="vsplit"; shift ;;
    +[0-9]*) LINE="${1#+}"; shift ;;
    *) FILE="$1"; shift ;;
  esac
done

[ -z "$FILE" ] && exit 0

FILE_VIM="${FILE//\'/\'\'}"
case "$OPEN_MODE" in
  window) CMD=":execute 'edit ' . fnameescape('${FILE_VIM}')" ;;
  tab) CMD=":execute 'tabedit ' . fnameescape('${FILE_VIM}')" ;;
  vsplit) CMD=":execute 'vsplit ' . fnameescape('${FILE_VIM}')" ;;
esac

[ -n "$LINE" ] && CMD="$CMD | call cursor($LINE,1)"
CMD="$CMD | normal! zz"

"$NVR" --servername "$SOCKET" --remote-send "<C-\\><C-N>${CMD}<CR>"

if command -v osascript >/dev/null 2>&1; then
  osascript -e "tell application \"$GODOT_TERMINAL\" to activate"
fi
