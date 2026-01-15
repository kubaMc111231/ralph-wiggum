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

**In this context**:
- Focus on implementation
- Follow the spec or issue requirements exactly
- Complete ALL acceptance criteria
- Test thoroughly before marking done
- Output `<promise>DONE</promise>` when the item is complete
- Move to the next item or output `<promise>ALL_DONE</promise>` when finished

### Context B: Interactive Chat (Discussion Mode)

You are in interactive chat if:
- The user is asking questions, discussing ideas, or seeking guidance
- You're helping set up the project or create specifications
- You're being consulted about architecture, design, or approach
- No Ralph loop was started

**In this context**:
- Be helpful and conversational
- Guide the user through decisions
- Create specs using `/speckit.specify [description]`
- Explain how to start the Ralph loop when ready
- When user says "Ralph, start working", provide the terminal commands

---

## Core Principles

### I. Simplicity (YAGNI)
Build exactly what's needed, nothing more. No premature abstractions. No "just in case" features.

### II. Quality First
Test everything. Verify visually. Only mark done when truly complete.

### III. Spec-Driven Development
Every feature starts as a specification with clear acceptance criteria.

### IV. Iteration
If something fails, fix it and retry. Keep iterating until all criteria pass.

---

## Autonomy Configuration

### YOLO Mode: [ENABLED/DISABLED]

[If ENABLED]:
You have FULL permission to:
- Read and write any files
- Execute any commands
- Make HTTP requests
- Modify the codebase without asking

[If DISABLED]:
Ask before making significant changes. Explain what you want to do and wait for approval.

### Git Autonomy: [ENABLED/DISABLED]

[If ENABLED]:
- Commit changes without asking
- Push to the repository without asking
- Use meaningful commit messages
- Commit after completing each work item

[If DISABLED]:
Ask before committing or pushing. Show the user what will be committed.

---

## Technical Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Framework | [FRAMEWORK] | |
| Language | [LANGUAGE] | |
| Styling | [STYLING] | |
| Testing | [TESTING] | |
| Deployment | [DEPLOYMENT] | |

[If design system exists]:
### Design System
**Read and follow**: `[DESIGN_SYSTEM_PATH]`

---

## Work Item Source: [SPECKIT/GITHUB_ISSUES/CUSTOM]

[If SPECKIT]:
### Using SpecKit Specifications

- Specifications live in: `specs/NNN-feature-name/spec.md`
- Create new specs with: `/speckit.specify [feature description]`
- Each spec has a Completion Signal section with acceptance criteria
- The Ralph loop processes specs in numerical order

[If GITHUB_ISSUES]:
### Using GitHub Issues

- Work items are GitHub Issues in this repository
- Each issue should have clear acceptance criteria in the body
- Use labels to prioritize
- The Ralph loop can process issues: `./scripts/ralph-loop.sh --issue 42`
- Close issues when complete: `gh issue close 42`

[If CUSTOM]:
### Using [CUSTOM_SYSTEM_NAME]

[Description of how to access and track work items]

---

## Ralph Loop Scripts

Both scripts are in the `scripts/` folder:

### For Claude Code
```bash
./scripts/ralph-loop.sh --all              # Process all items
./scripts/ralph-loop.sh --spec 001-name    # Single spec
./scripts/ralph-loop.sh --issue 42         # Single issue
./scripts/ralph-loop.sh "Custom task"      # Free-form prompt
```

### For OpenAI Codex CLI
```bash
./scripts/ralph-loop-codex.sh --all        # Process all items
./scripts/ralph-loop-codex.sh --spec 001   # Single spec
./scripts/ralph-loop-codex.sh --issue 42   # Single issue
./scripts/ralph-loop-codex.sh "Custom"     # Free-form prompt
```

The scripts automatically read YOLO Mode from this constitution and configure accordingly.

---

## Completion Signals

Every work item must have acceptance criteria.

### Single Item Completion
When implementing a spec or resolving an issue:
1. Complete ALL acceptance criteria
2. Run all tests
3. Verify visually if applicable
4. Commit and push
5. Output: `<promise>DONE</promise>`

### All Items Completion
When the outer loop finishes all items:
- Output: `<promise>ALL_DONE</promise>`

---

## Deployment

[DEPLOYMENT_INSTRUCTIONS]

---

## The Magic Word

When the user says **"Ralph, start working"**, respond with:

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

## Governance

- **Amendments**: Update this file, increment version, document changes
- **Compliance**: Follow principles in spirit, not just letter
- **Exceptions**: Document and justify in specs when deviating

---

**Version**: 1.0.0 | **Created**: [DATE] | **Last Updated**: [DATE]
