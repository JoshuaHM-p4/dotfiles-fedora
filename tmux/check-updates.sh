#!/usr/bin/env bash
# Report whether tmux and its plugins have updates available.
# Read-only: fetches from remotes but changes nothing.
set -uo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
PLUGINS="$DOTFILES/tmux/.tmux/plugins"

echo "=== tmux ==="
printf "  running : %s\n" "$(tmux -V 2>/dev/null || echo 'not running')"
if command -v rpm >/dev/null 2>&1; then
    printf "  package : %s\n" "$(rpm -q tmux 2>/dev/null || echo 'not from rpm')"
fi
if command -v dnf >/dev/null 2>&1; then
    if dnf check-update tmux >/dev/null 2>&1; then
        echo "  status  : up to date"
    else
        # exit 100 = updates available, 1 = error
        [[ $? -eq 100 ]] && echo "  status  : UPDATE AVAILABLE (dnf upgrade tmux)" \
                         || echo "  status  : up to date"
    fi
fi

echo
echo "=== plugins ==="
for dir in "$PLUGINS"/*/; do
    name=$(basename "$dir")
    if [[ ! -e "$dir/.git" ]]; then
        printf "  %-16s NOT INITIALIZED\n" "$name"
        continue
    fi
    (
        cd "$dir" || exit
        git fetch -q --tags origin 2>/dev/null
        branch=$(git remote show origin 2>/dev/null | sed -n 's/.*HEAD branch: //p')
        branch="${branch:-master}"
        behind=$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo "?")
        have=$(git describe --tags HEAD 2>/dev/null || git rev-parse --short HEAD)
        want=$(git describe --tags "origin/$branch" 2>/dev/null || echo "-")
        if [[ "$behind" == "0" ]]; then
            printf "  %-16s up to date  (%s)\n" "$name" "$have"
        else
            printf "  %-16s %s behind    %s -> %s\n" "$name" "$behind" "$have" "$want"
        fi
    )
done

echo
echo "=== dotfiles submodule pointers ==="
git -C "$DOTFILES" submodule status | sed 's/^/  /'

cat <<'HINT'

To update:
  tmux           sudo dnf upgrade tmux        (then restart the server)
  plugins        prefix + U                   (TPM; prefix is C-a)
  a single one   git -C <plugin-dir> pull
  reload config  prefix + r

After updating plugins, the dotfiles repo sees new submodule commits.
Record them with:
  git -C "$DOTFILES" add tmux/.tmux/plugins && git -C "$DOTFILES" commit -m "bump tmux plugins"

Re-link custom themes after a powerkit update:
  ~/.tmux/powerkit-themes/install.sh
HINT
