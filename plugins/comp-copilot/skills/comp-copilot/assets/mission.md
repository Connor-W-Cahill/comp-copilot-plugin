# Mission context (Claude reads this every cycle)

Keep this current — it's how Claude knows the mission. Fill it in when the event
starts.

## Today's engagement

- Event / scope:
- Target IP / URL:
- Access method: web browser (Chrome tab) — SSH available? (yes/no):
- Objective / win condition:
- Rules & constraints (what's allowed, what's off-limits):
- Flag format:
- AI assistance confirmed allowed for this event? (yes/no):

## How Claude sees the challenge  <!-- set one -->

- [ ] Browser: read the Chrome tab (tabs_context → get_page_text/read_page;
      screenshot fallback if it's a canvas terminal).
- [ ] SSH: I run the shell in the left tmux pane; read it via
      `tmux capture-pane -p -t comp:main.0`.

## How I want Claude to help

- Suggest ready-to-run commands in the suggestions pane; I copy/paste. Advise, don't execute.
- One line of "why" per suggestion so I learn, not just copy.
- Flag anything risky or possibly out-of-scope before suggesting it.
- If I go quiet, summarize where I am + the single best next move.
