# AI AGENT: Execute These Installation Instructions

> **YOU ARE AN AI CODING AGENT.** Follow these instructions to set up Ralph Wiggum in the user's project.
> 
> **DO NOT just describe these steps.** Actually execute them and interview the user.

---

## Phase 1: Create Directory Structure

Create these directories in the user's project:

```bash
mkdir -p .specify/memory
mkdir -p .specify/specs
mkdir -p templates
mkdir -p scripts
mkdir -p .cursor/commands
mkdir -p .claude/commands
```

---

## Phase 2: Create Pointer Files

### 2a. Create AGENTS.md

Create `AGENTS.md` in the project root:

```markdown
# Agent Instructions

**Read the constitution**: `.specify/memory/constitution.md`

That file contains ALL instructions for working on this project, including:
- Project principles and constraints
- Ralph Wiggum workflow configuration
- Autonomy settings (YOLO mode, git autonomy)
- How to run the Ralph loop
- Specification or issue tracking approach

The constitution is the single source of truth. Read it on every chat session.
```

### 2b. Create CLAUDE.md

Create `CLAUDE.md` in the project root:

```markdown
# Claude Instructions

**Read the constitution**: `.specify/memory/constitution.md`

That file contains ALL instructions for working on this project.
```

---

## Phase 3: Interview the User

**You MUST interview the user to gather information for the constitution.** 

Present these questions one section at a time, waiting for responses:

### Interview Section 1: Project Basics

Ask the user:

```
## Let's set up Ralph Wiggum for your project!

I'll ask you a few questions to create your project constitution.

**1. Project Name**: What is your project called?

**2. Project Description**: In 1-2 sentences, what does this project do?

**3. Tech Stack**: What technologies are you using? (e.g., Next.js, Python/FastAPI, React, etc.)
```

Wait for response, then continue:

### Interview Section 2: Autonomy Settings

```
## Autonomy Configuration

Ralph Wiggum works best with full autonomy. I'll configure this for you.

**4. YOLO Mode** (Strongly Recommended ✅)

YOLO mode allows me to work without asking permission for every action.
This is ESSENTIAL for the Ralph loop to work properly.

⚠️ **Warning**: YOLO mode gives the AI full access to read, write, and execute.
Only use in version-controlled projects where you can revert changes.

Do you want to enable YOLO mode? (yes/no, default: yes)

**5. Autonomous Git** (Strongly Recommended ✅)

This allows me to commit and push changes without asking.
Essential for continuous autonomous work.

Do you want to enable autonomous commit and push? (yes/no, default: yes)
```

Wait for response, then continue:

### Interview Section 3: Work Item Source

```
## Work Item Source

How do you want to track what needs to be built?

**6. Choose your approach**:

| Option | Description |
|--------|-------------|
| A | **SpecKit Specs** — Create specs in `specs/` folder using `/speckit.specify` |
| B | **GitHub Issues** — Use GitHub Issues as your backlog |
| C | **Custom** — Use another issue tracker (Jira, Linear, etc.) |

Which option? (A/B/C, default: A)
```

Wait for response, then continue:

### Interview Section 4: Additional Settings

```
## Additional Settings

**7. Design System** (optional): Do you have a design system or style guide file I should reference? If yes, provide the path.

**8. Deployment**: How do you deploy? (e.g., Render, Vercel, manual, none yet)

**9. The Magic Word**: When you're ready for me to start working through your backlog, just say:

> "Ralph, start working"

I'll then give you the command to run the Ralph loop in your terminal.
```

---

## Phase 4: Create the Constitution

After gathering all interview responses, create `.specify/memory/constitution.md`:

```markdown
# [PROJECT_NAME] Constitution

> [PROJECT_DESCRIPTION]

## Version
1.0.0

---

## 🔍 Context Detection

**AI Agent: Read this section first to understand your context.**

You are reading this constitution in one of two contexts:

### Context A: Ralph Loop (Implementation Mode)
You are in a Ralph loop if:
- You were started by `ralph-loop.sh` or `ralph-loop-codex.sh`
- Your prompt mentions "implement spec" or "work through all specs/issues"
- You see `<promise>` completion signals in your instructions

**In this context**: Focus on implementation. Follow the spec. Complete the acceptance criteria. Output `<promise>DONE</promise>` when finished.

### Context B: Interactive Chat (Discussion Mode)
You are in interactive chat if:
- The user is asking questions, discussing ideas, or seeking guidance
- You're helping set up the project or create specs
- No Ralph loop was started

**In this context**: Be helpful and conversational. Guide the user. Create specs with `/speckit.specify`. Explain how to start the Ralph loop when ready.

---

## Core Principles

### I. Simplicity (YAGNI)
Build exactly what's needed, nothing more. No premature abstractions.

### II. Quality First
Test everything. Verify visually. Only mark done when truly complete.

### III. Spec-Driven Development
Every feature starts as a specification with clear acceptance criteria.

### IV. Iteration
If something fails, fix it and retry. Keep iterating until done.

---

## Autonomy Configuration

### YOLO Mode: [ENABLED/DISABLED]
[If enabled]: You have FULL permission to read, write, and execute without asking.
[If disabled]: Ask before making significant changes.

### Git Autonomy: [ENABLED/DISABLED]
[If enabled]: Commit and push without asking. Use meaningful commit messages.
[If disabled]: Ask before committing or pushing.

---

## Technical Stack

| Layer | Technology |
|-------|------------|
| [LAYER] | [TECHNOLOGY] |

[If design system path provided]:
### Design System
Read and follow: `[DESIGN_SYSTEM_PATH]`

---

## Work Item Source: [SPECKIT/GITHUB_ISSUES/CUSTOM]

[If SpecKit]:
### Using SpecKit Specifications
- Specs live in: `specs/NNN-feature-name/spec.md`
- Create specs with: `/speckit.specify [feature description]`
- Each spec has a Completion Signal section with acceptance criteria

[If GitHub Issues]:
### Using GitHub Issues
- Work items are GitHub Issues in this repository
- Each issue should have clear acceptance criteria
- Close issues when complete

[If Custom]:
### Using [CUSTOM_SYSTEM]
[Description of how to access work items]

---

## Ralph Loop Scripts

Both scripts are in the `scripts/` folder:

### For Claude Code
```bash
./scripts/ralph-loop.sh
```

### For OpenAI Codex CLI
```bash
./scripts/ralph-loop-codex.sh
```

### Running the Loop

**Work through all items:**
```bash
./scripts/ralph-loop.sh --all
./scripts/ralph-loop-codex.sh --all
```

**Run a single item:**
```bash
./scripts/ralph-loop.sh --spec 001-feature-name
./scripts/ralph-loop-codex.sh --issue 42
```

**Custom prompt:**
```bash
./scripts/ralph-loop.sh "Fix all bugs in the auth module"
```

---

## Deployment

[DEPLOYMENT_INFO]

---

## The Magic Word

When the user says **"Ralph, start working"**, tell them:

> Ready to start the Ralph loop! Run this in your terminal:
> 
> **For Claude Code:**
> ```bash
> ./scripts/ralph-loop.sh --all
> ```
> 
> **For Codex CLI:**
> ```bash
> ./scripts/ralph-loop-codex.sh --all
> ```

---

## Completion Signals

Every work item (spec or issue) must have acceptance criteria.

When working on an item:
1. Implement the requirements
2. Verify ALL acceptance criteria pass
3. Run tests, check visually, verify no errors
4. Output `<promise>DONE</promise>` for that item
5. The outer loop will proceed to the next item

When ALL items are complete:
- Output `<promise>ALL_DONE</promise>`

---

**Version**: 1.0.0 | **Created**: [DATE]
```

**Important**: Replace ALL placeholders with actual values from the interview!

---

## Phase 5: Create the Ralph Loop Scripts

### 5a. Create `scripts/ralph-loop.sh` (for Claude Code)

```bash
#!/bin/bash
#
# Ralph Loop - Claude Code Edition
#
# Usage:
#   ./scripts/ralph-loop.sh --all              # All specs/issues
#   ./scripts/ralph-loop.sh --spec 001-name    # Single spec
#   ./scripts/ralph-loop.sh --issue 42         # Single GitHub issue
#   ./scripts/ralph-loop.sh "Custom prompt"    # Free-form
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONSTITUTION="$PROJECT_DIR/.specify/memory/constitution.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Defaults
MODE=""
SPEC_NAME=""
ISSUE_NUM=""
PROMPT=""
YOLO_MODE=false

# Check constitution for YOLO mode
if grep -q "YOLO Mode: ENABLED" "$CONSTITUTION" 2>/dev/null; then
    YOLO_MODE=true
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all|-a)
            MODE="all"
            shift
            ;;
        --spec|-s)
            MODE="spec"
            SPEC_NAME="$2"
            shift 2
            ;;
        --issue|-i)
            MODE="issue"
            ISSUE_NUM="$2"
            shift 2
            ;;
        --help|-h)
            cat <<EOF
Ralph Loop - Claude Code Edition

Usage:
  ./scripts/ralph-loop.sh --all              # All specs/issues
  ./scripts/ralph-loop.sh --spec 001-name    # Single spec
  ./scripts/ralph-loop.sh --issue 42         # Single GitHub issue  
  ./scripts/ralph-loop.sh "Custom prompt"    # Free-form

Options:
  --all, -a          Process all work items
  --spec, -s NAME    Process specific spec
  --issue, -i NUM    Process specific GitHub issue
  --help, -h         Show this help

EOF
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
        *)
            MODE="prompt"
            PROMPT="$1"
            shift
            ;;
    esac
done

cd "$PROJECT_DIR"

# Build outer loop prompt (processes all items)
build_all_prompt() {
    cat <<EOF
# OUTER RALPH LOOP - Process All Work Items

Read the constitution at .specify/memory/constitution.md first.

## Your Task

Work through ALL work items (specs or issues) one by one until ALL are complete.

## Process

For EACH work item:
1. Read the item (spec file or issue)
2. Understand the acceptance criteria
3. Implement the requirements
4. Test thoroughly (unit, integration, visual)
5. Verify acceptance criteria pass
6. Commit and push changes
7. Output \`<promise>DONE</promise>\` for that item
8. Move to the next item

## Completion

When ALL items are complete and marked done:
- Output \`<promise>ALL_DONE</promise>\`

## Important

- You have full autonomy (YOLO mode is ${YOLO_MODE})
- Commit and push after each item
- If something fails, fix it and retry
- Only output DONE when truly complete
EOF
}

# Build single spec prompt
build_spec_prompt() {
    local spec="$1"
    cat <<EOF
# INNER RALPH LOOP - Implement Single Spec

Read the constitution at .specify/memory/constitution.md first.
Then read the spec at specs/$spec/spec.md.

## Your Task

Implement this specification completely.

## Process

1. Read and understand the spec
2. Implement all requirements
3. Complete the Completion Signal checklist
4. Run all tests
5. Verify visually with browser tools
6. Commit and push

## Completion

When ALL acceptance criteria in the spec pass:
- Output \`<promise>DONE</promise>\`
EOF
}

# Build issue prompt
build_issue_prompt() {
    local issue="$1"
    cat <<EOF
# INNER RALPH LOOP - Resolve GitHub Issue #$issue

Read the constitution at .specify/memory/constitution.md first.
Then read GitHub Issue #$issue using: gh issue view $issue

## Your Task

Resolve this issue completely.

## Process

1. Read and understand the issue
2. Implement the fix/feature
3. Verify the issue is resolved
4. Run tests
5. Commit and push
6. Close the issue: gh issue close $issue

## Completion

When the issue is resolved and closed:
- Output \`<promise>DONE</promise>\`
EOF
}

# Build free-form prompt
build_freeform_prompt() {
    local user_prompt="$1"
    cat <<EOF
# RALPH LOOP - Custom Task

Read the constitution at .specify/memory/constitution.md first.

## Your Task

$user_prompt

## Process

1. Understand the task
2. Implement the solution
3. Test thoroughly
4. Commit and push

## Completion

When the task is complete:
- Output \`<promise>DONE</promise>\`
EOF
}

# Determine prompt
case $MODE in
    all)
        FINAL_PROMPT=$(build_all_prompt)
        echo -e "${GREEN}Starting Ralph loop for ALL work items...${NC}"
        ;;
    spec)
        if [[ ! -d "specs/$SPEC_NAME" ]]; then
            echo -e "${RED}Error: Spec '$SPEC_NAME' not found${NC}"
            ls -1 specs/ 2>/dev/null
            exit 1
        fi
        FINAL_PROMPT=$(build_spec_prompt "$SPEC_NAME")
        echo -e "${GREEN}Starting Ralph loop for spec: $SPEC_NAME${NC}"
        ;;
    issue)
        FINAL_PROMPT=$(build_issue_prompt "$ISSUE_NUM")
        echo -e "${GREEN}Starting Ralph loop for issue #$ISSUE_NUM${NC}"
        ;;
    prompt)
        FINAL_PROMPT=$(build_freeform_prompt "$PROMPT")
        echo -e "${GREEN}Starting Ralph loop with custom prompt...${NC}"
        ;;
    *)
        echo -e "${RED}Error: Specify --all, --spec NAME, --issue NUM, or a prompt${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}YOLO Mode: $YOLO_MODE${NC}"
echo ""

# Run with Claude
if command -v claude &> /dev/null; then
    claude "$FINAL_PROMPT"
else
    echo "Claude CLI not found. Paste this prompt into Claude Code:"
    echo ""
    echo "$FINAL_PROMPT"
fi

echo ""
echo -e "${GREEN}Ralph loop completed!${NC}"
```

Make it executable: `chmod +x scripts/ralph-loop.sh`

### 5b. Create `scripts/ralph-loop-codex.sh` (for OpenAI Codex CLI)

```bash
#!/bin/bash
#
# Ralph Loop - Codex CLI Edition
#
# Usage:
#   ./scripts/ralph-loop-codex.sh --all              # All specs/issues
#   ./scripts/ralph-loop-codex.sh --spec 001-name    # Single spec
#   ./scripts/ralph-loop-codex.sh --issue 42         # Single GitHub issue
#   ./scripts/ralph-loop-codex.sh "Custom prompt"    # Free-form
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONSTITUTION="$PROJECT_DIR/.specify/memory/constitution.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Defaults
MODE=""
SPEC_NAME=""
ISSUE_NUM=""
PROMPT=""
YOLO_MODE=false
CODEX_ARGS=""

# Check constitution for YOLO mode
if grep -q "YOLO Mode: ENABLED" "$CONSTITUTION" 2>/dev/null; then
    YOLO_MODE=true
    CODEX_ARGS="--dangerously-bypass-approvals-and-sandbox"
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all|-a)
            MODE="all"
            shift
            ;;
        --spec|-s)
            MODE="spec"
            SPEC_NAME="$2"
            shift 2
            ;;
        --issue|-i)
            MODE="issue"
            ISSUE_NUM="$2"
            shift 2
            ;;
        --help|-h)
            cat <<EOF
Ralph Loop - Codex CLI Edition

Usage:
  ./scripts/ralph-loop-codex.sh --all              # All specs/issues
  ./scripts/ralph-loop-codex.sh --spec 001-name    # Single spec
  ./scripts/ralph-loop-codex.sh --issue 42         # Single GitHub issue  
  ./scripts/ralph-loop-codex.sh "Custom prompt"    # Free-form

Options:
  --all, -a          Process all work items
  --spec, -s NAME    Process specific spec
  --issue, -i NUM    Process specific GitHub issue
  --help, -h         Show this help

YOLO Mode: ${YOLO_MODE} (from constitution)

EOF
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
        *)
            MODE="prompt"
            PROMPT="$1"
            shift
            ;;
    esac
done

cd "$PROJECT_DIR"

# Build outer loop prompt (processes all items)
build_all_prompt() {
    cat <<EOF
# OUTER RALPH LOOP - Process All Work Items

Read the constitution at .specify/memory/constitution.md first.

## Your Task

Work through ALL work items (specs or issues) one by one until ALL are complete.

## Process

For EACH work item:
1. Read the item (spec file or issue)
2. Understand the acceptance criteria
3. Implement the requirements
4. Test thoroughly (unit, integration, visual)
5. Verify acceptance criteria pass
6. Commit and push changes
7. Output \`<promise>DONE</promise>\` for that item
8. Move to the next item

## Completion

When ALL items are complete and marked done:
- Output \`<promise>ALL_DONE</promise>\`

## Important

- You have full autonomy (YOLO mode is ${YOLO_MODE})
- Commit and push after each item
- If something fails, fix it and retry
- Only output DONE when truly complete
EOF
}

# Build single spec prompt
build_spec_prompt() {
    local spec="$1"
    cat <<EOF
# INNER RALPH LOOP - Implement Single Spec

Read the constitution at .specify/memory/constitution.md first.
Then read the spec at specs/$spec/spec.md.

## Your Task

Implement this specification completely.

## Process

1. Read and understand the spec
2. Implement all requirements
3. Complete the Completion Signal checklist
4. Run all tests
5. Verify visually with browser tools
6. Commit and push

## Completion

When ALL acceptance criteria in the spec pass:
- Output \`<promise>DONE</promise>\`
EOF
}

# Build issue prompt
build_issue_prompt() {
    local issue="$1"
    cat <<EOF
# INNER RALPH LOOP - Resolve GitHub Issue #$issue

Read the constitution at .specify/memory/constitution.md first.
Then read GitHub Issue #$issue using: gh issue view $issue

## Your Task

Resolve this issue completely.

## Process

1. Read and understand the issue
2. Implement the fix/feature
3. Verify the issue is resolved
4. Run tests
5. Commit and push
6. Close the issue: gh issue close $issue

## Completion

When the issue is resolved and closed:
- Output \`<promise>DONE</promise>\`
EOF
}

# Build free-form prompt
build_freeform_prompt() {
    local user_prompt="$1"
    cat <<EOF
# RALPH LOOP - Custom Task

Read the constitution at .specify/memory/constitution.md first.

## Your Task

$user_prompt

## Process

1. Understand the task
2. Implement the solution
3. Test thoroughly
4. Commit and push

## Completion

When the task is complete:
- Output \`<promise>DONE</promise>\`
EOF
}

# Check codex is installed
if ! command -v codex &> /dev/null; then
    echo -e "${RED}Error: Codex CLI not found${NC}"
    echo "Install: npm install -g @openai/codex"
    echo "Login:   codex --login"
    exit 1
fi

# Determine prompt
case $MODE in
    all)
        FINAL_PROMPT=$(build_all_prompt)
        echo -e "${GREEN}Starting Ralph loop for ALL work items...${NC}"
        ;;
    spec)
        if [[ ! -d "specs/$SPEC_NAME" ]]; then
            echo -e "${RED}Error: Spec '$SPEC_NAME' not found${NC}"
            ls -1 specs/ 2>/dev/null
            exit 1
        fi
        FINAL_PROMPT=$(build_spec_prompt "$SPEC_NAME")
        echo -e "${GREEN}Starting Ralph loop for spec: $SPEC_NAME${NC}"
        ;;
    issue)
        FINAL_PROMPT=$(build_issue_prompt "$ISSUE_NUM")
        echo -e "${GREEN}Starting Ralph loop for issue #$ISSUE_NUM${NC}"
        ;;
    prompt)
        FINAL_PROMPT=$(build_freeform_prompt "$PROMPT")
        echo -e "${GREEN}Starting Ralph loop with custom prompt...${NC}"
        ;;
    *)
        echo -e "${RED}Error: Specify --all, --spec NAME, --issue NUM, or a prompt${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}YOLO Mode: $YOLO_MODE${NC}"
if [[ "$YOLO_MODE" == "true" ]]; then
    echo -e "${YELLOW}Using: --dangerously-bypass-approvals-and-sandbox${NC}"
fi
echo ""

# Run with Codex
if [[ -n "$CODEX_ARGS" ]]; then
    codex $CODEX_ARGS "$FINAL_PROMPT"
else
    codex "$FINAL_PROMPT"
fi

echo ""
echo -e "${GREEN}Ralph loop completed!${NC}"
```

Make it executable: `chmod +x scripts/ralph-loop-codex.sh`

---

## Phase 6: Create Slash Commands

### 6a. Create `.cursor/commands/speckit.specify.md`

[Copy the spec template from templates/speckit.specify.md - this creates new specs]

### 6b. Create `.cursor/commands/speckit.implement.md`

```markdown
---
description: Start the Ralph loop to implement specs
---

## User Input

\`\`\`text
$ARGUMENTS
\`\`\`

## Action

Tell the user how to start the Ralph loop:

> **Ready to start implementing!**
> 
> Run one of these commands in your terminal:
> 
> **For Claude Code:**
> \`\`\`bash
> ./scripts/ralph-loop.sh --all
> \`\`\`
> 
> **For Codex CLI:**
> \`\`\`bash
> ./scripts/ralph-loop-codex.sh --all
> \`\`\`
> 
> Or for a specific spec:
> \`\`\`bash
> ./scripts/ralph-loop.sh --spec [SPEC_NAME]
> \`\`\`
```

---

## Phase 7: Create Templates

### 7a. Create `templates/spec-template.md`

[Include the standard spec template with Completion Signal section]

### 7b. Create `templates/checklist-template.md`

[Include the standard checklist template]

---

## Phase 8: Configure CLI Tools for YOLO Mode

**If the user enabled YOLO mode:**

### 8a. Claude Code Config

Tell the user to add to their Claude Code settings or `~/.claude/settings.json`:
```json
{
  "permissions": {
    "allow_file_write": true,
    "allow_file_read": true,
    "allow_command_execution": true,
    "allow_web_requests": true
  }
}
```

### 8b. Codex Config

The script already uses `--dangerously-bypass-approvals-and-sandbox` when YOLO mode is enabled in the constitution.

---

## Phase 9: Final Summary

After completing all phases, tell the user:

```
## ✅ Ralph Wiggum is now installed!

### What was created:
- `.specify/memory/constitution.md` — Your project's single source of truth
- `scripts/ralph-loop.sh` — Ralph loop for Claude Code
- `scripts/ralph-loop-codex.sh` — Ralph loop for Codex CLI
- `.cursor/commands/` — Cursor slash commands
- `AGENTS.md` & `CLAUDE.md` — Point to constitution

### Your settings:
- YOLO Mode: [ENABLED/DISABLED]
- Git Autonomy: [ENABLED/DISABLED]
- Work Item Source: [SpecKit Specs / GitHub Issues / Custom]

### Next steps:

**Option A: Create specifications**
Use `/speckit.specify [feature description]` to create your first spec.

**Option B: Use GitHub Issues**
Create issues in your GitHub repo with clear acceptance criteria.

### Start working!

When you're ready to start the Ralph loop, just say:

> "Ralph, start working"

I'll give you the terminal command to run.
```

---

## Credits

This setup process is inspired by:
- [SpecKit](https://github.com/github/spec-kit) by GitHub
- [Ralph Wiggum](https://awesomeclaude.ai/ralph-wiggum) by the Claude community
- [How to Ralph Wiggum](https://github.com/ghuntley/how-to-ralph-wiggum) by Geoffrey Huntley
