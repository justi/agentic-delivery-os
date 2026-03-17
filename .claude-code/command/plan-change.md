
# Plan Change

Guide the user through a structured, interactive planning conversation that transforms an initial idea or problem report into a complete planning context for a single tracked change.

**Usage:** `/plan-change [<workItemRef>] [free-text idea / context]`

## Input

Arguments: $ARGUMENTS
- `workItemRef` (optional): first token matching `<PREFIX>-<digits>` pattern
- `ideaSeed`: remainder of arguments after stripping workItemRef

## WorkItemRef Resolution

1. If workItemRefHint is provided: validate format, ask user to confirm.
2. If none: scan `doc/changes/**/chg-*-spec.md`, propose creating new ticket or ask user.
3. This command MUST NOT create folders or files in `doc/changes/`; it only proposes identifiers.

## Session Flow

1. **Initialization & orientation**: Confirm repo scope, resolve workItemRef, get change description.
2. **Clarify problem and context**: Current state, pain points, affected users, change type.
3. **Define goals and success metrics**: Business, user, operational goals with measurable metrics.
4. **Outline functional capabilities and flows**: F-# style capabilities, key flows.
5. **Identify interfaces & integration contracts**: UI, APIs, events, data model.
6. **Non-functional requirements and telemetry**: Performance, reliability, security, observability.
7. **Dependencies, risks, assumptions**: Internal/external deps, risks, version impact.
8. **Affected components and scope boundaries**: In Scope, Out of Scope, Deferred.
9. **Acceptance criteria and rollout strategy**: Given/When/Then criteria, rollout plan.
10. **Consolidation and readiness check**: Resolve open questions, synthesize planning summary.

## Output

After emitting the change planning summary:
1. Output concise human-readable recap.
2. Recommend exact next command: `/write-spec <workItemRef>`.
3. Do NOT call `/write-spec` automatically.

## Constraints

- Never generate or suggest code.
- Never propose exact file paths or class names; use logical component names.
- Do not create, edit, or commit files; read-only filesystem and Git.
- Do not construct the canonical spec; only gather planning context.

## ADOS Flow Position

**Step 1/10** in change lifecycle (phase: `clarify_scope`)

### Prerequisites (MUST exist before running)
- None (this is the first step)

### This step creates
- chg-<ref>-pm-notes.yaml (planning context)

### Next step
- `/write-spec <ref>`
