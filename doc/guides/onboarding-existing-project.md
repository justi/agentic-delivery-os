---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/guides/onboarding-existing-project.md
---
# Onboarding an Existing Project to ADOS

> **Audience:** Engineers and tech leads adopting Agentic Delivery OS (ADOS) in an existing project.
>
> **Goal:** Step-by-step guide to set up the minimum viable ADOS configuration, with clear distinction between mandatory and optional artifacts.

---

## Getting ADOS

**One-liner global install** (recommended — gives you ADOS agents in every project):

```bash
curl -fsSL https://raw.githubusercontent.com/juliusz-cwiakalski/agentic-delivery-os/main/scripts/install.sh | bash -s -- --global
```

This clones ADOS to `~/.ados/repo/` and installs all agent and command definitions globally.

**Then set up a specific project:**

```bash
~/.ados/repo/scripts/install.sh --local
```

This copies mandatory ADOS artifacts (templates, handbook, directory structure) into your current project.

**Alternative — manual clone:**

```bash
git clone --depth=1 https://github.com/juliusz-cwiakalski/agentic-delivery-os.git /tmp/ados-source
```

> **Tip:** Use `--dry-run` with either install mode to preview changes before applying them.
> To remove ADOS later, run `~/.ados/repo/scripts/uninstall.sh --global` or `~/.ados/repo/scripts/uninstall.sh --local`.

---

## Prerequisites

Before starting, ensure you have:

- A **git repository** for your project
- **[OpenCode](https://opencode.ai)** — the AI coding agent that ADOS currently targets. OpenCode provides the agent/command framework that ADOS definitions use. Other tools (Claude Code CLI, Cursor, Windsurf) may work with manual configuration but are not officially tested.
- An **AI provider API key** — OpenCode requires access to an LLM provider (e.g., Anthropic API key for Claude). See [OpenCode docs](https://opencode.ai) for setup.
- Basic familiarity with ADOS concepts (see [Agents & Commands Guide](opencode-agents-and-commands-guide.md))
- Access to your team's issue tracker (GitHub Issues or Jira)

> **What to expect:**
> - **Automated bootstrap:** ~15 minutes (scan + interview + review)
> - **Manual setup:** ~30 minutes (copy files, configure tracker, create stubs)
> - **First change (full 10-phase workflow):** ~1 hour
> - **Ongoing changes:** 15-30 minutes each (agents handle most phases automatically)

---

## Artifact Checklist

ADOS is both a framework you adopt **and** a system that uses itself. Some artifacts are generic (copy as-is from the ADOS repo), while others must be written specifically for your project. Use this table to plan your setup:

| Artifact | Path | Action | Notes |
|----------|------|--------|-------|
| **Mandatory** | | | |
| AGENTS.md | `AGENTS.md` | Copy & customize | Customize project description, repo structure, key references |
| PM instructions | `.ai/agent/pm-instructions.md` | Create & customize | Configure your tracker (GitHub/Jira), workflow mapping, labels |
| Documentation handbook | `doc/documentation-handbook.md` | Copy as-is | Shared standard — keep identical across repos |
| **Recommended** | | | |
| Documentation index | `doc/00-index.md` | Copy & customize | Update links to match your docs |
| Document templates | `doc/templates/` | Copy as-is | 7 templates — agents read at runtime |
| Decision records dir | `doc/decisions/` | Copy as-is | README.md + 00-index.md stubs |
| AI rules index | `.ai/rules/README.md` | Copy & customize | Add project-specific rules to routing table |
| **Optional (create as needed)** | | | |
| Project overview | `doc/overview/` | Create & customize | North star, architecture, glossary |
| Feature specs | `doc/spec/features/` | Create & customize | Current-truth feature descriptions |
| Coding rules | `.ai/rules/<topic>.md` | Create & customize | Language/framework-specific coding standards |
| Testing strategy | `.ai/rules/testing-strategy.md` | Create & customize | Required before `@test-plan-writer` can run |
| Project guides | `doc/guides/` | Create & customize | Dev setup, debugging, deployment, etc. |

> **Decision management:** All decisions (architecture, product, technical, business, operational) go in `doc/decisions/` — see the [Decision Records Management Guide](decision-records-management.md).

---

## Choose Your Setup Path

> **Automated (recommended):** Run `/bootstrap` and the `@bootstrapper` agent will scan your repo, ask targeted questions, and generate all required artifacts with your approval. Takes ~15 minutes.
>
> **Manual (full control):** Follow Steps 1-5 below to set up each artifact individually. Takes ~30 minutes.
>
> **Skip to:** [Automated Bootstrap](#automated-bootstrap) | [Manual Setup](#manual-setup-step-by-step)

---

## Automated Bootstrap

```
/bootstrap
```

The `@bootstrapper` agent will:

1. **Scan** your repo structure, tech stack, and existing docs
2. **Assess** what it can infer vs. what needs your input
3. **Interview** you with targeted questions (~3-7 per round)
4. **Draft** all required ADOS artifacts for your review
5. **Write** final artifacts upon your approval

After bootstrap completes, jump to [First Change Walkthrough](#first-change-walkthrough) to validate your setup.

---

## Manual Setup (Step-by-Step)

### Step 1: Mandatory Artifacts

These three files are **required** for ADOS to function. Without them, agents cannot orchestrate changes.

### 1.1 `AGENTS.md` (Project Root)

The bootstrap file that AI agents read first. It tells agents what your project is, how the delivery process works, and where to find everything.

**Setup:**

1. Copy `AGENTS.md` from the ADOS repository as a starting point
2. Customize the following sections for your project:
   - **"What this repo is"** — describe your project, not ADOS
   - **"Repo structure"** — match your actual directory layout
   - **"Key references"** — update paths to your project's docs
3. Keep the **Delivery process**, **Agent team**, and **Commands** sections as-is (they describe ADOS capabilities)
4. Update agent/command counts if you add custom agents

**Key content:**

- Project description and purpose
- Delivery process overview (10-phase workflow)
- Agent team inventory
- Commands table
- Repo structure tree
- Key references table

### 1.2 `.ai/agent/pm-instructions.md`

Configures the `@pm` agent for your specific issue tracker and workflow.

> **What goes here:** PM instructions contain ONLY information that is specific to your project and tracker. Do not repeat the standard ADOS change lifecycle (that lives in `doc/guides/change-lifecycle.md`). The goal is a lean file: the less you repeat, the less drifts.

#### Mandatory Sections

| Section | Purpose |
|---------|---------|
| **Tracker Configuration** | Which tracker is canonical (GitHub Issues / Jira / local markdown backlog), connection details, project keys |
| **Workflow States Mapping** | How ADOS lifecycle phases map to your tracker's statuses or labels |
| **Label Taxonomy** | Which labels the PM agent should use — at minimum `change` for all ADOS-managed items |
| **Backlog Source of Truth** | Explicit statement of where the backlog lives to prevent duplicate sources |

#### Recommended Extensions

| Extension | When to add | Example |
|-----------|------------|---------|
| **Issue Validation Checklist** | When tickets often start without enough context | "Check labels are set, status is not Blocked, epic context is read" |
| **Priority & Selection Rules** | When PM needs to auto-select the next issue | "In-progress takes precedence, then `priority:high`, then oldest" |
| **Quality Gate References** | When repo has specific scripts to run before PR/MR | "Run `scripts/quality-gates.sh` via `@runner`" |
| **Blocking Question Workflow** | When human approval gates exist | "Add comment with question, assign to human, set `blocked` label, STOP" |
| **Multi-Repo Coordination** | When changes span multiple repos | "Use `todo-<repo>`/`done-<repo>` labels; see inventory table" |
| **Definition of Ready (DoR)** | When tickets need pre-conditions before work starts | 5-9 point checklist: AC defined, dependencies identified, etc. |
| **Estimation Methodology** | When team uses story points or T-shirt sizing | "Fibonacci scale (1-89), split at 100+, triangulate against reference stories" |
| **PR/MR Workflow Customizations** | When merge process has repo-specific steps | "Squash-only merge, i18n completeness check before MR, human-only merge" |
| **Decision Documentation** | When product decisions need formal records | "Delegate to `@architect`; use PDRs in `doc/decisions/`" |

#### What NOT to include

- Do not repeat the standard ADOS change lifecycle — reference `doc/guides/change-lifecycle.md`
- Do not embed build/test commands — those belong in quality gate scripts or the project README
- Do not duplicate content across repos — if 5 repos share identical tracker config, extract it into a shared file
- Do not include volatile delivery schedules or backlogs — use separate planning docs
- Do not embed tool bug workarounds — document those in tool docs or fix them upstream

#### Example: GitHub Issues (Minimal)

```markdown
# PM Instructions

## Tracker Configuration

tracker: github
owner: <your-github-org-or-username>
repo: <your-repo-name>

## Workflow Mapping

| Phase | GitHub Label | Notes |
|-------|-------------|-------|
| Planning started | `in-progress` | Applied when PM begins work |
| Ready for review | `review` | Applied when PR is ready |
| Done | (close issue) | Issue closed after merge |

## Labels

- `change` — all changes managed by ADOS
- `bug`, `feature`, `docs` — issue type labels
- `priority:high`, `priority:medium`, `priority:low` — priority levels

## Backlog Source of Truth

GitHub Issues is the only backlog. Do not create or rely on local backlog files.

## Conventions

- workItemRef format: `GH-<number>` (e.g., `GH-123`)
- Branch naming: `<type>/GH-<number>/<slug>`
```

#### Example: Jira (with common extensions)

```markdown
# PM Instructions

## Tracker Configuration

tracker: jira
project_key: <YOUR-PROJECT-KEY>
base_url: https://<your-domain>.atlassian.net

## Workflow Mapping

| Phase | Jira Status | Transition ID | Notes |
|-------|-------------|---------------|-------|
| Planning started | In Progress | 21 | |
| Spec/Plan/Tests created | In Progress | — | No transition needed |
| Delivery started | In Progress | — | |
| Ready for review | In Review | 31 | |
| Done | Done | 41 | |
| Blocked | Blocked | 51 | Set when waiting on human input |

## Labels

- `change` — all changes managed by ADOS
- `todo-<repo-name>`, `done-<repo-name>` — per-repo tracking (for multi-repo setups)

## Backlog Source of Truth

Jira is the canonical backlog. Query: project = <KEY> AND labels = "change" AND status != Done ORDER BY priority DESC, created ASC

## Issue Validation Checklist

Before starting any issue:
1. Verify `change` label is applied
2. Check status is not `Blocked`
3. Read parent epic (if any) for wider context
4. Confirm acceptance criteria exist in description

## Conventions

- workItemRef format: `<PROJECT>-<number>` (e.g., `PDEV-123`)
- Branch naming: `<type>/<PROJECT>-<number>/<slug>`
```

#### Example: Local Markdown Backlog

```markdown
# PM Instructions

## Tracker Configuration

tracker: local
backlog_file: doc/planning/backlog.md

## Backlog File Format

| ID | Title | Status | Priority | Labels |
|----|-------|--------|----------|--------|
| STORY-1 | ... | todo | high | feature |

## Workflow Mapping

| Phase | Backlog Status |
|-------|---------------|
| Planning started | in-progress |
| Ready for review | review |
| Done | done |

## Labels

- feature, bug, docs, infra

## Conventions

- workItemRef format: `STORY-<number>` or `BUG-<number>`
- Branch naming: `<type>/STORY-<number>/<slug>`
```

> **Tip:** Start minimal. You can always add extensions later as your workflow matures. The leanest effective PM instructions file is ~30 lines; the richest is ~300 lines.

### 1.3 `doc/documentation-handbook.md`

The canonical documentation standard. Copy it **as-is** from the ADOS repository.

**Setup:**

1. Copy `doc/documentation-handbook.md` from ADOS into your project's `doc/` directory
2. Do NOT customize — keep it identical across repos (see §1 of the handbook)
3. This ensures all agents and humans follow the same documentation conventions

---

## Step 2: Recommended Artifacts (Optional)

These artifacts improve the ADOS experience but are not strictly required. Set them up incrementally as your project grows.

### 2.1 `doc/00-index.md` — Documentation Landing Page

A table of contents for your project's documentation. Helps humans and agents navigate.

**Setup:** Copy from ADOS and update links to match your project's actual docs.

### 2.2 `doc/overview/` — Project Overview

High-level project context:

- `01-north-star.md` — Vision, mission, and product direction
- `02-roadmap.md` — High-level phases and milestones
- `architecture-overview.md` — System architecture diagrams
- `glossary.md` — Terms and acronyms used in the project

### 2.3 `doc/spec/features/` — Feature Specifications

Current-truth descriptions of your system's features. Use `doc/templates/feature-spec-template.md` as the structural guide.

### 2.4 `doc/templates/` — Document Templates

Copy the templates directory from ADOS:

- `change-spec-template.md`
- `decision-record-template.md`
- `feature-spec-template.md`
- `test-spec-template.md`
- `test-plan-template.md`
- `implementation-plan-template.md`
- `north-star-template.md`

Agents read these at runtime to guide document structure.

### 2.5 `doc/decisions/` — Decision Records

Set up the decision records directory:

1. Create `doc/decisions/README.md` (copy from ADOS)
2. Create `doc/decisions/00-index.md` (empty index)
3. See [Decision Records Management Guide](decision-records-management.md) for the full standard

### 2.6 `doc/guides/` — Project-Specific Guides

Add guides as needed:

- Local development setup
- Debugging procedures
- Testing strategy
- Deployment workflows

---

## Step 3: Decision Records Setup

If your project makes architectural, product, or technical decisions, set up decision records:

1. Create `doc/decisions/` directory with `README.md` and `00-index.md`
2. Read the [Decision Records Management Guide](decision-records-management.md) for:
   - Decision types (ADR, PDR, TDR, BDR, ODR)
   - Naming convention (`<TYPE>-<zeroPad4>-<slug>.md`)
   - Lifecycle (Proposed → Under Review → Accepted)
   - Governance (who proposes, reviews, accepts)
3. Use `/plan-decision` + `/write-decision` to create your first decision record

---

## Step 4: First Change Walkthrough

Once your mandatory artifacts are in place, try running the full 10-phase workflow on a real change:

### Using Autopilot (Recommended)

```
@pm deliver change GH-1
```

The `@pm` agent will orchestrate all 10 phases:

1. **Clarify scope** — PM reads the ticket and cross-checks against system spec
2. **Specification** — `@spec-writer` creates the change spec
3. **Test planning** — `@test-plan-writer` creates the test plan
4. **Delivery planning** — `@plan-writer` creates the implementation plan
5. **Delivery** — `@coder` executes the plan phases
6. **System spec update** — `@doc-syncer` reconciles docs
7. **Review** — `@reviewer` audits against spec/plan
8. **Quality gates** — `@runner` runs builds/tests/lint
9. **DoD check** — PM verifies all criteria met
10. **PR creation** — `@pr-manager` creates the PR

### Using Manual Commands

```
/plan-change GH-1
/write-spec GH-1
/write-test-plan GH-1
/write-plan GH-1
/run-plan GH-1
/review GH-1
/sync-docs GH-1
/check
/pr
```

---

## Troubleshooting

### "Agent can't find my issue tracker"

Ensure `.ai/agent/pm-instructions.md` exists and has the correct tracker configuration. The `@pm` agent reads this file first.

### "Templates are not being used"

Verify `doc/templates/` exists and contains the template files. Agents fall back to embedded defaults if templates are absent — this is expected behavior, not an error.

### "Decision records workflow doesn't work"

Ensure `doc/decisions/` directory exists. The `@architect` agent writes decision records there. See [Decision Records Management Guide](decision-records-management.md).

### "Change artifacts are in the wrong location"

Check your `AGENTS.md` for the correct folder pattern: `doc/changes/YYYY-MM/YYYY-MM-DD--<workItemRef>--<slug>/`. The `@pm` agent creates this structure automatically.

### "Agents reference files that don't exist"

Run a fresh ADOS onboarding — some referenced directories (like `doc/overview/`, `doc/spec/`) need to be created. Create them with README.md stubs and populate incrementally.

---

## Related Guides

| Guide | Description |
|-------|-------------|
| [Change Lifecycle](change-lifecycle.md) | Detailed 10-phase delivery workflow |
| [Change Convention](unified-change-convention-tracker-agnostic-specification.md) | Naming, folders, branches |
| [Agents & Commands Guide](opencode-agents-and-commands-guide.md) | How to use agents and commands |
| [Tools Convention](tools-convention.md) | Standard for building CLI tools |
| [Documentation Handbook](../documentation-handbook.md) | Repository documentation standard |
| [Decision Records Management](decision-records-management.md) | Decision record types, lifecycle, governance |
