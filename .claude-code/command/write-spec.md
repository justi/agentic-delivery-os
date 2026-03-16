# Write Spec

Generate a canonical change specification from planning session context.

**Usage:** `/write-spec <workItemRef>`

## Input

Arguments: $ARGUMENTS
- `workItemRef`: first token matching `<PREFIX>-<number>` pattern. REQUIRED.
- If no valid workItemRef found, output: `NEEDS_INPUT: workItemRef required. Usage: /write-spec <workItemRef>`

## Process

1. Parse `workItemRef` from $ARGUMENTS.
2. Use the Agent tool to delegate to the `spec-writer` agent with the workItemRef.
3. The spec-writer gathers planning context, creates the spec file.

## Output

After successful execution:
- Created file path
- Branch name
- Recommendation: "Run `/write-plan <workItemRef>` to generate the implementation plan"

## Constraints

- No implementation details in the spec.
- Only the spec file may be written.
- Await human approval before `/write-plan`.
