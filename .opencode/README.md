# OpenCode Tooling (Repo)

Repo-local OpenCode agents, commands, and skills.

## Layout (This Repo)

- Agents: `.opencode/agent/*.md`
- Commands: `.opencode/command/*.md`
- Skills: `.opencode/skills/<skill-name>/SKILL.md`

Note: OpenCode upstream docs use `.opencode/agents/` and `.opencode/commands/`. This repo uses singular folders.

## Conventions

- Naming: kebab-case; agent/command name = filename; skill name = folder name.
- Descriptions: frontmatter `description` stays short (usually 3-10 words).
- Commands: accept args via `$ARGUMENTS` and optional `$1`, `$2`, ...
- Commands: prefer `subtask: true` for non-trivial work (avoid polluting main context).
- Context: keep `@path` includes narrow; keep `!` shell injections small and deterministic.
- Repo rules: if a tool runs repo workflows (build/test/docs), follow `AGENTS.md`.
- Consistency: if a new tool overlaps an existing workflow area (change lifecycle, quality gates, docs, UI), match the established patterns unless explicitly diverging.
- Prompt tuning: when updating existing tools, preserve intent and keep diffs minimal.
- Tool suites: when a workflow spans multiple tools, tune them together (contracts, arguments, outputs, delegation).
- Hygiene: update this file whenever you add/rename/remove a tool or materially change its intent.
- PM tracker config: `@pm` reads `.ai/agent/pm-instructions.md` (repo-specific Jira/GitHub workflow).
- PM delegation: `@pm` delegates debugging to `@fixer` and command execution to `@runner`.
- Pre-PR gate (autopilot): `@pm` runs `@reviewer` + `@doc-syncer` before `@pr-manager`.

## Agents

- `architect`: architecture decisions and ADR authoring
- `bootstrapper`: automate ADOS adoption for existing projects
- `coder`: implement plan phases by writing code for a change
- `committer`: create one Conventional Commit
- `designer`: apply visual design system
- `doc-syncer`: reconcile system docs with change
- `editor`: rewrite/translate content per repo guidelines
- `external-researcher`: research external sources via MCP (context7, deepwiki, perplexity)
- `fixer`: reproduce and fix failures
- `image-generator`: generate AI images via text-to-image CLI
- `image-reviewer`: analyze images, screenshots, and visual artifacts
- `plan-writer`: author change implementation plans
- `pm`: orchestrate changes; manage tickets via MCP (reads `.ai/agent/pm-instructions.md`)
- `pr-manager`: create/update PR/MR for branch; enriches description with ticket context via MCP
- `reviewer`: review change vs spec/plan
- `runner`: run commands and capture logs
- `spec-writer`: author change specifications
- `test-plan-writer`: author change test plans
- `toolsmith`: create and tune OpenCode tooling

## Commands

- `/bootstrap`: scaffold ADOS artifacts for an existing project
- `/check`: run quality gates (no fixes)
- `/check-fix`: run quality gates and fix failures
- `/commit`: delegate a single Conventional Commit
- `/design`: generate/update visual identity assets
- `/plan-change`: plan a change (prep context)
- `/plan-decision`: plan a technical decision (prep context)
- `/pr`: create/update PR/MR and sync title/description (`tmp/pr/<branch>/description.md`, via `@pr-manager`); fetches ticket context from Jira/GitHub when `workItemRef` is detected
- `/review`: review a change vs spec/plan
- `/review-deep`: deeper review vs spec/plan
- `/run-plan`: execute an implementation plan
- `/sync-docs`: reconcile system specs from a change
- `/write-decision`: write a decision record (ADR/PDR/TDR/BDR/ODR) from planning context
- `/write-plan`: generate an implementation plan
- `/write-spec`: generate a change spec
- `/write-test-plan`: generate a change test plan

---

## Historical Notes

Agent and command names were standardized in January 2026. Old-to-new mapping is preserved below for reference during migration of existing projects.

<details>
<summary>Name rename map (2026-01)</summary>

### Agents

| Old Name | New Name | Rationale |
|----------|----------|-----------|
| `change-delivery-orchestrator` | _(removed)_ | Redundant sub-orchestrator; `@pm` delegates directly to `@coder` |
| `change-reviewer` | `reviewer` | Drop redundant prefix |
| `change-spec-writer` | `spec-writer` | Drop redundant prefix |
| `change-test-plan-writer` | `test-plan-writer` | Drop redundant prefix |
| `content-editor` | `editor` | Shorter |
| `conventional-committer` | `committer` | Shorter |
| `debug-test-fixer` | `fixer` | Shorter |
| `image-critique-agent` | `image-reviewer` | Drop `-agent` suffix |
| `implementation-plan-writer` | `plan-writer` | Shorter |
| `opencode-toolsmith` | `toolsmith` | Drop `opencode-` prefix |
| `plan-executor` | `coder` | Unambiguous — writes code |
| `product-manager` | `pm` | Universally understood |
| `run-logs-runner` | `runner` | Cleaner |
| `system-spec-updater` | `doc-syncer` | Aligns with `/sync-docs` |
| `visual-designer` | `designer` | Shorter |

### Commands

| Old Name | New Name | Rationale |
|----------|----------|-----------|
| `/plan-change-scope` | `/plan-change` | Shorter |
| `/write-change-spec` | `/write-spec` | Shorter |
| `/write-change-plan` | `/write-plan` | Shorter |
| `/write-change-test-plan` | `/write-test-plan` | Shorter |
| `/execute-change-plan` | `/run-plan` | Action-oriented |
| `/review-change` | `/review` | Shorter |
| `/update-system-docs` | `/sync-docs` | Cleaner |
| `/run-quality-gates` | `/check` | Shorter |
| `/run-quality-gates-fix` | `/check-fix` | Shorter |
| `/create-pr` | `/pr` | Shorter |
| `/create-commit` | `/commit` | Shorter |
| `/plan-architecture-decision` | `/plan-decision` | Shorter |
| `/write-architecture-decision-record` | `/write-decision` | Generic — supports all decision types |

</details>
