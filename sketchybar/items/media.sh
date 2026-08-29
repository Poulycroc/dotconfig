#!/usr/bin/env bash
sketchybar --add item media left \
           --set media icon="" \
                 icon.width=26 \
                 icon.padding_left=0 icon.padding_right=0 \
                 icon.background.drawing=on \
                 icon.background.color=0x00000000 \
                 icon.background.image.drawing=on \
                 icon.background.image.scale=0.5 \
                 icon.background.image.corner_radius=6 \
                 background.padding_left=8 \
                 label.padding_left=8 label.padding_right=8 \
                 label.max_chars=40 \
                 update_freq=2 \
                 script="$CONFIG_DIR/plugins/media.sh" \
                 click_script="$CONFIG_DIR/plugins/media_click.sh"
