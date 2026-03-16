# Commit

Trigger the `committer` agent to create exactly one Conventional Commit.

**Usage:** `/commit [intent message]`

## Input

Arguments: $ARGUMENTS (optional commit intent hint)

## Process

1. Use the Agent tool to delegate to the `committer` agent immediately.
2. Pass $ARGUMENTS as the commit intent hint.
3. Do not restate the committer's workflow; do not add extra commentary.
4. If blocked, surface the agent's message without alteration.
5. If successful, return exactly the agent's output.
