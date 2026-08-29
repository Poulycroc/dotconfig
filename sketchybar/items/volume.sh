#!/usr/bin/env bash
sketchybar --add item volume right \
           --subscribe volume volume_change mouse.scrolled \
           --set volume icon="󰕾" \
                 script="$CONFIG_DIR/plugins/volume.sh"
