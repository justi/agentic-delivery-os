---
change:
  ref: GH-27
  type: docs
  status: Proposed
  slug: agents-md
  title: "Create AGENTS.md — canonical guide for AI agents and contributors"
  owners: [juliusz-cwiakalski]
  service: repo-root
  labels: [documentation, developer-experience]
  version_impact: none
  audience: internal
  security_impact: none
  risk_level: low
  dependencies:
    internal: []
    external: []
---

# CHANGE SPECIFICATION

> **PURPOSE**: Define the `AGENTS.md` file — a single, scannable entry point at the repo root that tells AI coding agents and human contributors how to work with this codebase (structure, conventions, build/test/lint commands, license headers, and pointers to detailed docs).

## 1. SUMMARY

Create `AGENTS.md` at the repository root as the canonical quick-reference for AI agents and contributors. The file documents repo structure, the `tools/` vs `scripts/` convention, how to run tests, license header requirements, and links to deeper guides — without duplicating their content.

## 2. CONTEXT

### 2.1 Current State Snapshot

- The repo has detailed per-domain docs:
  - `.opencode/README.md` — OpenCode agents and commands
  - `.ai/rules/bash.md` — Bash coding rules
  - `doc/guides/change-lifecycle.md` — Change delivery lifecycle
  - `doc/guides/unified-change-convention-tracker-agnostic-specification.md` — Change naming convention
- There is no top-level `AGENTS.md` file.
- AI coding agents (Claude Code, OpenCode agents, Copilot, etc.) typically look for `AGENTS.md` at the repo root to bootstrap their understanding of the project.

### 2.2 Pain Points / Gaps

- **No single entry point**: agents must discover conventions across multiple files scattered in `.ai/rules/`, `.opencode/`, and `doc/guides/`.
- **Undocumented `tools/` convention**: the intended `tools/` directory (PATH-able CLI utilities, no `.sh` extension, MIT licensed) is not documented anywhere yet. Upcoming work (GH-26) will create the first tool there.
- **Undocumented `scripts/` convention**: while `scripts/` exists with `add-header-location.sh`, the convention (repo-internal automation, `.sh` extension, tests in `.tests/`) is implicit.
- **License header convention is only embedded in script logic**: the three-line frontmatter pattern (copyright, MIT, latest-version URL) is enforced by `scripts/add-header-location.sh` but not documented as a human-readable convention.

## 3. PROBLEM STATEMENT

Without `AGENTS.md`, AI agents lack a fast, authoritative bootstrap file and must infer conventions from scattered sources — leading to inconsistent outputs and repeated discovery overhead.

## 4. GOALS

- **G-1**: Provide a single-file bootstrap for AI agents and contributors at the repo root.
- **G-2**: Document the `tools/` and `scripts/` directory conventions so future tools (starting with GH-26) follow a documented standard.
- **G-3**: Document the license header convention and the `add-header-location.sh` script.
- **G-4**: Link to detailed docs without duplicating content.

### 4.1 Success Metrics / KPIs

| Metric | Target |
|--------|--------|
| File exists and is discoverable | `AGENTS.md` at repo root |
| Covers all required sections | 100% of acceptance criteria pass |
| No content duplication | All deep-topic sections link rather than repeat |

### 4.2 Non-Goals

- **NG-1**: This spec does not create the `tools/` directory or any CLI tools (that is GH-26).
- **NG-2**: This spec does not modify or extend existing docs — it only references them.
- **NG-3**: This spec does not define CI pipelines or pre-commit hooks (those are covered in `.ai/rules/bash.md`).

## 5. FUNCTIONAL CAPABILITIES

| ID | Capability | Rationale |
|----|------------|-----------|
| F-1 | `AGENTS.md` at repo root documents repo structure overview | Gives agents immediate orientation |
| F-2 | Documents `tools/` directory convention (PATH-able, no `.sh`, MIT licensed) | Establishes standard before first tool is created |
| F-3 | Documents `scripts/` directory convention (repo-internal, `.sh` extension, `.tests/` subfolder) | Makes implicit convention explicit |
| F-4 | Documents how to run tests (`scripts/.tests/test-*.sh`, `tools/.tests/test-*.sh`) | Agents know how to validate changes |
| F-5 | Documents license header requirements (copyright, MIT, latest-version URL) and `add-header-location.sh` | Agents apply correct frontmatter |
| F-6 | References key docs (`.opencode/README.md`, `.ai/rules/bash.md`, change lifecycle, change convention) without duplicating their content | Keeps AGENTS.md concise and maintainable |

### 5.1 Capability Details

**F-1 — Repo structure overview**
A concise directory tree showing the major top-level directories and their purpose.

**F-2 — `tools/` convention**
- Location: `tools/` at repo root
- Purpose: PATH-able CLI utilities intended for use beyond this repo
- Naming: no `.sh` extension (invoked by name)
- License: each tool carries the standard MIT license header
- Tests: `tools/.tests/test-*.sh`
- Note: directory does not exist yet; convention is documented in advance of GH-26

**F-3 — `scripts/` convention**
- Location: `scripts/` at repo root
- Purpose: repo-internal automation (build, header management, etc.)
- Naming: `.sh` extension
- Tests: `scripts/.tests/test-*.sh`

**F-4 — Running tests**
- Pattern: `bash <dir>/.tests/test-*.sh` for individual tests
- Aggregator (if present): `scripts/test-all.sh` (convention from `.ai/rules/bash.md` §12)
- Note: no aggregator exists yet; document the pattern

**F-5 — License header convention**
Three-line markdown frontmatter block inside `---` fences:
1. `# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (...)`
2. `# MIT License - see LICENSE file for full terms`
3. `# Latest version: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/<path>`

Script: `scripts/add-header-location.sh` adds/updates this header automatically.

**F-6 — Reference links**
Link (do not duplicate) to:
- `.opencode/README.md` — OpenCode agents and commands
- `.ai/rules/bash.md` — Bash coding rules
- `doc/guides/change-lifecycle.md` — Change delivery lifecycle
- `doc/guides/unified-change-convention-tracker-agnostic-specification.md` — Change naming convention

## 6. USER & SYSTEM FLOWS

```
Agent starts working on repo
  → Reads AGENTS.md
  → Understands structure, conventions, test commands
  → Follows links to deeper docs when needed
  → Produces conformant output
```

## 7. SCOPE & BOUNDARIES

### 7.1 In Scope

- New file: `AGENTS.md` at repo root
- Content: repo structure, `tools/` convention, `scripts/` convention, testing, license headers, doc references

### 7.2 Out of Scope

- [OUT] Creating the `tools/` directory (GH-26)
- [OUT] Modifying existing docs
- [OUT] CI pipeline changes
- [OUT] Pre-commit hook installation

### 7.3 Deferred / Maybe-Later

- Test aggregator script (`scripts/test-all.sh`) — document the convention now, implement when needed
- Quality gate command documentation — covered by `.opencode/README.md`

## 8. INTERFACES & INTEGRATION CONTRACTS

### 8.1 REST / HTTP Endpoints

N/A — documentation-only change.

### 8.2 Events / Messages

N/A

### 8.3 Data Model Impact

N/A

### 8.4 External Integrations

N/A

### 8.5 Backward Compatibility

No backward compatibility concerns. This is a new file.

## 9. NON-FUNCTIONAL REQUIREMENTS (NFRs)

| ID | Requirement | Threshold |
|----|-------------|-----------|
| NFR-1 | File length | ≤ 200 lines (concise and scannable) |
| NFR-2 | No content duplication | Zero duplicated paragraphs from linked docs |
| NFR-3 | Markdown rendering | Valid GitHub-flavored Markdown, renders correctly on GitHub |

## 10. TELEMETRY & OBSERVABILITY REQUIREMENTS

N/A — documentation-only change.

## 11. RISKS & MITIGATIONS

| ID | Risk | Impact | Probability | Mitigation | Residual Risk |
|----|------|--------|-------------|------------|---------------|
| RSK-1 | AGENTS.md becomes stale as repo evolves | M | M | Keep it concise with links rather than inline detail; `.opencode/README.md` convention §20 already says "update this file when changing workflows" | Low — small surface area |

## 12. ASSUMPTIONS

- AI coding agents (Claude Code, Copilot, etc.) look for `AGENTS.md` at the repo root as a convention.
- The `tools/` directory convention described here will be followed by GH-26 and future tool work.
- The license header format matches what `scripts/add-header-location.sh` currently produces.

## 13. DEPENDENCIES

| Direction | Item | Notes |
|-----------|------|-------|
| Blocks | GH-26 (text-to-image toolbox) | GH-26 should follow the `tools/` convention documented here |
| Reads | `scripts/add-header-location.sh` | License header convention is derived from this script's behavior |

## 14. OPEN QUESTIONS

No open questions.

## 15. DECISION LOG

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| DEC-1 | Document `tools/` convention before the directory exists | Establishes standard so GH-26 can follow it from day one | 2026-03-07 |
| DEC-2 | Use link-not-duplicate pattern for detailed docs | Keeps AGENTS.md small and avoids sync burden | 2026-03-07 |
| DEC-3 | Include ADOS markdown frontmatter (copyright header) on AGENTS.md itself | Dogfooding the convention the file documents | 2026-03-07 |

## 16. AFFECTED COMPONENTS (HIGH-LEVEL)

| Component | Impact |
|-----------|--------|
| Repo root | New file `AGENTS.md` |

## 17. ACCEPTANCE CRITERIA

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F1-1 | Given the repo root, when an agent or contributor reads `AGENTS.md`, then it exists and is valid Markdown | F-1 |
| AC-F2-1 | Given `AGENTS.md`, when the reader looks for `tools/` convention, then the file documents: PATH-able CLI utilities, no `.sh` extension, MIT licensed, tests in `tools/.tests/` | F-2 |
| AC-F3-1 | Given `AGENTS.md`, when the reader looks for `scripts/` convention, then the file documents: repo-internal automation, `.sh` extension, tests in `scripts/.tests/` | F-3 |
| AC-F4-1 | Given `AGENTS.md`, when the reader needs to run tests, then the file documents the test file pattern (`test-*.sh`) and test directory locations | F-4 |
| AC-F5-1 | Given `AGENTS.md`, when the reader needs to add a license header, then the file documents the three-line convention (copyright, MIT, latest-version URL) and references `scripts/add-header-location.sh` | F-5 |
| AC-F6-1 | Given `AGENTS.md`, when the reader needs deeper information, then the file links to `.opencode/README.md`, `.ai/rules/bash.md`, `doc/guides/change-lifecycle.md`, and `doc/guides/unified-change-convention-tracker-agnostic-specification.md` without duplicating their content | F-6 |
| AC-NFR1-1 | Given `AGENTS.md`, when its line count is measured, then it is ≤ 200 lines | NFR-1 |

## 18. ROLLOUT & CHANGE MANAGEMENT (HIGH-LEVEL)

Merge to main. No rollout steps — file is immediately available to all agents and contributors.

## 19. DATA MIGRATION / SEEDING (IF APPLICABLE)

N/A

## 20. PRIVACY / COMPLIANCE REVIEW

N/A — no PII or sensitive data.

## 21. SECURITY REVIEW HIGHLIGHTS

N/A — documentation-only change, no code execution.

## 22. MAINTENANCE & OPERATIONS IMPACT

- AGENTS.md should be updated when new top-level conventions are introduced (e.g., new `tools/` or `scripts/` patterns).
- The file links to other docs, so broken-link risk is minimal (all links are repo-relative).

## 23. GLOSSARY

| Term | Definition |
|------|------------|
| AGENTS.md | Convention file at repo root that AI coding agents read to understand project conventions |
| tools/ | Directory for PATH-able CLI utilities (no `.sh` extension) |
| scripts/ | Directory for repo-internal automation scripts (`.sh` extension) |
| License header | Three-line YAML frontmatter block with copyright, MIT license, and latest-version URL |

## 24. APPENDICES

### A. Example AGENTS.md structure (indicative)

```
---
# Copyright (c) 2025-2026 ...
# MIT License ...
# Latest version: ...
---

# AGENTS.md

## Repo structure
## tools/ convention
## scripts/ convention
## Running tests
## License headers
## Key references
```

## 25. DOCUMENT HISTORY

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-07 | spec-writer | Initial spec |

---

## AUTHORING GUIDELINES

- Used only planning context from the user's change planning summary
- All deep-topic details link to existing docs rather than being duplicated
- Acceptance criteria reference functional capabilities and use Given/When/Then
- NFRs include measurable thresholds

## VALIDATION CHECKLIST

- [x] `change.ref` matches provided `workItemRef` (GH-27)
- [x] `owners` has at least one entry
- [x] `status` is "Proposed"
- [x] All sections present in spec_structure order
- [x] ID prefixes consistent (F-, AC-, NFR-, RSK-, DEC-)
- [x] Acceptance criteria reference at least one F-/NFR- ID
- [x] NFRs include measurable values
- [x] Risks include Impact & Probability
- [x] No implementation details (file paths for code, step-by-step tasks)
- [x] No content duplicated from linked docs
