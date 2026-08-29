#!/usr/bin/env bash
# ponytail: reproduce aerospace gaps.outer.top without a WM. Every 0.5s, push the frontmost app's
# standard, non-fullscreen windows whose top is inside the bar strip down to TOP.
# Frontmost only: windows go under the bar while being dragged/placed, i.e. while frontmost.
# Errors land in .gaps.log (Accessibility permission missing shows up there).
# Upgrade path: aerospace, or a Swift AX observer.
TOP=30
LOG="$(dirname "$0")/../.gaps.log"
while :; do
	osascript - "$TOP" <<'EOS' >/dev/null 2>"$LOG"
on run argv
  set top to (item 1 of argv) as integer
  tell application "System Events"
    set p to first application process whose frontmost is true
    repeat with w in (every window of p whose subrole is "AXStandardWindow")
      try
        if (value of attribute "AXFullScreen" of w) is not true then
          set {x, y} to position of w
          if y < top then
            set {wd, ht} to size of w
            set position of w to {x, top}
            set size of w to {wd, ht - (top - y)}
          end if
        end if
      end try
    end repeat
  end tell
end run
EOS
	sleep 0.5
done
