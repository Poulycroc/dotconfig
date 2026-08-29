#!/usr/bin/env bash
case "$SENDER" in
volume_change)
	case "$INFO" in
	[6-9][0-9] | 100) ICON="󰕾" ;;
	[3-5][0-9]) ICON="󰖀" ;;
	[1-9] | [1-2][0-9]) ICON="󰕿" ;;
	*) ICON="󰖁" ;;
	esac
	sketchybar --set "$NAME" icon="$ICON" label="$INFO%"
	;;
mouse.scrolled)
	CURRENT=$(osascript -e 'output volume of (get volume settings)')
	NEW=$((CURRENT + (SCROLL_DELTA > 0 ? 5 : -5)))
	((NEW > 100)) && NEW=100
	((NEW < 0)) && NEW=0
	osascript -e "set volume output volume $NEW"
	;;
esac
