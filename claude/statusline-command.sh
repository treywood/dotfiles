#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Shorten cwd: replace $HOME with ~
home="$HOME"
short_cwd=" ${cwd/#$home/~}"

# Git branch (skip optional locks to avoid stalling)
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    dirty=$(git -C "$cwd" -c core.fsmonitor=false status --porcelain 2>/dev/null | head -1)
    if [ -n "$dirty" ]; then
      git_info=" ( $branch *)"
    else
      git_info=" ( $branch)"
    fi
  fi
fi

# Context usage
ctx_info=""
if [ -n "$used_pct" ]; then
  ctx_int=$(printf "%.0f" "$used_pct")
  ctx_info=" ctx:${ctx_int}%"
fi

printf "%s%s\n%s%s" "$short_cwd" "$git_info" "$model" "$ctx_info"
