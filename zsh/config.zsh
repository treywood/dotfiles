# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$(brew --prefix)/share/antigen/antigen.zsh"

export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

antigen bundle git
antigen bundle command-not-found

export ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
export ZSH_TAB_TITLE_ADDITIONAL_TERMS='kitty'
antigen bundle trystan2k/zsh-tab-title@main

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma-continuum/fast-syntax-highlighting

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,underline'
antigen bundle zsh-users/zsh-history-substring-search

export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
export ZVM_VI_SURROUND_BINDKEY='s-prefix'
export ZVM_VI_HIGHLIGHT_BACKGROUND='#503946'
export ZVM_VI_HIGHLIGHT_FOREGROUND='#d3c6aa'
export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE

# Load clipboard history widget before zsh-vi-mode
source ~/.config/zsh/clipboard-history.zsh

function zvm_after_init() {
  bindkey '^K' history-substring-search-up
  bindkey '^P' history-substring-search-up
  bindkey '^J' history-substring-search-down
  bindkey '^N' history-substring-search-down
  bindkey '^@' autosuggest-accept

  # Load fzf keybindings after zsh-vi-mode
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

  # Bind Ctrl-Y to clipboard search
  bindkey '^Y' fzf-clipboard-widget
}
antigen bundle jeffreytse/zsh-vi-mode

antigen theme romkatv/powerlevel10k

antigen apply

POWERLEVEL9k_DISABLE_CONFIGURATION_WIZARD=true
source ~/.config/zsh/p10k.zsh

# fzf shell integration
# Note: key-bindings.zsh is loaded in zvm_after_init() to avoid conflicts with zsh-vi-mode
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

# fzf configuration
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window=right:60%"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
export FZF_ALT_C_OPTS="--preview 'ls -la {}' --preview-window=right:60%"

# Use fd if available for faster file/directory searching
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

export GPG_TTY=$(tty)
export EDITOR="nvim"

export JQ_COLORS="0;35:0;35:0;35:0;39:0;32:0;39:0;39"

export PATH="/usr/local/sbin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
export PATH="$PATH:$HOME/.cabal/bin"
export PATH="$PATH:$HOME/.ghcup/bin"

FPATH="$HOME/.completions:$FPATH"

export DEV_HOME="$HOME/workspace/"
function cdp() {
  if [ -z "$1" ]; then
    local dir=$(find "$DEV_HOME" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf --preview 'ls -la {}' --preview-window=right:60%)
    [ -n "$dir" ] && cd "$dir"
  else
    cd "$DEV_HOME/$1"
  fi
}
