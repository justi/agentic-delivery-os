# Run Plan

Execute implementation plan phases for a change.

**Usage:** `/run-plan <workItemRef> [directives]`

## Input

Arguments: $ARGUMENTS
- `workItemRef` (first argument): Tracker reference. REQUIRED.
- Directives (optional):
  - "execute next N phases"
  - "execute all remaining phases"
  - "execute phase N"
  - "no review" / "continue without review"
  - "dry run"
  - "commit per task"

Defaults (no directive): phasesToRun=1; askForReview=true; commitMode=per-phase.

## Process

Use the Agent tool to delegate to the `coder` agent with the full arguments and directives.

The coder agent will:
1. Parse workItemRef and directives.
2. Locate spec and plan via discovery rules.
3. Ensure correct branch.
4. Execute phases, marking tasks complete with evidence.
5. Commit via the `committer` agent after each phase.
6. Report status when done or blocked.

## Discovery Rules

- Locate change folder: `doc/changes/**/*--<workItemRef>--*/`
- Plan file: `chg-<workItemRef>-plan.md`
- Spec file: `chg-<workItemRef>-spec.md`
