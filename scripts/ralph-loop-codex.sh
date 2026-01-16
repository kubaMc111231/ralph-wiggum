#!/bin/bash
#
# Ralph Loop for OpenAI Codex CLI
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
#   ./scripts/ralph-loop-codex.sh              # Build mode (unlimited)
#   ./scripts/ralph-loop-codex.sh 20           # Build mode (max 20 iterations)
#   ./scripts/ralph-loop-codex.sh plan         # Planning mode
#   ./scripts/ralph-loop-codex.sh plan 5       # Planning mode (max 5 iterations)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
CONSTITUTION="$PROJECT_DIR/.specify/memory/constitution.md"

# Configuration
MAX_ITERATIONS=0  # 0 = unlimited
MODE="build"
CODEX_CMD="codex"
YOLO_FLAG="--dangerously-bypass-approvals-and-sandbox"

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
Ralph Loop for OpenAI Codex CLI

Based on Geoffrey Huntley's Ralph Wiggum methodology + SpecKit specs.
https://github.com/ghuntley/how-to-ralph-wiggum

Usage:
  ./scripts/ralph-loop-codex.sh              # Build mode, unlimited
  ./scripts/ralph-loop-codex.sh 20           # Build mode, max 20 iterations
  ./scripts/ralph-loop-codex.sh plan         # Planning mode
  ./scripts/ralph-loop-codex.sh plan 5       # Planning mode (max 5)

Modes:
  build (default)  Pick tasks from IMPLEMENTATION_PLAN.md and implement
  plan             Create/update IMPLEMENTATION_PLAN.md from specs

YOLO Mode: Uses $YOLO_FLAG

How it works:
  1. Each iteration passes PROMPT.md content to Codex
  2. Codex picks the HIGHEST PRIORITY incomplete task
  3. Codex implements, tests, and verifies acceptance criteria
  4. Codex outputs <promise>DONE</promise> ONLY if criteria are met
  5. Bash loop checks for the magic phrase
  6. If found, loop continues to next iteration (fresh context)
  7. If not found, loop retries

Prerequisites:
  - OpenAI Codex CLI: npm install -g @openai/codex
  - Authenticated: codex --login

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

# Check if Codex CLI is available
if ! command -v "$CODEX_CMD" &> /dev/null; then
    echo -e "${RED}Error: Codex CLI not found${NC}"
    echo ""
    echo "Install Codex CLI:"
    echo "  npm install -g @openai/codex"
    echo ""
    echo "Then authenticate:"
    echo "  codex --login"
    exit 1
fi

# Check prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo -e "${RED}Error: $PROMPT_FILE not found${NC}"
    echo "Run ./scripts/ralph-loop.sh first to create default prompts."
    exit 1
fi

# Build Codex flags
CODEX_FLAGS=""
if [ "$YOLO_ENABLED" = true ]; then
    CODEX_FLAGS="$YOLO_FLAG"
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}              RALPH LOOP (Codex) STARTING                    ${NC}"
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
    LOG_FILE="$LOG_DIR/ralph_codex_${MODE}_$(date '+%Y%m%d_%H%M%S').log"

    # Read prompt content
    PROMPT_CONTENT=$(cat "$PROMPT_FILE")
    
    # Run Codex, capture output
    CODEX_OUTPUT=""
    if CODEX_OUTPUT=$("$CODEX_CMD" $CODEX_FLAGS "$PROMPT_CONTENT" 2>&1 | tee "$LOG_FILE"); then
        echo ""
        echo -e "${GREEN}✓ Codex execution completed${NC}"
        
        # Check if DONE promise was output
        if echo "$CODEX_OUTPUT" | grep -q "<promise>DONE</promise>"; then
            echo -e "${GREEN}✓ Completion signal detected: <promise>DONE</promise>${NC}"
            echo -e "${GREEN}✓ Task completed successfully!${NC}"
            CONSECUTIVE_FAILURES=0
            
            if [ "$MODE" = "plan" ]; then
                echo ""
                echo -e "${GREEN}Planning complete! Run './scripts/ralph-loop-codex.sh' to start building.${NC}"
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
                CONSECUTIVE_FAILURES=0
            fi
        fi
    else
        echo -e "${RED}✗ Codex execution failed${NC}"
        echo -e "${YELLOW}Check log: $LOG_FILE${NC}"
        CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    fi

    # Push changes after each iteration (if any)
    git push origin "$CURRENT_BRANCH" 2>/dev/null || {
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
echo -e "${GREEN}       RALPH LOOP (Codex) FINISHED ($ITERATION iterations)   ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
