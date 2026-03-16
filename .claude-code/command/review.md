
# Review

Perform focused code review of diff between base branch and the canonical change branch. Validate alignment against specification, implementation plan, and repository rules.

**Usage:** `/review <workItemRef> [directives...]`

## Input

Arguments: $ARGUMENTS
- `workItemRef` (first argument): Tracker reference (e.g., `PDEV-123`, `GH-456`). REQUIRED.
- `directives`: Optional. `base=<branch>`, `head=<ref>`, `no commit`, `dry run`, `preview only`.

## Process

Use the Agent tool to delegate to the `reviewer` agent with the full arguments.

## Discovery Rules

- Locate change folder: search `doc/changes/**/*--<workItemRef>--*/`
- Spec file: `chg-<workItemRef>-spec.md`; Plan file: `chg-<workItemRef>-plan.md`
- Abort if spec OR plan missing.

## Review Method

- Scope compliance, plan alignment, quality checks, out-of-scope detection.
- If findings exist, append remediation phase to plan.

## Output

1. Review Summary: pass/fail, changed files count, key themes.
2. Findings: one line per item.
3. Plan Update: "Added Phase X" OR "No plan changes required."
4. Next action: suggest `/run-plan <workItemRef>` if remediation added.

## ADOS Flow Position

**Step 7/9** in change lifecycle (phase: `review_fix`)

### Prerequisites (MUST exist before running)
- Delivery complete
- Docs synced

### This step creates
- Review findings, remediation if needed

### Next step
- `/check`
