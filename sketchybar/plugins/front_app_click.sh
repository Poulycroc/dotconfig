#!/usr/bin/env bash
# Cycle the frontmost app's windows: raise the rearmost (like Cmd-`), then refresh the dots.
osascript -e 'tell application "System Events" to tell (first application process whose frontmost is true) to perform action "AXRaise" of last window' 2>/dev/null
NAME="${NAME:-front_app}" "$(dirname "$0")/front_app.sh"
