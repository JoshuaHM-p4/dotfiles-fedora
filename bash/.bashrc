# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Always ensure scripts directory is in PATH
if ! [[ "$PATH" =~ "$HOME/.local/scripts" ]]; then
  PATH="$HOME/.local/scripts:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# Start of Custom Configurations
## Custom Aliases
fastfetch
alias sourceb='source ~/.bashrc'
alias ff='fastfetch'
alias c='clear'
alias r='ranger'
alias lsa='ls -a'
alias ll='ls -la'
alias flatsize="flatpak list --columns=size,name,application | awk '{ s=\$1; if (\$2==\"kB\") s*=1024; else if (\$2==\"MB\") s*=1048576; else if (\$2==\"GB\") s*=1073741824; printf \"%015.0f|%s\\n\", s, \$0 }' | sort -r | cut -d'|' -f2"

alias opn='xdg-open .'
alias dotfiles='cd ~/.dotfiles && nvim .'
unalias pjd 2>/dev/null
pjd() {
  cd ~/CODE/proj/"$1" || return
  clear
}
_pjd() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local IFS=$'\n'
  COMPREPLY=($(cd ~/CODE/proj && compgen -d -- "$cur"))
}
pjdc() {
  pjd "$1"
  claude .
}
pjda() {
  pjd "$1"
  agy .
}
pjdx() {
  pjd "$1"
  codex .
}
pjdn() {
  pjd "$1" || return
  npm run dev
}
pjdv() {
  pjd "$1" || return
  nvim .
}
pjdvi() {
  pjd "$1" || return
  vim .
}
pjdo() {
  pjd "$1" || return
  xdg-open .
}
_pjd() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local IFS=$'\n'
  COMPREPLY=($(cd ~/CODE/proj && compgen -d -- "$cur"))
}
complete -o filenames -F _pjd pjd pjdc pjda pjdx pjdn pjdv pjdvi pjdo

alias dcd='cd ~/Documents && clear'
alias dwd='cd ~/Downloads/ && clear'
alias dsd='cd ~/Desktop/ && clear'
alias rdd='cd ~/Documents/RESEARCH/ && clear'
alias rddr='cd ~/Documents/RESEARCH/DP1/repositories/ && clear'
alias obsidian='~/Documents/Obsidian Vault/ && clear'
alias notes='nvim ~/Documents/Obsidian\ Vault/000\ INDEX/99\ PERSONAL/Notes.md'
alias becoming='nvim ~/Documents/Obsidian\ Vault/000\ INDEX/99\ PERSONAL/Purposes.md'
alias discordo='~/Programs/discordo/discordo'
alias logicsim='~/Games/Digital-Logic-Sim/Digital-Logic-Sim.x86_64'
alias logout='gnome-session-quit --logout --no-prompt'

alias nins='npm install'
alias nrd='npm run dev'
alias nrb='npm run build'

alias pyvenv='python3 -m venv .venv 2>/dev/null || python3 -m venv venv'
alias pyvenv312=' /usr/bin/python3.12 -m venv .venv 2>/dev/null || python3 -m venv venv'
alias pyenv='source .venv/bin/activate 2>/dev/null || source venv/bin/activate'
alias piptxt='pip freeze > requirements.txt'
alias pipins='pip install -r requirements.txt'
alias venvrun='source .venv/bin/activate 2>/dev/null || source venv/bin/activate && python main.py 2>/dev/null || python run.py'
alias pyrun='python main.py 2>/dev/null || python run.py'

gcp() {
  git add .
  git commit -m "$1"
  git push
}
# ─────────────────────────────────────────
#  Git Aliases + Completion
# ─────────────────────────────────────────

# ── Core shortcuts ──────────────────────
alias gi='git init'
alias gcl='git clone'

# ── Status & Log ────────────────────────
alias gs='git status'
alias gss='git status -s'
alias gitlog='git log --oneline --graph --decorate'
alias gitloga='git log --oneline --graph --decorate --all'
alias gitlogo='git log --oneline'
gitlogh() {
  local days=""
  local author=""

  # Check if the first argument is a number
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    days="$1"
    author="$2"
  else
    author="$1"
  fi

  # Run the git log command with conditional arguments
  git log ${author:+--author="$author"} ${days:+--since="$days days ago"} --pretty=format:"%C(yellow)%h%Creset - %C(cyan)%an%Creset, %C(green)%ad%Creset : %s"
}

# ── Staging ─────────────────────────────
alias ga='git add'
alias gaa='git add .'
alias gap='git add -p'
alias gaddx="git add . ':!package.json' ':!package-lock.json' ':!**/package.json' ':!**/package-lock.json'"
alias gaddc="git add . ':!*.md' ':!docs/'"
alias grm='git rm'

# Jump to a worktree by branch name
wt() {
  local dir
  dir=$(git worktree list --porcelain |
    awk -v branch="refs/heads/$1" \
      '/^worktree /{dir=$2} /^branch /{if($2==branch) print dir}')
  if [ -n "$dir" ]; then
    cd "$dir" || return
    echo "Switched to worktree: $dir (branch: $1)"
  else
    echo "No worktree found for branch '$1'"
    return 1
  fi
}
wti() {
  local selected
  selected=$(git worktree list | fzf --height 40% --reverse)
  if [ -n "$selected" ]; then
    cd "$(echo "$selected" | awk '{print $1}')" || return
  fi
}

# ── Restoring ────────────────────────────
alias gr='git restore'
alias grs='git restore --staged'

# ── Committing ──────────────────────────
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcam='git commit --amend -m'
alias gcan='git commit --amend --no-edit'

# ── Branching ───────────────────────────
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'

# ── Remote ──────────────────────────────
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git pull'
alias glr='git pull --rebase'
alias gps='git push'
alias gpsu='git push -u origin HEAD'
alias gpsf='git push --force-with-lease'

# ── Merging & Rebasing ──────────────────
alias gm='git merge'
alias gms='git merge --squash'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

# ── Stash ───────────────────────────────
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstd='git stash drop'

# ── Diff ────────────────────────────────
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'

# ── Reset & Clean ───────────────────────
alias grh='git reset HEAD'
alias grhh='git reset --hard HEAD'
alias gclean='git clean -fd'

# ── Tags ────────────────────────────────
alias gt='git tag'
alias gta='git tag -a'
alias gtl='git tag -l'

# ── Misc ────────────────────────────────
alias gchp='git cherry-pick'
alias gbl='git blame'
alias gsh='git show'
alias gwip='git add . && git commit -m "WIP: work in progress"'
alias gundo='git reset --soft HEAD~1'

# ─────────────────────────────────────────
#  Bash Completion for git aliases
# ─────────────────────────────────────────

_setup_git_completions() {
  if declare -f __git_complete >/dev/null 2>&1; then
    __git_complete gi _git_init
    __git_complete gcl _git_clone
    __git_complete gs _git_status
    __git_complete gss _git_status
    __git_complete gitlog _git_log
    __git_complete gitloga _git_log
    __git_complete gitlogo _git_log
    __git_complete ga _git_add
    __git_complete gaa _git_add
    __git_complete gap _git_add
    __git_complete gaddx _git_add
    __git_complete gr _git_restore
    __git_complete grs _git_restore
    __git_complete grm _git_rm
    __git_complete gc _git_commit
    __git_complete gcm _git_commit
    __git_complete gca _git_commit
    __git_complete gcam _git_commit
    __git_complete gcan _git_commit
    __git_complete gb _git_branch
    __git_complete gba _git_branch
    __git_complete gbd _git_branch
    __git_complete gbD _git_branch
    __git_complete gco _git_checkout
    __git_complete gcob _git_checkout
    __git_complete gsw _git_switch
    __git_complete gswc _git_switch
    __git_complete gm _git_merge
    __git_complete gms _git_merge
    __git_complete gf _git_fetch
    __git_complete gfa _git_fetch
    __git_complete gl _git_pull
    __git_complete glr _git_pull
    __git_complete gps _git_push
    __git_complete gpsu _git_push
    __git_complete gpsf _git_push
    __git_complete grb _git_rebase
    __git_complete grbi _git_rebase
    __git_complete grbc _git_rebase
    __git_complete grba _git_rebase
    __git_complete gd _git_diff
    __git_complete gds _git_diff
    __git_complete gdt _git_difftool
    __git_complete grh _git_reset
    __git_complete grhh _git_reset
    __git_complete gclean _git_clean
    __git_complete gt _git_tag
    __git_complete gta _git_tag
    __git_complete gtl _git_tag
    __git_complete gchp _git_cherry_pick
    __git_complete gbl _git_log
    __git_complete gsh _git_show
    __git_complete gundo _git_reset
  fi
}

_setup_git_completions

wr() {
  if [ -z "$1" ]; then
    nvim ~/Documents/NOTES/
  else
    nvim ~/Documents/NOTES/"$1"
  fi
}
preview-alacritty-themes() {
  local work repo config pid picked theme

  work=$(mktemp -d) || return
  repo="$work/alacritty-theme"
  config="$work/preview.toml"

  git clone --quiet --depth 1 \
    https://github.com/alacritty/alacritty-theme.git "$repo" || {
    rm -rf -- "$work"
    return 1
  }

  cp "$repo/themes/acme.toml" "$config"

  alacritty \
    --config-file "$config" \
    --title "Alacritty theme preview" \
    --hold \
    -e "$repo/print_colors.sh" &
  pid=$!

  picked=$(
    for theme in "$repo"/themes/*.toml; do
      printf '%s\t%s\n' \
        "$(basename "$theme" .toml)" "$theme"
    done |
      sort |
      fzf \
        --delimiter=$'\t' \
        --with-nth=1 \
        --prompt='Alacritty theme › ' \
        --bind "focus:execute-silent(cp -- {2} \"$config\")"
  )

  kill "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null
  rm -rf -- "$work"

  if [[ -n $picked ]]; then
    printf 'Selected theme: %s\n' "${picked%%$'\t'*}"
  fi
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/joshuam/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/home/joshuam/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/home/joshuam/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="/home/joshuam/miniconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH=~/.local/bin:$PATH
if [ -f ~/.bash_secrets ]; then
  source ~/.bash_secrets
fi
. "$HOME/.cargo/env"

export PS1='\[\e[32m\]\u\[\e[0m\]@\[\e[33m\]\h\[\e[0m\]:\[\e[36m\]\w\[\e[0m\]\$ '

# Added by Antigravity CLI installer
export PATH="/home/joshuam/.local/bin:$PATH"
