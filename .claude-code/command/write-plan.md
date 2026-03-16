
# Write Plan

Generate or update an implementation plan from the canonical change specification.

**Usage:** `/write-plan <workItemRef>`

## Input

Arguments: $ARGUMENTS
- `workItemRef`: first token matching `<PREFIX>-<number>` pattern. REQUIRED.
- If no valid workItemRef found, output: `NEEDS_INPUT: workItemRef required. Usage: /write-plan <workItemRef>`

## Process

1. Parse `workItemRef` from $ARGUMENTS.
2. Use the Agent tool to delegate to the `plan-writer` agent with the workItemRef.
3. The plan-writer agent locates the spec, extracts fields, creates/updates the plan.

## Output

After successful execution:
- Created/updated file path
- Branch name
- Recommendation: "Run `/write-test-plan <workItemRef>` to generate the test plan, or `/run-plan <workItemRef>` to begin execution"

## Constraints

- Spec must exist; fail if not found.
- Only the plan file may be written.

## ADOS Flow Position

**Step 4/9** in change lifecycle (phase: `delivery_planning`)

### Prerequisites (MUST exist before running)
- chg-<ref>-spec.md
- chg-<ref>-test-plan.md

### This step creates
- chg-<ref>-plan.md

### Next step
- `/run-plan <ref>`
