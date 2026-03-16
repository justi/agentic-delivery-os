---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/.ai/checklists/code-review.md
---
# Code Review Checklist

Repository-local review criteria for ADOS. The `code-reviewer` agent evaluates each applicable item against the PR/MR diff.

## Prompt Quality (agents and commands)

- [ ] Prompt uses XML structure for Claude/Grok models, Markdown for GPT, JSON for DeepSeek
- [ ] Description frontmatter is short (3-10 words) and disambiguates when to use the tool
- [ ] Constraints are explicit and non-redundant
- [ ] Inputs and outputs are clearly defined
- [ ] No verbose prose — prefer structured tags over paragraphs
- [ ] Agent does not exceed its stated responsibilities (single responsibility)
- [ ] Delegation boundaries are clear (which agents are called, what is passed)

## Naming and Conventions

- [ ] File and folder names use kebab-case
- [ ] Agent/command name matches filename
- [ ] Conventional Commit format used in commit messages
- [ ] Branch naming follows `<type>/<workItemRef>/<slug>` convention
- [ ] License headers present on all new Markdown and Bash files

## Security

- [ ] No hardcoded secrets, tokens, or credentials
- [ ] No sensitive data written to non-gitignored paths
- [ ] `tmp/` artifacts do not contain secrets
- [ ] Pre-flight checks validate auth status before CLI operations

## Error Handling

- [ ] CLI commands check exit codes and handle failures
- [ ] Graceful fallback when optional files/tools are absent
- [ ] Clear error messages with actionable advice (not stack traces)
- [ ] NEEDS_INPUT marker used when critical input is missing

## Documentation

- [ ] `.opencode/README.md` inventory updated when agents/commands added or removed
- [ ] `AGENTS.md` updated when agent team or commands change
- [ ] New features documented in relevant guide files
- [ ] Decision records created for significant architectural decisions

## Testing

- [ ] Changed code paths have corresponding test coverage
- [ ] Test files follow `test-*.sh` naming in `.tests/` directories
- [ ] Acceptance criteria from spec are verifiable

## Consistency

- [ ] New tools match patterns of existing sibling tools
- [ ] Platform detection mirrors `@pr-manager` conventions
- [ ] `tmp/` directory conventions followed (per-branch paths, gitignored)
- [ ] State persistence follows established schema patterns
