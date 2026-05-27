# Dotfiles

Personal configuration files for macOS development environment.

## Quick Start

To bootstrap a new machine with these dotfiles:

```bash
git clone --recurse-submodules https://github.com/yourusername/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./bootstrap.sh
```

The bootstrap script will:
- Install Homebrew (if not already installed)
- Install essential tools: Neovim, Kitty, bat, fzf, fd, ripgrep, starship
- Install Fira Code font (regular and Nerd Font variant)
- Set up fzf shell integration
- Initialize vendored zsh plugin submodules under `zsh/plugins/`
- Prompt for and create your development directory (default: `~/workspace/`)
- Create `~/.local/bin` and `~/.completions` directories
- Create symlinks for all configuration directories and files
- Backup any existing configurations to `~/.dotfiles-backup-TIMESTAMP`

## What's Included

### Configuration Directories (symlinked to `~/.config/`)
- **nvim/** - Neovim configuration with Lua (lazy.nvim)
- **kitty/** - Kitty terminal emulator settings
- **ghostty/** - Ghostty terminal emulator settings
- **zsh/** - Zsh shell configuration and vendored plugins
- **bat/** - Bat (cat alternative) configuration and themes
- **starship.toml** - Cross-shell prompt configuration

### Dotfiles (symlinked to `~/`)
- **.ideavimrc** - IntelliJ IdeaVim plugin configuration
- **.gitconfig** - Git configuration and aliases

### Claude Code (symlinked to `~/.claude/`)
- **claude/settings.json** - Claude Code settings
- **claude/statusline-command.sh** - Custom statusline script

### Other Files
- **Everforest-Hard-Dark.icls** - IntelliJ color scheme
- **.luarc.json** - Lua language server configuration

## What Gets Installed

The bootstrap script automatically installs:

### Via Homebrew
- **Neovim** - Modern Vim-based text editor
- **bat** - Cat clone with syntax highlighting
- **fzf** - Fuzzy finder for command line
- **fd** - Fast find alternative
- **ripgrep** - Fast grep alternative
- **starship** - Cross-shell prompt (configured via `starship.toml`)

### Via Official Installers
- **Kitty** - GPU-based terminal emulator (installed to `~/.local/kitty.app`)

### Fonts (via Homebrew Casks)
- **Fira Code** - Monospaced font with programming ligatures
- **Fira Code Nerd Font** - Fira Code with extra glyphs for powerline/icons

## Zsh Plugins

Zsh plugins are vendored as git submodules under `zsh/plugins/` and sourced
directly in `zsh/config.zsh` — no plugin manager required. Included:

- `zsh-vi-mode` - vi-style modal editing
- `fast-syntax-highlighting` - syntax highlighting for the command line
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
creating symlinks. Backups are stored in `~/.dotfiles-backup-TIMESTAMP/` and
include the date and time of the backup.

To restore a backup:
```bash
# Remove symlinks
rm ~/.config/nvim ~/.config/kitty ~/.config/ghostty # etc...

# Restore from backup
cp -r ~/.dotfiles-backup-TIMESTAMP/* ~/
```

## Structure

```
dotfiles/
├── bootstrap.sh         # Setup script for new machines
├── nvim/                # Neovim configuration
├── kitty/               # Kitty terminal config
├── ghostty/             # Ghostty terminal config
├── zsh/                 # Zsh configuration
│   ├── config.zsh       # Main zsh config file
│   ├── plugins/         # Vendored plugin submodules
│   └── _cdp             # cdp completion script
├── bat/                 # Bat configuration
├── claude/              # Claude Code settings + statusline
├── starship.toml        # Starship prompt config
├── .ideavimrc           # IdeaVim config
└── .gitconfig           # Git configuration
```

## License

Feel free to use and modify as needed.
