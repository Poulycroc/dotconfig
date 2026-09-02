#!/usr/bin/env bash
# Native app icon via icon.background.image=app.<Name>. Image icons ignore icon.padding,
# so width is fixed and spacing comes from item background.padding.
sketchybar --add item apple left \
	--set apple icon= label.drawing=off icon.padding_right=10 \
	--add item front_app left \
	--subscribe front_app front_app_switched \
	--set front_app icon="" \
	icon.width=20 \
	icon.padding_left=0 icon.padding_right=0 \
	icon.background.drawing=on \
	icon.background.color=0x00000000 \
	icon.background.image.drawing=on \
	icon.background.image.scale=0.6 \
	background.padding_left=8 \
	label.padding_left=6 label.padding_right=8 \
	script="$CONFIG_DIR/plugins/front_app.sh" \
                 update_freq=1 \
                 click_script="$CONFIG_DIR/plugins/front_app_click.sh"
