#!/usr/bin/env bash
media-control toggle-play-pause
sleep 0.3
NAME="${NAME:-media}" "$(dirname "$0")/media.sh"
