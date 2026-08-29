#!/usr/bin/env bash
CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
source "$CONFIG_DIR/colors.sh"
COVER="${TMPDIR:-/tmp}/sketchybar_cover.jpg"

{ read -r TITLE; read -r ARTIST; read -r RATE; } < <(nowplaying-cli get title artist playbackRate 2>/dev/null)

if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
	sketchybar --set "$NAME" drawing=off
	exit 0
fi

# Re-fetch cover only when track changes (title cached in a sidecar file).
if [ "$(cat "$COVER.title" 2>/dev/null)" != "$TITLE" ]; then
	ART=$(nowplaying-cli get artworkData 2>/dev/null)
	if [ -n "$ART" ] && [ "$ART" != "null" ]; then
		echo "$ART" | base64 -d > "$COVER" && sips -Z 52 "$COVER" >/dev/null 2>&1
	else
		rm -f "$COVER"
	fi
	echo "$TITLE" > "$COVER.title"
fi

LABEL="$TITLE"; [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ] && LABEL="$ARTIST · $TITLE"
[ "$RATE" = "1" ] && ICON="󰎆" || ICON="󰏤"

if [ -f "$COVER" ]; then
	sketchybar --set "$NAME" drawing=on label="$LABEL" icon="" icon.background.image="$COVER"
else
	sketchybar --set "$NAME" drawing=on label="$LABEL" icon="$ICON" icon.background.image.drawing=off
fi
