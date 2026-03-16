
# Sync Docs

Update current system specification docs from an accepted change.

**Usage:** `/sync-docs <workItemRef> [directives]`

## Input

Arguments: $ARGUMENTS
- `workItemRef` (first argument): Tracker reference. REQUIRED.
- Directives (optional): `dry run`, `contracts only`, `force`, `no commit`, `base=<branch>`.

## Process

Use the Agent tool to delegate to the `doc-syncer` agent with the full arguments.

The doc-syncer agent will:
1. Load change documentation (spec, plan, test plan).
2. Verify change is implemented and in terminal state.
3. Identify affected areas.
4. Update or create docs so `doc/spec/**` describes the system after the change.
5. Follow Documentation Handbook invariants.
6. Commit: `docs(spec): reconcile system spec with change chg-<workItemRef>`

## Notes

- Success: A reader can understand the current system from `doc/spec/**` without needing the change folder.
- Never modify change spec or plan files.
- Never touch source code.

## ADOS Flow Position

**Step 6/9** in change lifecycle (phase: `system_spec_update`)

### Prerequisites (MUST exist before running)
- Delivery complete (code committed)

### This step creates
- Updated PLAN.md, MAINTENANCE.md, README.md as needed

### Next step
- `/review <ref>`
