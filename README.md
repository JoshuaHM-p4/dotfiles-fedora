# Dotfiles Repository

These are configuration files (dotfiles) for personal use, version-controlled for easy replication, restoration, and sharing across machines. The repository uses GNU Stow to symlink config files into appropriate locations.
This system is tailored for Fedora Linux.

## Restoring/Installing Dotfiles into New Machine

```bash
git clone --recursive https://github.com/JoshuaHM-p4/dotfiles-fedora.git ~/.dotfiles
cd ~/.dotfiles
stow -v .
```

This pulls in any plugins or themes managed as submodules (e.g., Alacritty themes, tmux plugin manager):

```bash
git submodule update --init --recursive
```

## Structure

- `nvim/` → Neovim configuration (linked to ~/.config/nvim)
- `tmux/` → tmux configuration (~/.tmux.conf and plugins)
- `alacritty/` → Alacritty terminal settings (~/.config/alacritty)
- `vim/` → Vim configuration (linked to ~/.vimrc and ~/.vim)
- `bash/` → Bash configuration (~/.bashrc and ~/.bash_profile)

## Requirements

- stow

```bash
sudo dnf install stow
```
