
# Check

Run quality gates for Research Explorer.

**Usage:** `/check`

## Process

1. Run `rake audit` — 7 sub-audits (models, migrations, modules, tailwind, sql, counters, routes)
2. Run `rails test` — all integration and model tests
3. Report summary: PASS/FAIL count, timing, any failures with details

## Quality Gates

```bash
rake audit          # Static analysis + smoke tests
rails test          # 72+ automated tests
```

Both must pass. If either fails, report what failed and suggest fix.

## ADOS Flow Position

**Step 8/9** in change lifecycle (phase: `quality_gates`)

### Prerequisites (MUST exist before running)
- Code committed
- Review done

### This step creates
- Audit + test results

### Next step
- `/pr (if all green)`
