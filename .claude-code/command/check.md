# Check

Run the repository's configured quality gates command and return a concise, high-signal summary with log pointers.

**Usage:** `/check [fast|slow|all|<gate>...] [--skip-autofix] [--dry-run]`

## Input

Arguments: $ARGUMENTS

## Resolution

1. Read `AGENTS.md` and look for an explicit quality gates runner instruction.
2. Default fallback: `./scripts/quality-gates.sh`
3. Pass through user-provided arguments as-is.
4. Always run from repository root.

## Process

1. Use the Agent tool to delegate to the `runner` agent with the resolved quality gates command.
2. Ensure logs are saved under `tmp/run-logs-runner/<YYYY-MM-DD>/`.
3. If quality gates fail, surface which gate(s) failed and relevant pointers.

## Notes

- This command is run-only; do not attempt fixes.
- For fixing failures, use `/check-fix` or invoke the `fixer` agent directly.
