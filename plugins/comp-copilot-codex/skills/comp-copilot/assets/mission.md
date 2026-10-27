# Mission context (the co-pilot reads this every cycle)

Keep this current — it's how the co-pilot knows the mission. Fill it in when the
event starts.

## Today's engagement

- Event / scope:
- Target IP / URL (exact origin, for the Chrome plugin):
- Access method: SSH available? (yes/no) / browser (Chrome)? / paste:
- Objective / win condition:
- Rules & constraints (what's allowed, what's off-limits):
- Flag format:
- AI assistance confirmed allowed for this event? (yes/no):

## How the co-pilot sees the challenge  <!-- set one -->

- [ ] SSH: I run the target shell in the left tmux pane; the co-pilot reads it
      with `tmux capture-pane -p -t comp:main.0`.
- [ ] Browser (Chrome plugin): the challenge is a Chrome tab; the co-pilot reads
      it via the Codex Chrome plugin (node_repl `js`: the page's innerText, or a
      screenshot for a canvas terminal). The target origin above must be granted
      to the Codex Chrome extension first.
- [ ] Web terminal (paste): the challenge is browser-only and unreadable (no
      Chrome plugin / origin not granted / pure canvas); I paste the relevant
      output into chat or append it to `inbox.md` when I want eyes.

## Watch mode  <!-- set one -->

- [ ] Goal: start with `/goal` (see goal-prompt.txt) + a token/time budget for
      the competition window; it watches and refreshes the board on its own.
- [ ] On-demand: I say "check it, what's next?" when I want a single pass.

## How I want the co-pilot to help

- Suggest ready-to-run commands in the suggestions pane; I copy/paste. Advise, don't execute.
- One line of "why" per suggestion so I learn, not just copy.
- Flag anything risky or possibly out-of-scope before suggesting it.
- If I go quiet, summarize where I am + the single best next move.
