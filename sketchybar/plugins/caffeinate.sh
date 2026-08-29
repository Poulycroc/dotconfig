#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
source "$CONFIG_DIR/colors.sh"
STATE_FILE="${TMPDIR:-/tmp}/sketchybar_caffeinate.pid"

toggle() {
	if [ -f "$STATE_FILE" ]; then
		pkill -F "$STATE_FILE"
		rm "$STATE_FILE"
		sketchybar --set $NAME icon.color=$INACTIVE_COLOR
	else
		caffeinate -d -i -s &
		echo $! >"$STATE_FILE"
		sketchybar --set $NAME icon.color=$ACCENT
	fi
}

update() {
	if [ -f "$STATE_FILE" ] && kill -0 $(cat "$STATE_FILE") 2>/dev/null; then
		sketchybar --set $NAME icon.color=$ACCENT
	else
		rm -f "$STATE_FILE"
		sketchybar --set $NAME icon.color=$INACTIVE_COLOR
	fi
}

case "$SENDER" in
"routine" | "forced")
	update
	;;
"mouse.clicked")
	toggle
	;;
esac
