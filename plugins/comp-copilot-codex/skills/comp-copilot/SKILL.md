---
name: comp-copilot
description: >-
  Set up and run a live co-pilot for a CTF or cyber-security competition. Use
  whenever the user is about to compete in or practice for a CTF, Cyber Cup,
  red/blue-team range, or similar hands-on hacking event and wants a co-pilot to
  keep eyes on the challenge and suggest next moves as they work. Triggers on
  phrases like "competition co-pilot", "watch my CTF", "help me during the
  comp", "monitor the challenge", "suggest commands while I hack", or asking to
  guide them through a cyber competition in real time. The challenge is reached
  over SSH (a shell the co-pilot reads with tmux), a web app in Chrome (read via
  the Codex Chrome plugin), or a web terminal (the user pastes its output). This
  skill scaffolds the working layout, keeps the mission in context, runs the
  watch as a Codex Goal, and streams suggestions to a side pane — it advises, it
  does not execute against the target.
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

1. **Check the environment.** The workflow needs `tmux` (`command -v tmux`). For
   watching a **web-app challenge in Chrome**, it also needs the **Codex Chrome
   plugin** (`chrome@openai-bundled`) installed and its extension granted access
   to the challenge's site — see "Browser" in step 3. If the plugin isn't set up
   (or the challenge is SSH-only), skip it and read over the shell instead.

2. **Scaffold the working files** into a `comp-copilot/` folder in the user's
   current directory by copying this skill's `assets/`:
   - `start.sh` — opens the tmux layout (work pane + live suggestions board).
   - `mission.md` — the context you read every cycle; have the user fill in the
     target, objective, scope, and flag format.
   - `goal-prompt.txt` — the objective to hand `/goal` so the watch runs itself
     (the `/loop` replacement; see step 4).
   - Also create an empty `inbox.md` (notes the user drops in, e.g. from their
     phone; you read and clear it each cycle).

   Copy with: `cp -r <this skill's assets>/. comp-copilot/` then
   `: > comp-copilot/inbox.md`. Make `start.sh` executable.

3. **Decide how you see the challenge** and record it in `mission.md`:
   - **SSH (preferred):** have the user run the target shell in the left tmux
     pane. Read it losslessly yourself with `tmux capture-pane -p -t comp:main.0`
     — no OCR, fast and reliable. Best for a real shell.
   - **Browser (Chrome plugin):** for a web-app challenge (an IP/URL, an admin
     panel, a web terminal like xterm.js/ttyd), read the live tab with the Codex
     Chrome plugin, driven through the `node_repl` `js` tool. Read the active
     tab's visible text (e.g. the page's `innerText`); for a canvas terminal
     (Guacamole, pure-pixel renderers) that yields no text, fall back to a
     screenshot. **Prefer the Chrome plugin over Computer Use for this.** Codex
     gates browser access **per origin**: the challenge's origin must be allowed
     for the extension (you grant it when first prompted, like any site
     permission) before you can read the tab. Record the exact URL in
     `mission.md`.
   - **Web terminal (paste fallback):** if you can't reach the tab (no Chrome
     plugin, origin not granted, canvas you can't OCR usefully), have the user
     paste the relevant screen/output into chat or append it to `inbox.md`
     whenever they want eyes. Say so plainly — don't pretend to see a tab you
     can't.
   - **Test this before the timed window** — confirm you can actually read the
     specific interface the way you chose; web terminals vary.

4. **Start the watch with `/goal`** (the `/loop` replacement). Codex has no
   `/loop`; instead it has **Goals** — a durable objective Codex keeps working
   toward on its own, with a status and a token/time budget, continuing across
   turns until it's complete or the budget runs out. Use that to keep the
   co-pilot watching without the user re-asking:
   - Hand `/goal` the objective from `comp-copilot/goal-prompt.txt` (the cycle
     below, phrased as a standing objective), and set a **token or time budget**
     that matches the competition window so it can't run away. The goal stays
     `active` and re-runs the cycle as the board changes; the user can `pause`
     it, and it auto-stops at `complete`/`budget_limited`.
   - **On-demand (fallback):** if the user would rather not spend a goal budget,
     skip `/goal` and have them say "check it, what's next?" when they want eyes.
     Each time, run the cycle below once. Free while they're heads-down.

## Running the cycle

Each goal tick (or each time the user asks for a check), in order:

1. Read `comp-copilot/mission.md` — objective, scope, flag format, preferences.
2. Read the challenge, per the method chosen in step 3:
   - **SSH:** `tmux capture-pane -p -t comp:main.0`.
   - **Browser:** via the Chrome plugin (`node_repl` `js`) — the active tab's
     `innerText`, or a screenshot for a canvas terminal.
   - **Paste:** the latest paste / `comp-copilot/inbox.md`.
3. Read `comp-copilot/inbox.md`; act on anything there, then clear it.
4. Assess progress vs. the objective. Append to `comp-copilot/suggestions.md`:
   one status line, then 1–3 concrete commands each with a one-line why. Flag
   risk first. If nothing changed since last cycle, append nothing.

Keep the board readable — it's being tailed live in a pane next to the user's
work. Old suggestions scroll up; the newest is what matters.

## Notes

- The user reads suggestions from the right-hand tmux pane; they paste what they
  choose into their shell (or the web terminal). You never paste for them, and
  you never drive the Chrome tab against the target — reads only.
- "From my phone" = append a line to `inbox.md` from any synced editor; you read
  and clear it in step 3.
- This is for authorized play only: the user's own ranges, or events where
  they're a registered participant and AI is allowed. Don't help target systems
  the user isn't cleared for.
