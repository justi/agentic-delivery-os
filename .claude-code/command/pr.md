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
