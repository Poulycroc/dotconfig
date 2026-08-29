#!/usr/bin/env bash
# Click toggles `caffeinate -dis` (never sleep). Colored = on.
sketchybar --add item caffeinate right \
           --subscribe caffeinate mouse.clicked \
           --set caffeinate icon="󰅶" label.drawing=off update_freq=30 \
                 script="$CONFIG_DIR/plugins/caffeinate.sh"
