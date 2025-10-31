#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${BLUE}=== Dotfiles Bootstrap Script ===${NC}"
echo -e "Dotfiles directory: ${GREEN}$DOTFILES_DIR${NC}"
echo

# Function to print colored messages
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        warning "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        success "✓ Homebrew installed"
    else
        success "✓ Homebrew already installed"
    fi
}

# Install Kitty terminal
install_kitty() {
    info "Checking Kitty installation..."

    if command -v kitty &> /dev/null; then
        success "✓ Kitty already installed"
    else
        info "Installing Kitty terminal..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        success "✓ Kitty installed"

        # Add kitty to PATH in the current session
        export PATH="$HOME/.local/bin:$PATH"

        info "Kitty installed to ~/.local/kitty.app"
        info "Desktop integration: ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/"
    fi
}

# Install packages via Homebrew
install_packages() {
    info "Checking and installing required packages..."

    local packages=(
        "neovim"
        "bat"
        "fzf"
        "fd"
        "ripgrep"
        "antigen"
    )

    for package in "${packages[@]}"; do
        if brew list "$package" &> /dev/null; then
            success "✓ $package already installed"
        else
            info "Installing $package..."
            brew install "$package"
            success "✓ $package installed"
        fi
    done
}

# Install fonts via Homebrew casks
install_fonts() {
    info "Checking and installing fonts..."

    local fonts=(
        "font-fira-code"
        "font-fira-code-nerd-font"
    )

    for font in "${fonts[@]}"; do
        if brew list --cask "$font" &> /dev/null; then
            success "✓ $font already installed"
        else
            info "Installing $font..."
            brew install --cask "$font"
            success "✓ $font installed"
        fi
    done
}

# Setup fzf shell integration
setup_fzf() {
    info "Setting up fzf shell integration..."

    if command -v fzf &> /dev/null; then
        # Run fzf install script for shell integration
        if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
            # Run with --key-bindings --completion --no-update-rc to install shell integration
            # without modifying rc files (our dotfiles handle that)
            "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>&1 | grep -v "Update your shell configuration"
            success "✓ fzf shell integration configured"
        fi
    fi
}

# Setup antigen
setup_antigen() {
    info "Setting up antigen..."

    local antigen_path="$(brew --prefix)/share/antigen/antigen.zsh"
    if [ -f "$antigen_path" ]; then
        success "✓ Antigen is available at $antigen_path"

        # Antigen will auto-install plugins on first zsh launch
        info "Antigen plugins will be installed on next shell launch"
    else
        error "Antigen not found at expected location"
        return 1
    fi
}

# Function to backup existing files/directories
backup_if_exists() {
    local target=$1
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        info "Backing up existing $target to $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        return 0
    fi
    return 1
}

# Setup development directory
setup_dev_directory() {
    info "Setting up development directory..."

    # Check if DEV_HOME is already set
    local dev_home="${DEV_HOME:-}"

    if [ -z "$dev_home" ]; then
        echo
        echo -e "${BLUE}Where would you like your development projects directory?${NC}"
        read -p "Enter path (default: ~/workspace): " dev_home
        dev_home="${dev_home:-$HOME/workspace}"
    fi

    # Expand tilde if present
    dev_home="${dev_home/#\~/$HOME}"

    if [ ! -d "$dev_home" ]; then
        info "Creating development directory: $dev_home"
        mkdir -p "$dev_home"
        success "✓ Development directory created"
    else
        success "✓ Development directory exists: $dev_home"
    fi

    # Export for use in this session
    export DEV_HOME="$dev_home"

    # Check if DEV_HOME is set in zshrc
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "export DEV_HOME=" "$HOME/.zshrc"; then
            info "Adding DEV_HOME to .zshrc"
            echo "" >> "$HOME/.zshrc"
            echo "# Development directory" >> "$HOME/.zshrc"
            echo "export DEV_HOME=\"$dev_home\"" >> "$HOME/.zshrc"
        fi
    fi
}

# Setup local bin directory
setup_local_bin() {
    info "Setting up ~/.local/bin directory..."

    if [ ! -d "$HOME/.local/bin" ]; then
        mkdir -p "$HOME/.local/bin"
        success "✓ Created ~/.local/bin directory"
    else
        success "✓ ~/.local/bin directory exists"
    fi

    # Add to PATH in current session
    export PATH="$HOME/.local/bin:$PATH"
}

# Setup completions directory
setup_completions() {
    info "Setting up zsh completions..."

    # Create completions directory if it doesn't exist
    if [ ! -d "$HOME/.completions" ]; then
        mkdir -p "$HOME/.completions"
        success "✓ Created ~/.completions directory"
    else
        success "✓ ~/.completions directory exists"
    fi

    # Symlink _cdp completion
    create_symlink "$DOTFILES_DIR/zsh/_cdp" "$HOME/.completions/_cdp" "cdp completion script"
}

# Function to create symlink with backup
create_symlink() {
    local source=$1
    local target=$2
    local description=$3

    if [ -L "$target" ]; then
        local current_link=$(readlink "$target")
        if [ "$current_link" = "$source" ]; then
            success "✓ $description (already linked correctly)"
            return 0
        else
            warning "Removing existing symlink: $target -> $current_link"
            rm "$target"
        fi
    fi

    backup_if_exists "$target" || true

    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$target")
    if [ ! -d "$parent_dir" ]; then
        info "Creating directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi

    ln -s "$source" "$target"
    success "✓ $description"
}

# Main execution flow
echo -e "${BLUE}Step 1: Installing dependencies${NC}\n"
check_homebrew
echo
install_packages
echo
install_fonts
echo
install_kitty
echo
setup_fzf
echo
setup_antigen
echo

echo -e "${BLUE}Step 2: Setting up directories${NC}\n"
setup_local_bin
echo
setup_dev_directory
echo
setup_completions
echo

echo -e "${BLUE}Step 3: Creating symlinks${NC}\n"

# Symlink .config directories
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" "Neovim config"
create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty" "Kitty terminal config"
create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh" "Zsh config directory"
create_symlink "$DOTFILES_DIR/bat" "$HOME/.config/bat" "Bat config"

# Symlink home directory dotfiles
create_symlink "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc" "IdeaVim config"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "Git config"

# Check if zsh config is sourced in .zshrc
echo
info "Checking .zshrc configuration..."
if [ -f "$HOME/.zshrc" ]; then
    if grep -q "source.*dotfiles/zsh/config.zsh" "$HOME/.zshrc"; then
        success "✓ .zshrc already sources zsh/config.zsh"
    else
        warning ".zshrc exists but doesn't source zsh/config.zsh"
        echo -e "${YELLOW}You may want to add this line to your .zshrc:${NC}"
        echo -e "${GREEN}source $DOTFILES_DIR/zsh/config.zsh${NC}"
    fi
else
    info "No .zshrc found. Creating one..."
    cat > "$HOME/.zshrc" << EOF
# Load dotfiles zsh configuration
source $DOTFILES_DIR/zsh/config.zsh
EOF
    success "✓ Created .zshrc with dotfiles configuration"
fi

# Summary
echo
echo -e "${BLUE}=== Bootstrap Complete ===${NC}"
if [ -d "$BACKUP_DIR" ]; then
    echo -e "Backups saved to: ${YELLOW}$BACKUP_DIR${NC}"
fi
echo
echo -e "${GREEN}All dependencies installed and symlinks created successfully!${NC}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Restart your terminal or run: exec zsh"
echo "     - Antigen will automatically install all zsh plugins on first launch"
echo "  2. Open Neovim to install plugins (Lazy.nvim auto-installs on first run)"
echo "  3. Review backed up files if any were created"
echo
echo -e "${BLUE}Installed tools:${NC}"
echo "  • Neovim, Kitty terminal"
echo "  • bat, fzf, fd, ripgrep"
echo "  • Antigen (zsh plugin manager)"
echo "  • Fira Code font (regular and Nerd Font variant)"
echo
echo -e "${BLUE}Directories configured:${NC}"
echo "  • ~/.local/bin (for local executables)"
echo "  • ~/.completions (zsh completion scripts)"
echo "  • ${DEV_HOME:-\$DEV_HOME} (development projects)"
echo
