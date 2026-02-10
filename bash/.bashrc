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
alias reload='source ~/.bashrc'
alias ff='fastfetch'
alias c='clear'
alias r='ranger'
alias g='git status'
alias gp='git pull'
alias lsa='ls -a'
alias ll='ls -la'
alias dotfiles='cd ~/.dotfiles && nvim .'
alias pjd='cd ~/CODE/proj'
alias dcd='cd ~/Documents'
alias becoming='nvim ~/Documents/Obsidian\ Vault/000\ INDEX/99\ PERSONAL/Purposes.md'

alias r2modman='~/Downloads/ebkr-r2modman-3.2.9/r2modman-3.2.9.AppImage'
alias discordo='~/Programs/discordo/discordo'
alias logicsim='~/Games/Digital-Logic-Sim/Digital-Logic-Sim.x86_64'
alias logout='gnome-session-quit --logout --no-prompt'

gcp() {
  git add .
  git commit -m "$1"
  git push
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
