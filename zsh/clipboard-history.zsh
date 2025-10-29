#!/usr/bin/env zsh

# Clipboard history file
CLIPBOARD_HISTORY_FILE="${HOME}/.clipboard_history"
CLIPBOARD_HISTORY_MAX=1000

# Initialize clipboard history file if it doesn't exist
[[ -f "$CLIPBOARD_HISTORY_FILE" ]] || touch "$CLIPBOARD_HISTORY_FILE"

# Function to add to clipboard history
_add_to_clipboard_history() {
  local clip="$(pbpaste)"

  # Only add if not empty and different from last entry
  if [[ -n "$clip" ]]; then
    local last_clip=""
    [[ -f "$CLIPBOARD_HISTORY_FILE" ]] && last_clip="$(head -n 1 "$CLIPBOARD_HISTORY_FILE")"

    if [[ "$clip" != "$last_clip" ]]; then
      # Create a temporary file with the new clip at the top
      local temp_file="${CLIPBOARD_HISTORY_FILE}.tmp"
      echo "$clip" > "$temp_file"
      echo "---CLIP---" >> "$temp_file"

      # Append existing history
      if [[ -f "$CLIPBOARD_HISTORY_FILE" ]]; then
        cat "$CLIPBOARD_HISTORY_FILE" >> "$temp_file"
      fi

      # Keep only the last N clips
      awk -v max="$CLIPBOARD_HISTORY_MAX" '
        BEGIN { RS="---CLIP---"; count=0 }
        NF && count < max {
          if (count > 0) print "---CLIP---"
          printf "%s", $0
          count++
        }
      ' "$temp_file" > "$CLIPBOARD_HISTORY_FILE"

      rm -f "$temp_file"
    fi
  fi
}

# FZF widget to search clipboard history
fzf-clipboard-widget() {
  local selected

  if [[ ! -f "$CLIPBOARD_HISTORY_FILE" ]]; then
    zle -M "No clipboard history found"
    return
  fi

  # Parse clipboard history and show in fzf
  selected=$(awk '
    BEGIN { RS="---CLIP---"; count=1 }
    NF {
      # Trim leading/trailing whitespace
      gsub(/^[[:space:]]+|[[:space:]]+$/, "")
      if (length($0) > 0) {
        # Replace newlines with ␤ for display
        gsub(/\n/, "␤", $0)
        # Truncate long entries for display
        display = (length($0) > 100) ? substr($0, 1, 100) "..." : $0
        printf "[%d] %s\n", count, display
        count++
      }
    }
  ' "$CLIPBOARD_HISTORY_FILE" | \
    fzf --height 40% \
        --reverse \
        --header "Select clipboard entry" \
        --preview-window="down:wrap" \
        --preview 'num=$(echo {} | grep -o "^\[[0-9]*\]" | tr -d "[]"); awk -v n="$num" '\''BEGIN { RS="---CLIP---"; count=1 } NF && count==n { gsub(/^[[:space:]]+|[[:space:]]+$/, ""); print; exit } NF { count++ }'\'' "'"$CLIPBOARD_HISTORY_FILE"'"')

  if [[ -n "$selected" ]]; then
    # Extract the clip number
    local num=$(echo "$selected" | grep -o "^\[[0-9]*\]" | tr -d "[]")

    # Get the actual clip content
    local clip=$(awk -v n="$num" '
      BEGIN { RS="---CLIP---"; count=1 }
      NF && count==n {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "")
        print
        exit
      }
      NF { count++ }
    ' "$CLIPBOARD_HISTORY_FILE")

    if [[ -n "$clip" ]]; then
      # Copy to clipboard
      echo -n "$clip" | pbcopy
      zle -M "Copied to clipboard"
    fi
  fi

  zle reset-prompt
}

# Register the widget
zle -N fzf-clipboard-widget

# Monitor clipboard changes in background (check every 2 seconds)
_clipboard_monitor() {
  while true; do
    _add_to_clipboard_history
    sleep 2
  done
}

# Start clipboard monitoring in background if not already running
if [[ -z "${CLIPBOARD_MONITOR_PID}" ]]; then
  _clipboard_monitor &
  export CLIPBOARD_MONITOR_PID=$!

  # Kill monitor on shell exit
  trap "kill ${CLIPBOARD_MONITOR_PID} 2>/dev/null" EXIT
fi
