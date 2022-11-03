# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$(brew --prefix)/share/antigen/antigen.zsh"

antigen bundle git
antigen bundle command-not-found

export ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
export ZSH_TAB_TITLE_ADDITIONAL_TERMS='kitty'
antigen bundle trystan2k/zsh-tab-title

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=green,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'
antigen bundle zsh-users/zsh-history-substring-search

export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
export ZVM_VI_SURROUND_BINDKEY='s-prefix'
export ZVM_CURSOR_STYLE_ENABLED=false
export ZVM_VI_HIGHLIGHT_BACKGROUND='green'
export ZVM_VI_HIGHLIGHT_FOREGROUND='black'
export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
antigen bundle jeffreytse/zsh-vi-mode

antigen theme romkatv/powerlevel10k

antigen apply

POWERLEVEL9k_DISABLE_CONFIGURATION_WIZARD=true
source ~/.config/zsh/p10k.zsh

bindkey -r '^P'
bindkey -r '^N'
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export GPG_TTY=$(tty)
export EDITOR="nvim"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
export PATH="$PATH:$HOME/.ghcup/bin"
