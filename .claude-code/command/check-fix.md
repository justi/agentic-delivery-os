# Check and Fix

Run quality gates and fix any issues found.

**Usage:** `/check-fix`

## Process

1. Run quality gates. If the project specifies fast quality gates, execute those first.
2. If issues are found, systematically fix them.
3. Once fast quality gates pass, proceed to run full quality gates and fix any remaining issues.
4. Finally, use the Agent tool to delegate to the `committer` agent to create a single high-quality Conventional Commit summarizing all changes made.

## Delegation

This command delegates to the `fixer` agent for the core workflow. The fixer agent will use the `runner` agent for command execution and the `committer` agent for the final commit.
