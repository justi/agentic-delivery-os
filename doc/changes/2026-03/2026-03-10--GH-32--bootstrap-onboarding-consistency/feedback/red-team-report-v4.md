---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/feedback/red-team-report-v4.md
---
# Red Team Report v4 — DEEP Final Pre-Public Audit

**Date:** 2026-03-11
**Branch:** `feat/GH-32/bootstrap-onboarding-consistency`
**Scope:** Line-by-line audit of all 19 agent files, 16 command files, all documentation, scripts, README, and cross-reference validation.
**Reviewers:** Security Officer, Technical Writer, Bash Developer, Product Manager, QA Engineer, CTO

---

## Overall Verdict: CONCERNS

The repository is in strong shape after three rounds of review. No BLOCK-level private data leaks remain in shipped files. However, this deep audit uncovered **23 findings** across 8 categories — mostly MEDIUM and LOW severity, with **4 HIGH** items that should be addressed before public launch.

---

## 1. Private Reference Sweep

### Status: PASS (with caveats)

**Methodology:** Grepped entire repository for `menuvivo`, `flagshipx`, `DaySync`, `Planora`, `atlassian.net`, `/home/juliusz/`, and `PDEV-` (case-insensitive).

**Results:**
- **`.opencode/` directory:** CLEAN — no private project names found in any agent or command file.
- **`README.md`:** CLEAN
- **`AGENTS.md`:** CLEAN (except `PDEV-123` used as generic Jira example — acceptable)
- **`doc/guides/`:** CLEAN (`atlassian.net` appears only as `<your-domain>.atlassian.net` placeholder in onboarding guide — acceptable)
- **`scripts/`:** CLEAN
- **`doc/changes/` and `feedback/`:** Contains historical references to menuvivo, FlagshipX, DaySync, Planora — these are historical delivery artifacts and are ACCEPTABLE per the review criteria.

### PRS-1: `responsive-recipes-images` slug in README.md and change convention guide

- **File:** `README.md:157`, `doc/guides/unified-change-convention-tracker-agnostic-specification.md:86,170,299,302`
- **What:** The branch example `feat/PDEV-123/responsive-recipes-images` references "recipes" — a domain concept from a private project (likely menuvivo). While `PDEV-123` is acceptable as a generic Jira example, `responsive-recipes-images` is a specific feature slug from a private project.
- **Why it matters:** A visitor might wonder "what recipes?" — it subtly reveals the system was built for a food/recipe app.
- **Suggested fix:** Change to a generic slug like `responsive-product-images` or `user-profile-avatars`.
- **Severity:** LOW

### PRS-2: `recipe-service-cleanup` in change convention guide

- **File:** `doc/guides/unified-change-convention-tracker-agnostic-specification.md:172`
- **What:** Example `refactor/PDEV-789/recipe-service-cleanup` — same issue as PRS-1.
- **Suggested fix:** Change to `refactor/PDEV-789/user-service-cleanup`.
- **Severity:** LOW

### PRS-3: `feat(recipes): PDEV-4 add createdAt field to recipes` in pr-manager.md

- **File:** `.opencode/agent/pr-manager.md:217`
- **What:** The PR title example references "recipes" — a private project domain concept.
- **Suggested fix:** Change to `feat(users): PDEV-4 add createdAt field to user profiles` or similar generic example.
- **Severity:** LOW

---

## 2. Agent Files — Line-by-Line Audit (19 files)

### AGT-1: `designer.md` contains project-specific technology assumptions

- **File:** `.opencode/agent/designer.md:33-34,43-44,53`
- **What:** References `src/styles/global.css`, `src/components/ui/**`, "Tailwind + shadcn/ui patterns", and `--fx-*` CSS variables. These are specific to a particular project's tech stack (likely FlagshipX), not generic ADOS tooling.
- **Why it matters:** This agent ships to every ADOS user. A Python/Go project won't have `src/components/ui/**` or Tailwind. The agent should be project-agnostic or clearly state these are examples.
- **Suggested fix:** Rewrite the "Canonical references" section to say "Read the project's design system document (if it exists)" instead of hardcoding paths. Move the Tailwind/shadcn specifics into a conditional: "If the project uses Tailwind/shadcn, prefer..."
- **Severity:** HIGH

### AGT-2: `designer.md` references non-existent design system file

- **File:** `.opencode/agent/designer.md:67`
- **What:** References `doc/spec/features/spec-visual-design-system.md` — this file does not exist in the ADOS repo and won't exist in most adopter projects.
- **Why it matters:** The agent will fail to load its "single source of truth" on first use in any project.
- **Suggested fix:** Change to a discovery pattern: "Search for a visual design system document in `doc/spec/features/` or `doc/guides/`. If none exists, inform the user."
- **Severity:** HIGH

### AGT-3: `plan-change.md` command has `agent: build` — non-existent agent

- **File:** `.opencode/command/plan-change.md:7`
- **What:** The frontmatter says `agent: build` but there is no agent named `build` in the repository. The 19 agents are: pm, coder, spec-writer, plan-writer, test-plan-writer, reviewer, doc-syncer, pr-manager, runner, fixer, committer, architect, editor, designer, image-generator, image-reviewer, bootstrapper, external-researcher, toolsmith.
- **Why it matters:** This command may not route to the correct agent. The `/plan-change` command is a planning session — it should either have no agent (run in main context) or reference `pm`.
- **Suggested fix:** Remove `agent: build` or change to the appropriate agent.
- **Severity:** HIGH

### AGT-4: `design.md` command has `agent: build` — non-existent agent

- **File:** `.opencode/command/design.md:7`
- **What:** Same issue as AGT-3. `agent: build` does not exist.
- **Suggested fix:** Change to `agent: designer` (the actual visual design agent).
- **Severity:** HIGH

### AGT-5: `fixer.md` references `CLAUDE.md`

- **File:** `.opencode/agent/fixer.md:80`
- **What:** Says "Ensure changes align with project standards described in any provided CLAUDE.md or AGENTS.md files." — `CLAUDE.md` is a Claude Code convention, not an OpenCode convention.
- **Why it matters:** Minor inconsistency. ADOS targets OpenCode; referencing `CLAUDE.md` is a vestige of Claude Code origins.
- **Suggested fix:** Change to "Ensure changes align with project standards described in `AGENTS.md`." (remove CLAUDE.md reference).
- **Severity:** LOW

### AGT-6: `toolsmith.md` references `claude-opus-4-5` and `claude-sonnet-4-5` in model profiles

- **File:** `.opencode/agent/toolsmith.md:587-601`
- **What:** The model profiles reference `claude-opus-4-5` and `claude-sonnet-4-5` but the actual frontmatter models used across agents are `anthropic/claude-opus-4-6` and `anthropic/claude-sonnet-4-6`. The model profiles appear to be one generation behind.
- **Why it matters:** The toolsmith's model selection guidance is stale — it will recommend older models.
- **Suggested fix:** Update model profiles to reference current model versions (4-6 series).
- **Severity:** MEDIUM

### AGT-7: `architect.md` references project-specific config files

- **File:** `.opencode/agent/architect.md:74-75`
- **What:** Lists `astro.config.mjs`, `supabase/**`, `.gitlab-ci.yml` as canonical references. These are specific to a particular project stack (Astro + Supabase + GitLab CI).
- **Why it matters:** Ships to every ADOS user. A Next.js + AWS + GitHub Actions project would find these references confusing.
- **Suggested fix:** Generalize to "Config/build/infrastructure: project configuration files (e.g., `package.json`, `tsconfig.json`, CI/CD configs, infrastructure configs)".
- **Severity:** MEDIUM

### AGT-8: `coder.md` version bump reference

- **File:** `.opencode/agent/coder.md:109`
- **What:** "For final phase: ensure version bump and CHANGELOG tasks validated against AGENTS.md." — ADOS itself doesn't have a CHANGELOG.md or version bump convention.
- **Why it matters:** Minor — this is generic guidance that applies to adopter projects, not ADOS itself. Acceptable as-is.
- **Severity:** LOW (informational)

---

## 3. Command Files — Line-by-Line Audit (16 files)

### CMD-1: Command descriptions match `.opencode/README.md` and `AGENTS.md`

**Verification matrix:**

| Command | `.opencode/README.md` | `AGENTS.md` | Command file | Match? |
|---------|----------------------|-------------|--------------|--------|
| `/bootstrap` | scaffold ADOS artifacts | Scaffold ADOS artifacts | Scaffold ADOS artifacts | ✅ |
| `/check` | run quality gates (no fixes) | Run quality gates (no fixes) | Run quality gates and summarize | ✅ (close enough) |
| `/check-fix` | run quality gates and fix failures | Run quality gates and fix failures | Execute quality gates, fix issues | ✅ |
| `/commit` | delegate a single Conventional Commit | Create one Conventional Commit | Delegate a single Conventional Commit | ✅ |
| `/design` | generate/update visual identity assets | Generate/update visual design assets | Generate and update visual design assets | ✅ |
| `/plan-change` | plan a change (prep context) | Interactive planning session | Interactive change-planning session | ✅ |
| `/plan-decision` | plan a technical decision | Interactive architecture decision session | Interactive architecture decision session | ✅ |
| `/pr` | create/update PR/MR | Create/update PR/MR | Create/update PR/MR title and description | ✅ |
| `/review` | review a change vs spec/plan | Review change vs spec/plan | Review change vs spec & plan | ✅ |
| `/review-deep` | deeper review vs spec/plan | Deep review with stronger reasoning model | Deep review of change vs spec & plan | ✅ |
| `/run-plan` | execute an implementation plan | Execute plan phases | Execute implementation plan phases | ✅ |
| `/sync-docs` | reconcile system specs from a change | Reconcile system docs from a change | Update current system specification docs | ✅ |
| `/write-adr` | write an ADR from planning context | Generate Architecture Decision Record | Generate ADR from planning context | ✅ |
| `/write-plan` | generate an implementation plan | Generate implementation plan | Generate or update implementation plan | ✅ |
| `/write-spec` | generate a change spec | Generate change specification | Generate canonical change specification | ✅ |
| `/write-test-plan` | generate a change test plan | Generate test plan | Generate or update change test plan | ✅ |

**Result:** All 16 commands have consistent descriptions across all three locations. ✅

### CMD-2: Agent references in commands

| Command | `agent:` in frontmatter | Correct? |
|---------|------------------------|----------|
| `/bootstrap` | `bootstrapper` | ✅ |
| `/check` | `runner` | ✅ |
| `/check-fix` | `fixer` | ✅ |
| `/commit` | `committer` | ✅ |
| `/design` | `build` | ❌ (see AGT-4) |
| `/plan-change` | `build` | ❌ (see AGT-3) |
| `/plan-decision` | (not specified) | ✅ (runs in main context) |
| `/pr` | `pr-manager` | ✅ |
| `/review` | `reviewer` | ✅ |
| `/review-deep` | `reviewer` | ✅ |
| `/run-plan` | `coder` | ✅ |
| `/sync-docs` | `doc-syncer` | ✅ |
| `/write-adr` | (not specified) | ✅ |
| `/write-plan` | `plan-writer` | ✅ |
| `/write-spec` | `spec-writer` | ✅ |
| `/write-test-plan` | `test-plan-writer` | ✅ |

**Result:** 2 commands reference non-existent `build` agent (AGT-3, AGT-4). All others correct.

---

## 4. Cross-Reference Validation

### CRV-1: Agent count consistency

| Location | Count | Correct? |
|----------|-------|----------|
| `AGENTS.md:12` | "19 AI agents" | ✅ |
| `AGENTS.md:174` | "19 agents (one .md each)" | ✅ |
| `README.md:104` | "19 agents" | ✅ |
| `README.md:165` | "19 agents (one .md each)" | ✅ |
| `.opencode/README.md` | 19 agents listed | ✅ |
| Actual files in `.opencode/agent/` | 19 files | ✅ |
| `doc/guides/opencode-agents-and-commands-guide.md` | 19 agents listed | ✅ |

**Result:** Agent count is consistent everywhere. ✅

### CRV-2: Command count consistency

| Location | Count | Correct? |
|----------|-------|----------|
| `AGENTS.md:12` | "16 commands" | ✅ |
| `AGENTS.md:175` | "16 commands (one .md each)" | ✅ |
| `README.md:106` | "16 commands" | ✅ |
| `README.md:166` | "16 commands (one .md each)" | ✅ |
| `.opencode/README.md` | 16 commands listed | ✅ |
| Actual files in `.opencode/command/` | 16 files | ✅ |
| `doc/guides/opencode-agents-and-commands-guide.md` | 16 commands listed (table rows) | ✅ |

**Result:** Command count is consistent everywhere. ✅

### CRV-3: Template count consistency

| Location | Count | Correct? |
|----------|-------|----------|
| `AGENTS.md:192` | "7 templates" | ✅ |
| `README.md:183` | "7 templates" | ✅ |
| `doc/templates/README.md` | 7 templates listed | ✅ |
| `doc/00-index.md` | 7 templates listed | ✅ |
| Actual files in `doc/templates/` | 7 templates + 1 README.md = 8 files | ✅ |

**Result:** Template count is consistent everywhere. ✅

### CRV-4: Every agent in AGENTS.md has a file

| Agent | File exists? |
|-------|-------------|
| pm | ✅ `.opencode/agent/pm.md` |
| architect | ✅ `.opencode/agent/architect.md` |
| bootstrapper | ✅ `.opencode/agent/bootstrapper.md` |
| spec-writer | ✅ `.opencode/agent/spec-writer.md` |
| plan-writer | ✅ `.opencode/agent/plan-writer.md` |
| test-plan-writer | ✅ `.opencode/agent/test-plan-writer.md` |
| coder | ✅ `.opencode/agent/coder.md` |
| designer | ✅ `.opencode/agent/designer.md` |
| editor | ✅ `.opencode/agent/editor.md` |
| reviewer | ✅ `.opencode/agent/reviewer.md` |
| fixer | ✅ `.opencode/agent/fixer.md` |
| runner | ✅ `.opencode/agent/runner.md` |
| doc-syncer | ✅ `.opencode/agent/doc-syncer.md` |
| committer | ✅ `.opencode/agent/committer.md` |
| pr-manager | ✅ `.opencode/agent/pr-manager.md` |
| external-researcher | ✅ `.opencode/agent/external-researcher.md` |
| image-generator | ✅ `.opencode/agent/image-generator.md` |
| image-reviewer | ✅ `.opencode/agent/image-reviewer.md` |
| toolsmith | ✅ `.opencode/agent/toolsmith.md` |

**Result:** All 19 agents have corresponding files. ✅

### CRV-5: Every command in AGENTS.md has a file

All 16 commands verified — all have corresponding files. ✅

### CRV-6: Delegation tables reference existing agents

Checked all delegation references in agent files:
- `pm.md` delegation table: all 13 agents exist ✅
- `coder.md` delegates to: `@runner`, `@committer`, `@architect`, `@designer`, `@editor` — all exist ✅
- `fixer.md` delegates to: `@runner`, `@image-reviewer` — all exist ✅
- `designer.md` delegates to: `@image-generator`, `@image-reviewer` — all exist ✅

**Result:** All delegation references point to existing agents. ✅

---

## 5. Documentation Accuracy

### DOC-1: Change lifecycle matches pm.md implementation

**Verified:** The 10-phase table in `doc/guides/change-lifecycle.md` matches the workflow steps in `.opencode/agent/pm.md` exactly:

| Phase | Lifecycle Guide | pm.md | Match? |
|-------|----------------|-------|--------|
| 1. clarify_scope | @pm | Step 3 | ✅ |
| 2. specification | @spec-writer | Step 4 | ✅ |
| 3. test_planning | @test-plan-writer | Step 4 | ✅ |
| 4. delivery_planning | @plan-writer | Step 4 | ✅ |
| 5. delivery | @coder | Step 5 | ✅ |
| 6. system_spec_update | @doc-syncer | Step 6 | ✅ |
| 7. review_fix | @reviewer | Step 6 | ✅ |
| 8. quality_gates | @runner | Step 7 | ✅ |
| 9. dod_check | @pm | Step 8 | ✅ |
| 10. pr_creation | @pr-manager | Step 9 | ✅ |

**Result:** Perfect alignment. ✅

### DOC-2: `doc/00-index.md` link verification

| Link | Target exists? |
|------|---------------|
| `overview/` | ✅ (directory exists) |
| `spec/` | ✅ (directory exists) |
| `documentation-handbook.md` | ✅ |
| `changes/` | ✅ |
| `guides/change-lifecycle.md` | ✅ |
| `guides/unified-change-convention-tracker-agnostic-specification.md` | ✅ |
| `guides/opencode-agents-and-commands-guide.md` | ✅ |
| `guides/onboarding-existing-project.md` | ✅ |
| `guides/decision-records-management.md` | ✅ |
| `guides/tools-convention.md` | ✅ |
| `templates/change-spec-template.md` | ✅ |
| `templates/decision-record-template.md` | ✅ |
| `templates/feature-spec-template.md` | ✅ |
| `templates/north-star-template.md` | ✅ |
| `templates/test-spec-template.md` | ✅ |
| `templates/test-plan-template.md` | ✅ |
| `templates/implementation-plan-template.md` | ✅ |
| `decisions/` | ✅ |
| `decisions/00-index.md` | ✅ |

**Result:** All links resolve to existing files/directories. ✅

### DOC-3: Onboarding guide walkthrough

Followed the guide step by step:
1. ✅ Global install curl command matches `scripts/install.sh`
2. ✅ Local install command matches script behavior
3. ✅ `/bootstrap` command exists and delegates to `@bootstrapper`
4. ✅ Manual setup steps reference correct file paths
5. ✅ GitHub Issues and Jira examples are generic (no private project keys)
6. ✅ First change walkthrough matches actual command flow
7. ✅ Troubleshooting section covers common issues
8. ✅ Related guides links all resolve

**Result:** Guide would work for a new user. ✅

### DOC-4: `doc/guides/opencode-agents-and-commands-guide.md` completeness

- Lists all 19 agents in section 2.2 ✅
- Lists all 16 commands in section 2.1 ✅
- Descriptions are accurate and match agent/command files ✅
- Manual workflow (section 3) matches actual command flow ✅
- Autopilot workflow (section 4) matches pm.md phases ✅

**Result:** Complete and accurate. ✅

---

## 6. README.md Perfection Check

### README-1: Value proposition clarity

The README opens with a clear pipeline visualization and explains what ADOS is in the first 3 lines. The "Why this exists" section articulates the problem well. The "What this gives you" section is concrete.

**Assessment:** Strong. A first-time visitor would understand the value within 30 seconds. ✅

### README-2: Quick Start flow

1. `curl` one-liner → `scripts/install.sh --global` ✅
2. `~/.ados/repo/scripts/install.sh --local` ✅
3. `/bootstrap` ✅
4. Uninstall commands provided ✅
5. Update path documented ✅

**Assessment:** Quick Start is clear and actionable. ✅

### README-3: Link verification

All relative links in README.md verified:
- `./assets/hero.png` → ✅ exists
- `assets/hero.webp` → ✅ exists
- `.opencode/command/review.md` → ✅ exists
- `.opencode/command/sync-docs.md` → ✅ exists
- `.opencode/command/check.md` → ✅ exists
- `.opencode/command/pr.md` → ✅ exists
- `.opencode/agent/pm.md` → ✅ exists
- All other agent/command links → ✅ verified
- `doc/guides/onboarding-existing-project.md` → ✅ exists
- `.opencode/README.md` → ✅ exists
- `.ai/agent/pm-instructions.md` → ✅ exists
- `LICENSE` → ✅ exists

**Result:** All links resolve. ✅

### README-4: Grammar and phrasing

- **Line 20:** "This repo is a practical reference implementation of a spec-driven workflow using OpenCode:" — Clear and professional. ✅
- **Line 87:** "This project exists to evolve and validate an AI-native delivery operating model on real work" — Good. ✅
- No grammatical errors found.
- No "work in progress" or internal language found.

**Result:** Professional and polished. ✅

### README-5: `PDEV-123` examples in README.md

- **File:** `README.md:141,157`
- **What:** Uses `PDEV-123` as a Jira example and `feat/PDEV-123/responsive-recipes-images` as a branch example.
- **Assessment:** `PDEV-123` is acceptable as a generic Jira project key example. The `responsive-recipes-images` slug is a minor private project leak (see PRS-1).
- **Severity:** LOW

---

## 7. Install/Uninstall Script Review

### SCR-1: `install.sh` — No hardcoded private paths

- All paths are derived from `$HOME` or configurable via environment variables ✅
- `ADOS_REPO_URL` defaults to the public GitHub repo ✅
- No private filesystem paths ✅
- Help text matches actual behavior ✅
- Error messages are clear ✅
- Path validation prevents writing outside `$HOME` ✅

**Result:** Clean and well-engineered. ✅

### SCR-2: `uninstall.sh` — Safety checks

- `safe_rmdir()` has depth checks, refuses to remove `/` or `$HOME` ✅
- Confirmation prompt before destructive operations ✅
- `--dry-run` support ✅
- Known file lists match actual ADOS artifacts ✅

### SCR-3: `uninstall.sh` template file list includes 8 entries

- **File:** `scripts/uninstall.sh:82-91`
- **What:** `ADOS_LOCAL_TEMPLATE_FILES` lists 8 files including `north-star-template.md` and `README.md`. This matches the actual `doc/templates/` contents.
- **Result:** Correct. ✅

**Result:** Both scripts are production-quality. ✅

---

## 8. Tone and Professionalism

### TONE-1: Engineering director perspective

Read README.md, AGENTS.md, and onboarding guide as an engineering director evaluating adoption:

**Strengths:**
- Clear problem statement ("prompt roulette", lack of repeatability)
- Honest about what it is ("reference implementation", not "enterprise platform")
- Concrete deliverables (19 agents, 16 commands, 10-phase workflow)
- Professional but approachable tone
- No inflated claims
- Good "What this gives you" section with specific benefits
- Clear distinction between autopilot and manual modes

**Concerns:**
- None significant. The tone is appropriate for an open-source developer tool.

**Result:** Would inspire confidence in an engineering director. ✅

---

## 9. Additional Findings

### ADD-1: `designer.md` and `design.md` are project-specific, not framework-generic

- **Files:** `.opencode/agent/designer.md`, `.opencode/command/design.md`
- **What:** Both files assume a React/Tailwind/shadcn tech stack. The designer agent references `src/components/ui/**`, `src/styles/global.css`, and specific CSS variable prefixes (`--fx-*`). The design command references "React/Tailwind Theme" as the first output type.
- **Why it matters:** ADOS is a framework-agnostic delivery system. These two files are the only ones that assume a specific frontend tech stack. Every other agent is properly generic.
- **Suggested fix:** Rewrite both to be tech-stack-agnostic with a discovery pattern: "Read the project's design system document. If the project uses React/Tailwind, apply those patterns. If not, adapt to the project's actual tech stack."
- **Severity:** MEDIUM (combined with AGT-1 and AGT-2)

### ADD-2: `plan-change.md` examples use billing/tenant domain

- **File:** `.opencode/command/plan-change.md:31,153-264`
- **What:** The planning summary example is entirely about "tenant billing model for enterprise customers" with billing-specific APIs, events, and data models. While this is clearly an example, it's very detailed and domain-specific.
- **Assessment:** This is acceptable — examples need to be concrete to be useful, and the command file includes a note "Follow the pattern; ignore the specific example content" (though this note is actually in other files, not this one). The billing domain is generic enough.
- **Severity:** LOW (informational — no action needed)

### ADD-3: `plan-decision.md` examples use billing/tenant domain

- **File:** `.opencode/command/plan-decision.md:35,197-348`
- **What:** Same pattern as ADD-2 — detailed billing/tenant examples.
- **Assessment:** Same as ADD-2 — acceptable.
- **Severity:** LOW (informational)

### ADD-4: `.opencode/README.md` says "OpenCode upstream docs use `.opencode/agents/` and `.opencode/commands/`"

- **File:** `.opencode/README.md:11`
- **What:** Notes that OpenCode upstream uses plural folder names but this repo uses singular. This is a useful clarification for contributors.
- **Assessment:** Acceptable as-is. ✅

### ADD-5: `toolsmith.md` persistent memory path inconsistency

- **File:** `.opencode/agent/toolsmith.md:169`
- **What:** Says persistent memory goes to `.ai/context/{agent|command|skill}/<name>.yaml` but the bootstrapper uses `.ai/local/bootstrapper-context.yaml` and PM uses `.ai/local/pm-context.yaml`. The convention is inconsistent.
- **Why it matters:** When toolsmith creates new agents with persistent memory, it will use a different path convention than existing agents.
- **Suggested fix:** Align toolsmith's guidance with the actual convention (`.ai/local/<name>-context.yaml`).
- **Severity:** MEDIUM

### ADD-6: `check.md` references `playwright-report` paths

- **File:** `.opencode/command/check.md:55`
- **What:** References `tmp/playwright-report` and `tmp/playwright-report/ai-failures.jsonl` — these are specific to projects using Playwright.
- **Why it matters:** Minor — the check command is designed to be customized per project via `AGENTS.md` quality gates configuration. The Playwright reference is in a "pointers mentioned by quality-gates.sh" context, which is acceptable.
- **Severity:** LOW

### ADD-7: AGENTS.md references `.Claude/` in system prompt but repo uses `.opencode/`

- **File:** `AGENTS.md` (as rendered by the system prompt / Claude Code context)
- **What:** The system prompt that was provided to this review session references `.Claude/agent/*.md` and `.Claude/command/*.md` but the actual repository uses `.opencode/agent/*.md` and `.opencode/command/*.md`. This appears to be a Claude Code ↔ OpenCode naming translation issue in the AGENTS.md that gets loaded by Claude Code.
- **Assessment:** This is likely handled by the AI coding tool's path mapping. The actual AGENTS.md file in the repo correctly references `.opencode/`. No action needed.
- **Severity:** LOW (informational)

---

## Prioritized Action Items

| # | Action | File(s) | Est. Time | Severity | Finding |
|---|--------|---------|-----------|----------|---------|
| 1 | **Fix `agent: build`** in plan-change.md and design.md — change to correct agent or remove | `.opencode/command/plan-change.md:7`, `.opencode/command/design.md:7` | 2 min | HIGH | AGT-3, AGT-4 |
| 2 | **Generalize designer.md** — remove hardcoded `src/` paths, Tailwind/shadcn assumptions, and non-existent design system file reference | `.opencode/agent/designer.md:33-34,43-44,53,67` | 15 min | HIGH | AGT-1, AGT-2 |
| 3 | **Update toolsmith.md model profiles** — change `claude-opus-4-5` → `claude-opus-4-6` etc. | `.opencode/agent/toolsmith.md:587-601` | 5 min | MEDIUM | AGT-6 |
| 4 | **Generalize architect.md** — remove Astro/Supabase/GitLab-specific config references | `.opencode/agent/architect.md:74-75` | 5 min | MEDIUM | AGT-7 |
| 5 | **Align toolsmith persistent memory path** with actual convention (`.ai/local/`) | `.opencode/agent/toolsmith.md:169` | 2 min | MEDIUM | ADD-5 |
| 6 | **Generalize design.md command** — make tech-stack-agnostic | `.opencode/command/design.md` | 10 min | MEDIUM | ADD-1 |
| 7 | **Replace `responsive-recipes-images`** with generic slug in README and change convention guide | `README.md:157`, `doc/guides/unified-change-convention-tracker-agnostic-specification.md:86,170,172,299,302` | 5 min | LOW | PRS-1, PRS-2 |
| 8 | **Replace `recipes` example** in pr-manager.md | `.opencode/agent/pr-manager.md:217` | 1 min | LOW | PRS-3 |
| 9 | **Remove `CLAUDE.md` reference** from fixer.md | `.opencode/agent/fixer.md:80` | 1 min | LOW | AGT-5 |

**Total estimated time: ~46 minutes**

---

## Consensus Findings (flagged by 2+ review perspectives)

### CF-1: `agent: build` references (Security + QA + CTO)
Two commands reference a non-existent `build` agent. This is a functional bug that could cause routing failures.

### CF-2: `designer.md` is project-specific (Product + CTO + Technical Writer)
The designer agent and design command are the only files that assume a specific tech stack (React/Tailwind/shadcn). Every other agent is properly generic.

### CF-3: Example slugs leak private project domain (Security + Technical Writer)
"recipes" appears in examples across 3 files — a minor but detectable trace of the system's origins.

---

## What v1-v3 Caught vs. What v4 Found

| Category | v1-v3 | v4 (new) |
|----------|-------|----------|
| Private project names in agent files | ✅ Fixed (menuvivo, FlagshipX) | ✅ Clean |
| Private URLs | ✅ Fixed | ✅ Clean |
| Private filesystem paths | ✅ Fixed | ✅ Clean |
| Agent/command count consistency | ✅ Fixed | ✅ Verified everywhere |
| README completeness | ✅ Fixed | ✅ All links verified |
| `agent: build` references | ❌ Not caught | 🆕 Found (AGT-3, AGT-4) |
| Project-specific tech stack in designer | ❌ Not caught (only FlagshipX name was caught) | 🆕 Found (AGT-1, AGT-2) |
| Stale model versions in toolsmith | ❌ Not caught | 🆕 Found (AGT-6) |
| Project-specific config in architect | ❌ Not caught | 🆕 Found (AGT-7) |
| Persistent memory path inconsistency | ❌ Not caught | 🆕 Found (ADD-5) |
| "recipes" slug in examples | ❌ Not caught | 🆕 Found (PRS-1, PRS-2, PRS-3) |

---

## Coverage Gaps

1. **Runtime testing:** This review is static analysis only. The `agent: build` issue (AGT-3, AGT-4) should be verified by actually running `/plan-change` and `/design` to confirm whether OpenCode handles the missing agent gracefully or errors.
2. **OpenCode compatibility:** The review assumes OpenCode's agent routing behavior. If `agent: build` silently falls back to the default model, the impact is lower than if it errors.
3. **Template content quality:** Templates were verified to exist but their internal content was not audited line-by-line for quality.

---

## Bottom Line

**The repository is 95% ready for public launch.** Three rounds of prior review cleaned up all major private data leaks and consistency issues. This deep audit found **4 HIGH-severity items** — two are trivial 1-line fixes (`agent: build` → correct agent), and two require modest rewriting to make the designer agent/command tech-stack-agnostic. The remaining findings are LOW/MEDIUM polish items. Total fix time is under 1 hour. After addressing the HIGH items, this repo will present well to any engineering team evaluating it.
