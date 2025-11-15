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

fastfetch
alias ff='fastfetch'
alias c='clear'
alias r='ranger'
alias g='git status'
alias gp='git pull'
alias quartus='~/Programs/intel_quartus/quartus/bin/quartus &'
alias r2modman='~/Downloads/ebkr-r2modman-3.2.9/r2modman-3.2.9.AppImage'
alias discordo='~/Programs/discordo/discordo'
alias logicsim='~/Games/Digital-Logic-Sim/Digital-Logic-Sim.x86_64'

gcp() {
  git add .
  git commit -m "$1"
  git push
}

get_roc() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/results/roc_auc/${filename}" \
    ~/Downloads/
}

get_auc_comparison() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/results/roc_auc_comparison/${filename}" \
    ~/Downloads/
}
get_simdist() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/results/similarity_distributions/${filename}" \
    ~/Downloads/
}
get_results() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/results/${filename}" \
    ~/Downloads/
}

get_csv() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/results/csv/${filename}" \
    ~/Downloads/
}
get_sim() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/results/simulation/${filename}" \
    ~/Downloads/
}

get_checkpoint() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/checkpoints/${filename}" \
    ~/Downloads/
}

upload_sample() {
  local filename="$1"
  scp -i ~/.ssh/id_rsa \
    "~/Downloads/${filename}" \
    "trainee-01@saliksik.asti.dost.gov.ph:/home/trainee-01/scratch1/face-embedding-model-analysis/data/samples/input"
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

export QSYS_ROOTDIR="/home/joshuam/Programs/intel_quartus/quartus/sopc_builder/bin"
