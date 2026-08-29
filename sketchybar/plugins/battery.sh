#!/usr/bin/env bash
CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
source "$CONFIG_DIR/colors.sh"

BATT=$(pmset -g batt)
PERCENTAGE=$(grep -Eo "[0-9]+%" <<<"$BATT" | cut -d% -f1)
[ -z "$PERCENTAGE" ] && exit 0

case "$PERCENTAGE" in
9[0-9] | 100) ICON="󰁹" ;;
[6-8][0-9]) ICON="󰂀" ;;
[3-5][0-9]) ICON="󰁾" ;;
[1-2][0-9]) ICON="󰁼" ;;
*) ICON="󰂃" ;;
esac
grep -q "AC Power" <<<"$BATT" && ICON="󰂄"

# red <=10, peach <=20, else accent icon / text label
if ((PERCENTAGE <= 10)); then
	ICON_COLOR="$RED" LABEL_COLOR="$RED"
elif ((PERCENTAGE <= 20)); then
	ICON_COLOR="$PEACH" LABEL_COLOR="$PEACH"
else
	ICON_COLOR="$ACCENT" LABEL_COLOR="$TEXT_COLOR"
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$ICON_COLOR" label.color="$LABEL_COLOR"
