#!/usr/bin/env bash
# Caps Lock pill for the tmux status bar (empty when off).
# Runs straight from status-format so it refreshes every status-interval,
# bypassing powerkit's 5s render cache. Colors match mytheme warning-*.

for led in /sys/class/leds/*::capslock/brightness; do
    if [[ -r "$led" && "$(<"$led")" != "0" ]]; then
        printf '#[fg=#dcc77e,bg=default]#[fg=#5e5229,bg=#dcc77e]\U000F0632 '
        printf '#[fg=#d4b95e,bg=#dcc77e]#[fg=#5e5229,bg=#d4b95e,bold] CAPS '
        printf '#[fg=#d4b95e,bg=default,nobold]#[default] '
        exit 0
    fi
done
