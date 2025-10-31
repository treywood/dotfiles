# Dotfiles

Personal configuration files for macOS development environment.

## Quick Start

To bootstrap a new machine with these dotfiles:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./bootstrap.sh
```

The bootstrap script will:
- Install Homebrew (if not already installed)
- Install essential tools: Neovim, Kitty, bat, fzf, fd, ripgrep, antigen
- Install Fira Code font (regular and Nerd Font variant)
- Set up fzf shell integration
- Configure antigen (zsh plugin manager)
- Prompt for and create your development directory (default: `~/workspace/`)
- Create `~/.local/bin` directory for local executables
- Create symlinks for all configuration directories and files
- Backup any existing configurations to `~/.dotfiles-backup-TIMESTAMP`
- Provide guidance on next steps

## What's Included

### Configuration Directories (symlinked to `~/.config/`)
- **nvim/** - Neovim configuration with Lua
- **kitty/** - Kitty terminal emulator settings
- **zsh/** - Zsh shell configuration and customizations
- **bat/** - Bat (cat alternative) configuration and themes

### Dotfiles (symlinked to `~/`)
- **.ideavimrc** - IntelliJ IdeaVim plugin configuration
- **.gitconfig** - Git configuration and aliases

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
- **antigen** - Zsh plugin manager

### Via Official Installers
- **Kitty** - GPU-based terminal emulator (installed to `~/.local/kitty.app`)

### Fonts (via Homebrew Casks)
- **Fira Code** - Monospaced font with programming ligatures
- **Fira Code Nerd Font** - Fira Code with extra glyphs for powerline/icons

## Post-Installation

After running the bootstrap script:

1. **Restart your terminal** or run:
   ```bash
   exec zsh
   ```
   Antigen will automatically install all zsh plugins (powerlevel10k theme, zsh-vi-mode, syntax highlighting, etc.) on first launch.

2. **Open Neovim** to install plugins:
   ```bash
   nvim
   ```
   Lazy.nvim will automatically install all plugins on first run.

3. **Review any backups** in `~/.dotfiles-backup-TIMESTAMP/` if files were backed up

## Customization

### Zsh Configuration
The main zsh configuration is in `zsh/config.zsh`. Your `~/.zshrc` should source this file.

### Local Overrides
For machine-specific configurations that shouldn't be committed:
- Neovim: Use files in `.gitignore` like `nvim/lua/config/local.lua`
- Zsh: Add overrides to `~/.zshrc` after sourcing the dotfiles config

## Backup and Recovery

The bootstrap script automatically backs up existing configurations before creating symlinks. Backups are stored in `~/.dotfiles-backup-TIMESTAMP/` and include the date and time of the backup.

To restore a backup:
```bash
# Remove symlinks
rm ~/.config/nvim ~/.config/kitty # etc...

# Restore from backup
cp -r ~/.dotfiles-backup-TIMESTAMP/* ~/
```

## Structure

```
dotfiles/
├── bootstrap.sh          # Setup script for new machines
├── nvim/                 # Neovim configuration
├── kitty/                # Kitty terminal config
├── zsh/                  # Zsh configuration
│   ├── config.zsh       # Main zsh config file
│   └── _cdp             # cdp completion script
├── bat/                  # Bat configuration
├── .ideavimrc           # IdeaVim config
└── .gitconfig           # Git configuration
```

## License

Feel free to use and modify as needed.
