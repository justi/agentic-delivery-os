---
id: chg-GH-27-agents-md
status: Completed
created: 2026-03-07T00:00:00Z
last_updated: 2026-03-07T00:00:00Z
owners: [juliusz-cwiakalski]
service: repo-root
labels: [documentation, developer-experience]
links:
  change_spec: ./chg-GH-27-spec.md
summary: "Create AGENTS.md — delivery system bootstrap for AI agents and contributors"
version_impact: none
---

# Implementation Plan — GH-27: Create AGENTS.md

## Context and Goals

Create `AGENTS.md` at the repository root as the canonical bootstrap for AI agents and contributors. The file leads with the delivery system (10-phase process, 18 agents, 15 commands), provides extension guidance (`@toolsmith` delegation, agent contracts, testing through the process), and documents repo conventions.

**Goals** (from spec v2.0):

- **G-1**: Single-file bootstrap that orients agents on the delivery system.
- **G-2**: Convey quality bar: agent prompts ARE the product; modifications require `@toolsmith`.
- **G-3**: Provide extension guidance so agents evolve the OS correctly.
- **G-4**: Document repo conventions (tools/, scripts/, testing, license headers).
- **G-5**: Link to detailed docs without duplicating content.

## Scope

**In Scope**:

- New file: `AGENTS.md` at repo root (delivery-system-first structure)
- License header frontmatter on `AGENTS.md` (via `scripts/add-header-location.sh`)
- Update `README.md` to reference `AGENTS.md` in "Docs at a glance" and "Repo structure"

**Out of Scope**:

- Creating the `tools/` directory (GH-26)
- Modifying existing docs beyond adding the `AGENTS.md` reference in README
- CI pipeline or pre-commit hook changes

**Constraints**:

- `AGENTS.md` must be ≤ 200 lines (NFR-1)
- No duplicated content from linked docs (NFR-2)
- Valid GitHub-flavored Markdown (NFR-3)

## Phases

### Phase 1: Create AGENTS.md (initial version)

**Goal**: Author the initial `AGENTS.md` file with repo-conventions focus.

**Tasks**:

- [x] Create `AGENTS.md` at repo root with initial sections (repo structure, tools/, scripts/, tests, license headers, key references)
- [x] Run `scripts/add-header-location.sh AGENTS.md` to add license header frontmatter

**Completion signal**: `docs(GH-27): add AGENTS.md`

### Phase 2: Update README.md

**Goal**: Add `AGENTS.md` reference to README.

**Tasks**:

- [x] Add `AGENTS.md` entry to "Docs at a glance" section
- [x] Add `AGENTS.md` entry to "Repo structure" tree

**Completion signal**: `docs(GH-27): update README to reference AGENTS.md`

### Phase 3: Rewrite AGENTS.md with delivery-system-first structure

**Goal**: Expand AGENTS.md scope per user feedback — lead with delivery system, agent team, commands, extension guidance.

**Tasks**:

- [x] Rewrite with mission statement (agent prompts ARE the product)
- [x] Add 10-phase delivery process table with agent-per-phase mapping
- [x] Add full agent roster (18 agents) grouped by delivery role
- [x] Add full command inventory (15 commands) in workflow order
- [x] Add usage section (autopilot + manual workflow)
- [x] Add "Extending the system" section with `@toolsmith` delegation, contract awareness, testing guidance
- [x] Add change artifact conventions section
- [x] Expand repo structure tree (show .opencode/, .ai/ internals)
- [x] Keep tools/, scripts/, testing, license header sections (condensed)
- [x] Expand key references table (7 docs)
- [x] Verify ≤ 200 lines

**Acceptance Criteria**:

- Must: Mission statement conveys agent prompts ARE the product (AC-F1-1)
- Must: 10-phase delivery process table present (AC-F2-1)
- Must: All 18 agents listed with roles (AC-F3-1)
- Must: All 15 commands listed (AC-F4-1)
- Must: Autopilot and manual modes documented (AC-F5-1)
- Must: "Extending the system" section with @toolsmith delegation (AC-F6-1)
- Must: Change artifact conventions documented (AC-F7-1)
- Must: Annotated repo structure tree (AC-F8-1)
- Must: tools/ and scripts/ conventions documented (AC-F9-1)
- Must: Testing and license header conventions documented (AC-F10-1)
- Must: Key references table (AC-F11-1)
- Must: ≤ 200 lines (AC-NFR1-1)

**Completion signal**: `docs(GH-27): rewrite AGENTS.md with delivery-system-first structure`

### Phase 4: Remediation — Trim AGENTS.md to ≤200 lines

**Goal**: Satisfy AC-NFR1-1 (≤200 lines). Phase 3 produced 225 lines; condense lower sections without removing any section.

**Tasks**:

- [x] Merge `tools/` and `scripts/` convention sections into a single combined table (Aspect | `tools/` | `scripts/`)
- [x] Compress "Running tests" section — replace bash code block with 1-2 line description
- [x] Compress "License headers" section — collapse example code block into compact paragraph
- [x] Verify final line count ≤ 200

**Acceptance Criteria**:

- Must: ≤ 200 lines (AC-NFR1-1) — re-validated
- Must: All sections from Phase 3 still present (AC-F1-1 through AC-F11-1 unaffected)

**Completion signal**: `docs(GH-27): trim AGENTS.md to ≤200 lines (AC-NFR1-1)`

## Plan Revision Log

| Date | Change |
|------|--------|
| 2026-03-07 | Initial plan created (3 phases: create, update README, finalize) |
| 2026-03-07 | Added Phase 3 for delivery-system-first rewrite per scope expansion |
| 2026-03-07 | Added Phase 4: Remediation — trim AGENTS.md to ≤200 lines (AC-NFR1-1 failed at 225 lines) |

## Execution Log

| Date | Phase | Summary |
|------|-------|---------|
| 2026-03-07 | Phase 1: Create AGENTS.md | Created AGENTS.md (93 lines) with repo-conventions focus. Commit `d56df3a`. |
| 2026-03-07 | Phase 2: Update README.md | Added AGENTS.md to "Docs at a glance" and "Repo structure". Commit `5f7b9da`. |
| 2026-03-07 | Phase 3: Rewrite AGENTS.md | Complete rewrite with delivery-system-first structure. Commit `a0de1c4`. |
| 2026-03-07 | Phase 4: Remediation | Trimmed AGENTS.md from 225 → 183 lines. Merged tools/scripts into one table, compressed Running tests and License headers sections. AC-NFR1-1 now PASSED. |
