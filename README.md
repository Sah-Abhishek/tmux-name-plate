# tmux-name-plate

Give each tmux session a **name plate**: a coloured label on the top edge of every pane, above the
terminal contents, so you can tell at a glance which terminal is for what.

```
──────────────────────────────────────────────── Client X - prod ──
$ ./deploy.sh
```

- The plate belongs to the **session**, so it shows on every window and pane in that session.
- It only takes up a line while the session has a name.
- Your status bar and terminal title are left alone.

## Requirements

tmux 3.2 or newer.

## Install

Clone the repo:

```sh
git clone https://github.com/Sah-Abhishek/tmux-name-plate.git ~/.tmux/plugins/tmux-name-plate
```

Add this to `~/.tmux.conf`:

```tmux
run-shell ~/.tmux/plugins/tmux-name-plate/nameplate.tmux
```

Reload tmux:

```sh
tmux source ~/.tmux.conf
```

Optionally put the `nameplate` command on your PATH:

```sh
ln -s ~/.tmux/plugins/tmux-name-plate/bin/nameplate ~/.local/bin/nameplate
```

## Usage

### From the keyboard

Press `prefix` then `N` (by default `Ctrl+b`, then `Shift+n`), type a name and press Enter.
Submit an empty name to remove the plate.

### From the shell

| What | Command |
|---|---|
| Set the name | `nameplate Client X - backend` |
| Set it with a colour | `nameplate --bg red Prod DB` |
| Change only the colours | `nameplate --fg white --bg colour208` |
| Show the current name | `nameplate` |
| Remove it | `nameplate --clear` |
| Name a different session | `nameplate -t api Client X - API` |
| One name for every session | `nameplate -g My laptop` |

Colours can be any tmux colour: `red`, `colour208`, `"#ff8800"`, …

### When creating a session

```sh
tmux new -s api \; set @nameplate "Client X - API"
```

Names are kept only while the tmux server is running.

## Options

Set these in `~/.tmux.conf` **before** the `run-shell` line:

```tmux
set -g @nameplate_align  right   # right | left | centre: where the plate sits on the pane's top edge
set -g @nameplate_fg     black   # default text colour
set -g @nameplate_bg     yellow  # default background colour
set -g @nameplate_key    N       # prefix key that asks for a name
```

## How it works

The plate is drawn in the pane's top border (`pane-border-format`). tmux hooks turn that border
on (`pane-border-status top`) only in windows whose session has a name, and update it whenever a
name is set or a window is created.
