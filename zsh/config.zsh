# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$(brew --prefix)/share/antigen/antigen.zsh"
antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle command-not-found

export ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
export ZSH_TAB_TITLE_ADDITIONAL_TERMS='kitty'
antigen bundle trystan2k/zsh-tab-title

# last
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

POWERLEVEL9k_DISABLE_CONFIGURATION_WIZARD=true
source ~/.config/zsh/p10k.zsh

export GPG_TTY=$(tty)
export EDITOR="nvim"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
