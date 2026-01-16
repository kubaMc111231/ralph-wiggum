#!/bin/bash
#
# Ralph Loop for Claude Code
#
# Based on Geoffrey Huntley's Ralph Wiggum methodology:
# https://github.com/ghuntley/how-to-ralph-wiggum
#
# Combined with SpecKit-style specifications.
#
# Key principles:
# - Each iteration picks ONE task from IMPLEMENTATION_PLAN.md
# - Agent works until acceptance criteria are met
# - Only outputs <promise>DONE</promise> when truly complete
# - Bash loop checks for magic phrase before continuing
# - Fresh context window each iteration
#
# Usage:
#   ./scripts/ralph-loop.sh              # Build mode (unlimited)
#   ./scripts/ralph-loop.sh 20           # Build mode (max 20 iterations)
#   ./scripts/ralph-loop.sh plan         # Planning mode
#   ./scripts/ralph-loop.sh plan 5       # Planning mode (max 5 iterations)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
CONSTITUTION="$PROJECT_DIR/.specify/memory/constitution.md"

# Configuration
MAX_ITERATIONS=0  # 0 = unlimited
MODE="build"
CLAUDE_CMD="claude"
YOLO_FLAG="--dangerously-skip-permissions"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

mkdir -p "$LOG_DIR"

# Check constitution for YOLO setting
YOLO_ENABLED=true
if [[ -f "$CONSTITUTION" ]]; then
    if grep -q "YOLO Mode.*DISABLED" "$CONSTITUTION" 2>/dev/null; then
        YOLO_ENABLED=false
    fi
fi

show_help() {
    cat <<EOF
Ralph Loop for Claude Code

Based on Geoffrey Huntley's Ralph Wiggum methodology + SpecKit specs.
https://github.com/ghuntley/how-to-ralph-wiggum

Usage:
  ./scripts/ralph-loop.sh              # Build mode, unlimited iterations
  ./scripts/ralph-loop.sh 20           # Build mode, max 20 iterations
  ./scripts/ralph-loop.sh plan         # Planning mode
  ./scripts/ralph-loop.sh plan 5       # Planning mode (max 5 iterations)

Modes:
  build (default)  Pick tasks from IMPLEMENTATION_PLAN.md and implement
  plan             Create/update IMPLEMENTATION_PLAN.md from specs

How it works:
  1. Each iteration feeds PROMPT.md to Claude via stdin
  2. Claude picks the HIGHEST PRIORITY incomplete task
  3. Claude implements, tests, and verifies acceptance criteria
  4. Claude outputs <promise>DONE</promise> ONLY if criteria are met
  5. Bash loop checks for the magic phrase
  6. If found, loop continues to next iteration (fresh context)
  7. If not found, loop retries the same task

Files:
  PROMPT_build.md          - Build mode instructions
  PROMPT_plan.md           - Planning mode instructions  
  IMPLEMENTATION_PLAN.md   - Shared state (task list)
  .specify/memory/constitution.md - Project principles

EOF
}

# Parse arguments
if [ "$1" = "plan" ]; then
    MODE="plan"
    MAX_ITERATIONS=${2:-0}
elif [[ "$1" =~ ^[0-9]+$ ]]; then
    MODE="build"
    MAX_ITERATIONS=$1
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

cd "$PROJECT_DIR"

# Determine prompt file
if [ "$MODE" = "plan" ]; then
    PROMPT_FILE="PROMPT_plan.md"
else
    PROMPT_FILE="PROMPT_build.md"
fi

# Check if Claude CLI is available
if ! command -v "$CLAUDE_CMD" &> /dev/null; then
    echo -e "${RED}Error: Claude CLI not found${NC}"
    echo ""
    echo "Install Claude Code CLI and authenticate first."
    echo "https://claude.ai/code"
    exit 1
fi

# Create default prompt files if they don't exist
if [ ! -f "PROMPT_build.md" ]; then
    echo -e "${YELLOW}Creating default PROMPT_build.md...${NC}"
    cat > "PROMPT_build.md" << 'BUILDEOF'
# Ralph Build Mode

Based on Geoffrey Huntley's Ralph Wiggum methodology.

---

## Phase 0: Orient

0a. Read `.specify/memory/constitution.md` for project principles.

0b. Study `specs/*` to understand feature specifications.

0c. Read @IMPLEMENTATION_PLAN.md to see the current task list.

---

## Phase 1: Select Task

From IMPLEMENTATION_PLAN.md, pick the **HIGHEST PRIORITY** incomplete task.

Before implementing, search the codebase — don't assume it's not done.

---

## Phase 2: Implement

Implement the task completely:
- Follow the spec's requirements
- Write clean, maintainable code
- Add tests as needed

---

## Phase 3: Validate

Run the project's test suite and verify:
- All tests pass
- No lint errors
- The task's acceptance criteria are met

---

## Phase 4: Commit & Update

1. Update @IMPLEMENTATION_PLAN.md — mark task complete or note issues
2. `git add -A`
3. `git commit` with a descriptive message
4. `git push`

---

## Completion Signal

**CRITICAL:** Only output the magic phrase when the task is 100% complete.

Check:
- [ ] Implementation matches requirements
- [ ] All tests pass
- [ ] Acceptance criteria verified
- [ ] Changes committed and pushed

**If ALL checks pass, output:** `<promise>DONE</promise>`

**If ANY check fails:** Fix the issue and try again. Do NOT output the magic phrase.
BUILDEOF
fi

if [ ! -f "PROMPT_plan.md" ]; then
    echo -e "${YELLOW}Creating default PROMPT_plan.md...${NC}"
    cat > "PROMPT_plan.md" << 'PLANEOF'
# Ralph Planning Mode

Based on Geoffrey Huntley's Ralph Wiggum methodology.

---

## Phase 0: Orient

0a. Read `.specify/memory/constitution.md` for project principles.

0b. Study `specs/*` to learn all feature specifications.

0c. Read @IMPLEMENTATION_PLAN.md (if exists) for current state.

---

## Phase 1: Gap Analysis

Compare specs against current codebase:
- What's fully implemented?
- What's partially done?
- What's not started?
- What has issues or bugs?

---

## Phase 2: Create Plan

Update @IMPLEMENTATION_PLAN.md with a prioritized bullet list:

```markdown
## Priority Tasks

- [ ] [HIGH] Task description - from spec NNN
- [ ] [HIGH] Task description - from spec NNN  
- [ ] [MEDIUM] Task description
- [ ] [LOW] Task description

## Completed

- [x] Completed task
```

Prioritize by:
1. Dependencies (do prerequisites first)
2. Impact (high-value features first)
3. Complexity (mix easy wins with harder tasks)

---

## Completion Signal

When the plan is complete and saved:

`<promise>DONE</promise>`
PLANEOF
fi

# Check prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo -e "${RED}Error: $PROMPT_FILE not found${NC}"
    exit 1
fi

# Build Claude flags
CLAUDE_FLAGS="-p"
if [ "$YOLO_ENABLED" = true ]; then
    CLAUDE_FLAGS="$CLAUDE_FLAGS $YOLO_FLAG"
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}              RALPH LOOP (Claude Code) STARTING              ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Mode:${NC}     $MODE"
echo -e "${BLUE}Prompt:${NC}   $PROMPT_FILE"
echo -e "${BLUE}Branch:${NC}   $CURRENT_BRANCH"
echo -e "${YELLOW}YOLO:${NC}     $([ "$YOLO_ENABLED" = true ] && echo "ENABLED" || echo "DISABLED")"
[ $MAX_ITERATIONS -gt 0 ] && echo -e "${BLUE}Max:${NC}      $MAX_ITERATIONS iterations"
echo ""
echo -e "${CYAN}The loop checks for <promise>DONE</promise> in each iteration.${NC}"
echo -e "${CYAN}Agent must verify acceptance criteria before outputting it.${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the loop${NC}"
echo ""

ITERATION=0
CONSECUTIVE_FAILURES=0
MAX_CONSECUTIVE_FAILURES=3

while true; do
    # Check max iterations
    if [ $MAX_ITERATIONS -gt 0 ] && [ $ITERATION -ge $MAX_ITERATIONS ]; then
        echo -e "${GREEN}Reached max iterations: $MAX_ITERATIONS${NC}"
        break
    fi

    ITERATION=$((ITERATION + 1))
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    echo ""
    echo -e "${PURPLE}════════════════════ LOOP $ITERATION ════════════════════${NC}"
    echo -e "${BLUE}[$TIMESTAMP]${NC} Starting iteration $ITERATION"
    echo ""

    # Log file for this iteration
    LOG_FILE="$LOG_DIR/ralph_${MODE}_$(date '+%Y%m%d_%H%M%S').log"

    # Run Claude with prompt via stdin, capture output
    # -p: Print mode (non-interactive, outputs response)
    CLAUDE_OUTPUT=""
    if CLAUDE_OUTPUT=$(cat "$PROMPT_FILE" | "$CLAUDE_CMD" $CLAUDE_FLAGS 2>&1 | tee "$LOG_FILE"); then
        echo ""
        echo -e "${GREEN}✓ Claude execution completed${NC}"
        
        # Check if DONE promise was output
        if echo "$CLAUDE_OUTPUT" | grep -q "<promise>DONE</promise>"; then
            echo -e "${GREEN}✓ Completion signal detected: <promise>DONE</promise>${NC}"
            echo -e "${GREEN}✓ Task completed successfully!${NC}"
            CONSECUTIVE_FAILURES=0
            
            # For planning mode, we might want to stop after one successful plan
            if [ "$MODE" = "plan" ]; then
                echo ""
                echo -e "${GREEN}Planning complete! Run './scripts/ralph-loop.sh' to start building.${NC}"
                # Continue to allow re-planning if needed, or uncomment to stop:
                # break
            fi
        else
            echo -e "${YELLOW}⚠ No completion signal found${NC}"
            echo -e "${YELLOW}  Agent did not output <promise>DONE</promise>${NC}"
            echo -e "${YELLOW}  This means acceptance criteria were not met.${NC}"
            echo -e "${YELLOW}  Retrying in next iteration...${NC}"
            CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
            
            if [ $CONSECUTIVE_FAILURES -ge $MAX_CONSECUTIVE_FAILURES ]; then
                echo ""
                echo -e "${RED}⚠ $MAX_CONSECUTIVE_FAILURES consecutive iterations without completion.${NC}"
                echo -e "${RED}  The agent may be stuck. Consider:${NC}"
                echo -e "${RED}  - Checking the logs in $LOG_DIR${NC}"
                echo -e "${RED}  - Simplifying the current task${NC}"
                echo -e "${RED}  - Running plan mode to reassess${NC}"
                echo ""
                # Reset counter but don't stop - let it keep trying
                CONSECUTIVE_FAILURES=0
            fi
        fi
    else
        echo -e "${RED}✗ Claude execution failed${NC}"
        echo -e "${YELLOW}Check log: $LOG_FILE${NC}"
        CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    fi

    # Push changes after each iteration (if any)
    git push origin "$CURRENT_BRANCH" 2>/dev/null || {
        # Only warn if there were actually commits to push
        if git log origin/$CURRENT_BRANCH..HEAD --oneline 2>/dev/null | grep -q .; then
            echo -e "${YELLOW}Push failed, creating remote branch...${NC}"
            git push -u origin "$CURRENT_BRANCH" 2>/dev/null || true
        fi
    }

    # Brief pause between iterations
    echo ""
    echo -e "${BLUE}Waiting 2s before next iteration...${NC}"
    sleep 2
done

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}         RALPH LOOP FINISHED ($ITERATION iterations)         ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
