# dotfiles

Bare git repo at `~/.dotfiles`, work-tree `$HOME`. Files live where they're consumed — no symlinks, with one principled exception: on machines where `.zshrc` is corporate-managed, the tracked config is sourced from it (see bootstrap step 6). One source-line beats a checkout battle with IT.

`config` is a zsh function = `git --git-dir=~/.dotfiles --work-tree=$HOME` (defined in `.config/zsh/config.zsh`). It's used both during bootstrap (as `git ...` until the function is loaded) and for all everyday operations after.

## Bootstrap

```sh
# 1. Clone bare.
git clone --bare git@github.com:<you>/dotfiles ~/.dotfiles

# 2. Pre-checkout local config — hide $HOME from `status`, keep fsmonitor away
#    from $HOME. The tracked .gitconfig also enforces these via includeIf once
#    checked out, but they're needed *before* checkout to make step 3 safe.
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles false
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local core.fsmonitor false
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local core.untrackedCache false

# 3. Checkout. Refuses to overwrite existing files — move conflicts aside first.
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --init --recursive

# 4. Packages.
brew bundle install --file=~/Brewfile

# 5. Machine-local git config — identity, gpg, and any work-tree-scoped
#    includeIfs (e.g. work gitconfig pulled in for ~/Development/).
#    Example:
#      [user]
#          name = Your Name
#          email = you@example.com
#      [commit]
#          gpgsign = false
$EDITOR ~/.gitconfig.local

# 6. On machines where ~/.zshrc is not corporate-managed, the tracked
#    config.zsh is your zshrc — point your shell at it however your distro
#    expects. On corporate-managed machines, source it from the existing rc:
grep -q 'config.zsh' ~/.zshrc || echo 'source ~/.config/zsh/config.zsh' >> ~/.zshrc

# 7. Apply the fast-syntax-highlighting overlay (one-time; persists in fsh state).
zsh -ic 'fast-theme XDG:overlay'
```

After step 6's shell reload, `config` (the function) is available everywhere.

## Update

```sh
config status / add / commit / push       # like git
brew bundle install --file=~/Brewfile     # sync packages
```

### Bumping a vendored submodule

Submodule SHAs in this repo are the lockfile. To intentionally bump one:

```sh
cd ~/.config/nvim/pack/vendor/start/<plugin>
git fetch && git checkout <ref>      # or `origin/main` for latest
cd ~ && config add <path> && config commit -m "bump <plugin>"
```

## Per-machine files (not tracked)

- `~/.gitconfig.local` — identity, gpg, work-tree includeIfs
- `~/.claude/settings.local.json` — Claude Code permission grants + per-machine flags (e.g. `skipDangerousModePermissionPrompt`)
- `~/.config/nvim/lua/config/local.lua`, `~/.config/nvim/lua/config/lazy/local.lua` — nvim local overrides
