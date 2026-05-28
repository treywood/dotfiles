## Quick Start

```bash
./bootstrap.sh       # install + symlink everything
./macos-defaults     # opt-in: set sensible macOS system defaults
```

The bootstrap script will:
- Install Homebrew (if not already installed)
- `brew bundle install` everything in [`Brewfile`](Brewfile) (CLI tools, ghostty, Monaspace fonts)
- Set up fzf shell integration
- Initialize vendored zsh plugin submodules under `zsh/plugins/`
- Prompt for and create your development directory (default: `~/workspace/`)
- Create `~/.local/bin` and `~/.completions` directories
- Create symlinks for all configuration directories and files
- Backup any existing configurations to `~/.dotfiles-backup-TIMESTAMP`
- Append a managed block to `~/.zshrc` that sources `zsh/config.zsh`

## What's Included

### Configuration Directories (symlinked to `~/.config/`)
- **nvim/** - Neovim configuration with Lua (lazy.nvim)
- **ghostty/** - Ghostty terminal emulator settings
- **zsh/** - Zsh shell configuration and vendored plugins
- **bat/** - Bat (cat alternative) configuration and themes
- **starship.toml** - Cross-shell prompt configuration
- **overlay.ini** - fast-syntax-highlighting overlay theme (symlinked to `~/.config/fsh/overlay.ini`)

### Dotfiles (symlinked to `~/`)
- **.gitconfig** - Git configuration and aliases

### Claude Code (symlinked to `~/.claude/`)
- **claude/settings.json** - Claude Code settings
- **claude/statusline-command.sh** - Custom statusline script

### Other Files
- **.luarc.json** - Lua language server configuration

## What Gets Installed

Everything in [`Brewfile`](Brewfile). Edit that file to add or remove packages —
`./bootstrap.sh` will pick up the changes on re-run, and `brew bundle dump
--file=Brewfile --force` lets you snapshot the current state.

To remove things you've taken out of the Brewfile:

```bash
brew bundle cleanup --file=Brewfile        # dry run
brew bundle cleanup --file=Brewfile --force # actually uninstall
```

## macOS Defaults

`./macos-defaults` applies a curated set of `defaults write` commands —
keyboard repeat speed, Finder visibility tweaks, screenshot location, etc.
It's not run by `bootstrap.sh`; open it, comment out anything you don't want,
then run it. Most settings only take full effect after logout.

## Zsh Plugins

Zsh plugins are vendored as git submodules under `zsh/plugins/` and sourced
directly in `zsh/config.zsh` — no plugin manager required. Included:

- `zsh-vi-mode` - vi-style modal editing
- `fast-syntax-highlighting` - syntax highlighting for the command line
- `fzf-tab` - replace zsh's default completion menu with fzf
- `zsh-autosuggestions` - fish-style autosuggestions
- `zsh-history-substring-search` - history search bound to `^P`/`^N`/`^K`/`^J`
- `zsh-tab-title` - terminal tab title management

If you cloned without `--recurse-submodules`, run:

```bash
git submodule update --init --recursive
```

## Post-Installation

After running the bootstrap script:

1. **Restart your terminal** or run `exec zsh`. The starship prompt loads from
   `~/.config/starship.toml`; vendored zsh plugins are sourced from
   `zsh/plugins/`.

2. **Open Neovim** to install plugins:
   ```bash
   nvim
   ```
   lazy.nvim will automatically install all plugins on first run.

3. **Review any backups** in `~/.dotfiles-backup-TIMESTAMP/` if files were
   backed up.

## Customization

### Zsh Configuration
The main zsh configuration is in `zsh/config.zsh`. Your `~/.zshrc` should
source this file (the bootstrap script creates one if missing).

### Local Overrides
For machine-specific configurations that shouldn't be committed:
- Neovim: Use files in `.gitignore` like `nvim/lua/config/local.lua`
- Zsh: Add overrides to `~/.zshrc` after sourcing the dotfiles config

## Backup and Recovery

The bootstrap script automatically backs up existing configurations before
creating symlinks. Backups are stored in `~/.dotfiles-backup-TIMESTAMP/`,
mirroring the original paths under `$HOME` (e.g. `~/.config/nvim` is backed
up to `~/.dotfiles-backup-TIMESTAMP/.config/nvim`).

Use `./restore` to undo the bootstrap symlinks and (optionally) put the
backup back:

```bash
./restore                              # just remove the dotfiles symlinks
./restore ~/.dotfiles-backup-20260101  # also copy the backup tree back into $HOME
```

`./restore` leaves Brew packages and zsh plugin submodules alone — uninstall
those with `brew bundle cleanup --file=Brewfile --force` if you want a fully
clean machine.

## Managing Neovim Plugins

Neovim plugins are vendored as git submodules under `nvim/pack/vendor/start/`.
Two helper scripts at the repo root manage them:

- `./add-plugin <author/repo> [sha]` - add a plugin (optionally pinned to a sha)
- `./remove-plugin <name>` - deinit the submodule and clean up its config

Both print follow-up steps for wiring the plugin into `nvim/lua/config/plugins.lua`.

## Pre-Commit Hook

`bootstrap.sh` installs `hooks/pre-commit` as a symlink under `.git/hooks/`.
It runs `shellcheck` on any staged shell scripts (detected by extension or
shebang) and blocks the commit on findings. Edit `hooks/pre-commit` to change
behavior — changes take effect immediately since it's symlinked.

## Structure

```
dotfiles/
├── bootstrap.sh         # Setup script for new machines
├── restore              # Undo bootstrap symlinks (optionally restore a backup)
├── macos-defaults       # Opt-in `defaults write` settings for macOS
├── add-plugin           # Add a vendored nvim plugin (git submodule)
├── remove-plugin        # Remove a vendored nvim plugin
├── Brewfile             # Packages/casks installed by `brew bundle`
├── hooks/               # Git hooks symlinked into .git/hooks by bootstrap
├── nvim/                # Neovim configuration
├── ghostty/             # Ghostty terminal config
├── zsh/                 # Zsh configuration
│   ├── config.zsh       # Main zsh config file
│   ├── plugins/         # Vendored plugin submodules
│   └── _cdp             # cdp completion script
├── bat/                 # Bat configuration
├── claude/              # Claude Code settings + statusline
├── starship.toml        # Starship prompt config
├── overlay.ini          # fast-syntax-highlighting overlay theme
└── .gitconfig           # Git configuration
```

## License

Feel free to use and modify as needed.
