# CyberHawks Agent Ladder

Starter files from the CyberHawks (University of North Georgia) talk *Climb the Agent Ladder:
Agentic AI for Cybersecurity*. Each rung adds one capability to a coding agent. This repo
already contains every rung, so you can open it and try them, or read each file to build
your own.

| Rung | What it adds | File in this repo |
|---|---|---|
| 1. Rules | Instructions the agent reads every session | `AGENTS.md` |
| 2. Slash command | A saved prompt you run with `/triage` | `.claude/commands/triage.md` |
| 3. Skill | Know-how that loads itself when relevant, plus extra files | `.claude/skills/sherlock-triage/` |
| 4. Subagents | Specialists with their own context window | `.claude/agents/` |
| 5. Hook | A script that blocks dangerous commands automatically | `.claude/hooks/guard.sh` + `.claude/settings.json` |
| 6. Multi-agent | One orchestrator running subagents in parallel | (a prompt, see below) |
| 7. Plugin | All of the above, packaged so anyone can install it | `plugins/cyberhawks-ladder/` |

> Use these only on targets you are authorized to test: your own VMs, HTB Sherlocks/labs
> on your own account, picoCTF. Read your competition's AI rules before using agents there
> (NCL, for example, allows AI tools but bans agents that touch the game platform).

---

## Rung 0: Set up (do this first)

1. Install [VS Code](https://code.visualstudio.com) and the **Claude Code** extension.
   Claude Code needs a paid Claude plan (Pro or higher) or API credits.
2. Optional: install the **Agent Flow** extension to watch agents work as a live graph.
3. Install `jq` (needed by the hook): `sudo apt install jq` (Kali/Ubuntu) or `brew install jq` (macOS).
   The hook is a bash script, so on Windows use WSL.
4. Clone this repo:
   ```bash
   git clone https://github.com/ThomasMurilloBivins/agent-ladder-CH.git
   ```
5. In VS Code, open the project root: **File → Open Folder… → select `agent-ladder-CH`**.
   The project root is the folder that directly contains `.claude/` and `AGENTS.md`.
   Open that folder itself, not its parent and not a subfolder.
6. If you use Agent Flow, open it first: **Ctrl+Shift+P → "Agent Flow: Open Agent Flow"**.
   Then open the Claude Code panel from the left Activity Bar.

**Reload rule:** subagents and hooks load when a session starts. After you add or change
them, run **Ctrl+Shift+P → "Developer: Reload Window"**. Skills and commands can be
refreshed in chat with `/reload-skills`.

---

## Rung 1: Rules (`AGENTS.md`)

A plain Markdown file of rules the agent reads every session. Put your scope and your rules
of engagement here. Claude Code v2.1.277 and later reads `AGENTS.md` directly. On older
versions, create a `CLAUDE.md` containing one line: `@AGENTS.md`.

**Try it:** start a session. You should see `AGENTS.md loaded`.

## Rung 2: Slash command (`/triage`)

A saved prompt. The file name becomes the command, and `$ARGUMENTS` is whatever you type
after it.

**Try it:** `/triage samples/sample-auth.log`

Gotcha: `/triage` with no path used to run and silently do nothing. This version stops
and asks you for a path.

## Rung 3: Skill (`sherlock-triage`)

A folder with a `SKILL.md`. Claude loads it **automatically** when your request matches its
description, and it can bring along extra files. Here, `sigma-style.md` loads only when you
ask for a detection rule. `SKILL.md` is an open standard that Codex, GitHub Copilot, Gemini CLI
and other tools also read.

**Try it:** `/sherlock-triage samples/sample-auth.log`, then ask:
*"Write a Sigma rule that would have caught this."*

## Rung 4: Subagents (`recon`, `web`, `notes`)

Each subagent runs in its own context window with its own instructions and tool list, and
sends back only a summary. Claude delegates to one automatically when your request matches
its `description`. To call one yourself, type `@` and pick it.

**Try it:** `@recon summarize samples/scan.txt and flag the best lead`

Gotchas: every agent needs a unique `name:`, because two files with the same name collide
and one disappears. The old `/agents` menu is gone in recent versions, so type `@` to see
your agents.

## Rung 5: Hook (`guard.sh`)

Before every Bash command, Claude Code passes the command to `guard.sh`. Exit code `2`
**blocks** it before it runs; exit `0` lets it through. This holds even if someone turns
off permission prompts.

**Try it:** ask *"Run: rm -rf /tmp/test"*. It is blocked, even though the folder doesn't exist.

If it doesn't block: check that `which jq` prints a
path, run `jq . .claude/settings.json` to validate the JSON, then reload the window.

## Rung 6: Multi-agent (orchestrator)

Your main chat becomes the orchestrator and runs the subagents in parallel. Agent Flow
draws each one as a branch.

**Try it:** paste this prompt:
```
You are the orchestrator for my authorized lab VM. Delegate in parallel using subagents:
  - recon: read samples/scan.txt and flag the best foothold
  - web:   read samples/site/index.html and note likely issues
  - notes: record findings in engagement-log.md
Collect all three and give me ONE prioritized next step. Do not exploit anything.
```

## Rung 7: Plugin (package and share)

`plugins/cyberhawks-ladder/` contains rungs 3–5 packaged as one plugin. This repo is also a
plugin **marketplace** (see `.claude-plugin/marketplace.json`), so you can use the ladder in
any project:

```
/plugin marketplace add ThomasMurilloBivins/agent-ladder-CH
/plugin install cyberhawks-ladder@cyberhawks
```

Plugin skills get a prefix: `/cyberhawks-ladder:sherlock-triage`.
Don't install the plugin and also work inside this repo at the same time, or the hook runs
twice.

---

## The same ladder in other tools

| Rung | Claude Code | GitHub Copilot | Codex | Cursor |
|---|---|---|---|---|
| Rules | `AGENTS.md` / `CLAUDE.md` | `.github/copilot-instructions.md` | `AGENTS.md` | Rules / `AGENTS.md` |
| Commands | `.claude/commands/` | `.github/prompts/*.prompt.md` | prompts | Commands |
| Skills | `.claude/skills/` | `.github/skills/` (also reads `.claude/skills/`) | `.agents/skills/` | Skills |
| Subagents | `.claude/agents/` | `.github/agents/` | — | Subagents |
| Hooks | `.claude/settings.json` | `.github/hooks/*.json` | — | Hooks |

Exact paths change often, so check each tool's docs.

## Practice data

- `samples/` contains a fake auth.log, a fake nmap scan and a fake web page.
- For a real log, try the **HTB Sherlock "Brutus"**, an SSH brute-force investigation of a
  Linux `auth.log`. Download it from Hack The Box and run
  `/sherlock-triage path/to/auth.log`, then paste the Sherlock's questions.

## Learn more

- Claude Code docs: <https://code.claude.com/docs>
- Agent Flow: <https://github.com/patoles/agent-flow>
- OWASP Top 10 for Agentic Applications: <https://genai.owasp.org>
