# 🧠 Ralph Wiggum

> Autonomous AI coding with spec-driven development

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Quick Start

**AI Agent? Start Here:**
> Read and execute [INSTALLATION.md](INSTALLATION.md) for a guided setup with interactive interview.

**Human Developer? Start Here:**
> Read [INSTALL.md](INSTALL.md) for manual setup instructions.

---

## What is Ralph Wiggum?

Ralph Wiggum combines **Geoffrey Huntley's iterative bash loop** with **SpecKit-style specifications** for fully autonomous AI-assisted software development.

### Key Features

- 🔄 **Iterative Self-Correction** — Each loop picks ONE task, implements it, verifies, and commits
- 📋 **Spec-Driven Development** — Professional specifications with clear acceptance criteria
- 🎯 **Completion Verification** — Agent only outputs `<promise>DONE</promise>` when criteria are 100% met
- 🧠 **Fresh Context Each Loop** — Every iteration starts with a clean context window
- 📝 **Shared State on Disk** — `IMPLEMENTATION_PLAN.md` persists between loops

---

## How It Works

Based on [Geoffrey Huntley's methodology](https://github.com/ghuntley/how-to-ralph-wiggum):

```
┌─────────────────────────────────────────────────────────────┐
│                     RALPH LOOP                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │    Orient    │───▶│  Pick Task   │───▶│  Implement   │  │
│  │  Read specs  │    │  from Plan   │    │   & Test     │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                   │         │
│         ┌────────────────────────────────────────┘         │
│         ▼                                                   │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   Verify     │───▶│   Commit     │───▶│  Output DONE │  │
│  │  Criteria    │    │   & Push     │    │  (if passed) │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                   │         │
│         ┌────────────────────────────────────────┘         │
│         ▼                                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Bash loop checks for <promise>DONE</promise>         │  │
│  │ If found: next iteration | If not: retry             │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### The Magic Phrase

The agent outputs `<promise>DONE</promise>` **ONLY** when:
- All acceptance criteria are verified
- Tests pass
- Changes are committed and pushed

The bash loop checks for this phrase. If not found, it retries.

---

## Two Modes

| Mode | Purpose | Command |
|------|---------|---------|
| **plan** | Gap analysis: compare specs vs code, create task list | `./scripts/ralph-loop.sh plan` |
| **build** | Implementation: pick task, implement, test, commit | `./scripts/ralph-loop.sh` |

---

## Installation

### For AI Agents

Point your AI agent to this repo and say:

> "Set up Ralph Wiggum in my project using https://github.com/fstandhartinger/ralph-wiggum"

The agent will:
1. Create all necessary files
2. Interview you about your project
3. Create a constitution.md with your preferences
4. Set up the bash loop scripts
5. Explain how to create specs and run Ralph

### Manual Setup

See [INSTALL.md](INSTALL.md) for step-by-step manual instructions.

---

## Usage

### 1. Create Specifications

Use `/speckit.specify` in Cursor or describe features to your AI:

```
/speckit.specify Add user authentication with OAuth
```

This creates `specs/001-user-auth/spec.md` with:
- Feature requirements
- Acceptance criteria
- Completion signal section

### 2. Run Planning Mode

```bash
./scripts/ralph-loop.sh plan
```

Creates `IMPLEMENTATION_PLAN.md` with prioritized tasks.

### 3. Run Build Mode

```bash
./scripts/ralph-loop.sh        # Unlimited iterations
./scripts/ralph-loop.sh 20     # Max 20 iterations
```

Each iteration:
1. Picks the highest priority task
2. Implements it completely
3. Verifies acceptance criteria
4. Outputs `<promise>DONE</promise>` only if criteria pass
5. Bash loop checks for the phrase
6. Context cleared, next iteration starts

### Using Codex Instead

```bash
./scripts/ralph-loop-codex.sh plan
./scripts/ralph-loop-codex.sh
```

---

## File Structure

```
project/
├── .specify/
│   └── memory/
│       └── constitution.md      # Project principles & config
├── specs/
│   └── NNN-feature-name/
│       └── spec.md              # Feature specification
├── scripts/
│   ├── ralph-loop.sh            # Claude Code loop
│   └── ralph-loop-codex.sh      # OpenAI Codex loop
├── PROMPT_build.md              # Build mode instructions
├── PROMPT_plan.md               # Planning mode instructions
├── IMPLEMENTATION_PLAN.md       # Shared state (task list)
├── AGENTS.md                    # Points to constitution
└── CLAUDE.md                    # Points to constitution
```

---

## Core Principles

### 1. Fresh Context Each Loop
Each iteration gets a clean context window. The agent reads files from disk each time.

### 2. Shared State on Disk
`IMPLEMENTATION_PLAN.md` persists between loops. Agent reads it to pick tasks, updates it with progress.

### 3. Backpressure via Tests
Tests, lints, and builds reject invalid work. Agent must fix issues before the magic phrase.

### 4. Completion Verification
Agent only outputs `<promise>DONE</promise>` when acceptance criteria are 100% verified. The bash loop enforces this.

### 5. Let Ralph Ralph
Trust the AI to self-identify, self-correct, and self-improve. Observe patterns and adjust prompts.

---

## Alternative Spec Sources

During installation, you can choose:

1. **SpecKit Specs** (default) — Markdown files in `specs/`
2. **GitHub Issues** — Fetch from a repository
3. **Custom Source** — Your own mechanism

The constitution and prompts adapt accordingly.

---

## Credits

This approach builds upon:

- [Geoffrey Huntley's how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum) — The original methodology
- [Original Ralph Wiggum technique](https://awesomeclaude.ai/ralph-wiggum) — By the Claude community
- [Claude Code Ralph Wiggum plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [SpecKit](https://github.com/github/spec-kit) by GitHub — Spec-driven development

Our contribution: Combining the bash loop approach with SpecKit-style specifications and a smooth AI-driven installation process.

---

## License

MIT License — See [LICENSE](LICENSE) for details.

---

**Website**: [ralph-wiggum-web.onrender.com](https://ralph-wiggum-web.onrender.com)
