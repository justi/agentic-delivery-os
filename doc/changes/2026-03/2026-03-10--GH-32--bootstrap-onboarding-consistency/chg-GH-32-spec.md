---
change:
  ref: GH-32
  type: feat
  status: Proposed
  slug: bootstrap-onboarding-consistency
  title: "Bootstrap agent + onboarding guide + cross-document consistency fixes"
  owners: [juliusz-cwiakalski]
  service: delivery-os
  labels: [onboarding, documentation, consistency, developer-experience]
  version_impact: minor
  audience: mixed
  security_impact: none
  risk_level: medium
  dependencies:
    internal: [spec-writer, plan-writer, test-plan-writer, doc-syncer, architect, toolsmith]
    external: []
---

# CHANGE SPECIFICATION

> **PURPOSE**: Establish a frictionless ADOS adoption path for existing projects via a new `@bootstrapper` agent and `/bootstrap` command, fix cross-document inconsistencies throughout the repo, introduce a tracker-agnostic decision records standard, populate `doc/templates/` with agent-readable templates, and provide a human-facing onboarding guide. This change makes ADOS self-hosting-correct and externally adoptable.

## 1. SUMMARY

This change delivers five interconnected parts that together close the gap between ADOS as an internal system and ADOS as an adoptable framework:

1. **Cross-document consistency fixes** — remove ghost references, fix stale paths, create missing directories, and reconcile the Documentation Handbook with actual repo structure.
2. **Decision records management standard** — a new guide and template for tracker-agnostic decision records (ADR/PDR/TDR/BDR/ODR) at `doc/decisions/`.
3. **Document templates** — six templates in `doc/templates/` that agents read at runtime and humans use for manual authoring.
4. **Onboarding guide** — a step-by-step guide for adopting ADOS in an existing project.
5. **Bootstrap agent and command** — a stateful, multi-session `@bootstrapper` agent and thin `/bootstrap` command that automate project onboarding.

## 2. CONTEXT

### 2.1 Current State Snapshot

- ADOS has a mature 10-phase delivery process, 18 agents, and 15 commands — all tuned for internal use.
- The Documentation Handbook (`doc/documentation-handbook.md`) defines a standard tree that references directories and files that do not exist in this repo (`doc/overview/`, `doc/00-index.md`, `doc/templates/`, `doc/adr/`, `/.ai/context-maps/coding-agent-index.md`).
- The `@architect` agent and `/write-adr` command write ADRs to `doc/adr/` — a directory that does not exist and whose naming supports only one decision type (architectural).
- Agent prompts embed document structure inline rather than reading from templates, creating a drift risk between what agents produce and what the handbook prescribes.
- There is no onboarding path: teams adopting ADOS must reverse-engineer the required files, their order, and their content from multiple cross-referencing guides.

### 2.2 Pain Points / Gaps

- **Ghost references**: The Documentation Handbook §4.1, §6, and §8 reference `/.ai/context-maps/coding-agent-index.md`, which does not exist and has never existed.
- **Stale agent paths**: The Handbook §2, §4.1a, §10, and §15 FAQ reference `/.ai/agents/` — the correct path is `.opencode/agent/`.
- **Missing standard directories**: `doc/overview/`, `doc/00-index.md`, `doc/templates/`, `doc/planning/product-decisions/` are referenced but absent.
- **ADR location mismatch**: The Handbook references `doc/adr/`; the `@architect` agent writes to `doc/adr/`; neither directory exists. The naming convention only supports ADRs, not broader decision types.
- **No template files**: The Handbook §17 lists five templates in `doc/templates/` — none exist.
- **No adoption guide**: The only way to adopt ADOS is to study multiple docs and guess the minimum viable setup.
- **No automated bootstrap**: No agent or command helps scaffold ADOS artifacts for a new project.

## 3. PROBLEM STATEMENT

ADOS cannot be adopted by external teams because: (1) its own documentation contains cross-references to non-existent files and directories, undermining trust; (2) it lacks decision records infrastructure despite agents and docs referencing it; (3) templates referenced by the handbook do not exist; and (4) there is no guided onboarding path — neither a human guide nor an automated bootstrap. These gaps also prevent ADOS from being self-hosting-correct (i.e., matching its own conventions).

## 4. GOALS

- **G-1**: Frictionless ADOS adoption via `@bootstrapper` agent and `/bootstrap` command that automate project scaffolding.
- **G-2**: Cross-document consistency — all docs and agent prompts reference correct, existing paths with zero ghost references.
- **G-3**: Self-hosting integrity — the ADOS repo matches its own conventions (handbook tree, templates, decision records).
- **G-4**: Tracker-agnostic decision records standard supporting ADR, PDR, TDR, BDR, and ODR types at `doc/decisions/`.
- **G-5**: `doc/templates/` populated with best-of-breed templates that agents read at runtime and humans use for manual authoring.

### 4.1 Success Metrics / KPIs

| Metric | Target |
|--------|--------|
| Ghost references in doc/ and agent prompts | 0 |
| Missing directories referenced by handbook | 0 |
| Templates listed in handbook vs. existing in repo | 100% match |
| Decision records standard documented and tooling updated | Guide + template + agent/command updates |
| Onboarding guide covers minimum viable setup | All mandatory artifacts documented |
| Bootstrap agent generates valid ADOS scaffolding | Produces AGENTS.md + pm-instructions.md + at least one feature spec |

### 4.2 Non-Goals

- **NG-1**: Tribal knowledge extraction — moved to GH-33.
- **NG-2**: CI/CD pipeline for doc validation — out of scope for this change.
- **NG-3**: Multi-repo bootstrap (bootstrapping across multiple repositories simultaneously).
- **NG-4**: Automated testing of bootstrapper output quality (manual human review is the quality gate).

## 5. FUNCTIONAL CAPABILITIES

| ID | Capability | Rationale |
|----|------------|-----------|
| F-1 | Remove ghost references to non-existent `/.ai/context-maps/coding-agent-index.md` from Documentation Handbook | Eliminates misleading references that confuse agents and humans |
| F-2 | Fix references from `/.ai/agents/` to `.opencode/agent/` across all docs | Aligns docs with actual repo structure after the 2026-01 rename |
| F-3 | Create missing directory stubs with README placeholders for `doc/overview/`, `doc/templates/`, `doc/decisions/` | Makes handbook's standard tree match reality |
| F-4 | Create `doc/00-index.md` as the documentation landing page | Fulfills handbook §4.2 requirement; provides human + agent entry point |
| F-5 | Migrate all `doc/adr/` references to `doc/decisions/` across docs and agent prompts | Unifies decision record location for all decision types |
| F-6 | Reconcile Documentation Handbook §3 standard tree with actual repo structure | Ensures the handbook is trustworthy as the canonical docs standard |
| F-7 | Create `doc/guides/decision-records-management.md` defining the decision records standard | Establishes lifecycle, naming, types, and governance for all decision records |
| F-8 | Create `doc/templates/decision-record-template.md` | Provides a reusable template for all decision record types (ADR/PDR/TDR/BDR/ODR) |
| F-9 | Update `@architect` agent and `/write-adr` + `/plan-decision` commands to use `doc/decisions/` | Aligns tooling with the new decision records standard |
| F-10 | Create six document templates in `doc/templates/` | Fulfills handbook §17 and provides runtime-readable templates for agents |
| F-11 | Update `@spec-writer`, `@plan-writer`, `@test-plan-writer`, `@doc-syncer` to read templates at runtime with fallback to embedded defaults | Ensures template-agent alignment with graceful degradation |
| F-12 | Create `doc/guides/onboarding-existing-project.md` | Guides teams through ADOS adoption with minimum viable doc inventory |
| F-13 | Create `@bootstrapper` agent with stateful, multi-session workflow | Automates ADOS adoption via repo scan → confidence assessment → human interview → draft → review → write |
| F-14 | Create `/bootstrap` command as thin entry point to `@bootstrapper` | Provides the CLI interface for the bootstrap workflow |
| F-15 | Define persistent state schema at `.ai/local/bootstrapper-context.yaml` | Enables multi-session bootstrap workflow with accumulated context |
| F-16 | Update `.opencode/README.md` with new agent and command entries | Maintains the tooling inventory as required by repo conventions |

### 5.1 Capability Details

**F-1 — Ghost reference removal (Documentation Handbook)**
The Handbook §4.1 excerpt, §6 lifecycle, and §8 agent usage all reference `/.ai/context-maps/coding-agent-index.md`. This file has never existed. References must be removed or replaced with correct alternatives (e.g., direct links to `.opencode/agent/` or `AGENTS.md`).

**F-2 — Agent path correction**
The Handbook §2, §4.1a, §10, and §15 FAQ reference `/.ai/agents/` for agent system prompts. The correct path since the 2026-01 refactor is `.opencode/agent/`. All references must be updated.

**F-3 — Missing directory stubs**
Create directories with minimal README.md placeholders explaining purpose:
- `doc/overview/` — high-level project context (north star, roadmap, architecture, glossary)
- `doc/templates/` — authoring templates for all document types
- `doc/decisions/` — decision records (replacing the never-created `doc/adr/`)

**F-5 — ADR-to-decisions migration**
All references to `doc/adr/` (Handbook, agent prompts, commands) must be updated to `doc/decisions/`. The naming convention changes from `ADR-####-short-title.md` to `<decision-id>-<type>-<slug>.md` to support multiple decision types.

**F-7 — Decision records management standard**
The guide must define:
- **Decision types**: ADR (Architecture), PDR (Product), TDR (Technical), BDR (Business), ODR (Operational)
- **Location**: `doc/decisions/` (flat directory, all types co-located)
- **Naming**: `<decision-id>-<type>-<slug>.md` (e.g., `DEC-0001-ADR-event-bus-selection.md`)
- **Lifecycle**: Proposed → Under Review → Accepted → (Deprecated | Superseded)
- **Required sections**: Context, Drivers, Options, Decision, Consequences, Status
- **Governance**: who can propose, review, accept, and supersede decisions

**F-10 — Document templates**
Six templates covering the core ADOS document types:
1. `change-spec-template.md` — change specification
2. `decision-record-template.md` — decision record (all types)
3. `feature-spec-template.md` — feature specification for `doc/spec/features/`
4. `test-spec-template.md` — test specification for `doc/quality/test-specs/`
5. `test-plan-template.md` — per-change test plan
6. `implementation-plan-template.md` — per-change implementation plan

Each template includes: front-matter skeleton, all required sections, inline guidance (as HTML comments), and placeholder content showing expected level of detail.

**F-11 — Agent template reading with fallback**
Agents that produce documents (`@spec-writer`, `@plan-writer`, `@test-plan-writer`, `@doc-syncer`) must:
1. Attempt to read the corresponding template from `doc/templates/`
2. If the template exists, use it as the structural guide (sections, front-matter)
3. If the template does not exist, fall back to the agent's embedded default structure
4. Agent prompts define quality rules and domain-specific logic; templates define only structure

**F-13 — Bootstrapper agent workflow**
The `@bootstrapper` agent follows a multi-session, stateful workflow:
1. **Repo scan**: analyze existing project structure, tech stack, existing docs
2. **Confidence assessment**: determine what can be inferred vs. what needs human input
3. **Human interview**: ask targeted questions to fill gaps (iterative, progressive refinement)
4. **Draft generation**: produce draft artifacts based on accumulated context
5. **Human review**: present drafts for approval/correction
6. **Write**: generate final artifacts upon approval

Generated artifacts include: `AGENTS.md`, `.ai/agent/pm-instructions.md`, initial feature specs, documentation handbook customization, templates, and overview docs.

**F-15 — Bootstrapper persistent state**
The `.ai/local/bootstrapper-context.yaml` schema stores:
- Project metadata (name, tech stack, team structure)
- Interview history (questions asked, answers received)
- Confidence scores per artifact
- Generated artifact status (draft/approved/written)
- Session timestamps

This file lives in `.ai/local/` (git-ignored) as ephemeral state per repo conventions.

## 6. USER & SYSTEM FLOWS

```
Flow 1: Cross-document consistency (Part 1)
  Human/PM identifies ghost references
  → @coder updates Documentation Handbook (remove ghosts, fix paths)
  → @coder creates missing directory stubs
  → @coder updates agent prompts (doc/adr/ → doc/decisions/)
  → @reviewer validates zero ghost references remain

Flow 2: Decision records (Part 2)
  @coder creates doc/guides/decision-records-management.md
  → @coder creates doc/templates/decision-record-template.md
  → @coder updates @architect agent (doc/adr/ → doc/decisions/, new naming)
  → @coder updates /write-adr and /plan-decision commands
  → @reviewer validates consistency

Flow 3: Templates (Part 3)
  @coder creates 6 templates in doc/templates/
  → @coder updates @spec-writer, @plan-writer, @test-plan-writer, @doc-syncer
    to read templates at runtime with fallback
  → @reviewer validates agent-template alignment

Flow 4: Onboarding (Part 4)
  @coder creates doc/guides/onboarding-existing-project.md
  → @reviewer validates completeness (mandatory vs optional artifacts)

Flow 5: Bootstrap (Part 5)
  @toolsmith creates @bootstrapper agent
  → @toolsmith creates /bootstrap command
  → @coder updates .opencode/README.md
  → @reviewer validates agent workflow and state schema

Flow 6: New project adopts ADOS
  User runs /bootstrap in their project
  → @bootstrapper scans repo structure
  → @bootstrapper assesses confidence per artifact
  → @bootstrapper interviews human (iterative)
  → @bootstrapper drafts artifacts
  → Human reviews and approves
  → @bootstrapper writes final artifacts
  → User has working ADOS setup
```

## 7. SCOPE & BOUNDARIES

### 7.1 In Scope

- Documentation Handbook ghost reference removal and path corrections
- Creation of missing directory stubs (`doc/overview/`, `doc/templates/`, `doc/decisions/`)
- Creation of `doc/00-index.md`
- Migration of all `doc/adr/` references to `doc/decisions/`
- Decision records management guide and template
- Six document templates in `doc/templates/`
- Agent prompt updates for template reading and `doc/decisions/` path
- Onboarding guide for existing projects
- `@bootstrapper` agent and `/bootstrap` command
- `.opencode/README.md` inventory update

### 7.2 Out of Scope

- [OUT] Tribal knowledge extraction (GH-33)
- [OUT] CI pipeline for documentation validation
- [OUT] Multi-repo bootstrap orchestration
- [OUT] Automated quality scoring of bootstrapper output
- [OUT] Migration of existing ADR files (none exist in this repo)
- [OUT] Copywriting guide (`doc/guides/copywriting.md`) — placeholder only if needed

### 7.3 Deferred / Maybe-Later

- Bootstrapper self-test suite (automated validation of generated artifacts)
- Template versioning and cross-repo sync mechanism
- Interactive bootstrapper web UI
- `doc/guides/copywriting.md` full content (placeholder stub is in-scope if referenced)

## 8. INTERFACES & INTEGRATION CONTRACTS

### 8.1 REST / HTTP Endpoints

N/A — no application code; documentation and agent prompt changes only.

### 8.2 Events / Messages

N/A

### 8.3 Data Model Impact

| ID | Element | Description |
|----|---------|-------------|
| DM-1 | `.ai/local/bootstrapper-context.yaml` | New YAML schema for bootstrapper persistent state (git-ignored, ephemeral) |

### 8.4 External Integrations

N/A — no external API dependencies.

### 8.5 Backward Compatibility

- **Agent prompts**: `@spec-writer`, `@plan-writer`, `@test-plan-writer`, `@doc-syncer` gain template-reading capability with fallback to current embedded defaults — no breaking change.
- **`@architect`**: Output path changes from `doc/adr/` to `doc/decisions/`. Since `doc/adr/` never existed and contains no files, this is a non-breaking path correction.
- **Documentation Handbook**: Structural corrections and additions; no existing valid workflow is broken.

## 9. NON-FUNCTIONAL REQUIREMENTS (NFRs)

| ID | Requirement | Threshold |
|----|-------------|-----------|
| NFR-1 | Cross-document consistency | Zero ghost references to non-existent files or directories across all docs and agent prompts |
| NFR-2 | Template completeness | All 6 templates render as valid GitHub-flavored Markdown and contain all required sections |
| NFR-3 | Onboarding guide completeness | Guide covers 100% of mandatory ADOS artifacts with setup instructions |
| NFR-4 | Bootstrapper state resilience | Bootstrapper can resume from `.ai/local/bootstrapper-context.yaml` after session interruption with zero data loss |
| NFR-5 | Agent fallback reliability | Agents function identically when `doc/templates/` directory is absent (fallback to embedded defaults) |
| NFR-6 | Decision records guide completeness | Guide defines all 5 decision types with lifecycle, naming, and governance |
| NFR-7 | Documentation Handbook alignment | §3 standard tree matches actual repo directory structure post-change |

## 10. TELEMETRY & OBSERVABILITY REQUIREMENTS

N/A — documentation and agent prompt changes only; no runtime telemetry applicable.

## 11. RISKS & MITIGATIONS

| ID | Risk | Impact | Probability | Mitigation | Residual Risk |
|----|------|--------|-------------|------------|---------------|
| RSK-1 | Large scope (5 parts) leads to incomplete delivery or inconsistent quality across parts | H | M | Deliver in phased order (Parts 1-2-3-4-5); each part is independently valuable and reviewable. Gate each part before proceeding. | Low — phased delivery limits blast radius |
| RSK-2 | Template-prompt drift: templates and agent prompts diverge over time | M | M | Agents read templates at runtime (single source); prompts define quality rules only. Fallback-to-defaults pattern catches missing templates. | Low — runtime reading prevents static drift |
| RSK-3 | Bootstrapper generates inaccurate artifacts for complex projects | H | M | Mandatory human review checkpoint before write phase. Progressive refinement via interview loops. Confidence scores per artifact guide human attention. | Medium — human review is the ultimate quality gate but requires effort |
| RSK-4 | Cross-document consistency fixes introduce new broken references | M | L | Run systematic link validation after each consistency fix. Reviewer validates zero ghost references as acceptance criterion. | Low — validation is straightforward |
| RSK-5 | Decision records standard adds process overhead that teams resist | M | L | Standard is lightweight by design (single template, flat directory, familiar lifecycle). Types are optional — teams can start with ADR only. | Low — incremental adoption path |
| RSK-6 | Agent prompt changes (4 agents + 3 commands) introduce regressions | H | L | Test each modified agent through the delivery process on a real change. Review diffs for unintended behavior changes. | Low — prompts are version-controlled and reviewed |

## 12. ASSUMPTIONS

- The Documentation Handbook is the canonical standard for repository documentation structure; fixing it fixes the standard for all adopters.
- `doc/adr/` has never contained any files in this repo, so migration to `doc/decisions/` is a path correction, not a data migration.
- Agents can read files from `doc/templates/` at runtime using their existing file-reading capabilities (no new MCP tools needed).
- The `@toolsmith` agent is the appropriate creator for `@bootstrapper` and `/bootstrap` (per AGENTS.md extension guidance).
- Menuvivo MVDR system and FlagshipX templates provide sufficient source material for decision records standard and document templates.
- `.ai/local/` is git-ignored across all ADOS-adopting repos (established convention).

## 13. DEPENDENCIES

| Direction | Item | Notes |
|-----------|------|-------|
| Depends on | GH-27 (AGENTS.md) | Delivered. AGENTS.md exists and provides the bootstrap file that `@bootstrapper` references. |
| Blocked by | None | No blocking dependencies. |
| Blocks | GH-33 (tribal knowledge extraction) | GH-33 depends on the onboarding and bootstrap infrastructure delivered here. |
| Internal | `@spec-writer`, `@plan-writer`, `@test-plan-writer`, `@doc-syncer` | Agent prompts modified to add template-reading capability. |
| Internal | `@architect`, `/write-adr`, `/plan-decision` | Agent and commands modified to use `doc/decisions/` path. |
| Internal | `@toolsmith` | Creates `@bootstrapper` agent and `/bootstrap` command. |

## 14. OPEN QUESTIONS

| ID | Question | Context | Status |
|----|----------|---------|--------|
| OQ-1 | Should the bootstrapper generate `doc/documentation-handbook.md` as-is or a project-customized version? | The handbook says "keep this file identical across repos" (§1), but projects may need local adjustments. | Decision needed: consult `@architect` |
| OQ-2 | Should `doc/guides/copywriting.md` be created as a stub or omitted entirely? | Referenced in the cross-doc audit but may not be needed for ADOS itself. | Pending — create stub only if handbook references it |
| OQ-3 | What is the numbering scheme for decision IDs in `doc/decisions/`? | Zero-padded 4-digit (`DEC-0001`) vs. sequential without padding. Need to align with ADR convention (`ADR-####`). | Decision needed: consult `@architect` |

## 15. DECISION LOG

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| DEC-1 | Five-part scope: consistency fixes → decision records → templates → onboarding → bootstrap | Each part builds on the previous; consistency fixes must come first to establish a trustworthy base. | 2026-03-10 |
| DEC-2 | `@bootstrapper` agent + `/bootstrap` command (not command-only) | Multi-session stateful workflow requires persistent context that a thin command cannot maintain. Agent holds the workflow logic; command is the entry point. | 2026-03-10 |
| DEC-3 | Templates in `doc/templates/` (Option C: both agent + template) | Templates define structure (customizable per project); agent prompts define quality rules. Agents read templates at runtime, fallback to embedded defaults if templates are absent. | 2026-03-10 |
| DEC-4 | Decision records at `doc/decisions/` (not `doc/adr/`) | Tracker-agnostic; supports multiple decision types (ADR/PDR/TDR/BDR/ODR). Synthesized from Menuvivo MVDR system. | 2026-03-10 |
| DEC-5 | Tribal knowledge extraction moved to GH-33 | Scope management: GH-32 is already large (5 parts). Tribal knowledge is independently valuable and can depend on GH-32's bootstrap infrastructure. | 2026-03-10 |

## 16. AFFECTED COMPONENTS (HIGH-LEVEL)

| Component | Impact |
|-----------|--------|
| `doc/documentation-handbook.md` | Updated — ghost references removed, paths fixed, standard tree reconciled |
| `doc/00-index.md` | New — documentation landing page |
| `doc/overview/` | New — directory stub with README placeholder |
| `doc/decisions/` | New — directory for decision records (replaces never-created `doc/adr/`) |
| `doc/templates/` | New — six document templates |
| `doc/guides/decision-records-management.md` | New — decision records standard |
| `doc/guides/onboarding-existing-project.md` | New — ADOS adoption guide |
| `.opencode/agent/architect.md` | Updated — `doc/adr/` → `doc/decisions/`, new naming convention |
| `.opencode/agent/spec-writer.md` | Updated — template reading with fallback |
| `.opencode/agent/plan-writer.md` | Updated — template reading with fallback |
| `.opencode/agent/test-plan-writer.md` | Updated — template reading with fallback |
| `.opencode/agent/doc-syncer.md` | Updated — template reading with fallback |
| `.opencode/agent/bootstrapper.md` | New — bootstrapper agent |
| `.opencode/command/write-adr.md` | Updated — `doc/adr/` → `doc/decisions/` |
| `.opencode/command/plan-decision.md` | Updated — `doc/adr/` → `doc/decisions/` |
| `.opencode/command/bootstrap.md` | New — bootstrap command |
| `.opencode/README.md` | Updated — new agent and command entries |
| `AGENTS.md` | Updated — new agent and command in inventory |

## 17. ACCEPTANCE CRITERIA

### Part 1: Cross-document consistency

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F1-1 | **Given** the Documentation Handbook, **when** searching for `context-maps` or `coding-agent-index`, **then** zero matches are found. | F-1 |
| AC-F2-1 | **Given** all files under `doc/` and `.opencode/`, **when** searching for `/.ai/agents/`, **then** zero matches are found (all updated to `.opencode/agent/`). | F-2 |
| AC-F3-1 | **Given** the directories `doc/overview/`, `doc/templates/`, and `doc/decisions/`, **then** each exists and contains a README.md explaining its purpose. | F-3 |
| AC-F4-1 | **Given** `doc/00-index.md`, **then** it exists, contains links to overview, spec, changes, guides, and templates, and serves as the documentation landing page. | F-4 |
| AC-F5-1 | **Given** all files under `doc/` and `.opencode/`, **when** searching for `doc/adr/`, **then** zero matches are found (all updated to `doc/decisions/`). | F-5 |
| AC-F6-1 | **Given** Documentation Handbook §3 standard tree, **when** compared to the actual repo structure post-change, **then** every referenced directory either exists or has been removed from the tree. | F-6 |

### Part 2: Decision records

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F7-1 | **Given** `doc/guides/decision-records-management.md`, **then** it defines all 5 decision types (ADR, PDR, TDR, BDR, ODR) with naming, lifecycle (Proposed → Under Review → Accepted → Deprecated/Superseded), and governance. | F-7 |
| AC-F8-1 | **Given** `doc/templates/decision-record-template.md`, **then** it contains front-matter skeleton, all required sections (Context, Drivers, Options, Decision, Consequences, Status), and inline authoring guidance. | F-8 |
| AC-F9-1 | **Given** the `@architect` agent prompt, **when** it writes a decision record, **then** it targets `doc/decisions/` (not `doc/adr/`). | F-9 |
| AC-F9-2 | **Given** the `/write-adr` and `/plan-decision` commands, **when** they reference the output path, **then** they use `doc/decisions/` (not `doc/adr/`). | F-9 |

### Part 3: Document templates

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F10-1 | **Given** `doc/templates/`, **then** it contains exactly 6 templates: `change-spec-template.md`, `decision-record-template.md`, `feature-spec-template.md`, `test-spec-template.md`, `test-plan-template.md`, `implementation-plan-template.md`. | F-10 |
| AC-F10-2 | **Given** any template file, **when** rendered as GitHub-flavored Markdown, **then** it is valid and contains all required sections with inline guidance as HTML comments. | F-10 |
| AC-F11-1 | **Given** `@spec-writer`, **when** `doc/templates/change-spec-template.md` exists, **then** the agent reads it to guide document structure. | F-11 |
| AC-F11-2 | **Given** `@spec-writer`, **when** `doc/templates/change-spec-template.md` does NOT exist, **then** the agent falls back to its embedded default structure with no errors. | F-11 |
| AC-F11-3 | **Given** `@plan-writer`, `@test-plan-writer`, and `@doc-syncer`, **then** each reads its corresponding template at runtime with fallback to embedded defaults. | F-11 |

### Part 4: Onboarding guide

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F12-1 | **Given** `doc/guides/onboarding-existing-project.md`, **then** it lists all mandatory ADOS artifacts (AGENTS.md, pm-instructions.md, documentation-handbook.md) and all optional artifacts with clear labels. | F-12 |
| AC-F12-2 | **Given** the onboarding guide, **then** it includes a configuration walkthrough for `.ai/agent/pm-instructions.md` covering both GitHub and Jira tracker setups. | F-12 |
| AC-F12-3 | **Given** the onboarding guide, **then** it includes decision records setup instructions and links to the decision records management guide. | F-12 |
| AC-F12-4 | **Given** the onboarding guide, **then** it links to all relevant ADOS guides (change lifecycle, change convention, agents-and-commands guide, tools convention, documentation handbook). | F-12 |

### Part 5: Bootstrap agent and command

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F13-1 | **Given** `.opencode/agent/bootstrapper.md`, **then** it defines a multi-session workflow with phases: repo scan → confidence assessment → human interview → draft → review → write. | F-13 |
| AC-F13-2 | **Given** the `@bootstrapper` agent, **when** invoked on a project with no ADOS artifacts, **then** it scans the repo structure and asks targeted questions before generating any files. | F-13 |
| AC-F13-3 | **Given** the `@bootstrapper` agent, **then** it generates at minimum: `AGENTS.md`, `.ai/agent/pm-instructions.md`, and at least one feature spec. | F-13 |
| AC-F14-1 | **Given** `.opencode/command/bootstrap.md`, **then** it delegates to `@bootstrapper` and accepts an optional project-name argument. | F-14 |
| AC-F15-1 | **Given** `.ai/local/bootstrapper-context.yaml`, **then** its schema includes: project metadata, interview history, confidence scores, artifact status, and session timestamps. | F-15, DM-1 |
| AC-F16-1 | **Given** `.opencode/README.md`, **then** it lists `bootstrapper` in the Agents section and `/bootstrap` in the Commands section. | F-16 |
| AC-F16-2 | **Given** `AGENTS.md`, **then** it lists `bootstrapper` in the agent team and `/bootstrap` in the commands table. | F-16 |

## 18. ROLLOUT & CHANGE MANAGEMENT (HIGH-LEVEL)

- **Delivery order**: Part 1 (consistency) → Part 2 (decision records) → Part 3 (templates) → Part 4 (onboarding) → Part 5 (bootstrap). Each part is independently valuable.
- **Merge strategy**: Single PR containing all 5 parts. Phased commits within the PR for reviewability.
- **Communication**: Update repo README.md to mention onboarding guide and bootstrap command after merge.
- **Adoption**: ADOS itself is the first adopter (self-hosting validation). External adoption tracked via GH-33 and subsequent issues.

## 19. DATA MIGRATION / SEEDING (IF APPLICABLE)

- No data migration required. `doc/adr/` contains no files; the path change to `doc/decisions/` is a reference update only.
- Templates are seeded from best-of-breed source material (FlagshipX, Menuvivo) adapted to ADOS conventions.

## 20. PRIVACY / COMPLIANCE REVIEW

N/A — no PII, user data, or sensitive information involved. All deliverables are documentation and agent prompts.

## 21. SECURITY REVIEW HIGHLIGHTS

- **Bootstrapper state file** (`.ai/local/bootstrapper-context.yaml`) is git-ignored and must NOT contain secrets, tokens, or credentials. Agent prompt must explicitly prohibit this.
- No new external integrations or API keys introduced.

## 22. MAINTENANCE & OPERATIONS IMPACT

- **Template maintenance**: When agent prompt structure changes, corresponding templates should be updated. The fallback-to-defaults pattern provides a safety net during transition periods.
- **Decision records guide**: Lightweight; no ongoing operational burden. Updates only when new decision types are needed.
- **Bootstrapper agent**: May need tuning as ADOS conventions evolve. The onboarding guide serves as a static fallback if the agent is not available.
- **Documentation Handbook**: After consistency fixes, the handbook becomes the trustworthy single source of truth for doc structure. Future changes must maintain this alignment.

## 23. GLOSSARY

| Term | Definition |
|------|------------|
| ADOS | Agentic Delivery OS — the spec-driven software delivery system comprising agents, commands, and conventions |
| ADR | Architecture Decision Record — documents a significant architectural decision |
| PDR | Product Decision Record — documents a product strategy or feature scoping decision |
| TDR | Technical Decision Record — documents a technology choice or implementation approach |
| BDR | Business Decision Record — documents a business rule or process decision |
| ODR | Operational Decision Record — documents an infrastructure, deployment, or operations decision |
| Ghost reference | A documentation cross-reference pointing to a file or directory that does not exist |
| Self-hosting integrity | The property of ADOS matching its own documented conventions |
| Bootstrap | The process of scaffolding ADOS artifacts in a project that does not yet use ADOS |
| Fallback-to-defaults | Pattern where an agent attempts to read a template file and reverts to its embedded structure if the file is absent |

## 24. APPENDICES

### A. Cross-document audit findings (summary)

| Finding | Location | Fix |
|---------|----------|-----|
| Ghost ref: `/.ai/context-maps/coding-agent-index.md` | Handbook §4.1, §6, §8 | Remove or replace with correct path |
| Stale ref: `/.ai/agents/` | Handbook §2, §4.1a, §10, §15 FAQ | Replace with `.opencode/agent/` |
| Missing: `doc/overview/` | Handbook §3 | Create with README stub |
| Missing: `doc/00-index.md` | Handbook §3, §4.2 | Create as landing page |
| Missing: `doc/templates/` | Handbook §3, §17 | Create with 6 templates |
| Stale: `doc/adr/` references | Handbook §3, §4.2, §6; `@architect`; `/write-adr` | Replace with `doc/decisions/` |
| Missing: `doc/planning/product-decisions/` | Referenced in some contexts | Create stub or remove reference |

### B. Decision record types

| Type | Prefix | Scope | Example |
|------|--------|-------|---------|
| ADR | ADR | Architecture, system design, infrastructure patterns | Event bus selection, API versioning strategy |
| PDR | PDR | Product, feature scoping, UX strategy | Feature prioritization framework, MVP scope |
| TDR | TDR | Technology, libraries, implementation approach | State management library, testing framework |
| BDR | BDR | Business rules, pricing, compliance processes | Subscription tier structure, data retention policy |
| ODR | ODR | Operations, deployment, monitoring, incident response | Deployment pipeline design, alerting thresholds |

### C. Bootstrapper artifact generation scope

| Artifact | Mandatory | Generated by @bootstrapper |
|----------|-----------|---------------------------|
| `AGENTS.md` | Yes | Yes — project-specific version |
| `.ai/agent/pm-instructions.md` | Yes | Yes — with tracker configuration |
| `doc/documentation-handbook.md` | Yes | Yes or copy — see OQ-1 |
| Feature specs (`doc/spec/features/`) | Recommended | Yes — at least one from interview |
| `doc/overview/` docs | Optional | Yes — north star, architecture overview |
| `doc/templates/` | Optional | Copy from ADOS source |

## 25. DOCUMENT HISTORY

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-10 | spec-writer | Initial specification — 5-part scope from planning session |

---

## AUTHORING GUIDELINES

- Used only planning context from the change planning summary and PM notes
- Organized functional capabilities by the 5-part structure matching the ticket
- All deep-topic details link to existing docs or are captured as open questions
- Acceptance criteria use Given/When/Then format and reference functional capabilities
- NFRs include measurable thresholds (zero ghost refs, 100% coverage, etc.)
- Risks include Impact & Probability ratings with mitigations

## VALIDATION CHECKLIST

- [x] `change.ref` matches provided `workItemRef` (GH-32)
- [x] `owners` has at least one entry
- [x] `status` is "Proposed"
- [x] All sections present in spec_structure order (1–25 + guidelines + checklist)
- [x] ID prefixes consistent and unique within category (F-, AC-, NFR-, RSK-, DEC-, DM-, OQ-)
- [x] Acceptance criteria reference at least one F-/NFR- ID and use Given/When/Then
- [x] NFRs include measurable values
- [x] Risks include Impact & Probability
- [x] No implementation details (no file-level code paths, no step-by-step tasks)
- [x] No content duplicated from linked docs
- [x] Front matter validates per front_matter_rules
