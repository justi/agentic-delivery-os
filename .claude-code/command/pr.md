
# PR

Trigger the `pr-manager` agent to create/update the PR/MR for the current branch.

**Usage:** `/pr [--base <branch>] [--github|--gitlab]`

## Input

Arguments: $ARGUMENTS

## Process

1. Use the Agent tool to delegate to the `pr-manager` agent immediately with the provided args.
2. Do not restate its workflow; do not add extra commentary.
3. If blocked, surface the agent's message without alteration.
4. If successful, return exactly the agent's output.

## ADOS Flow Position

**Step 9/9** in change lifecycle (phase: `pr_creation`)

### Prerequisites (MUST exist before running)
- Quality gates passed
- All phases complete

### This step creates
- Pull request for human review

### Next step
- `STOP — wait for human review`
