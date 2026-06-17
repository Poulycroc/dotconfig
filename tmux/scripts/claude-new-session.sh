#!/usr/bin/env bash
# Spawn a new Claude session with a unique name so it shows up in the plugin picker.
set -uo pipefail

path="${1:-$PWD}"
prefix="claude-"
w="90%"
h="90%"

# Generate unique session name using timestamp
session="${prefix}new-$(date +%s)"

# If already inside a claude popup, detach first
current="$(tmux display-message -p '#S')"
if [[ "$current" == "$prefix"* ]]; then
  tmux detach-client
  sleep 0.1
fi

tmux new-session -d -s "$session" -c "$path" "claude"
tmux display-popup -w "$w" -h "$h" -E "tmux attach-session -t $session"
