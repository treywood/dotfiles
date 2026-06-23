export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

# Ensure brew is on PATH and HOMEBREW_PREFIX is set, even if the parent
# .zshrc skips /etc/zprofile (common with company-managed shells).
if [[ -z ${HOMEBREW_PREFIX-} ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Plugins are vendored as git submodules under zsh/plugins/.
# ${0:A:h} = the directory of this sourced file.
ZSH_PLUGINS="${0:A:h}/plugins"

# zsh-tab-title
export ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
export ZSH_TAB_TITLE_ADDITIONAL_TERMS='ghostty'
source "$ZSH_PLUGINS/zsh-tab-title/zsh-tab-title.plugin.zsh"

# fzf-tab (must load after compinit, before plugins that wrap widgets)
autoload -Uz compinit
# Full compinit (with security audit) on first run or if the dump is >24h old;
# fast path (skip audit) only when the dump exists and is fresh.
if [[ -f ~/.zcompdump && -z ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -C
else
  compinit
fi
source "$ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh"

# zsh-autosuggestions
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fast-syntax-highlighting (must be sourced before history-substring-search)
source "$ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-history-substring-search (must be sourced after syntax highlighting)
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,underline'
source "$ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh"

# zsh-vi-mode (load last; it wraps other plugins' widgets via its after-init hook).
# Settings that reference ZVM_* constants (e.g. $ZVM_MODE_INSERT, $ZVM_READKEY_ENGINE_ZLE)
# MUST be set inside zvm_config — the constants don't exist until the plugin sources.
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
  ZVM_VI_SURROUND_BINDKEY='s-prefix'
  ZVM_VI_HIGHLIGHT_BACKGROUND='#503946'
  ZVM_VI_HIGHLIGHT_FOREGROUND='#d3c6aa'
}

function zvm_after_init() {
  bindkey '^K' history-substring-search-up
  bindkey '^P' history-substring-search-up
  bindkey '^J' history-substring-search-down
  bindkey '^N' history-substring-search-down
  bindkey '^@' autosuggest-accept

  # Load fzf keybindings after zsh-vi-mode
  source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
  bindkey -r '\ec'   # disable Alt-C / Esc-c fzf-cd-widget
}
source "$ZSH_PLUGINS/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

eval "$(starship init zsh)"

# fzf shell integration
source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"

# fzf configuration
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window=right:60%"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"

# Use fd if available for faster file/directory searching
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Don't highlight pasted text (zsh defaults the `paste` context to standout).
zle_highlight=('paste:none')

export GPG_TTY=$(tty)
export EDITOR="nvim"

# Prevent prompt-side git calls (starship) from blocking on locks
export GIT_OPTIONAL_LOCKS=0

export JQ_COLORS="0;35:0;35:0;35:0;39:0;32:0;39:0;39"

export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
export PATH="$PATH:$HOME/.cabal/bin"
export PATH="$PATH:$HOME/.ghcup/bin"

eval "$(zoxide init zsh)"

export CLAUDE_CODE_NO_FLICKER=1

# Bare-repo dotfiles: ~/.dotfiles is a bare git repo whose work-tree is $HOME.
# `config` is just git pinned at that repo + work-tree, so e.g.:
#   config status        # untracked files hidden via status.showUntrackedFiles
#   config add ~/.zshrc  # track a new file
config() {
  git -C "$HOME" --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}
compdef config=git
