#!/usr/bin/env bash
# Two items so both get accent icons. Added right-side: first added = rightmost.
sketchybar --add item time right \
           --set time icon="󰥔" update_freq=10 script="$CONFIG_DIR/plugins/clock.sh" \
           --add item date right \
           --set date icon="󰃭" update_freq=60 script="$CONFIG_DIR/plugins/clock.sh"
