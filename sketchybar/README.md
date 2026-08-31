# sketchybar

![bar](assets/screenshot.png)

Mono Catppuccin bar for macOS 26 (Tahoe). Full width, `topmost=window`, 30 px
(38 px + notch cutout on the MacBook screen).

Items: apple · front app (native icon + one square per window, filled = focused,
click cycles) · now playing (cover art, click = play/pause) · network · RunCat-style
dino (frames in `assets/dino/`, speed follows CPU) · caffeinate toggle · volume ·
battery · time · date.

## Requirements

```sh
brew install sketchybar media-control
brew install --cask font-jetbrains-mono-nerd-font rectangle
brew services start sketchybar
```

Permissions: give **sketchybar** Accessibility (window dots, gaps loop use
System Events). The macOS menu bar is auto-hidden (hover the top edge to reach
it); sketchybar sits above windows but below the menu bar layer.

## Window placement (no tiling WM)

sketchybar cannot reserve screen space, so:

- **Rectangle** handles maximize/halves with a top gap matching the bar
  (no config file — prefs are plain defaults):

  ```sh
  defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 30
  # on notched screens the OS already reserves the strip; 0 would fall back to 30
  defaults write com.knollsoft.Rectangle screenEdgeGapTopNotch -int 1
  ```

- `plugins/gaps.sh` (started by sketchybarrc, pid in `.gaps.pid`) pushes
  manually dragged windows out of the strip every 0.5 s.

Keep in sync if the bar height changes: bar `height`, `TOP` in
`plugins/gaps.sh`, and Rectangle's `screenEdgeGapTop`.

## Quirks worth knowing (macOS 26)

- `defaults write NSGlobalDomain _HIHideMenuBar` does not apply; use
  `osascript -e 'tell app "System Events" to tell dock preferences to set autohide menu bar to true'`.
- sketchybar's native `media_change` event never fires → `media-control` polls.
- Menu bar aliases need Screen Recording, refresh at 1 fps and light the
  recording dot — that is why the dino is drawn from extracted frames instead.
