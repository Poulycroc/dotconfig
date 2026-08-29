#!/usr/bin/env bash
case "$NAME" in
  time) sketchybar --set "$NAME" label="$(date '+%H:%M')" ;;
  date) sketchybar --set "$NAME" label="$(date '+%a %d %b')" ;;
esac
