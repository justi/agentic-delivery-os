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
summary: "Create AGENTS.md — canonical guide for AI agents and contributors"
version_impact: none
---

# Implementation Plan — GH-27: Create AGENTS.md

## Context and Goals

Create `AGENTS.md` at the repository root as the canonical quick-reference for AI agents and contributors. The file documents repo structure, `tools/` vs `scripts/` conventions, how to run tests, license header requirements, and links to deeper guides — without duplicating their content.

**Goals** (from spec):

- **G-1**: Single-file bootstrap for AI agents and contributors at repo root.
- **G-2**: Document `tools/` and `scripts/` directory conventions.
- **G-3**: Document license header convention and `add-header-location.sh`.
- **G-4**: Link to detailed docs without duplicating content.

## Scope

**In Scope**:

- New file: `AGENTS.md` at repo root
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

**Risks**:

- RSK-1: AGENTS.md may become stale — mitigated by link-not-duplicate pattern and small surface area.

**Success Metrics**:

- File exists at repo root and is valid Markdown
- All acceptance criteria (AC-F1-1 through AC-NFR1-1) pass
- No content duplication from linked docs

## Phases

### Phase 1: Create AGENTS.md

**Goal**: Author the `AGENTS.md` file at the repo root with all required sections per the spec.

**Tasks**:

- [x] Create `AGENTS.md` at repo root covering all required sections (all 6 sections: repo structure, tools/ convention, scripts/ convention, running tests, license headers, key references)
- [x] Run `scripts/add-header-location.sh AGENTS.md` to add license header frontmatter (header added successfully)
- [x] Verify file is ≤ 200 lines (NFR-1) — 93 lines

**Acceptance Criteria**:

- Must: `AGENTS.md` exists at repo root and is valid GFM Markdown (AC-F1-1)
- Must: Documents `tools/` convention — PATH-able, no `.sh`, MIT licensed, tests in `tools/.tests/` (AC-F2-1)
- Must: Documents `scripts/` convention — repo-internal, `.sh` extension, tests in `scripts/.tests/` (AC-F3-1)
- Must: Documents test file pattern `test-*.sh` and test directory locations (AC-F4-1)
- Must: Documents license header convention (copyright, MIT, latest-version URL) and references `add-header-location.sh` (AC-F5-1)
- Must: Links to `.opencode/README.md`, `.ai/rules/bash.md`, `doc/guides/change-lifecycle.md`, `doc/guides/unified-change-convention-tracker-agnostic-specification.md` without duplicating their content (AC-F6-1)
- Must: File is ≤ 200 lines (AC-NFR1-1)
- Must: License header frontmatter present (DEC-3)

**Files and modules**:

- `AGENTS.md` (new)

**Tests**:

- Manual: verify Markdown renders on GitHub, line count ≤ 200, all links valid

**Completion signal**: `docs(GH-27): add AGENTS.md`

### Phase 2: Update README.md

**Goal**: Add `AGENTS.md` reference to README's "Docs at a glance" section and "Repo structure" tree.

**Tasks**:

- [x] Add `AGENTS.md` entry to "Docs at a glance" section in README.md (added as first item with description)
- [x] Add `AGENTS.md` entry to "Repo structure" tree in README.md (added to tree with comment)

**Acceptance Criteria**:

- Must: README "Docs at a glance" lists `AGENTS.md` with a brief description
- Must: README "Repo structure" tree includes `AGENTS.md`

**Files and modules**:

- `README.md` (update)

**Tests**:

- Manual: verify links resolve correctly

**Completion signal**: `docs(GH-27): update README to reference AGENTS.md`

### Phase 3: Finalize and Release

**Goal**: Final validation of all acceptance criteria and commit.

**Tasks**:

- [x] Validate all spec acceptance criteria (AC-F1-1 through AC-NFR1-1) with evidence — all PASSED
- [x] Verify no content duplication from linked docs (NFR-2) — PASSED, all deep-topic sections link only
- [x] Confirm valid GitHub-flavored Markdown (NFR-3) — PASSED, valid GFM with tables, code blocks, links

**Acceptance Criteria**:

- Must: All spec AC pass with documented evidence
- Must: No leftover TODOs or placeholders in AGENTS.md

**Files and modules**:

- (no new files — validation only)

**Tests**:

- Line count check: `wc -l AGENTS.md` ≤ 200
- Link validity: all referenced files exist in the repo

**Completion signal**: `docs(GH-27): finalize AGENTS.md delivery`

## Test Scenarios

| ID | Scenario | Expected | AC |
|----|----------|----------|----|
| TS-1 | `AGENTS.md` exists at repo root | File present | AC-F1-1 |
| TS-2 | `tools/` convention section present | Documents PATH-able, no `.sh`, MIT, `tools/.tests/` | AC-F2-1 |
| TS-3 | `scripts/` convention section present | Documents repo-internal, `.sh`, `scripts/.tests/` | AC-F3-1 |
| TS-4 | Test running section present | Documents `test-*.sh` pattern, test dirs | AC-F4-1 |
| TS-5 | License header section present | Documents three-line convention + `add-header-location.sh` | AC-F5-1 |
| TS-6 | Key references section present | Links to 4 docs, no duplicated content | AC-F6-1 |
| TS-7 | Line count ≤ 200 | `wc -l AGENTS.md` ≤ 200 | AC-NFR1-1 |
| TS-8 | License header frontmatter | `---` block with copyright, MIT, latest-version | DEC-3 |

## Artifacts and Links

| Artifact | Path |
|----------|------|
| Spec | `doc/changes/2026-03/2026-03-06--GH-27--agents-md/chg-GH-27-spec.md` |
| Plan | `doc/changes/2026-03/2026-03-06--GH-27--agents-md/chg-GH-27-plan.md` |
| AGENTS.md | `AGENTS.md` |
| README.md | `README.md` |

## Plan Revision Log

| Date | Change |
|------|--------|
| 2026-03-07 | Initial plan created |

## Execution Log

| Date | Phase | Summary |
|------|-------|---------|
| 2026-03-07 | Phase 1: Create AGENTS.md | Created AGENTS.md (93 lines) with all 6 required sections. License header added via add-header-location.sh. Commit `d56df3a`. |
| 2026-03-07 | Phase 2: Update README.md | Added AGENTS.md to "Docs at a glance" and "Repo structure" tree. Commit `5f7b9da`. |
| 2026-03-07 | Phase 3: Finalize and Release | All AC validated: AC-F1-1 through AC-NFR1-1 PASSED. No TODOs/placeholders. No content duplication. All 4 linked files exist. |

### Acceptance Criteria Evidence

| AC | Status | Evidence |
|----|--------|----------|
| AC-F1-1 | PASSED | `AGENTS.md` exists at repo root, 93 lines, valid GFM |
| AC-F2-1 | PASSED | `tools/` convention section documents PATH-able, no `.sh`, MIT licensed, `tools/.tests/` |
| AC-F3-1 | PASSED | `scripts/` convention section documents repo-internal, `.sh` extension, `scripts/.tests/` |
| AC-F4-1 | PASSED | Running tests section documents `test-*.sh` pattern and test directory locations |
| AC-F5-1 | PASSED | License headers section documents three-line convention + `add-header-location.sh` reference |
| AC-F6-1 | PASSED | Key references links to all 4 docs; no content duplication (link-only pattern) |
| AC-NFR1-1 | PASSED | `wc -l AGENTS.md` = 93 (≤ 200) |
| DEC-3 | PASSED | License header frontmatter present (lines 1-5) |
