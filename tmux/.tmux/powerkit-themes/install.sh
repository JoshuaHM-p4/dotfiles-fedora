#!/usr/bin/env bash
# Link custom PowerKit themes into the plugin's theme directory.
# The plugin is a git submodule, so the theme files live here (tracked by
# dotfiles) and are symlinked in. Re-run after updating tmux-powerkit.
set -euo pipefail

THEMES_SRC="${HOME}/.tmux/powerkit-themes"
PLUGIN_THEMES="${HOME}/.tmux/plugins/tmux-powerkit/src/themes"

[[ -d "$PLUGIN_THEMES" ]] || { echo "tmux-powerkit not installed at $PLUGIN_THEMES" >&2; exit 1; }

for theme in "$THEMES_SRC"/*/; do
    name=$(basename "$theme")
    ln -sfn "${theme%/}" "$PLUGIN_THEMES/$name"
    echo "linked: $PLUGIN_THEMES/$name -> ${theme%/}"
done
