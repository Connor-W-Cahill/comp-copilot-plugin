#!/usr/bin/env bash
# Competition co-pilot layout:
#   left pane  = your working terminal (SSH / tools)
#   right pane = live "suggestions" board that the co-pilot appends to
#
# The co-pilot watches the challenge (this left pane over SSH, read with
# `tmux capture-pane`) and appends next-step commands to the board. You copy
# what you want and run it. You always drive.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUGGESTIONS="${HERE}/suggestions.md"
SESSION="comp"

: > "$SUGGESTIONS"
printf '# Co-pilot suggestions — %s\n\n(waiting for the first check…)\n' "$(date '+%H:%M')" >> "$SUGGESTIONS"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "tmux session '$SESSION' already exists — attaching."
else
  tmux new-session -d -s "$SESSION" -n main
  tmux split-window -h -t "$SESSION:main" "less +F '$SUGGESTIONS'"
  tmux select-pane -t "$SESSION:main.0"
  tmux resize-pane -t "$SESSION:main.1" -x 55
fi

echo "Suggestions board: $SUGGESTIONS"
echo "Attach with:       tmux attach -t $SESSION"
echo "Co-pilot reads the left pane with: tmux capture-pane -p -t $SESSION:main.0"
tmux attach -t "$SESSION"
