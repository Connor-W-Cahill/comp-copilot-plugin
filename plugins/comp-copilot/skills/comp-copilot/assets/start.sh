#!/usr/bin/env bash
# Competition co-pilot layout:
#   left pane  = your working terminal (SSH / tools, if the event offers SSH)
#   right pane = live "suggestions" board that Claude appends to
#
# Claude watches the challenge (your Chrome tab, or this left pane over SSH) and
# appends next-step commands to the board. You copy what you want and run it.
# You always drive.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUGGESTIONS="${HERE}/suggestions.md"
SESSION="comp"

: > "$SUGGESTIONS"
printf '# Claude suggestions — %s\n\n(waiting for the loop to start…)\n' "$(date '+%H:%M')" >> "$SUGGESTIONS"

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
tmux attach -t "$SESSION"
