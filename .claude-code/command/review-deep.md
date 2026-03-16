# Review Deep

Perform thorough code review of diff between base branch and canonical change branch. Uses deeper analysis than the standard review.

**Usage:** `/review-deep <workItemRef> [directives...]`

## Input

Arguments: $ARGUMENTS
- `workItemRef` (first argument): Tracker reference (e.g., `PDEV-123`, `GH-456`). REQUIRED.
- `directives`: Optional. `base=<branch>`, `head=<ref>`, `no commit`, `dry run`, `preview only`.

## Process

Use the Agent tool to delegate to the `reviewer` agent with the full arguments and a directive for thorough analysis.

## Discovery Rules

- Locate change folder: search `doc/changes/**/*--<workItemRef>--*/`
- Spec file: `chg-<workItemRef>-spec.md`; Plan file: `chg-<workItemRef>-plan.md`
- Abort if spec OR plan missing.

## Review Method

- Scope compliance, plan alignment, quality dimensions, out-of-scope detection.
- If findings exist, append remediation phase to plan.
- Suggest `/run-plan <workItemRef>` if remediation added.
