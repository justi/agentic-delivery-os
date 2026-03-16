# Write Decision

Generate a Decision Record (ADR/PDR/TDR/BDR/ODR) from planning context.

**Usage:** `/write-decision <number>`

## Input

Arguments: $ARGUMENTS
- `number` (first argument): REQUIRED (digits only; will be normalized to 4 digits)

## Process

Use the Agent tool to delegate to the `architect` agent with the decision number and a directive to write the decision record.

The architect agent will:
1. Normalize number to zeroPad4.
2. Obtain the planning summary from `/plan-decision` session context.
3. Derive decision type, title, slug, metadata.
4. Write `doc/decisions/<TYPE>-<number>-<slug>.md`.
5. Stage and commit.

## Notes

- If no planning summary is available, the agent will ask the user to run `/plan-decision <number>` first.
- Supports all five types: ADR, PDR, TDR, BDR, ODR.
