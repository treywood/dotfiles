# dotfiles

A bare git repo at `~/.dotfiles` whose work-tree is `$HOME`. Files live where
they're actually consumed (e.g. `~/.config/nvim/`, `~/.gitconfig`,
`~/Brewfile`) — no symlink bootstrap.

## Working with the repo

`config.zsh` defines a `config` function (`git --git-dir=~/.dotfiles
--work-tree=$HOME`). Use it like git:

```sh
config status                # untracked files hidden
config add ~/.zshrc          # start tracking a file
config diff
config commit -m "..."
config push
```

`status.showUntrackedFiles=false` is set so `config status` doesn't list every
file in `$HOME`. To inspect untracked files temporarily: `config status -u`.

## New-machine bootstrap

```sh
git clone --bare git@github.com:<you>/dotfiles ~/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles false
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --init --recursive
brew bundle install --file=~/Brewfile
# Add `source ~/.config/zsh/config.zsh` to ~/.zshrc
```

Existing files at conflicting paths must be moved aside first; the `checkout`
will refuse to overwrite them.

## What's tracked

- **~/.config/nvim/** — Neovim config, plugins vendored as submodules under `pack/`
- **~/.config/zsh/config.zsh** — sourced from `~/.zshrc`; vendored plugins under `plugins/`
- **~/.config/ghostty/** — Ghostty terminal config
- **~/.config/bat/** — Bat config
- **~/.config/starship.toml** — Starship prompt
- **~/.config/fsh/overlay.ini** — fast-syntax-highlighting overlay theme
- **~/.claude/settings.json**, **~/.claude/statusline-command.sh** — Claude Code
- **~/.gitconfig** — git config (`include`s Square's gitconfig)
- **~/Brewfile** — `brew bundle install --file=~/Brewfile` to sync packages
- **~/.local/bin/macos-defaults** — opt-in `defaults write` settings
- **~/.local/bin/add-plugin**, **~/.local/bin/remove-plugin** — nvim plugin submodule helpers

## Plugin submodules

Both nvim and zsh plugins are git submodules. Update with:

```sh
config submodule update --init --recursive   # initial / after pull
config submodule update --remote             # bump to latest
```

## Pre-commit hook

The pre-commit hook (`shellcheck` on staged shell scripts) lives at
`~/.dotfiles/hooks/pre-commit` — directly in the bare repo's own hooks dir.
