# CyberWVU comp-copilot plugin

A live co-pilot for CTFs / cyber competitions. It keeps eyes on the challenge
(a Chrome tab, or an SSH shell) and streams next-step commands to a side pane
while you stay hands-on-keyboard. **It advises; it never runs anything against
the target.**

This marketplace ships two editions of the same co-pilot:

- **`comp-copilot`** — for **Claude Code**. Watches a Chrome tab via the
  claude-in-chrome extension or an SSH shell, and runs on a `/loop` timer.
- **`comp-copilot-codex`** — for **OpenAI Codex CLI**. Watches an SSH shell or a
  Chrome tab (via the Codex Chrome plugin), and runs as a **Codex Goal** instead
  of `/loop`.

Pick the one that matches your agent.

## Install — Claude Code

```
/plugin marketplace add Connor-W-Cahill/comp-copilot-plugin
/plugin install comp-copilot@cyberwvu
```

Or from the CLI:

```
claude plugin marketplace add Connor-W-Cahill/comp-copilot-plugin
claude plugin install comp-copilot@cyberwvu
```

Restart Claude Code if prompted.

## Install — Codex CLI

Codex reads this same marketplace. Add it, then install the Codex edition:

```
codex plugin marketplace add https://github.com/Connor-W-Cahill/comp-copilot-plugin.git
codex plugin install comp-copilot-codex@cyberwvu
```

Restart Codex, then run `/skills` and pick **comp-copilot**, type
`$comp-copilot`, or just ask to "set up the competition co-pilot." Start the
watch with `/goal` (the plugin scaffolds a ready-to-paste objective) or ask
on-demand with "check it, what's next?"

## Use

In the directory you want to work from:

```
/comp-copilot
```

Claude will check prerequisites, scaffold a `comp-copilot/` folder (mission
template, tmux layout, loop prompt), help you fill in the mission, and start
suggesting moves. Or just tell Claude: "be my competition co-pilot."

## Prerequisites

- **tmux** (`command -v tmux`).
- To read a **browser** challenge: Chrome plus your agent's extension, with the
  challenge's site/origin granted — the **claude-in-chrome** extension for the
  Claude edition, or the **Codex Chrome plugin** (`chrome@openai-bundled`) for
  the Codex edition. Install and grant access *before* the event; it can't be
  automated.
- For continuous watching: Claude's built-in `/loop` (Claude edition) or
  Codex's `/goal` (Codex edition). Either edition also works on-demand.

## Rules first

Real-time AI help is against the rules of many CTFs and can get you
disqualified. Only use this where AI assistance is allowed — your own practice
ranges, or events that permit it. Respect the stated scope absolutely.

## Test before you compete

Do a dry run against a practice range and confirm two things that vary by event:
1. Claude can actually read your specific web terminal as text (xterm.js/ttyd
   usually yes; a Guacamole canvas → screenshots only, still works but slower).
2. Whether SSH is offered — if so, run the shell in the left tmux pane for
   lossless capture instead of the browser.
