#!/usr/bin/env bash
set -euo pipefail

SOCKET="${GODOT_NVIM_SOCKET:-/tmp/godot.nvim}"
NVR="${NVR:-nvr}"

if [[ -S "$SOCKET" ]]; then
  if command -v "$NVR" >/dev/null 2>&1 && "$NVR" --nostart --servername "$SOCKET" --remote-expr '1' >/dev/null 2>&1; then
    echo "Neovim server already running at $SOCKET"
    exit 0
  fi

  echo "Removing stale socket: $SOCKET"
  rm -f "$SOCKET"
fi

exec nvim --listen "$SOCKET" "$@"
