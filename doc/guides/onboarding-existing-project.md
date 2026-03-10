# Onboarding an Existing Project to ADOS

> **Audience:** Engineers and tech leads adopting Agentic Delivery OS (ADOS) in an existing project.
>
> **Goal:** Step-by-step guide to set up the minimum viable ADOS configuration, with clear distinction between mandatory and optional artifacts.

---

## Prerequisites

Before starting, ensure you have:

- A **git repository** for your project
- An **AI coding agent** that supports ADOS (e.g., Claude Code with OpenCode, Cursor, Windsurf)
- Basic familiarity with ADOS concepts (see [Agents & Commands Guide](opencode-agents-and-commands-guide.md))
- Access to your team's issue tracker (GitHub Issues or Jira)

---

## Step 1: Mandatory Artifacts

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

**Setup for GitHub Issues:**

```yaml
# .ai/agent/pm-instructions.md

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

## Conventions

- workItemRef format: `GH-<number>` (e.g., `GH-123`)
- Branch naming: `<type>/GH-<number>/<slug>`
```

**Setup for Jira:**

```yaml
# .ai/agent/pm-instructions.md

## Tracker Configuration

tracker: jira
project_key: <YOUR-PROJECT-KEY>
base_url: https://<your-domain>.atlassian.net

## Workflow Mapping

| Phase | Jira Status | Transition ID | Notes |
|-------|-------------|---------------|-------|
| Planning started | In Progress | 21 | |
| Ready for review | In Review | 31 | |
| Done | Done | 41 | |

## Labels

- `change` — all changes managed by ADOS

## Conventions

- workItemRef format: `<PROJECT>-<number>` (e.g., `PDEV-123`)
- Branch naming: `<type>/<PROJECT>-<number>/<slug>`
```

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
3. Use `/plan-decision` + `/write-adr` to create your first decision record

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

## Step 5: Automated Bootstrap (Alternative)

For an automated approach, use the `@bootstrapper` agent:

```
/bootstrap
```

The `@bootstrapper` will:

1. Scan your repo structure and tech stack
2. Assess what it can infer vs. what needs human input
3. Ask targeted questions about your project
4. Generate draft artifacts for your review
5. Write final artifacts upon approval

See the `@bootstrapper` agent documentation for details.

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
