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
GIT_AUTONOMY=false
CODEX_ARGS=""

# Check constitution for settings
if [[ -f "$CONSTITUTION" ]]; then
    if grep -q "YOLO Mode: ENABLED" "$CONSTITUTION" 2>/dev/null; then
        YOLO_MODE=true
        CODEX_ARGS="--dangerously-bypass-approvals-and-sandbox"
    fi
    if grep -q "Git Autonomy: ENABLED" "$CONSTITUTION" 2>/dev/null; then
        GIT_AUTONOMY=true
    fi
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

Current Settings (from constitution):
  YOLO Mode:     $YOLO_MODE
  Git Autonomy:  $GIT_AUTONOMY

When YOLO Mode is enabled, uses: --dangerously-bypass-approvals-and-sandbox

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

# Check codex is installed
if ! command -v codex &> /dev/null; then
    echo -e "${RED}Error: Codex CLI not found${NC}"
    echo ""
    echo "Install Codex CLI:"
    echo "  npm install -g @openai/codex"
    echo ""
    echo "Then login:"
    echo "  codex --login"
    exit 1
fi

# Build outer loop prompt (processes all items)
build_all_prompt() {
    cat <<EOF
# OUTER RALPH LOOP - Process All Work Items

Read the constitution at .specify/memory/constitution.md first.

## Your Task

Work through ALL work items (specs in specs/ folder, or GitHub issues) one by one until ALL are complete.

## Outer Loop Process

1. List all work items (specs or issues)
2. For EACH item, start an inner loop:
   - Read the item's requirements and acceptance criteria
   - Implement completely
   - Test thoroughly
   - Verify acceptance criteria pass
   - Commit and push
   - Mark as done
   - Output \`<promise>DONE</promise>\` for that item
3. Move to the next item
4. Repeat until all items complete

## Completion Signal

When ALL items are complete:
- Output \`<promise>ALL_DONE</promise>\`

## Settings

- YOLO Mode: $YOLO_MODE (full autonomy to read/write/execute)
- Git Autonomy: $GIT_AUTONOMY (commit and push without asking)

## Important

- Read the constitution first for project context
- If something fails, fix it and retry
- Only output DONE when the item is truly complete
- Only output ALL_DONE when every item is complete
EOF
}

# Build single spec prompt
build_spec_prompt() {
    local spec="$1"
    cat <<EOF
# INNER RALPH LOOP - Implement Single Spec: $spec

Read the constitution at .specify/memory/constitution.md first.
Then read the spec at specs/$spec/spec.md.

## Your Task

Implement this specification completely until all acceptance criteria pass.

## Process

1. Read and understand the spec thoroughly
2. Implement all functional requirements
3. Complete every item in the Completion Signal checklist
4. Run all tests (unit, integration, e2e)
5. Verify visually with browser tools if applicable
6. Check for console/network errors
7. Commit and push with meaningful message

## Completion Signal

The spec file contains a "Completion Signal" section with:
- Implementation checklist
- Testing requirements
- Acceptance criteria

When ALL items in the Completion Signal pass:
- Output \`<promise>DONE</promise>\`

## Settings

- YOLO Mode: $YOLO_MODE
- Git Autonomy: $GIT_AUTONOMY
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
2. Identify acceptance criteria (from issue body or comments)
3. Implement the fix/feature
4. Test thoroughly
5. Verify the issue is resolved
6. Commit and push
7. Close the issue: gh issue close $issue

## Completion Signal

When the issue is resolved and closed:
- Output \`<promise>DONE</promise>\`

## Settings

- YOLO Mode: $YOLO_MODE
- Git Autonomy: $GIT_AUTONOMY
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

1. Understand the task and define acceptance criteria
2. Implement the solution
3. Test thoroughly
4. Verify acceptance criteria pass
5. Commit and push

## Completion Signal

When the task is complete and verified:
- Output \`<promise>DONE</promise>\`

## Settings

- YOLO Mode: $YOLO_MODE
- Git Autonomy: $GIT_AUTONOMY
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
            echo "Available specs:"
            ls -1 specs/ 2>/dev/null || echo "  (no specs found)"
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
        echo ""
        echo "Usage:"
        echo "  ./scripts/ralph-loop-codex.sh --all"
        echo "  ./scripts/ralph-loop-codex.sh --spec 001-feature-name"
        echo "  ./scripts/ralph-loop-codex.sh --issue 42"
        echo "  ./scripts/ralph-loop-codex.sh \"Fix the login bug\""
        exit 1
        ;;
esac

echo -e "${BLUE}YOLO Mode: $YOLO_MODE${NC}"
echo -e "${BLUE}Git Autonomy: $GIT_AUTONOMY${NC}"
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
