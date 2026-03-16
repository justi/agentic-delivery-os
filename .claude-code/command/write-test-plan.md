# Write Test Plan

Generate or update a change test plan.

**Usage:** `/write-test-plan <workItemRef> [options]`

Options: `focus=backend`, `nfr-only`, `no-manual`, etc.

## Input

Arguments: $ARGUMENTS
- `workItemRef`: first token matching `<PREFIX>-<number>` pattern. REQUIRED.
- Remaining args: options.
- If no valid workItemRef found, output: `NEEDS_INPUT: workItemRef required. Usage: /write-test-plan <workItemRef>`

## Process

1. Parse `workItemRef` and options from $ARGUMENTS.
2. Use the Agent tool to delegate to the `test-plan-writer` agent with the workItemRef and options.
3. The test-plan-writer locates spec and plan, reads testing strategy, generates test plan.

## Output

After successful execution:
- Created/updated file path
- Branch name
- Coverage summary
- Recommendation: "Run `/run-plan <workItemRef>` to begin execution"

## Constraints

- Spec must exist; fail if not found.
- Testing strategy must exist; fail if not found.
- Only the test plan file may be written.
