
# Check

Run this repository's configured quality gates and summarize results.

**Usage:** `/check [fast|slow|all|<gate>...] [--skip-autofix] [--dry-run]`

## Process

1. Read `CLAUDE.md` (or `AGENTS.md`) for the project's quality gates command.
   - Look for an explicit quality gates runner instruction (e.g., `./scripts/quality-gates.sh`).
   - If multiple are present, prefer the most explicit "Run all quality gates" instruction.
2. If no quality gates command is found, report an error and instruct the user to define one in `CLAUDE.md` or `AGENTS.md`.
3. Pass through user-provided arguments as-is to the resolved command.
4. Always run from repository root.
5. Use the Agent tool to delegate execution to the `runner` agent.
6. Report summary: PASS/FAIL count, timing, any failures with details.

## Output

- Exact command run
- Exit code and duration
- Log path(s) under `tmp/run-logs-runner/`
- Which gate(s) failed (if any), with top error snippets

## Constraints

- Do not attempt fixes; this command is run-only.
- For fixing failures, use `/check-fix` or the `fixer` agent.

## ADOS Flow Position

**Step 8/10** in change lifecycle (phase: `quality_gates`)

### Prerequisites (MUST exist before running)
- Code committed
- Review done

### This step creates
- Quality gate results (audit + test output)

### Next step
- Phase 9 (`dod_check`) is handled by the PM agent, then `/pr` (phase 10)
