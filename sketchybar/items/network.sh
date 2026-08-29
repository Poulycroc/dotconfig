#!/usr/bin/env bash
sketchybar --add item network e \
           --set network icon="󰤨" label="--" \
                 update_freq=2 \
                 script="$CONFIG_DIR/plugins/network.sh"
