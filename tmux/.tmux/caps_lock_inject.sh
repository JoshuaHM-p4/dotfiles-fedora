#!/usr/bin/env bash
# Prepend #(~/.tmux/caps_lock.sh) to powerkit's right side in status-format[0].
# Lives in a script because tmux `run` would format-expand the #(...) in the pattern.
# Idempotent: does nothing if already injected.

fmt=$(tmux show -gv 'status-format[0]')
[[ "$fmt" == *caps_lock.sh* ]] && exit 0

needle='#('"$HOME"'/.tmux/plugins/tmux-powerkit/bin/powerkit-render right)'
[[ "$fmt" == *"$needle"* ]] || exit 0

tmux set -g 'status-format[0]' "${fmt/"$needle"/#(~/.tmux/caps_lock.sh)$needle}"
