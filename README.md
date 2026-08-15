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
tmux session with an agent running in it. `workmux/config.yaml` holds the global
defaults: `mode: session`, `agent: claude`, and a three-window layout
(editor / server / agent).

```sh
workmux add feat/some-branch     # new worktree + session
workmux add -A -p "task text"    # let the agent name the branch
workmux ls                       # what is running where
workmux merge                    # merge into the base branch and clean up
```

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

