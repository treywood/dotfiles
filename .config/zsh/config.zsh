export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

# Cache brew prefix once. `brew --prefix` forks every call (~50–100ms);
# `brew shellenv` already exports HOMEBREW_PREFIX, so prefer that.
BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

# Plugins are vendored as git submodules under zsh/plugins/.
# ${0:A:h} = the directory of this sourced file.
ZSH_PLUGINS="${0:A:h}/plugins"

# zsh-tab-title
export ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
export ZSH_TAB_TITLE_ADDITIONAL_TERMS='kitty'
source "$ZSH_PLUGINS/zsh-tab-title/zsh-tab-title.plugin.zsh"

# zsh-autosuggestions
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fast-syntax-highlighting (must be sourced before history-substring-search)
source "$ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-history-substring-search (must be sourced after syntax highlighting)
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,underline'
source "$ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh"

# zsh-vi-mode (load last; it wraps other plugins' widgets via its after-init hook)
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
  bindkey '^@' autosuggest-accept

  # Load fzf keybindings after zsh-vi-mode
  source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
}
source "$ZSH_PLUGINS/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# Compute a worktree-collection-aware CWD for starship via a chpwd hook so
# starship doesn't fork a zsh + git rev-parse on every prompt redraw.
# starship reads $STARSHIP_CWD via [env_var.STARSHIP_CWD] in starship.toml.
autoload -Uz add-zsh-hook
_set_starship_cwd() {
  local gd
  gd=$(git rev-parse --git-common-dir 2>/dev/null)
  if [[ -z "$gd" ]]; then
    STARSHIP_CWD="${PWD/#$HOME/~}"
  else
    [[ "$gd" != /* ]] && gd="$PWD/$gd"
    local collection=${gd:A:h}
    if [[ "$PWD" == "$collection" ]]; then
      STARSHIP_CWD="${collection:t}"
    else
      STARSHIP_CWD="${collection:t}${PWD#$collection}"
    fi
  fi
  export STARSHIP_CWD
}
add-zsh-hook chpwd _set_starship_cwd
_set_starship_cwd

# Print a blank line before each prompt for visual separation in scrollback.
# Done via terminal output (not PROMPT) so Square's hermit emoji prefix — which
# is prepended to PROMPT — stays attached to the prompt line instead of dangling
# above the blank line. Skipping the first prompt avoids a blank line at the
# top of a fresh terminal.
_blank_line_before_prompt() {
  [[ -n ${_PROMPT_SHOWN-} ]] && print
  _PROMPT_SHOWN=1
}
add-zsh-hook precmd _blank_line_before_prompt

eval "$(starship init zsh)"

# Make Ctrl-L (and cmd+k via cmux/ghostty) redraw the FULL multi-line prompt.
# Default zsh clear-screen widget only redisplays the current edit line, which
# for starship's two-line prompt means you'd only see `❯` after a clear.
function _clear-screen-full-redraw() {
    print -n '\e[H\e[2J\e[3J'
    zle reset-prompt
    zle -R
}
zle -N clear-screen _clear-screen-full-redraw

# fzf shell integration
# Note: key-bindings.zsh is loaded in zvm_after_init() to avoid conflicts with zsh-vi-mode
source "$BREW_PREFIX/opt/fzf/shell/completion.zsh"

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

# Prevent prompt-side git calls (starship) from blocking on locks held by
# concurrent git operations in huge repos like android-register.
export GIT_OPTIONAL_LOCKS=0

export JQ_COLORS="0;35:0;35:0;35:0;39:0;32:0;39:0;39"
export JQ_PAGER="jqp"

export PATH="/usr/local/sbin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
export PATH="$PATH:$HOME/.cabal/bin"
export PATH="$PATH:$HOME/.ghcup/bin"

FPATH="$HOME/.completions:$FPATH"

: "${DEV_HOME:=$HOME/workspace}"
export DEV_HOME
function cdp() {
  cd "$DEV_HOME/$1"
}

export CLAUDE_CODE_NO_FLICKER=1
