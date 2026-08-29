#!/usr/bin/env bash
sketchybar --add item battery right \
           --subscribe battery power_source_change system_woke \
           --set battery icon="󰁹" label="--" \
                 update_freq=120 \
                 script="$CONFIG_DIR/plugins/battery.sh"
