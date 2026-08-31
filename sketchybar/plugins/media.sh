#!/usr/bin/env bash
# Now Playing via media-control (mediaremote-adapter; nowplaying-cli is broken on macOS 26).
# Hides when macOS has no Now Playing entry — players that don't publish can't be seen.
CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
source "$CONFIG_DIR/colors.sh"
COVER="${TMPDIR:-/tmp}/sketchybar_cover.jpg"

OUT=$(media-control get 2>/dev/null | python3 -c 'import sys, json, base64, os
cover = sys.argv[1]
try:
    d = json.load(sys.stdin) or {}
except Exception:
    d = {}
title = (d.get("title") or "").replace("\n", " ")
artist = (d.get("artist") or "").replace("\n", " ")
playing = "1" if d.get("playing") else "0"
wrote, have = "0", "0"
if title:
    key = cover + ".title"
    prev = open(key).read() if os.path.exists(key) else ""
    art = d.get("artworkData")
    if art and prev != title:
        open(cover, "wb").write(base64.b64decode(art))
        open(key, "w").write(title)
        wrote = "1"
    if os.path.exists(cover) and (art or prev == title):
        have = "1"
print(title); print(artist); print(playing); print(have); print(wrote)' "$COVER")
{ read -r TITLE; read -r ARTIST; read -r PLAYING; read -r HAVE; read -r WROTE; } <<<"$OUT"

if [ -z "$TITLE" ]; then
	sketchybar --set "$NAME" drawing=off
	exit 0
fi

[ "$WROTE" = "1" ] && sips -Z 52 "$COVER" >/dev/null 2>&1

LABEL="$TITLE"; [ -n "$ARTIST" ] && LABEL="$ARTIST · $TITLE"
[ "$PLAYING" = "1" ] && ICON="󰎆" || ICON="󰏤"

if [ "$HAVE" = "1" ]; then
	sketchybar --set "$NAME" drawing=on label="$LABEL" icon="" icon.background.image="$COVER" icon.background.image.drawing=on
else
	sketchybar --set "$NAME" drawing=on label="$LABEL" icon="$ICON" icon.background.image.drawing=off
fi
