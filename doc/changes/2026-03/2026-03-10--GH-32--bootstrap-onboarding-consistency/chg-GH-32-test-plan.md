---
id: chg-GH-32-test-plan
status: Proposed
created: "2026-03-10T20:00:00Z"
last_updated: "2026-03-10T20:00:00Z"
owners: [juliusz-cwiakalski]
service: delivery-os
labels: [onboarding, documentation, consistency, developer-experience]
links:
  change_spec: ./chg-GH-32-spec.md
  implementation_plan: ./chg-GH-32-plan.md
  testing_strategy: "N/A — .ai/rules/testing-strategy.mdc does not exist in this repo. This change is documentation/agent-prompt only; testing strategy derived from repo conventions and PM guidance."
version_impact: minor
summary: >
  Test plan for GH-32: Bootstrap agent + onboarding guide + cross-document consistency fixes.
  Covers 5 parts: (1) cross-doc consistency, (2) decision records, (3) document templates,
  (4) onboarding guide, (5) bootstrap agent/command. All deliverables are Markdown docs and
  agent prompts — no application code. Testing is content validation, cross-reference
  validation, agent prompt inspection, and manual review checklists.
---

# Test Plan - Bootstrap agent + onboarding guide + cross-document consistency fixes

## 1. Scope and Objectives

### Scope

This test plan covers all 5 parts of GH-32:

1. **Part 1 — Cross-document consistency**: Ghost reference removal, stale path fixes, missing directory stubs, documentation landing page, `doc/adr/` → `doc/decisions/` migration, handbook reconciliation.
2. **Part 2 — Decision records**: Management guide, decision record template, agent/command path updates.
3. **Part 3 — Document templates**: Seven templates in `doc/templates/`, agent prompt updates for template reading with fallback.
4. **Part 4 — Onboarding guide**: Step-by-step ADOS adoption guide for existing projects.
5. **Part 5 — Bootstrap agent and command**: `@bootstrapper` agent, `/bootstrap` command, `.opencode/README.md` and `AGENTS.md` inventory updates.

### Objectives

- Verify zero ghost references remain across all docs and agent prompts.
- Verify all referenced paths resolve to existing files/directories.
- Verify all new documents contain required sections per their specification.
- Verify agent prompts correctly reference `doc/decisions/` and include template-reading instructions.
- Verify `@bootstrapper` agent and `/bootstrap` command are structurally complete.
- Verify inventory files (`.opencode/README.md`, `AGENTS.md`) are updated.

### Testing approach

This is a **documentation and agent prompt change only** — there is no application code. Testing consists of:

- **Automated content validation**: `grep`/`find` commands executed by `@runner` to detect ghost references, verify file existence, and check for required content patterns.
- **Manual review checklists**: Structural inspection by `@reviewer` for section completeness, authoring quality, and cross-document coherence.
- **Cross-reference validation**: Systematic verification that every path mentioned in any document resolves to an existing file or directory.

## 2. References

| Document | Location |
|----------|----------|
| Change Specification | `doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/chg-GH-32-spec.md` |
| Implementation Plan | `doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/chg-GH-32-plan.md` (pending) |
| PM Notes | `doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/chg-GH-32-pm-notes.yaml` |
| Documentation Handbook | `doc/documentation-handbook.md` |
| AGENTS.md | `AGENTS.md` |
| Agent inventory | `.opencode/README.md` |
| Testing strategy | N/A — `.ai/rules/testing-strategy.mdc` does not exist; approach defined in §1 above |

## 3. Coverage Overview

### 3.1 Functional Coverage (F-#, AC-#)

| F-ID | Capability | AC-IDs | TC-IDs | Status |
|------|-----------|--------|--------|--------|
| F-1 | Remove ghost references to `coding-agent-index` | AC-F1-1 | TC-GHOST-001 | Covered |
| F-2 | Fix `/.ai/agents/` → `.opencode/agent/` | AC-F2-1 | TC-GHOST-002 | Covered |
| F-3 | Create missing directory stubs | AC-F3-1 | TC-DIRS-001 | Covered |
| F-4 | Create `doc/00-index.md` | AC-F4-1 | TC-INDEX-001 | Covered |
| F-5 | Migrate `doc/adr/` → `doc/decisions/` references | AC-F5-1 | TC-GHOST-003 | Covered |
| F-6 | Reconcile Handbook §3 standard tree | AC-F6-1 | TC-HBOOK-001 | Covered |
| F-7 | Decision records management guide | AC-F7-1 | TC-DREC-001 | Covered |
| F-8 | Decision record template | AC-F8-1 | TC-DREC-002 | Covered |
| F-9 | Update `@architect`, `/write-adr`, `/plan-decision`, `@pm`, `/plan-change` | AC-F9-1, AC-F9-2 | TC-DREC-003, TC-DREC-004, TC-DREC-005, TC-DREC-006 | Covered |
| F-10 | Seven document templates | AC-F10-1, AC-F10-2 | TC-TMPL-001, TC-TMPL-002 | Covered |
| F-11 | Agent template reading with fallback | AC-F11-1, AC-F11-2, AC-F11-3 | TC-TMPL-003, TC-TMPL-004, TC-TMPL-005 | Covered |
| F-12 | Onboarding guide | AC-F12-1, AC-F12-2, AC-F12-3, AC-F12-4 | TC-ONBRD-001, TC-ONBRD-002, TC-ONBRD-003, TC-ONBRD-004 | Covered |
| F-13 | `@bootstrapper` agent | AC-F13-1, AC-F13-2, AC-F13-3 | TC-BOOT-001, TC-BOOT-002, TC-BOOT-003 | Covered |
| F-14 | `/bootstrap` command | AC-F14-1 | TC-BOOT-004 | Covered |
| F-15 | Bootstrapper persistent state schema | AC-F15-1 | TC-BOOT-005 | Covered |
| F-16 | Inventory updates | AC-F16-1, AC-F16-2 | TC-INVT-001, TC-INVT-002 | Covered |

### 3.2 Interface Coverage (API-#, EVT-#, DM-#)

| ID | Element | TC-IDs | Status |
|----|---------|--------|--------|
| DM-1 | `.ai/local/bootstrapper-context.yaml` schema | TC-BOOT-005 | Covered |

No API or EVT interfaces — documentation-only change.

### 3.3 Non-Functional Coverage (NFR-#)

| NFR-ID | Requirement | TC-IDs | Status |
|--------|-------------|--------|--------|
| NFR-1 | Zero ghost references | TC-GHOST-001, TC-GHOST-002, TC-GHOST-003, TC-NFR-001 | Covered |
| NFR-2 | Template completeness (valid GFM, required sections) | TC-TMPL-001, TC-TMPL-002 | Covered |
| NFR-3 | Onboarding guide completeness | TC-ONBRD-001, TC-ONBRD-002, TC-ONBRD-003, TC-ONBRD-004 | Covered |
| NFR-4 | Bootstrapper state resilience | TC-BOOT-005 | Covered |
| NFR-5 | Agent fallback reliability | TC-TMPL-004 | Covered |
| NFR-6 | Decision records guide completeness | TC-DREC-001 | Covered |
| NFR-7 | Handbook alignment with repo structure | TC-HBOOK-001 | Covered |

## 4. Test Types and Layers

| Test Type | Description | Executor | Applicable Parts |
|-----------|-------------|----------|-----------------|
| Content Validation | `grep`/`find` commands to verify file existence, required patterns, absence of ghost references | `@runner` | All |
| Cross-Reference Validation | Systematic path resolution — every doc-referenced path checked against repo | `@runner` + `@reviewer` | Parts 1, 3, 4, 5 |
| Structural Review | Manual inspection of section completeness, authoring quality, GFM validity | `@reviewer` | All |
| Agent Prompt Review | Manual inspection that agent prompts contain correct paths, template-reading instructions, and no regressions | `@reviewer` | Parts 2, 3, 5 |
| Inventory Validation | Verify `.opencode/README.md` and `AGENTS.md` list all new agents/commands | `@runner` | Part 5 |

There are **no unit tests, integration tests, E2E tests, or performance tests** for this change — all deliverables are static Markdown files and agent prompt definitions.

## 5. Test Scenarios

### 5.1 Scenario Index

| TC-ID | Title | Type | Priority | AC Coverage |
|-------|-------|------|----------|-------------|
| TC-GHOST-001 | Zero `context-maps`/`coding-agent-index` references | Happy Path | High | AC-F1-1 |
| TC-GHOST-002 | Zero `/.ai/agents/` references | Happy Path | High | AC-F2-1 |
| TC-GHOST-003 | Zero `doc/adr/` references | Happy Path | High | AC-F5-1 |
| TC-NFR-001 | Comprehensive ghost reference sweep | Happy Path | High | NFR-1 |
| TC-DIRS-001 | Missing directory stubs exist with README | Happy Path | High | AC-F3-1 |
| TC-INDEX-001 | `doc/00-index.md` exists and has required links | Happy Path | Medium | AC-F4-1 |
| TC-HBOOK-001 | Handbook §3 standard tree matches repo | Happy Path | High | AC-F6-1, NFR-7 |
| TC-DREC-001 | Decision records management guide completeness | Happy Path | High | AC-F7-1, NFR-6 |
| TC-DREC-002 | Decision record template completeness | Happy Path | High | AC-F8-1 |
| TC-DREC-003 | `@architect` targets `doc/decisions/` | Happy Path | High | AC-F9-1 |
| TC-DREC-004 | `/write-adr` and `/plan-decision` use `doc/decisions/` | Happy Path | High | AC-F9-2 |
| TC-DREC-005 | `@pm` agent references `doc/decisions/` correctly | Happy Path | High | AC-F9-1 |
| TC-DREC-006 | `/plan-change` command references `doc/decisions/` correctly | Happy Path | High | AC-F9-2 |
| TC-TMPL-001 | Seven templates exist in `doc/templates/` | Happy Path | High | AC-F10-1 |
| TC-TMPL-002 | Templates are valid GFM with required sections | Happy Path | Medium | AC-F10-2, NFR-2 |
| TC-TMPL-003 | `@spec-writer` reads template at runtime | Happy Path | High | AC-F11-1 |
| TC-TMPL-004 | `@spec-writer` fallback when template absent | Edge Case | High | AC-F11-2, NFR-5 |
| TC-TMPL-005 | `@plan-writer`, `@test-plan-writer`, `@doc-syncer` template reading | Happy Path | High | AC-F11-3 |
| TC-ONBRD-001 | Onboarding guide lists mandatory and optional artifacts | Happy Path | High | AC-F12-1 |
| TC-ONBRD-002 | Onboarding guide has PM config walkthrough | Happy Path | Medium | AC-F12-2 |
| TC-ONBRD-003 | Onboarding guide includes decision records setup | Happy Path | Medium | AC-F12-3 |
| TC-ONBRD-004 | Onboarding guide links to all ADOS guides | Happy Path | Medium | AC-F12-4 |
| TC-BOOT-001 | `@bootstrapper` agent defines multi-session workflow | Happy Path | High | AC-F13-1 |
| TC-BOOT-002 | `@bootstrapper` scans before generating | Happy Path | High | AC-F13-2 |
| TC-BOOT-003 | `@bootstrapper` generates minimum artifacts | Happy Path | High | AC-F13-3 |
| TC-BOOT-004 | `/bootstrap` command delegates to `@bootstrapper` | Happy Path | High | AC-F14-1 |
| TC-BOOT-005 | Bootstrapper state schema completeness | Happy Path | Medium | AC-F15-1, DM-1, NFR-4 |
| TC-INVT-001 | `.opencode/README.md` lists bootstrapper and /bootstrap | Happy Path | High | AC-F16-1 |
| TC-INVT-002 | `AGENTS.md` lists bootstrapper and /bootstrap | Happy Path | High | AC-F16-2 |

### 5.2 Scenario Details

---

#### TC-GHOST-001 - Zero `context-maps`/`coding-agent-index` references

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-1, AC-F1-1, NFR-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/documentation-handbook.md` and all files under `doc/`, `.opencode/`
**Tags**: @content-validation, @ghost-ref

**Preconditions**:

- All Part 1 deliverables committed.

**Steps**:

1. Run: `grep -r "context-maps" doc/ .opencode/` — expect zero matches.
2. Run: `grep -r "coding-agent-index" doc/ .opencode/` — expect zero matches.

**Expected Outcome**:

- Both commands return zero matches (exit code 1, empty output).

---

#### TC-GHOST-002 - Zero `/.ai/agents/` references

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-2, AC-F2-1, NFR-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: All files under `doc/` and `.opencode/`
**Tags**: @content-validation, @ghost-ref

**Preconditions**:

- All Part 1 deliverables committed.

**Steps**:

1. Run: `grep -rn "/.ai/agents/" doc/ .opencode/` — expect zero matches.
2. Run: `grep -rn "\.ai/agents/" doc/ .opencode/` — expect zero matches (ensure no variant forms remain).

**Expected Outcome**:

- Zero matches in all files. All former `/.ai/agents/` references have been replaced with `.opencode/agent/`.

**Notes / Clarifications**:

- The pattern `.ai/agents/` (with trailing `s`) is the stale path. The correct path is `.opencode/agent/` (no trailing `s`).

---

#### TC-GHOST-003 - Zero `doc/adr/` references

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-5, AC-F5-1, NFR-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: All files under `doc/` and `.opencode/`
**Tags**: @content-validation, @ghost-ref

**Preconditions**:

- All Part 2 deliverables committed.

**Steps**:

1. Run: `grep -rn "doc/adr/" doc/ .opencode/ AGENTS.md` — expect zero matches.
2. Run: `grep -rn "doc/adr" doc/ .opencode/ AGENTS.md` — expect zero matches (catches `doc/adr` without trailing slash too).

**Expected Outcome**:

- Zero matches. All `doc/adr/` references have been replaced with `doc/decisions/`.

**Notes / Clarifications**:

- Exclude the change spec and test plan files themselves from the search (they document the migration and may contain `doc/adr/` in descriptive text). Focus on live docs and agent prompts.

---

#### TC-NFR-001 - Comprehensive ghost reference sweep

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: NFR-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: Entire repo (excluding `doc/changes/` and `.git/`)
**Tags**: @content-validation, @ghost-ref, @nfr

**Preconditions**:

- All 5 parts delivered and committed.

**Steps**:

1. Run: `grep -rn "context-maps" --include="*.md" . --exclude-dir=.git --exclude-dir=doc/changes` — expect zero matches.
2. Run: `grep -rn "coding-agent-index" --include="*.md" . --exclude-dir=.git --exclude-dir=doc/changes` — expect zero matches.
3. Run: `grep -rn "/.ai/agents/" --include="*.md" . --exclude-dir=.git --exclude-dir=doc/changes` — expect zero matches.
4. Run: `grep -rn "doc/adr" --include="*.md" . --exclude-dir=.git --exclude-dir=doc/changes` — expect zero matches.
5. Run: `grep -rn "doc/planning/product-decisions" --include="*.md" . --exclude-dir=.git --exclude-dir=doc/changes` — expect zero matches.

**Expected Outcome**:

- All five sweeps return zero matches. No ghost references to non-existent paths remain in live documentation or agent prompts.

---

#### TC-DIRS-001 - Missing directory stubs exist with README

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-3, AC-F3-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/overview/`, `doc/templates/`, `doc/decisions/`
**Tags**: @content-validation, @directory-structure

**Preconditions**:

- Part 1 and Part 2 deliverables committed.

**Steps**:

1. Verify `doc/overview/` directory exists: `test -d doc/overview && echo OK`.
2. Verify `doc/overview/README.md` exists and contains a purpose description: `test -f doc/overview/README.md && grep -qi "purpose\|overview\|high-level" doc/overview/README.md && echo OK`.
3. Verify `doc/templates/` directory exists: `test -d doc/templates && echo OK`.
4. Verify `doc/templates/README.md` exists and contains a purpose description: `test -f doc/templates/README.md && grep -qi "template" doc/templates/README.md && echo OK`.
5. Verify `doc/decisions/` directory exists: `test -d doc/decisions && echo OK`.
6. Verify `doc/decisions/README.md` exists and contains a purpose description: `test -f doc/decisions/README.md && grep -qi "decision" doc/decisions/README.md && echo OK`.

**Expected Outcome**:

- All three directories exist, each with a README.md that explains the directory's purpose.

---

#### TC-INDEX-001 - `doc/00-index.md` exists and has required links

**Scenario Type**: Happy Path
**Impact Level**: Important
**Priority**: Medium
**Related IDs**: F-4, AC-F4-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/00-index.md`
**Tags**: @content-validation, @landing-page

**Preconditions**:

- Part 1 deliverables committed.

**Steps**:

1. Verify file exists: `test -f doc/00-index.md && echo OK`.
2. Verify it contains links to key sections: `grep -c "overview\|spec\|changes\|guides\|templates" doc/00-index.md` — expect >= 5 matches.
3. Manually review: Does it serve as a clear documentation landing page for both humans and agents?

**Expected Outcome**:

- `doc/00-index.md` exists, contains links to overview, spec, changes, guides, and templates sections, and reads as a useful entry point.

---

#### TC-HBOOK-001 - Handbook §3 standard tree matches repo

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-6, AC-F6-1, NFR-7
**Test Type(s)**: Cross-Reference Validation
**Automation Level**: Manual
**Target Layer / Location**: `doc/documentation-handbook.md`
**Tags**: @manual-review, @cross-ref

**Preconditions**:

- All 5 parts delivered and committed.

**Steps**:

1. Open `doc/documentation-handbook.md` and locate §3 (standard tree / directory structure).
2. For each directory listed in the standard tree, verify it exists in the repo using `ls -d <path>`.
3. For each file listed in the standard tree, verify it exists using `test -f <path>`.
4. Confirm no directory or file in §3 is missing from the repo (or the entry has been removed from §3).

**Expected Outcome**:

- Every directory and file listed in Handbook §3 either exists in the repo or has been removed from the standard tree. Zero mismatches.

**Notes / Clarifications**:

- Some entries may be "project-specific" (created per project) — these should be clearly marked as optional in the handbook rather than listed as always-present.

---

#### TC-DREC-001 - Decision records management guide completeness

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-7, AC-F7-1, NFR-6
**Test Type(s)**: Structural Review
**Automation Level**: Manual
**Target Layer / Location**: `doc/guides/decision-records-management.md`
**Tags**: @manual-review, @decision-records

**Preconditions**:

- Part 2 deliverables committed.

**Steps**:

1. Verify file exists: `test -f doc/guides/decision-records-management.md && echo OK`.
2. Verify all 5 decision types are mentioned: `grep -c "ADR\|PDR\|TDR\|BDR\|ODR" doc/guides/decision-records-management.md` — expect >= 5.
3. Verify naming convention is documented: `grep -qi "naming" doc/guides/decision-records-management.md && echo OK`.
4. Verify lifecycle states are documented: `grep -c "Proposed\|Under Review\|Accepted\|Deprecated\|Superseded" doc/guides/decision-records-management.md` — expect >= 4.
5. Verify governance section exists: `grep -qi "governance" doc/guides/decision-records-management.md && echo OK`.
6. Verify decision ID format uses type prefix + zero-padded 4-digit per OQ-3 resolution: `grep -q "ADR-0001\|PDR-0001" doc/guides/decision-records-management.md && echo OK`.
7. Manually review for completeness and clarity.

**Expected Outcome**:

- Guide defines all 5 decision types (ADR, PDR, TDR, BDR, ODR) with naming convention (type prefix + zero-padded 4-digit), lifecycle (Proposed → Under Review → Accepted → Deprecated/Superseded), and governance.

---

#### TC-DREC-002 - Decision record template completeness

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-8, AC-F8-1
**Test Type(s)**: Structural Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/templates/decision-record-template.md`
**Tags**: @content-validation, @decision-records

**Preconditions**:

- Part 2 deliverables committed.

**Steps**:

1. Verify file exists: `test -f doc/templates/decision-record-template.md && echo OK`.
2. Verify front-matter skeleton: `grep -q "^---" doc/templates/decision-record-template.md && echo OK`.
3. Verify required sections exist:
   - `grep -qi "context" doc/templates/decision-record-template.md && echo OK`
   - `grep -qi "drivers" doc/templates/decision-record-template.md && echo OK`
   - `grep -qi "options" doc/templates/decision-record-template.md && echo OK`
   - `grep -qi "decision" doc/templates/decision-record-template.md && echo OK`
   - `grep -qi "consequences" doc/templates/decision-record-template.md && echo OK`
   - `grep -qi "status" doc/templates/decision-record-template.md && echo OK`
4. Verify inline authoring guidance (HTML comments): `grep -c "<!--" doc/templates/decision-record-template.md` — expect >= 1.

**Expected Outcome**:

- Template contains front-matter skeleton, all 6 required sections (Context, Drivers, Options, Decision, Consequences, Status), and inline authoring guidance as HTML comments.

---

#### TC-DREC-003 - `@architect` targets `doc/decisions/`

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-9, AC-F9-1
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/architect.md`
**Tags**: @agent-prompt, @decision-records

**Preconditions**:

- Part 2 deliverables committed.

**Steps**:

1. Verify `doc/decisions/` is referenced: `grep -c "doc/decisions" .opencode/agent/architect.md` — expect >= 1.
2. Verify `doc/adr/` is NOT referenced: `grep -c "doc/adr" .opencode/agent/architect.md` — expect 0.
3. Manually review the architect prompt to confirm decision record output path is `doc/decisions/`.

**Expected Outcome**:

- `@architect` agent prompt references `doc/decisions/` and does NOT reference `doc/adr/`.

---

#### TC-DREC-004 - `/write-adr` and `/plan-decision` use `doc/decisions/`

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-9, AC-F9-2
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/command/write-adr.md`, `.opencode/command/plan-decision.md`
**Tags**: @agent-prompt, @decision-records

**Preconditions**:

- Part 2 deliverables committed.

**Steps**:

1. Verify `/write-adr` references `doc/decisions/`: `grep -c "doc/decisions" .opencode/command/write-adr.md` — expect >= 1.
2. Verify `/write-adr` does NOT reference `doc/adr/`: `grep -c "doc/adr" .opencode/command/write-adr.md` — expect 0.
3. Verify `/plan-decision` references `doc/decisions/`: `grep -c "doc/decisions" .opencode/command/plan-decision.md` — expect >= 1.
4. Verify `/plan-decision` does NOT reference `doc/adr/`: `grep -c "doc/adr" .opencode/command/plan-decision.md` — expect 0.

**Expected Outcome**:

- Both commands reference `doc/decisions/` and do NOT reference `doc/adr/`.

---

#### TC-DREC-005 - `@pm` agent references `doc/decisions/` correctly

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-9, AC-F9-1
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/pm.md`
**Tags**: @agent-prompt, @decision-records

**Preconditions**:

- Part 2 deliverables committed.

**Steps**:

1. Verify `@pm` references `doc/decisions/`: `grep -c "doc/decisions" .opencode/agent/pm.md` — expect >= 1.
2. Verify `@pm` does NOT reference `doc/adr/`: `grep -c "doc/adr" .opencode/agent/pm.md` — expect 0.

**Expected Outcome**:

- `@pm` agent prompt references `doc/decisions/` and does NOT reference `doc/adr/`.

---

#### TC-DREC-006 - `/plan-change` command references `doc/decisions/` correctly

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-9, AC-F9-2
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/command/plan-change.md`
**Tags**: @agent-prompt, @decision-records

**Preconditions**:

- Part 2 deliverables committed.

**Steps**:

1. Verify `/plan-change` references `doc/decisions/`: `grep -c "doc/decisions" .opencode/command/plan-change.md` — expect >= 1.
2. Verify `/plan-change` does NOT reference `doc/adr/`: `grep -c "doc/adr" .opencode/command/plan-change.md` — expect 0.

**Expected Outcome**:

- `/plan-change` command references `doc/decisions/` and does NOT reference `doc/adr/`.

---

#### TC-TMPL-001 - Seven templates exist in `doc/templates/`

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-10, AC-F10-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/templates/`
**Tags**: @content-validation, @templates

**Preconditions**:

- Part 3 deliverables committed.

**Steps**:

1. Verify each template file exists:
   - `test -f doc/templates/change-spec-template.md && echo OK`
   - `test -f doc/templates/decision-record-template.md && echo OK`
   - `test -f doc/templates/feature-spec-template.md && echo OK`
   - `test -f doc/templates/north-star-template.md && echo OK`
   - `test -f doc/templates/test-spec-template.md && echo OK`
   - `test -f doc/templates/test-plan-template.md && echo OK`
   - `test -f doc/templates/implementation-plan-template.md && echo OK`
2. Verify exactly 7 templates (plus README): `ls doc/templates/*.md | wc -l` — expect 8 (7 templates + README.md).

**Expected Outcome**:

- `doc/templates/` contains exactly 6 template files plus a README.md.

---

#### TC-TMPL-002 - Templates are valid GFM with required sections

**Scenario Type**: Happy Path
**Impact Level**: Important
**Priority**: Medium
**Related IDs**: F-10, AC-F10-2, NFR-2
**Test Type(s)**: Structural Review
**Automation Level**: Manual
**Target Layer / Location**: `doc/templates/*.md`
**Tags**: @manual-review, @templates

**Preconditions**:

- Part 3 deliverables committed.

**Steps**:

1. For each of the 6 templates, open the file and manually inspect:
   - Valid GitHub-Flavored Markdown (headings, lists, code blocks render correctly).
   - Front-matter skeleton is present (YAML between `---` delimiters).
   - All required sections for the document type are present.
   - Inline authoring guidance exists as HTML comments (`<!-- ... -->`).
   - Placeholder content shows expected level of detail.
2. Verify no template contains leftover `<...>` placeholders that should have been filled in or converted to HTML comments.

**Expected Outcome**:

- All 6 templates render as valid GFM, contain required sections with inline guidance, and include meaningful placeholder content.

---

#### TC-TMPL-003 - `@spec-writer` reads template at runtime

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-11, AC-F11-1
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/spec-writer.md`
**Tags**: @agent-prompt, @templates

**Preconditions**:

- Part 3 deliverables committed.

**Steps**:

1. Verify the spec-writer prompt references the template path: `grep -c "doc/templates/change-spec-template" .opencode/agent/spec-writer.md` — expect >= 1.
2. Verify the prompt contains instructions to read the template: `grep -qi "read.*template\|template.*read\|load.*template\|template.*load" .opencode/agent/spec-writer.md && echo OK`.
3. Manually review: Is the template-reading instruction clear and actionable?

**Expected Outcome**:

- `@spec-writer` prompt contains instructions to read `doc/templates/change-spec-template.md` at runtime for structural guidance.

---

#### TC-TMPL-004 - `@spec-writer` fallback when template absent

**Scenario Type**: Edge Case
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-11, AC-F11-2, NFR-5
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/spec-writer.md`
**Tags**: @agent-prompt, @templates, @edge-case

**Preconditions**:

- Part 3 deliverables committed.

**Steps**:

1. Verify the spec-writer prompt contains fallback instructions: `grep -qi "fallback\|default\|absent\|not found\|not exist\|missing" .opencode/agent/spec-writer.md && echo OK`.
2. Manually review: Does the prompt clearly instruct the agent to use its embedded default structure if the template file is not found?

**Expected Outcome**:

- `@spec-writer` prompt includes explicit fallback-to-defaults instruction when the template file does not exist.

---

#### TC-TMPL-005 - `@plan-writer`, `@test-plan-writer`, `@doc-syncer` template reading

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-11, AC-F11-3
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/plan-writer.md`, `.opencode/agent/test-plan-writer.md`, `.opencode/agent/doc-syncer.md`
**Tags**: @agent-prompt, @templates

**Preconditions**:

- Part 3 deliverables committed.

**Steps**:

1. For `@plan-writer`:
   - `grep -c "doc/templates/implementation-plan-template" .opencode/agent/plan-writer.md` — expect >= 1.
   - `grep -qi "fallback\|default" .opencode/agent/plan-writer.md && echo OK`.
2. For `@test-plan-writer`:
   - `grep -c "doc/templates/test-plan-template" .opencode/agent/test-plan-writer.md` — expect >= 1.
   - `grep -qi "fallback\|default" .opencode/agent/test-plan-writer.md && echo OK`.
3. For `@doc-syncer`:
   - `grep -c "doc/templates/" .opencode/agent/doc-syncer.md` — expect >= 1.
   - `grep -qi "fallback\|default" .opencode/agent/doc-syncer.md && echo OK`.

**Expected Outcome**:

- All three agent prompts reference their corresponding templates with fallback instructions.

---

#### TC-ONBRD-001 - Onboarding guide lists mandatory and optional artifacts

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-12, AC-F12-1, NFR-3
**Test Type(s)**: Structural Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/guides/onboarding-existing-project.md`
**Tags**: @content-validation, @onboarding

**Preconditions**:

- Part 4 deliverables committed.

**Steps**:

1. Verify file exists: `test -f doc/guides/onboarding-existing-project.md && echo OK`.
2. Verify mandatory artifacts are listed:
   - `grep -qi "AGENTS.md" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "pm-instructions" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "documentation-handbook" doc/guides/onboarding-existing-project.md && echo OK`
3. Verify mandatory vs optional labeling: `grep -qi "mandatory\|required\|optional" doc/guides/onboarding-existing-project.md && echo OK`.
4. Manually review: Are mandatory and optional artifacts clearly distinguished?

**Expected Outcome**:

- Guide lists all mandatory ADOS artifacts (AGENTS.md, pm-instructions.md, documentation-handbook.md) and optional artifacts with clear labels.

---

#### TC-ONBRD-002 - Onboarding guide has PM config walkthrough

**Scenario Type**: Happy Path
**Impact Level**: Important
**Priority**: Medium
**Related IDs**: F-12, AC-F12-2
**Test Type(s)**: Structural Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/guides/onboarding-existing-project.md`
**Tags**: @content-validation, @onboarding

**Preconditions**:

- Part 4 deliverables committed.

**Steps**:

1. Verify PM config walkthrough content:
   - `grep -qi "pm-instructions" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "github\|jira" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "tracker" doc/guides/onboarding-existing-project.md && echo OK`
2. Manually review: Does the walkthrough cover both GitHub and Jira tracker setups?

**Expected Outcome**:

- Guide includes a configuration walkthrough for `.ai/agent/pm-instructions.md` covering both GitHub and Jira tracker setups.

---

#### TC-ONBRD-003 - Onboarding guide includes decision records setup

**Scenario Type**: Happy Path
**Impact Level**: Important
**Priority**: Medium
**Related IDs**: F-12, AC-F12-3
**Test Type(s)**: Structural Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/guides/onboarding-existing-project.md`
**Tags**: @content-validation, @onboarding

**Preconditions**:

- Part 4 deliverables committed.

**Steps**:

1. Verify decision records content: `grep -qi "decision" doc/guides/onboarding-existing-project.md && echo OK`.
2. Verify link to management guide: `grep -qi "decision-records-management" doc/guides/onboarding-existing-project.md && echo OK`.

**Expected Outcome**:

- Guide includes decision records setup instructions and links to the decision records management guide.

---

#### TC-ONBRD-004 - Onboarding guide links to all ADOS guides

**Scenario Type**: Happy Path
**Impact Level**: Important
**Priority**: Medium
**Related IDs**: F-12, AC-F12-4
**Test Type(s)**: Cross-Reference Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `doc/guides/onboarding-existing-project.md`
**Tags**: @content-validation, @onboarding, @cross-ref

**Preconditions**:

- Part 4 deliverables committed.

**Steps**:

1. Verify links to key guides:
   - `grep -qi "change-lifecycle" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "change-convention\|unified-change" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "agents-and-commands\|Claude-agents" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "tools-convention" doc/guides/onboarding-existing-project.md && echo OK`
   - `grep -qi "documentation-handbook" doc/guides/onboarding-existing-project.md && echo OK`

**Expected Outcome**:

- Guide links to all relevant ADOS guides: change lifecycle, change convention, agents-and-commands guide, tools convention, and documentation handbook.

---

#### TC-BOOT-001 - `@bootstrapper` agent defines multi-session workflow

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-13, AC-F13-1
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/bootstrapper.md`
**Tags**: @agent-prompt, @bootstrapper

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Verify file exists: `test -f .opencode/agent/bootstrapper.md && echo OK`.
2. Verify multi-session workflow phases are defined:
   - `grep -qi "scan" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "confidence" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "interview" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "draft" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "review" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "write" .opencode/agent/bootstrapper.md && echo OK`
3. Manually review: Is the workflow clearly defined with phase transitions?

**Expected Outcome**:

- `@bootstrapper` agent prompt defines a multi-session workflow with phases: repo scan → confidence assessment → human interview → draft → review → write.

---

#### TC-BOOT-002 - `@bootstrapper` scans before generating

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-13, AC-F13-2
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Manual
**Target Layer / Location**: `.opencode/agent/bootstrapper.md`
**Tags**: @manual-review, @bootstrapper

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Manually review the bootstrapper agent prompt:
   - Does it instruct the agent to scan repo structure BEFORE generating any files?
   - Does it instruct the agent to ask targeted questions based on scan results?
   - Is there a clear prohibition against generating files before the scan and interview phases?

**Expected Outcome**:

- Agent prompt clearly establishes that repo scanning and human interview precede any file generation.

---

#### TC-BOOT-003 - `@bootstrapper` generates minimum artifacts

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-13, AC-F13-3
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/bootstrapper.md`
**Tags**: @agent-prompt, @bootstrapper

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Verify minimum artifact list in agent prompt:
   - `grep -qi "AGENTS.md" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "pm-instructions" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "feature spec\|feature-spec\|spec/features" .opencode/agent/bootstrapper.md && echo OK`
2. Manually review: Does the prompt specify that at minimum AGENTS.md, pm-instructions.md, and at least one feature spec are generated?

**Expected Outcome**:

- Agent prompt specifies generation of at minimum: `AGENTS.md`, `.ai/agent/pm-instructions.md`, and at least one feature spec.

---

#### TC-BOOT-004 - `/bootstrap` command delegates to `@bootstrapper`

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-14, AC-F14-1
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/command/bootstrap.md`
**Tags**: @agent-prompt, @bootstrapper

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Verify file exists: `test -f .opencode/command/bootstrap.md && echo OK`.
2. Verify delegation to bootstrapper: `grep -qi "bootstrapper" .opencode/command/bootstrap.md && echo OK`.
3. Verify optional project-name argument: `grep -qi "project.name\|project-name\|argument\|parameter" .opencode/command/bootstrap.md && echo OK`.
4. Manually review: Is the command a thin entry point that delegates to `@bootstrapper`?

**Expected Outcome**:

- `/bootstrap` command exists, delegates to `@bootstrapper`, and accepts an optional project-name argument.

---

#### TC-BOOT-005 - Bootstrapper state schema completeness

**Scenario Type**: Happy Path
**Impact Level**: Important
**Priority**: Medium
**Related IDs**: F-15, AC-F15-1, DM-1, NFR-4
**Test Type(s)**: Agent Prompt Review
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/agent/bootstrapper.md` (schema defined within agent prompt)
**Tags**: @agent-prompt, @bootstrapper, @schema

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Verify the bootstrapper prompt defines or references the state schema for `.ai/local/bootstrapper-context.yaml`:
   - `grep -qi "bootstrapper-context" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "project metadata\|project.metadata\|metadata" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "interview" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "confidence" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "artifact.status\|artifact status\|generated" .opencode/agent/bootstrapper.md && echo OK`
   - `grep -qi "session\|timestamp" .opencode/agent/bootstrapper.md && echo OK`
2. Verify the schema specifies `.ai/local/` as the location (git-ignored): `grep -q ".ai/local/" .opencode/agent/bootstrapper.md && echo OK`.
3. Verify the agent prompt prohibits storing secrets: `grep -qi "secret\|credential\|token" .opencode/agent/bootstrapper.md && echo OK`.

**Expected Outcome**:

- Schema includes: project metadata, interview history, confidence scores, artifact status, and session timestamps. File is located in `.ai/local/` (git-ignored). Agent prompt prohibits storing secrets.

---

#### TC-INVT-001 - `.opencode/README.md` lists bootstrapper and /bootstrap

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-16, AC-F16-1
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `.opencode/README.md`
**Tags**: @content-validation, @inventory

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Verify bootstrapper agent is listed: `grep -qi "bootstrapper" .opencode/README.md && echo OK`.
2. Verify bootstrap command is listed: `grep -qi "bootstrap" .opencode/README.md && echo OK`.
3. Manually review: Is bootstrapper in the Agents section and /bootstrap in the Commands section?

**Expected Outcome**:

- `.opencode/README.md` lists `bootstrapper` in the Agents section and `/bootstrap` in the Commands section.

---

#### TC-INVT-002 - `AGENTS.md` lists bootstrapper and /bootstrap

**Scenario Type**: Happy Path
**Impact Level**: Critical
**Priority**: High
**Related IDs**: F-16, AC-F16-2
**Test Type(s)**: Content Validation
**Automation Level**: Semi-automated
**Target Layer / Location**: `AGENTS.md`
**Tags**: @content-validation, @inventory

**Preconditions**:

- Part 5 deliverables committed.

**Steps**:

1. Verify bootstrapper agent is listed: `grep -qi "bootstrapper" AGENTS.md && echo OK`.
2. Verify bootstrap command is listed: `grep -qi "/bootstrap" AGENTS.md && echo OK`.
3. Manually review: Is bootstrapper in the agent team table and /bootstrap in the commands table?

**Expected Outcome**:

- `AGENTS.md` lists `bootstrapper` in the agent team and `/bootstrap` in the commands table.

## 6. Environments and Test Data

### Environment

All testing is performed against the local repository clone on the feature branch `feat/GH-32/bootstrap-onboarding-consistency`. No external environments, databases, or services are required.

### Test Data

No test data required. All verifications are against static Markdown files and directory structure within the repository.

### Tools

| Tool | Purpose |
|------|---------|
| `grep` | Search for patterns in files (ghost references, required content) |
| `find` / `ls` | Verify file and directory existence |
| `test -f` / `test -d` | Bash conditionals for existence checks |
| `wc -l` | Count matches or files |
| Manual review | Structural inspection, authoring quality, coherence |

## 7. Automation Plan and Implementation Mapping

| TC-ID | Automation Level | Implementation Approach | Target Location |
|-------|-----------------|------------------------|-----------------|
| TC-GHOST-001 | Semi-automated | `grep` commands by `@runner` | Repo-wide scan |
| TC-GHOST-002 | Semi-automated | `grep` commands by `@runner` | Repo-wide scan |
| TC-GHOST-003 | Semi-automated | `grep` commands by `@runner` | Repo-wide scan |
| TC-NFR-001 | Semi-automated | `grep` sweep by `@runner` | Repo-wide scan (excl. `doc/changes/`) |
| TC-DIRS-001 | Semi-automated | `test -d` / `test -f` / `grep` by `@runner` | `doc/overview/`, `doc/templates/`, `doc/decisions/` |
| TC-INDEX-001 | Semi-automated | `test -f` + `grep` by `@runner`, manual review by `@reviewer` | `doc/00-index.md` |
| TC-HBOOK-001 | Manual | `@reviewer` inspects §3 vs. repo structure | `doc/documentation-handbook.md` |
| TC-DREC-001 | Semi-automated | `grep` for required content by `@runner`, manual review by `@reviewer` | `doc/guides/decision-records-management.md` |
| TC-DREC-002 | Semi-automated | `grep` for required sections by `@runner` | `doc/templates/decision-record-template.md` |
| TC-DREC-003 | Semi-automated | `grep` by `@runner` | `.opencode/agent/architect.md` |
| TC-DREC-004 | Semi-automated | `grep` by `@runner` | `.opencode/command/write-adr.md`, `.opencode/command/plan-decision.md` |
| TC-TMPL-001 | Semi-automated | `test -f` + `ls | wc -l` by `@runner` | `doc/templates/` |
| TC-TMPL-002 | Manual | `@reviewer` inspects each template | `doc/templates/*.md` |
| TC-TMPL-003 | Semi-automated | `grep` by `@runner` | `.opencode/agent/spec-writer.md` |
| TC-TMPL-004 | Semi-automated | `grep` by `@runner`, manual review by `@reviewer` | `.opencode/agent/spec-writer.md` |
| TC-TMPL-005 | Semi-automated | `grep` by `@runner` | `.opencode/agent/plan-writer.md`, `.opencode/agent/test-plan-writer.md`, `.opencode/agent/doc-syncer.md` |
| TC-ONBRD-001 | Semi-automated | `grep` by `@runner`, manual review by `@reviewer` | `doc/guides/onboarding-existing-project.md` |
| TC-ONBRD-002 | Semi-automated | `grep` by `@runner` | `doc/guides/onboarding-existing-project.md` |
| TC-ONBRD-003 | Semi-automated | `grep` by `@runner` | `doc/guides/onboarding-existing-project.md` |
| TC-ONBRD-004 | Semi-automated | `grep` by `@runner` | `doc/guides/onboarding-existing-project.md` |
| TC-BOOT-001 | Semi-automated | `grep` by `@runner`, manual review by `@reviewer` | `.opencode/agent/bootstrapper.md` |
| TC-BOOT-002 | Manual | `@reviewer` inspects workflow ordering | `.opencode/agent/bootstrapper.md` |
| TC-BOOT-003 | Semi-automated | `grep` by `@runner` | `.opencode/agent/bootstrapper.md` |
| TC-BOOT-004 | Semi-automated | `grep` + manual review by `@reviewer` | `.opencode/command/bootstrap.md` |
| TC-BOOT-005 | Semi-automated | `grep` by `@runner`, manual review by `@reviewer` | `.opencode/agent/bootstrapper.md` |
| TC-INVT-001 | Semi-automated | `grep` by `@runner` | `.opencode/README.md` |
| TC-INVT-002 | Semi-automated | `grep` by `@runner` | `AGENTS.md` |

### Implementation Notes

- **No automated test scripts** are created for this change. All deliverables are static Markdown files and agent prompt definitions.
- **Semi-automated** means `@runner` executes `grep`/`find`/`test` commands and reports results; a human or `@reviewer` interprets ambiguous results.
- **Manual** means `@reviewer` performs structural inspection that cannot be reduced to pattern matching.
- A consolidated verification script could be composed from the `grep` commands in §5.2 for batch execution by `@runner`.

## 8. Risks, Assumptions, and Open Questions

### Risks

| ID | Risk | Mitigation |
|----|------|------------|
| TR-1 | Ghost reference patterns may have variant forms not caught by grep (e.g., different quoting, relative vs absolute paths) | Use multiple grep patterns per scenario; `@reviewer` performs manual spot-checks |
| TR-2 | Handbook §3 standard tree may list directories that are intentionally project-specific and not present in ADOS repo | TC-HBOOK-001 allows for directories to be marked optional; `@reviewer` judges each case |
| TR-3 | Agent prompt template-reading verification via grep may produce false positives (matching unrelated text) | Manual review step included in TC-TMPL-003/004/005 to confirm semantic correctness |

### Assumptions

- All 5 parts are delivered on the same branch (`feat/GH-32/bootstrap-onboarding-consistency`) and can be tested together.
- `doc/changes/` directory is excluded from ghost reference sweeps because it contains historical descriptions of the migration.
- Agent prompt files use `.md` extension and are located under `.opencode/agent/` and `.opencode/command/`.
- OQ-1 resolved: Bootstrapper copies handbook as-is per §1 convention.
- OQ-2 resolved: `doc/guides/copywriting.md` created as minimal stub.
- OQ-3 resolved: Decision IDs use type prefix + zero-padded 4-digit (ADR-0001, PDR-0001, etc.).

### Open Questions

None — all open questions from the spec (OQ-1, OQ-2, OQ-3) have been resolved per PM decisions recorded in `chg-GH-32-pm-notes.yaml`.

## 9. Plan Revision Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-10 | test-plan-writer | Initial test plan — 27 scenarios covering all 26 AC + 7 NFRs across 5 parts |

## 10. Test Execution Log

| Date | Executor | TC-IDs Executed | Result | Notes |
|------|----------|-----------------|--------|-------|
| — | — | — | — | No executions yet |
