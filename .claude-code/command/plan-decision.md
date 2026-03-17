# Plan Decision

Guide the user through a structured, interactive technical-decision conversation for an Architecture Decision Record (ADR).

**Usage:** `/plan-decision [<adrNumber>] [free-text context]`

## Input

Arguments: $ARGUMENTS
- `adrNumber` (optional): first token that is purely digits
- `ideaSeed`: remainder of arguments

## Process

Use the Agent tool to delegate to the `architect` agent for the decision planning session.

## ADR Number Resolution

1. If adrNumberHint provided: validate digits-only, normalize to zeroPad4 (e.g., 7 -> 0007).
2. If none: scan `doc/decisions/<TYPE>-*-*.md`, compute next number.
3. Present candidate to user for confirmation.
4. This command MUST NOT create files in `doc/decisions/`.

## Session Flow

1. **Initialization & orientation**: Confirm scope, resolve adrNumber, get decision description.
2. **Clarify context and problem framing**: Facts, assumptions, to-confirm items.
3. **Identify and validate decision drivers**: Business, technical, operational drivers.
4. **Shape the option space**: At least 2 alternatives + do-nothing baseline.
5. **Evaluate options and converge**: Compare against drivers, propose recommendation.
6. **Trade-offs and consequences**: Positive, negative, unknowns, scope boundaries.
7. **Implementation and rollout concept**: High-level only.
8. **Verification criteria and confidence**: KPIs, measurement windows.
9. **Consolidation and readiness check**: Resolve open questions, synthesize summary.

## Output

After emitting planning summary:
1. Recommend: `/write-decision <zeroPad4>`.
2. Do NOT call it automatically.

## Constraints

- Never generate or suggest code.
- Do not create, edit, or commit any files; read-only.
- Do not construct the canonical decision record; only gather planning context.
