# CyberWVU comp-copilot plugin

A live co-pilot for CTFs / cyber competitions. It keeps eyes on the challenge
(a Chrome tab, or an SSH shell) and streams next-step commands to a side pane
while you stay hands-on-keyboard. **It advises; it never runs anything against
the target.**

## Install (teammates)

In Claude Code:

```
/plugin marketplace add <this-repo-url>
/plugin install comp-copilot@cyberwvu
```

Or from the CLI:

```
claude plugin marketplace add <this-repo-url>
claude plugin install comp-copilot@cyberwvu
```

Restart Claude Code if prompted.

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
- **Chrome + the claude-in-chrome extension**, with permission granted for the
  challenge's site — required to read a browser-based challenge. Install and
  grant this *before* the event; it can't be automated.
- Claude Code with the `/loop` skill (built in) if you want continuous watching.

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
