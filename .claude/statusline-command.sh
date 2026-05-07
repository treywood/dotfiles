#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')

RESET='\033[0m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
GREY='\033[90m'

short_cwd="${cwd/#$DEV_HOME}"
short_cwd="${short_cwd/#$HOME/~}"
short_cwd="${short_cwd#/}"

# Git status (porcelain v2 — single call gives branch, upstream, ahead/behind, file states)
git_info=""
git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$git_root" ]; then
  status=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" -c core.fsmonitor=false \
    status --porcelain=v2 --branch --ignore-submodules=all 2>/dev/null)

  branch=""
  upstream=""
  ahead=0
  behind=0
  staged=0
  unstaged=0
  untracked=0
  conflicted=0

  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*)
        branch="${line#\# branch.head }"
        ;;
      "# branch.upstream "*)
        upstream="${line#\# branch.upstream }"
        ;;
      "# branch.ab "*)
        ab="${line#\# branch.ab }"
        a="${ab%% *}"
        b="${ab##* }"
        ahead="${a#+}"
        behind="${b#-}"
        ;;
      "1 "*|"2 "*)
        rest="${line#? }"
        xy="${rest%% *}"
        x="${xy%?}"
        y="${xy#?}"
        [ "$x" != "." ] && staged=$((staged+1))
        [ "$y" != "." ] && unstaged=$((unstaged+1))
        ;;
      "u "*)
        conflicted=$((conflicted+1))
        ;;
      "? "*)
        untracked=$((untracked+1))
        ;;
    esac
  done <<EOF
$status
EOF

  # Detached HEAD or unborn branch — show short SHA, no branch icon.
  branch_icon=" "
  if [ -z "$branch" ] || [ "$branch" = "(detached)" ]; then
    sha=$(git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null)
    [ -n "$sha" ] && branch="@${sha}"
    branch_icon=""
  fi

  stashes=$(git -C "$cwd" -c core.fsmonitor=false rev-list --walk-reflogs --count refs/stash 2>/dev/null)
  [ -z "$stashes" ] && stashes=0

  if [ -n "$branch" ]; then
    parts="${GREEN}${branch_icon}${branch}${RESET}"

    # Show upstream only if its short name differs from local branch
    if [ -n "$upstream" ]; then
      short_up="${upstream#*/}"
      if [ "$short_up" != "$branch" ]; then
        parts="${parts}${GREY}:${GREEN}${upstream}${RESET}"
      fi
    fi

    [ "$behind" -gt 0 ] && parts="${parts} ${GREEN}⇣${behind}${RESET}"
    [ "$ahead" -gt 0 ]  && parts="${parts} ${GREEN}⇡${ahead}${RESET}"
    [ "$stashes" -gt 0 ]    && parts="${parts} ${GREEN}*${stashes}${RESET}"
    [ "$conflicted" -gt 0 ] && parts="${parts} ${RED}~${conflicted}${RESET}"
    [ "$staged" -gt 0 ]     && parts="${parts} ${YELLOW}+${staged}${RESET}"
    [ "$unstaged" -gt 0 ]   && parts="${parts} ${YELLOW}!${unstaged}${RESET}"
    [ "$untracked" -gt 0 ]  && parts="${parts} ${GREEN}?${untracked}${RESET}"

    git_info=" ${parts}"
  fi
fi

printf '%b\n' "${CYAN}${short_cwd}${RESET}${git_info}"
