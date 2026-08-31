#!/usr/bin/env bash
# Label "App 󰝣󰝤󰝣" — one square per standard window (title-sorted), filled = focused.
APP="$INFO"
# lsappinfo is ~10ms and needs no permissions, unlike a System Events round-trip
[ -z "$APP" ] && APP=$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | cut -d'"' -f4)
[ -z "$APP" ] && exit 0

# One osascript, three bulk AX fetches — no per-window round-trips.
LIST=$(osascript -e 'tell application "System Events" to tell process "'"$APP"'"
	set subs to subrole of windows
	set mains to value of attribute "AXMain" of windows
	set titles to name of windows
end tell
set out to ""
repeat with i from 1 to count subs
	if item i of subs is "AXStandardWindow" then
		set m to 0
		if item i of mains is true then set m to 1
		set out to out & m & tab & item i of titles & linefeed
	end if
end repeat
return out' 2>/dev/null)

DOTS=""
if [ "$(grep -c . <<<"$LIST")" -gt 1 ]; then
	while IFS=$'\t' read -r main _; do
		[ "$main" = "1" ] && DOTS+="󰝤" || DOTS+="󰝣"
	done < <(sort -t$'\t' -k2 <<<"$LIST")
fi

LABEL="$APP"
[ -n "$DOTS" ] && LABEL="$APP  $DOTS"

if [ "$SENDER" = "front_app_switched" ]; then
	sketchybar --set "$NAME" label="$LABEL" icon.background.image="app.$APP"
else
	sketchybar --set "$NAME" label="$LABEL"
fi
