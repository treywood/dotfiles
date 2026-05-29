# dotfiles

Bare git repo at `~/.dotfiles`, work-tree `$HOME`. No symlinks — files live where they're consumed.

## Bootstrap

```sh
git clone --bare git@github.com:<you>/dotfiles ~/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles false
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --init --recursive
brew bundle install --file=~/Brewfile
# Add `source ~/.config/zsh/config.zsh` to ~/.zshrc
```

`checkout` refuses to overwrite existing files — move conflicts aside first.

## Update

`config` is a zsh function = `git --git-dir=~/.dotfiles --work-tree=$HOME`.

```sh
config status / add / commit / push       # like git
config submodule update --remote          # bump vendored nvim/zsh plugins
brew bundle install --file=~/Brewfile     # sync packages
```
