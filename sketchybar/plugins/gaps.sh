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
    -- Bulk fetches (2 Apple Events) instead of a whose-clause per poll: the whose
    -- clause hogged System Events and starved front_app.sh's window-dot queries.
    set subs to subrole of windows of p
    set poss to position of windows of p
    repeat with i from 1 to count of subs
      try
        if item i of subs is "AXStandardWindow" then
          set {x, y} to item i of poss
          -- ponytail: main screen only (0 ≤ y). Screens above main have negative y;
          -- clamping them yanked windows back to main. Bar strip on other screens unguarded.
          if y ≥ 0 and y < top then
            set w to window i of p
            if (value of attribute "AXFullScreen" of w) is not true then
              set {wd, ht} to size of w
              set position of w to {x, top}
              set size of w to {wd, ht - (top - y)}
            end if
          end if
        end if
      end try
    end repeat
  end tell
end run
EOS
	# ponytail: 2s poll — cheaper on System Events (front_app dots share it); dragged
	# windows sit under the bar up to 2s before snap, acceptable.
	sleep 2
done
