# dotfiles

My personal configuration files for neovim, tmux and stuff

## Structure

```
dotfiles/
|── bin/
|── nvim/
|── kitty/
|── tmux/
|── workmux/
└── yazi/
```

## workmux

[workmux](https://github.com/raine/workmux) puts every git worktree in its own
tmux window with an agent running in it. `workmux/config.yaml` holds the global
defaults: `mode: window` so every worktree stays in the current session,
`agent: claude`, and a `[ claude | nvim ]` pane layout. The sidebar is workmux's
own live agent-status pane — it is a toggle (`prefix + W`), not automatic; the
`sidebar:` block only styles it.

```sh
workmux add feat/some-branch     # new worktree + window
workmux add -A -p "task text"    # let the agent name the branch
workmux ls                       # what is running where
workmux dashboard                # TUI over every running agent (prefix + C-w)
workmux merge                    # merge into the base branch and clean up
workmux resurrect                # restore windows after a tmux/computer crash
```

tmux bindings live in `tmux/tmux.conf`: `prefix + C-w` for the dashboard popup,
`prefix + C-e` for the same dashboard on its worktrees tab, `prefix + W` to
toggle the sidebar. tmux's own `prefix + w` still lists every session and
window.

`auto_name` needs no `model` key: `agent: claude` already implies
`claude --model haiku -p` for branch naming.

Per-project settings live in a `.workmux.yaml` at the repo root and override
this file. That is the place for the integration branch, the files to copy into
a new worktree, and `post_create` hooks — notably allocating a dev-server port
per worktree, so a worktree can serve in parallel with the main checkout instead
of fighting it for the port. Config inherited from here is opted back in with
`"<global>"` inside a list.

## Credits

Obsidian/second brain workflow inspired by [zazencodes](https://github.com/zazencodes/dotfiles)

