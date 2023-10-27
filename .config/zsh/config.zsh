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
antigen bundle zdharma-continuum/fast-syntax-highlighting

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,underline'
antigen bundle zsh-users/zsh-history-substring-search

export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
export ZVM_VI_SURROUND_BINDKEY='s-prefix'
export ZVM_VI_HIGHLIGHT_BACKGROUND='#503946'
export ZVM_VI_HIGHLIGHT_FOREGROUND='#d3c6aa'
export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
function zvm_after_init() {
  bindkey '^K' history-substring-search-up
  bindkey '^P' history-substring-search-up
  bindkey '^J' history-substring-search-down
  bindkey '^N' history-substring-search-down
  bindkey '^L' autosuggest-accept
}
antigen bundle jeffreytse/zsh-vi-mode

antigen theme romkatv/powerlevel10k

antigen apply

POWERLEVEL9k_DISABLE_CONFIGURATION_WIZARD=true
source ~/.config/zsh/p10k.zsh

export GPG_TTY=$(tty)
export EDITOR="nvim"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
export PATH="$PATH:$HOME/.cabal/bin"
export PATH="$PATH:$HOME/.ghcup/bin"

FPATH="$HOME/.completions:$FPATH"

export DEV_HOME="$HOME/workspace/"
function cdp() {
  cd "$DEV_HOME/$1"
}
