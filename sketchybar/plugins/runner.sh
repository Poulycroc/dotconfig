#!/usr/bin/env bash
# Background loop (started from sketchybarrc, pid in .runner.pid). Cycles frames at RunCat's pace:
# delay = 200ms / clamp(cpu/5, 1, 6)  ->  200ms idle, 33ms at >=30% CPU.
# CPU comes from a streaming `top` (live figure, unlike ps %cpu which is a lifetime average).
CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
FRAMES=("$CONFIG_DIR"/assets/dino/*.png)
CPUFILE="${TMPDIR:-/tmp}/sketchybar_cpu"

top -l 0 -s 2 -n 0 | awk -v f="$CPUFILE" '/CPU usage/ { gsub("%", ""); print int($3 + $5) > f; close(f) }' &
TOPPID=$!
trap 'kill $TOPPID 2>/dev/null; exit' EXIT TERM INT

i=0
while :; do
	CPU=$(cat "$CPUFILE" 2>/dev/null)
	DELAY=$(awk -v c="${CPU:-0}" 'BEGIN { s = c / 5; if (s < 1) s = 1; if (s > 6) s = 6; printf "%.3f", 0.2 / s }')
	sketchybar --set runner icon.background.image="${FRAMES[i]}"
	i=$(((i + 1) % ${#FRAMES[@]}))
	sleep "$DELAY"
done
