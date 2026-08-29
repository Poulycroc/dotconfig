#!/usr/bin/env bash
# RunCat-style runner: frames in assets/dino, animated by plugins/runner.sh (speed = CPU load).
sketchybar --add item runner q \
           --set runner icon="" icon.width=26 \
                 icon.padding_left=0 icon.padding_right=0 \
                 icon.background.drawing=on \
                 icon.background.color=0x00000000 \
                 icon.background.image.drawing=on \
                 icon.background.image.scale=0.5 \
                 icon.background.image="$CONFIG_DIR/assets/dino/0.png" \
                 label.drawing=off \
                 background.padding_left=8 background.padding_right=8
