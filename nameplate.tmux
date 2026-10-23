#!/usr/bin/env bash
# tmux-name-plate: show a label ("name plate") for each tmux session, floating on the
# top edge of every pane, above its contents. The status bar is left alone.
#
# Load from ~/.tmux.conf with:
#   run-shell ~/path/to/tmux-name-plate/nameplate.tmux
#
# Options (set in ~/.tmux.conf *before* the run-shell line):
#   @nameplate_align     right | left | centre  where the plate sits on the pane's top edge (default: right)
#   @nameplate_fg        plate text colour                                          (default: black)
#   @nameplate_bg        plate background colour                                    (default: yellow)
#   @nameplate_key       prefix key that prompts for a new name                     (default: N)

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin="$dir/bin/nameplate"

get_opt() {
	local value
	value="$(tmux show-option -gqv "$1")"
	echo "${value:-$2}"
}

# Global defaults; a session can override any of these with `nameplate --fg/--bg`.
tmux set-option -g @nameplate_fg "$(get_opt @nameplate_fg black)"
tmux set-option -g @nameplate_bg "$(get_opt @nameplate_bg yellow)"

align="$(get_opt @nameplate_align right)"
key="$(get_opt @nameplate_key N)"

# The plate is drawn in the pane's top border line, which only exists in windows whose
# session has a name (see `nameplate --refresh`). Commas inside #{?...} must be escaped as "#,".
tmux set-option -g pane-border-format \
	"#[align=$align]#{?#{@nameplate},#[fg=#{@nameplate_fg}#,bg=#{@nameplate_bg}#,bold] #{@nameplate} #[default],}"

# Show or hide the border line whenever a name changes or a window is created,
# however the name was set (key binding, CLI or a plain `set @nameplate`).
tmux set-hook -g after-set-option \
	"if-shell -F '#{m:*@nameplate*,#{hook_arguments}}' \"run-shell '$bin --refresh'\""
tmux set-hook -g after-new-window "run-shell '$bin --refresh'"

# An empty answer hides the plate.
tmux bind-key "$key" command-prompt -I "#{@nameplate}" -p "Name plate:" "set-option @nameplate '%%'"

"$bin" --refresh
