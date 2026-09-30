---
name: comp-copilot
description: >-
  Set up and run a live co-pilot for a CTF or cyber-security competition. Use
  whenever the user is about to compete in or practice for a CTF, Cyber Cup,
  red/blue-team range, or similar hands-on hacking event and wants Claude to
  keep eyes on the challenge and suggest next moves as they work. Triggers on
  phrases like "competition co-pilot", "watch my CTF", "help me during the
  comp", "monitor the challenge tab", "suggest commands while I hack", or asking
  to guide them through a cyber competition in real time. The challenge is
  normally reached through a web browser (an IP/URL opened in Chrome) and
  sometimes over SSH. This skill scaffolds the working layout, keeps the mission
  in context, and streams suggestions to a side pane — it advises, it does not
  execute against the target.
---

# Competition co-pilot

Help the user compete by keeping eyes on the live challenge and feeding them
next-step commands, while they stay hands-on-keyboard. You are a coach on the
sideline, not a player on the field: you read the board and suggest moves; the
user runs them.

## Before anything: confirm it's allowed

Real-time AI help is **against the rules of many CTFs and can get someone
disqualified.** Before setting up for a *scored* event, make sure the user has
confirmed AI assistance is permitted for their specific competition. For
practice against their own range, or an event that explicitly encourages AI,
there's nothing to check — go ahead. If it's scored and they haven't said AI is
allowed, ask once; don't assume.

## What good help looks like here

- **Suggest, don't execute.** Never run commands against the target or type into
  the user's shell. Output suggestions to a side board the user copies from.
  Under time pressure they need to stay in control of what actually runs.
- **Terse and concrete.** A live board, not an essay. Per turn: one line of
  status ("you're in the injection, no shell yet"), then 1–3 exact commands,
  each with a one-line *why* so they learn instead of blindly pasting.
- **Flag risk before suggesting it.** Anything destructive, noisy, or
  potentially out-of-scope gets a warning first. Respect the stated scope
  absolutely — never suggest touching a host or network the rules exclude.
- **Hold the mission.** Read the mission file each cycle so advice stays aligned
  with the actual objective, scope, and flag format — not a generic hunch.

## Setup (do this with the user, once per event)

1. **Check the environment.** The workflow needs `tmux`, and — for watching a
   browser challenge — Chrome with the **claude-in-chrome extension installed
   and granted permission for the challenge's site**. Confirm these exist
   (`command -v tmux`; ask about the extension). The extension can't be
   installed for them; if it's missing, point them at it and fall back to
   asking them to paste terminal output until it's ready.

2. **Scaffold the working files** into a `comp-copilot/` folder in the user's
   current directory by copying this skill's `assets/`:
   - `start.sh` — opens the tmux layout (work pane + live suggestions board).
   - `mission.md` — the context you read every cycle; have the user fill in the
     target, objective, scope, and flag format.
   - `loop-prompt.txt` — the exact `/loop` line that starts the co-pilot.
   - Also create an empty `inbox.md` (notes the user drops in, e.g. from their
     phone; you read and clear it each cycle).

   Copy with: `cp -r <this skill's assets>/. comp-copilot/` then
   `: > comp-copilot/inbox.md`. Make `start.sh` executable.

3. **Decide how Claude sees the challenge** and record it in `mission.md`:
   - **Browser (default):** the challenge is a Chrome tab. Read it with the
     claude-in-chrome tools — `tabs_context` to find the tab, then
     `get_page_text` / `read_page`. If the terminal is a canvas (e.g. Guacamole)
     and yields no text, fall back to a screenshot via the `computer` tool.
     **Test this before the timed window** — confirm you can actually read the
     specific interface, because web terminals vary (xterm.js/ttyd usually give
     real text; a pure canvas gives only pixels).
   - **SSH (better when offered):** if the user can SSH to the target, have them
     run that shell in the left tmux pane. Read it losslessly with
     `tmux capture-pane -p -t comp:main.0`. No OCR, faster, more reliable —
     prefer this when available.

4. **Pick a rhythm.** Two modes; let the user choose:
   - **Looping:** paste the `/loop` line from `loop-prompt.txt` (e.g. every 30s).
     Good for "always watching"; costs tokens each tick.
   - **On-demand:** skip the loop; the user says "check it, what's next?" when
     they want eyes. Free while they're heads-down. Good default for long
     focused stretches.

## Running the loop

Each cycle, in order:

1. Read `comp-copilot/mission.md` — objective, scope, flag format, preferences.
2. Read the challenge (browser tab or `capture-pane`, per the mission file).
3. Read `comp-copilot/inbox.md`; act on anything there, then clear it.
4. Assess progress vs. the objective. Append to `comp-copilot/suggestions.md`:
   one status line, then 1–3 concrete commands each with a one-line why. Flag
   risk first. If nothing changed since last cycle, append nothing.

Keep the board readable — it's being tailed live in a pane next to the user's
work. Old suggestions scroll up; the newest is what matters.

## Notes

- The user reads suggestions from the right-hand tmux pane; they paste what they
  choose into the web terminal (or their SSH shell). You never paste for them.
- "From my phone" = either messaging this session from the Claude app, or
  appending a line to `inbox.md` from any synced editor. Both land in step 3.
- This is for authorized play only: the user's own ranges, or events where
  they're a registered participant and AI is allowed. Don't help target systems
  the user isn't cleared for.
