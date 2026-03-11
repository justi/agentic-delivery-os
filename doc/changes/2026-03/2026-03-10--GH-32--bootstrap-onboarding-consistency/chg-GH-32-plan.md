---
id: chg-GH-32-bootstrap-onboarding-consistency
status: Delivered
created: 2026-03-10T00:00:00Z
last_updated: 2026-03-10T00:00:00Z
owners: [juliusz-cwiakalski]
service: delivery-os
labels: [onboarding, documentation, consistency, developer-experience]
links:
  change_spec: ./chg-GH-32-spec.md
summary: >
  Establish a frictionless ADOS adoption path via a new @bootstrapper agent and /bootstrap command,
  fix cross-document inconsistencies, introduce a tracker-agnostic decision records standard,
  populate doc/templates/ with agent-readable templates, and provide a human-facing onboarding guide.
version_impact: minor
---

# IMPLEMENTATION PLAN — GH-32: Bootstrap agent + onboarding guide + cross-document consistency fixes

## Context and Goals

This change delivers five interconnected parts that make ADOS self-hosting-correct and externally adoptable:

1. **Cross-document consistency fixes** — eliminate ghost references, fix stale paths, create missing directories, and reconcile the Documentation Handbook with actual repo structure.
2. **Decision records management standard** — a new guide and template for tracker-agnostic decision records (ADR/PDR/TDR/BDR/ODR) at `doc/decisions/`.
3. **Document templates** — six templates in `doc/templates/` that agents read at runtime and humans use for manual authoring.
4. **Onboarding guide** — a step-by-step guide for adopting ADOS in an existing project.
5. **Bootstrap agent and command** — a stateful, multi-session `@bootstrapper` agent and thin `/bootstrap` command that automate project onboarding.

Each part builds on the previous: consistency fixes establish a trustworthy base, decision records and templates fill referenced-but-missing infrastructure, the onboarding guide documents the adoption path, and the bootstrapper automates it.

**Resolved open questions from spec:**

- **OQ-1**: Bootstrapper copies the Documentation Handbook as-is (no project-customized version).
- **OQ-2**: Create `doc/guides/copywriting.md` as a minimal stub.
- **OQ-3**: Decision IDs use type prefix + zero-padded 4-digit number (e.g., `ADR-0001`, `PDR-0001`).

**Nature of this change:** All deliverables are Markdown docs, agent prompts (`.opencode/agent/*.md`, `.opencode/command/*.md`), and directory scaffolding. There is NO application code.

## Scope

### In Scope

- Documentation Handbook ghost reference removal and path corrections (F-1, F-2, F-5, F-6)
- Creation of missing directory stubs with README placeholders: `doc/overview/`, `doc/templates/`, `doc/decisions/` (F-3)
- Creation of `doc/00-index.md` as documentation landing page (F-4)
- Migration of all `doc/adr/` references to `doc/decisions/` across docs and agent prompts (F-5, F-9)
- Decision records management guide and template (F-7, F-8)
- Six document templates in `doc/templates/` (F-10)
- Agent prompt updates for template reading with fallback (F-11)
- Onboarding guide for existing projects (F-12)
- `@bootstrapper` agent and `/bootstrap` command (F-13, F-14, F-15) — delegated to `@toolsmith`
- `.opencode/README.md` and `AGENTS.md` inventory updates (F-16)

### Out of Scope

- Tribal knowledge extraction (GH-33)
- CI pipeline for documentation validation
- Multi-repo bootstrap orchestration
- Automated quality scoring of bootstrapper output
- Migration of existing ADR files (none exist)

### Constraints

- All deliverables are documentation and agent prompts — no application code
- Agent prompts that are modified must preserve existing behavior (template reading is additive with fallback to embedded defaults)
- `@bootstrapper` and `/bootstrap` creation must be delegated to `@toolsmith` per AGENTS.md extension guidance
- License headers must be applied to all new files via `scripts/add-header-location.sh`

### Risks

- **RSK-1 (Large scope)**: 5 parts with 16 functional capabilities. Mitigated by phased delivery where each part is independently valuable.
- **RSK-4 (New broken references)**: Cross-document edits could introduce new ghost refs. Mitigated by systematic grep validation after each consistency fix.
- **RSK-6 (Agent prompt regressions)**: 4 agents + 3 commands modified. Mitigated by minimal diffs and review of each change.

### Success Metrics

- Zero ghost references to non-existent files/directories across all docs and agent prompts
- Zero references to `doc/adr/`, `/.ai/agents/`, `/.ai/context-maps/`, or `coding-agent-index` in docs/prompts (outside the spec itself)
- All 6 templates exist in `doc/templates/` and render as valid GFM
- Handbook §3 standard tree matches actual repo structure post-change
- `@bootstrapper` agent and `/bootstrap` command exist and are inventoried

## Phases

### Phase 1: Cross-document consistency fixes

**Goal**: Eliminate all ghost references, fix stale paths, create missing directories, and reconcile the Documentation Handbook with actual repo structure.

**Tasks**:

- [x] **1.1** Remove all references to `/.ai/context-maps/coding-agent-index.md` from `doc/documentation-handbook.md` (§4.1 excerpt at line ~141, §4.2 "For AI agents" link at line ~164, §6 agent note at line ~286, §8 agent usage at line ~306, §10 multi-repo table at line ~360, §13.4 context map example at lines ~520-534). Replace with correct alternatives: link to `AGENTS.md` or `.opencode/agent/` as the entry point for agents.
- [x] **1.2** Replace all `/.ai/agents/` references with `.opencode/agent/` in `doc/documentation-handbook.md` (§10 multi-repo table at line ~359, §4.2 /prompts/ description at line ~226, §15 FAQ at line ~566).
- [x] **1.3** Migrate all `doc/adr/` references to `doc/decisions/` in `doc/documentation-handbook.md`:
  - §3 standard tree (line ~86): change `/adr/` to `/decisions/` and update the example filename from `ADR-0001-short-title.md` to show the new naming pattern
  - §4.1a excerpt (line ~148): change `/doc/adr/**` to `/doc/decisions/**`
  - §4.2 /adr/ section (line ~188): rewrite to reference `doc/decisions/` with the new naming convention
  - §5 naming conventions (line ~268): update ADR naming to new decision record naming
  - §6 lifecycle (line ~277): change `/doc/adr/` to `/doc/decisions/`
  - §10 multi-repo table (lines ~365-366): change `/doc/adr/` to `/doc/decisions/`
  - §13.4 example (line ~530): change `/doc/adr/` to `/doc/decisions/`
  - §14 tooling (line ~545): update ADR naming validation
  - §17 template index (line ~586): change `adr-template.md` to `decision-record-template.md`
- [x] **1.4** Update §17 template index to match the 6 templates from F-10: `change-spec-template.md`, `decision-record-template.md`, `feature-spec-template.md`, `test-spec-template.md`, `test-plan-template.md`, `implementation-plan-template.md` (replaces current list that includes `mr-template.md` and old `adr-template.md`).
- [x] **1.5** Create missing directory stubs with `README.md` placeholders explaining purpose:
  - `doc/overview/README.md` — high-level project context (north star, roadmap, architecture, glossary)
  - `doc/templates/README.md` — authoring templates for all document types
  - `doc/decisions/README.md` — decision records for all decision types (ADR/PDR/TDR/BDR/ODR)
- [x] **1.6** Create `doc/00-index.md` as the documentation landing page with links to overview, spec, changes, guides, templates, and decisions.
- [x] **1.7** Migrate `doc/adr/` references to `doc/decisions/` in agent prompts and commands:
  - `.opencode/agent/architect.md`: update all `doc/adr/` references to `doc/decisions/`, update naming from `ADR-<zeroPad4>-<slug>.md` to `<TYPE>-<zeroPad4>-<slug>.md` (lines ~9, 32, 33, 46, 66, 143, 149, 213, 219)
  - `.opencode/agent/pm.md`: update `doc/adr/**` to `doc/decisions/**` (line ~85)
  - `.opencode/command/write-adr.md`: update all `doc/adr/` to `doc/decisions/`, update naming convention (lines ~30, 33, 73, 153, 288, 306)
  - `.opencode/command/plan-decision.md`: update all `doc/adr/` to `doc/decisions/` (lines ~13, 30, 67, 80, 91, 288, 331)
  - `.opencode/command/plan-change.md`: update `doc/adr/**` to `doc/decisions/**` (line ~68)
- [x] **1.8** Update `.opencode/README.md` line ~176 to reflect the `doc/adr/` → `doc/decisions/` change.
- [x] **1.9** Validate: run systematic grep — zero matches outside GH-32 change artifacts for `doc/adr/`, `/.ai/agents/`, `context-maps`, `coding-agent-index` across all `.md` files (excluding the GH-32 spec itself). Confirm zero matches.

**Acceptance Criteria**:

- Must: AC-F1-1 — Zero matches for `context-maps` or `coding-agent-index` in the Documentation Handbook
- Must: AC-F2-1 — Zero matches for `/.ai/agents/` across doc/ and .opencode/ (all updated to `.opencode/agent/`)
- Must: AC-F3-1 — `doc/overview/`, `doc/templates/`, `doc/decisions/` exist with README.md explaining purpose
- Must: AC-F4-1 — `doc/00-index.md` exists with links to overview, spec, changes, guides, templates
- Must: AC-F5-1 — Zero matches for `doc/adr/` across doc/ and .opencode/ (all updated to `doc/decisions/`)
- Must: AC-F6-1 — Handbook §3 standard tree matches actual repo structure post-change

**Files and modules**:

- `doc/documentation-handbook.md` (updated)
- `doc/00-index.md` (new)
- `doc/overview/README.md` (new)
- `doc/templates/README.md` (new)
- `doc/decisions/README.md` (new)
- `.opencode/agent/architect.md` (updated)
- `.opencode/agent/pm.md` (updated)
- `.opencode/command/write-adr.md` (updated)
- `.opencode/command/plan-decision.md` (updated)
- `.opencode/command/plan-change.md` (updated)
- `.opencode/README.md` (updated — line ~176 only)

**Tests**:

- Grep validation: `rg "doc/adr/" --glob "*.md"` returns zero matches (excluding GH-32 spec)
- Grep validation: `rg "/.ai/agents/" --glob "*.md"` returns zero matches (excluding GH-32 spec)
- Grep validation: `rg "context-maps|coding-agent-index" --glob "*.md"` returns zero matches (excluding GH-32 spec)
- Directory existence: `doc/overview/`, `doc/templates/`, `doc/decisions/` all exist with README.md
- File existence: `doc/00-index.md` exists

**Completion signal**: `docs(GH-32): fix cross-document consistency — ghost refs, stale paths, missing dirs`

---

### Phase 2: Decision records management standard

**Goal**: Establish the decision records standard with a guide and template, building on the `doc/decisions/` directory created in Phase 1.

**Source material**: Synthesized from best-of-breed decision management systems across multiple projects.

**Tasks**:

- [x] **2.1** Create `doc/guides/decision-records-management.md` — the decision records management guide. Adapt from Menuvivo MVDR system but generalized for ADOS (tracker-agnostic, not Jira-specific). Must define:
  - Decision types: ADR (Architecture), PDR (Product), TDR (Technical), BDR (Business), ODR (Operational)
  - Location: `doc/decisions/` (flat directory, all types co-located)
  - Naming convention: `<TYPE>-<zeroPad4>-<slug>.md` (e.g., `ADR-0001-event-bus-selection.md`, `PDR-0001-free-tier-scope.md`) — per OQ-3 resolution: type prefix + zero-padded 4-digit
  - Lifecycle: Proposed → Under Review → Accepted → (Deprecated | Superseded)
  - Required sections: Context, Drivers, Options, Decision, Consequences, Status
  - Governance: who can propose, review, accept, and supersede decisions
  - Index file: `doc/decisions/00-index.md` (manual or auto-generated)
  - Relationship to changes: how decisions link to change specs via front-matter
- [x] **2.2** Create `doc/templates/decision-record-template.md` — the decision record template usable for all 5 types. Adapt from Menuvivo ADR template. Must include:
  - Front-matter skeleton with all required keys (id, status, created, decision_date, owners, service, decision_type, links)
  - All required sections: Context, Drivers, Options Considered, Decision, Rationale, Consequences (Positive/Negative), Verification, References
  - Inline authoring guidance as HTML comments
  - Placeholder content showing expected level of detail
- [x] **2.3** Create `doc/decisions/00-index.md` — decision records index (initially empty table with column headers).
- [x] **2.4** Update `@architect` agent (`.opencode/agent/architect.md`) to support the new naming convention. In Phase 1 we updated paths from `doc/adr/` to `doc/decisions/`. In this phase, update the naming logic from `ADR-<zeroPad4>-<slug>.md` to `<TYPE>-<zeroPad4>-<slug>.md`, and add awareness of multiple decision types (currently the agent only knows about ADRs).
- [x] **2.5** Update `/write-adr` command (`.opencode/command/write-adr.md`) to use the new naming convention `<TYPE>-<zeroPad4>-<slug>.md` and reference `doc/templates/decision-record-template.md` for structure guidance.
- [x] **2.6** Update `/plan-decision` command (`.opencode/command/plan-decision.md`) to use the new naming convention and scan `doc/decisions/` for existing records of all types (not just ADRs).

**Acceptance Criteria**:

- Must: AC-F7-1 — `doc/guides/decision-records-management.md` defines all 5 decision types with naming, lifecycle, and governance
- Must: AC-F8-1 — `doc/templates/decision-record-template.md` contains front-matter skeleton, all required sections, and inline authoring guidance
- Must: AC-F9-1 — `@architect` agent targets `doc/decisions/` with new naming convention
- Must: AC-F9-2 — `/write-adr` and `/plan-decision` commands use `doc/decisions/` with new naming convention

**Files and modules**:

- `doc/guides/decision-records-management.md` (new)
- `doc/templates/decision-record-template.md` (new)
- `doc/decisions/00-index.md` (new)
- `.opencode/agent/architect.md` (updated — naming convention)
- `.opencode/command/write-adr.md` (updated — naming convention, template reference)
- `.opencode/command/plan-decision.md` (updated — naming convention, scan pattern)

**Tests**:

- `doc/guides/decision-records-management.md` contains all 5 type abbreviations: ADR, PDR, TDR, BDR, ODR
- `doc/guides/decision-records-management.md` contains lifecycle states: Proposed, Under Review, Accepted, Deprecated, Superseded
- `doc/templates/decision-record-template.md` contains sections: Context, Drivers, Options, Decision, Consequences, Status
- `doc/decisions/00-index.md` exists with table headers
- `@architect` agent references `<TYPE>-<zeroPad4>-<slug>.md` pattern

**Completion signal**: `docs(GH-32): add decision records management standard — guide, template, agent/command updates`

---

### Phase 3: Document templates

**Goal**: Create the 6 document templates in `doc/templates/` and update agent prompts to read templates at runtime with fallback to embedded defaults.

**Source material**: Synthesized from best-of-breed templates across multiple projects.

**Tasks**:

- [x] **3.1** Create `doc/templates/change-spec-template.md` — adapt from FlagshipX change-spec-template. Must include front-matter skeleton, all spec sections (Summary through Appendices), and inline HTML comment guidance. Align with `@spec-writer` embedded structure.
- [x] **3.2** Create `doc/templates/feature-spec-template.md` — adapt from FlagshipX feature-specification-template. For use in `doc/spec/features/`. Must include front-matter and all required sections with inline guidance.
- [x] **3.3** Create `doc/templates/test-spec-template.md` — adapt from Menuvivo test-spec-template. For use in `doc/quality/test-specs/`. Must include front-matter and all required sections with inline guidance.
- [x] **3.4** Create `doc/templates/test-plan-template.md` — adapt from FlagshipX test-plan-template. Per-change test plan template. Must include front-matter, coverage matrix, test scenarios, and inline guidance. Align with `@test-plan-writer` embedded structure.
- [x] **3.5** Create `doc/templates/implementation-plan-template.md` — derive from `@plan-writer` embedded structure. Must include front-matter, Context and Goals, Scope, Phases, Test Scenarios, Artifacts, Plan Revision Log, Execution Log, and inline guidance.
- [x] **3.6** Verify `doc/templates/decision-record-template.md` — exists from Phase 2 already exists (created in Phase 2). No action needed — this completes the set of 6 templates.
- [x] **3.7** Update `doc/templates/README.md` — already lists all 6 from Phase 1 (created in Phase 1) to list all 6 templates with brief descriptions.
- [x] **3.8** Update `@spec-writer` agent — template_reading section added (`.opencode/agent/spec-writer.md`) to read `doc/templates/change-spec-template.md` at runtime for structural guidance, with fallback to embedded default if template is absent. Add a template-reading step early in the process (before generating the spec). Template defines structure; agent prompt defines quality rules and domain logic.
- [x] **3.9** Update `@plan-writer` agent — template_reading section added (`.opencode/agent/plan-writer.md`) to read `doc/templates/implementation-plan-template.md` at runtime for structural guidance, with same fallback pattern.
- [x] **3.10** Update `@test-plan-writer` agent — template_reading section added (`.opencode/agent/test-plan-writer.md`) to read `doc/templates/test-plan-template.md` at runtime for structural guidance, with same fallback pattern.
- [x] **3.11** Update `@doc-syncer` agent — template search step updated with specific filenames and fallback (`.opencode/agent/doc-syncer.md`) to be aware of `doc/templates/` as a location containing structural templates. When reconciling docs, the doc-syncer should know templates exist for feature specs and test specs. Add a note about `doc/templates/feature-spec-template.md` and `doc/templates/test-spec-template.md` as structural references, with same fallback pattern.

**Acceptance Criteria**:

- Must: AC-F10-1 — `doc/templates/` contains exactly 6 templates: `change-spec-template.md`, `decision-record-template.md`, `feature-spec-template.md`, `test-spec-template.md`, `test-plan-template.md`, `implementation-plan-template.md`
- Must: AC-F10-2 — Each template renders as valid GFM and contains all required sections with inline HTML comment guidance
- Must: AC-F11-1 — `@spec-writer` reads `doc/templates/change-spec-template.md` when it exists
- Must: AC-F11-2 — `@spec-writer` falls back to embedded default when template is absent (no errors)
- Must: AC-F11-3 — `@plan-writer`, `@test-plan-writer`, and `@doc-syncer` each read their corresponding template with fallback

**Files and modules**:

- `doc/templates/change-spec-template.md` (new)
- `doc/templates/feature-spec-template.md` (new)
- `doc/templates/test-spec-template.md` (new)
- `doc/templates/test-plan-template.md` (new)
- `doc/templates/implementation-plan-template.md` (new)
- `doc/templates/README.md` (updated — list all 6)
- `.opencode/agent/spec-writer.md` (updated — template reading)
- `.opencode/agent/plan-writer.md` (updated — template reading)
- `.opencode/agent/test-plan-writer.md` (updated — template reading)
- `.opencode/agent/doc-syncer.md` (updated — template awareness)

**Tests**:

- All 6 template files exist in `doc/templates/`
- Each template contains YAML front-matter (starts with `---`)
- Each template contains at least one HTML comment (`<!--`)
- `@spec-writer` prompt contains reference to `doc/templates/change-spec-template.md`
- `@plan-writer` prompt contains reference to `doc/templates/implementation-plan-template.md`
- `@test-plan-writer` prompt contains reference to `doc/templates/test-plan-template.md`
- `@doc-syncer` prompt contains reference to `doc/templates/`

**Completion signal**: `docs(GH-32): add 6 document templates and agent template-reading capability`

---

### Phase 4: Onboarding guide

**Goal**: Create a comprehensive step-by-step guide for adopting ADOS in an existing project.

**Tasks**:

- [x] **4.1** Create `doc/guides/onboarding-existing-project.md` — comprehensive guide with mandatory/optional artifacts, GitHub+Jira config, first change walkthrough — the ADOS adoption guide. Must cover:
  - **Prerequisites**: what the target project needs before starting (a git repo, basic familiarity with ADOS concepts)
  - **Mandatory artifacts** with setup instructions:
    - `AGENTS.md` — what to include, how to customize for the project
    - `.ai/agent/pm-instructions.md` — configuration walkthrough for both GitHub and Jira tracker setups
    - `doc/documentation-handbook.md` — copy as-is from ADOS (per OQ-1 resolution)
  - **Recommended artifacts** (clearly labeled as optional):
    - `doc/00-index.md` — documentation landing page
    - `doc/overview/` — north star, roadmap, architecture overview
    - `doc/spec/features/` — initial feature specs
    - `doc/templates/` — copy from ADOS
    - `doc/decisions/` — decision records directory
    - `doc/guides/` — project-specific guides
  - **Decision records setup**: link to `doc/guides/decision-records-management.md`
  - **First change walkthrough**: brief example of running the 10-phase workflow on a real change
  - **Links to all relevant ADOS guides**: change lifecycle, change convention, agents-and-commands guide, tools convention, documentation handbook
  - **Automated bootstrap**: mention `@bootstrapper` / `/bootstrap` as the automated alternative (with forward reference)
  - **Troubleshooting**: common issues when adopting ADOS

**Acceptance Criteria**:

- Must: AC-F12-1 — Lists all mandatory artifacts (AGENTS.md, pm-instructions.md, documentation-handbook.md) and all optional artifacts with clear labels
- Must: AC-F12-2 — Includes pm-instructions.md configuration walkthrough for both GitHub and Jira
- Must: AC-F12-3 — Includes decision records setup instructions and links to the decision records management guide
- Must: AC-F12-4 — Links to all relevant ADOS guides (change lifecycle, change convention, agents-and-commands guide, tools convention, documentation handbook)

**Files and modules**:

- `doc/guides/onboarding-existing-project.md` (new)

**Tests**:

- File exists and renders as valid GFM
- Contains references to: `AGENTS.md`, `pm-instructions.md`, `documentation-handbook.md`
- Contains both "GitHub" and "Jira" mentions for tracker setup
- Contains link to `doc/guides/decision-records-management.md`
- Contains links to: change-lifecycle, change convention, agents-and-commands guide, tools convention

**Completion signal**: `docs(GH-32): add onboarding guide for existing projects`

---

### Phase 5: Bootstrap agent and command

**Goal**: Create the `@bootstrapper` agent and `/bootstrap` command to automate ADOS adoption. This phase MUST be delegated to `@toolsmith` per AGENTS.md extension guidance.

**Delegation**: `@toolsmith` creates both `.opencode/agent/bootstrapper.md` and `.opencode/command/bootstrap.md`.

**Tasks**:

- [x] **5.1** Create `.opencode/agent/bootstrapper.md` — multi-session workflow with 6 phases, persistent state schema, security constraints — the bootstrapper agent. Must define:
  - Multi-session workflow with phases: repo scan → confidence assessment → human interview → draft → review → write
  - Persistent state at `.ai/local/bootstrapper-context.yaml` (schema: project metadata, interview history, confidence scores, artifact status, session timestamps)
  - Generated artifacts: `AGENTS.md` (project-specific), `.ai/agent/pm-instructions.md` (with tracker config), `doc/documentation-handbook.md` (copy as-is per OQ-1), at least one feature spec
  - Security constraint: state file must NOT contain secrets, tokens, or credentials
  - The agent should reference `doc/guides/onboarding-existing-project.md` for the manual adoption path
  - The agent should reference `doc/templates/` for structural templates when generating artifacts
- [x] **5.2** Create `.opencode/command/bootstrap.md` — thin entry point, subtask: false, optional project-name arg — thin entry point to `@bootstrapper`. Must:
  - Accept an optional project-name argument
  - Delegate to `@bootstrapper` agent
  - Be a `subtask: false` command (multi-session workflow needs main context)
- [x] **5.3** Update `.opencode/README.md` — bootstrapper in Agents, /bootstrap in Commands
  - Add `bootstrapper` to the Agents section (alphabetical order) with description: `bootstrapper: automate ADOS adoption for existing projects`
  - Add `/bootstrap` to the Commands section (alphabetical order) with description: `/bootstrap: scaffold ADOS artifacts for an existing project`
- [x] **5.4** Update `AGENTS.md` — Onboarding subsection, /bootstrap command, 19 agents / 16 commands
  - Add `bootstrapper` to the Agent team section under a new "Onboarding" subsection (between "Orchestration" and "Artifact creation")
  - Add `/bootstrap` to the Commands table
  - Update the agent/command counts in "What this repo is" (18→19 agents, 15→16 commands)

**Acceptance Criteria**:

- Must: AC-F13-1 — `.opencode/agent/bootstrapper.md` defines multi-session workflow with all phases
- Must: AC-F13-2 — `@bootstrapper` scans repo and asks questions before generating files
- Must: AC-F13-3 — `@bootstrapper` generates at minimum: AGENTS.md, pm-instructions.md, and at least one feature spec
- Must: AC-F14-1 — `.opencode/command/bootstrap.md` delegates to `@bootstrapper` and accepts optional project-name
- Must: AC-F15-1 — Bootstrapper state schema includes: project metadata, interview history, confidence scores, artifact status, session timestamps
- Must: AC-F16-1 — `.opencode/README.md` lists `bootstrapper` in Agents and `/bootstrap` in Commands
- Must: AC-F16-2 — `AGENTS.md` lists `bootstrapper` in agent team and `/bootstrap` in commands table

**Files and modules**:

- `.opencode/agent/bootstrapper.md` (new — via @toolsmith)
- `.opencode/command/bootstrap.md` (new — via @toolsmith)
- `.opencode/README.md` (updated — inventory)
- `AGENTS.md` (updated — inventory, counts)

**Tests**:

- `.opencode/agent/bootstrapper.md` exists and contains: "repo scan", "confidence", "interview", "draft", "review", "write"
- `.opencode/agent/bootstrapper.md` references `.ai/local/bootstrapper-context.yaml`
- `.opencode/command/bootstrap.md` exists and references `bootstrapper` agent
- `.opencode/README.md` contains `bootstrapper` in Agents section
- `.opencode/README.md` contains `/bootstrap` in Commands section
- `AGENTS.md` contains `bootstrapper` in agent team
- `AGENTS.md` contains `/bootstrap` in commands table

**Completion signal**: `feat(GH-32): add @bootstrapper agent and /bootstrap command`

---

### Phase 6: Final cleanup and release preparation

**Goal**: Apply license headers, create remaining stubs, and ensure all cross-references are consistent.

**Tasks**:

- [x] **6.1** Create `doc/guides/copywriting.md` — minimal stub linking to @editor agent as a minimal stub (per OQ-2 resolution). Content: front-matter + title + brief description stating this is a placeholder for future copywriting guidelines, linking to `@editor` agent for current copy conventions.
- [x] **6.2** Create `doc/planning/product-decisions/README.md` — with doc/planning/README.md parent as a directory stub (referenced in spec Appendix A). If `doc/planning/` does not exist, create it with a README.md explaining its purpose.
- [x] **6.3** Run `scripts/add-header-location.sh` — all 18 new files got license headers on all new files to add license headers:
  - `doc/00-index.md`
  - `doc/overview/README.md`
  - `doc/templates/README.md` and all 6 templates
  - `doc/decisions/README.md` and `doc/decisions/00-index.md`
  - `doc/guides/decision-records-management.md`
  - `doc/guides/onboarding-existing-project.md`
  - `doc/guides/copywriting.md`
  - `doc/planning/product-decisions/README.md` (if created)
  - `.opencode/agent/bootstrapper.md`
  - `.opencode/command/bootstrap.md`
- [x] **6.4** Final validation — all grep checks pass: zero ghost references outside GH-32 artifacts
  - `rg "doc/adr/" --glob "*.md"` → zero matches (excluding GH-32 spec)
  - `rg "/.ai/agents/" --glob "*.md"` → zero matches (excluding GH-32 spec)
  - `rg "context-maps|coding-agent-index" --glob "*.md"` → zero matches (excluding GH-32 spec)
  - Verify all new directories exist: `doc/overview/`, `doc/templates/`, `doc/decisions/`, `doc/planning/product-decisions/`
  - Verify all 6 templates exist
  - Verify `doc/00-index.md`, `doc/guides/decision-records-management.md`, `doc/guides/onboarding-existing-project.md`, `doc/guides/copywriting.md` exist
  - Verify `.opencode/agent/bootstrapper.md` and `.opencode/command/bootstrap.md` exist
- [x] **6.5** Reconcile this plan's spec — all 16 functional capabilities (F-1 through F-16) verified as addressed: F-1→1.1, F-2→1.2, F-3→1.5, F-4→1.6, F-5→1.3/1.7, F-6→1.3, F-7→2.1, F-8→2.2, F-9→1.7/2.4-2.6, F-10→3.1-3.6, F-11→3.8-3.11, F-12→4.1, F-13→5.1, F-14→5.2, F-15→5.1, F-16→5.3-5.4. All AC-* criteria covered.

**Acceptance Criteria**:

- Must: All new files have license headers
- Must: `doc/guides/copywriting.md` exists as a stub
- Must: Zero ghost references remain (final validation passes)
- Should: `doc/planning/product-decisions/` exists if referenced in handbook

**Files and modules**:

- `doc/guides/copywriting.md` (new — stub)
- `doc/planning/product-decisions/README.md` (new — stub)
- All files from previous phases (license header application)

**Tests**:

- All new `.md` files contain `Copyright` or `MIT License` in first 5 lines
- Final grep validation passes (zero ghost references)
- All directories referenced in handbook §3 exist

**Completion signal**: `docs(GH-32): final cleanup — license headers, stubs, validation`

## Test Scenarios

| ID | Scenario | Phases | AC |
|----|----------|--------|----|
| TS-1 | Ghost reference elimination | 1, 6 | AC-F1-1, AC-F2-1, AC-F5-1 |
| TS-2 | Missing directory creation | 1, 6 | AC-F3-1 |
| TS-3 | Documentation landing page | 1 | AC-F4-1 |
| TS-4 | Handbook-reality alignment | 1, 6 | AC-F6-1 |
| TS-5 | Decision records guide completeness | 2 | AC-F7-1 |
| TS-6 | Decision record template structure | 2 | AC-F8-1 |
| TS-7 | Architect agent path + naming | 1, 2 | AC-F9-1 |
| TS-8 | Write-adr + plan-decision commands | 1, 2 | AC-F9-2 |
| TS-9 | Template inventory completeness | 2, 3 | AC-F10-1, AC-F10-2 |
| TS-10 | Agent template reading (with template) | 3 | AC-F11-1 |
| TS-11 | Agent template fallback (without template) | 3 | AC-F11-2 |
| TS-12 | Multi-agent template reading | 3 | AC-F11-3 |
| TS-13 | Onboarding guide mandatory artifacts | 4 | AC-F12-1 |
| TS-14 | Onboarding guide tracker config | 4 | AC-F12-2 |
| TS-15 | Onboarding guide decision records | 4 | AC-F12-3 |
| TS-16 | Onboarding guide cross-links | 4 | AC-F12-4 |
| TS-17 | Bootstrapper agent workflow | 5 | AC-F13-1, AC-F13-2, AC-F13-3 |
| TS-18 | Bootstrap command delegation | 5 | AC-F14-1 |
| TS-19 | Bootstrapper state schema | 5 | AC-F15-1 |
| TS-20 | Inventory updates (README + AGENTS.md) | 5 | AC-F16-1, AC-F16-2 |

## Artifacts and Links

| Artifact | Location | Type |
|----------|----------|------|
| Change specification | `./chg-GH-32-spec.md` | Spec |
| Documentation Handbook | `doc/documentation-handbook.md` | Updated |
| Documentation index | `doc/00-index.md` | New |
| Decision records guide | `doc/guides/decision-records-management.md` | New |
| Onboarding guide | `doc/guides/onboarding-existing-project.md` | New |
| Copywriting guide stub | `doc/guides/copywriting.md` | New (stub) |
| Decision records index | `doc/decisions/00-index.md` | New |
| 6 document templates | `doc/templates/*.md` | New |
| Bootstrapper agent | `.opencode/agent/bootstrapper.md` | New |
| Bootstrap command | `.opencode/command/bootstrap.md` | New |
| Architect agent | `.opencode/agent/architect.md` | Updated |
| PM agent | `.opencode/agent/pm.md` | Updated |
| Spec-writer agent | `.opencode/agent/spec-writer.md` | Updated |
| Plan-writer agent | `.opencode/agent/plan-writer.md` | Updated |
| Test-plan-writer agent | `.opencode/agent/test-plan-writer.md` | Updated |
| Doc-syncer agent | `.opencode/agent/doc-syncer.md` | Updated |
| Write-adr command | `.opencode/command/write-adr.md` | Updated |
| Plan-decision command | `.opencode/command/plan-decision.md` | Updated |
| Plan-change command | `.opencode/command/plan-change.md` | Updated |
| OpenCode README | `.opencode/README.md` | Updated |
| AGENTS.md | `AGENTS.md` | Updated |

## Plan Revision Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-10 | plan-writer | Initial plan — 6 phases covering 5 spec parts + final cleanup |

## Execution Log

| Phase | Status | Started | Completed | Commit | Notes |
|-------|--------|---------|-----------|--------|-------|
| 1 | Complete | 2026-03-10 | 2026-03-10 | | Ghost refs, stale paths, missing dirs fixed |
| 2 | Complete | 2026-03-10 | 2026-03-10 | | Guide, template, index, agent/command updates |
| 3 | Complete | 2026-03-10 | 2026-03-10 | | 5 templates created, 4 agents updated for template reading |
| 4 | Complete | 2026-03-10 | 2026-03-10 | | Onboarding guide with all mandatory/optional artifacts |
| 5 | Complete | 2026-03-10 | 2026-03-10 | | @bootstrapper agent + /bootstrap command + inventory updates |
| 6 | Complete | 2026-03-10 | 2026-03-10 | | License headers on 18 files, copywriting stub, planning stubs, final validation passed, spec reconciliation complete |
