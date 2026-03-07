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

> **PURPOSE**: Define the `AGENTS.md` file — the bootstrap file at the repo root that orients AI coding agents on the delivery system (process, agent team, commands), how to extend it (via `@toolsmith`), and repo conventions (structure, tools, scripts, testing, license headers).

## 1. SUMMARY

Create `AGENTS.md` at the repository root as the canonical bootstrap for AI agents and contributors. The file leads with the delivery system (10-phase process, 18 agents, 15 commands, autopilot + manual usage), provides extension guidance (delegate to `@toolsmith`, tune agents together, test through the process), and documents repo conventions (tools/, scripts/, testing, license headers) — all without duplicating detailed docs.

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

- **No single entry point**: agents must discover the delivery system, agent team, and conventions across multiple files scattered in `.opencode/`, `.ai/rules/`, and `doc/guides/`.
- **Core value undiscoverable**: the 10-phase delivery process, 18-agent team, and 15 commands are documented in detail but have no concise bootstrap summary at the repo root.
- **No extension guidance**: agents modifying the OS have no documented principles (delegate to `@toolsmith`, tune agents together, check contracts, test through the process).
- **Undocumented `tools/` convention**: the intended `tools/` directory (PATH-able CLI utilities, no `.sh` extension, MIT licensed) is not documented anywhere yet.
- **Undocumented `scripts/` convention**: while `scripts/` exists with `add-header-location.sh`, the convention is implicit.

## 3. PROBLEM STATEMENT

Without `AGENTS.md`, AI agents lack a fast, authoritative bootstrap file that conveys what this repo IS (an autonomous delivery OS), how the delivery process works, and how to extend the system correctly — leading to inconsistent outputs, missed quality bars, and agents treating the repo as a generic code project rather than a delivery system whose prompts are production artifacts.

## 4. GOALS

- **G-1**: Provide a single-file bootstrap that orients agents on the delivery system (process, team, commands).
- **G-2**: Convey the quality bar: agent prompts ARE the product; modifications require `@toolsmith`.
- **G-3**: Provide extension guidance so agents evolve the OS in the right direction.
- **G-4**: Document repo conventions (tools/, scripts/, testing, license headers) as secondary content.
- **G-5**: Link to detailed docs without duplicating content.

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
| F-1 | Mission statement: agent prompts ARE the product, quality compounds | Sets quality bar for every agent working here |
| F-2 | 10-phase delivery process table (phase → agent → what happens) | Core product — agents understand the pipeline they're part of |
| F-3 | Full agent roster (18 agents) grouped by delivery role | Agents know who does what and how they collaborate |
| F-4 | Full command inventory (15 commands) in workflow order | Agents know the interface to the delivery process |
| F-5 | Usage guide: autopilot (`@pm`) and manual workflow modes | Agents know how to drive the system |
| F-6 | Extension guidance: delegate to `@toolsmith`, tune agents together, test through process | Agents evolve the OS correctly |
| F-7 | Change artifact conventions (workItemRef, folders, files, branches) | Agents follow naming standards |
| F-8 | Repo structure with annotated directory tree | Gives agents immediate orientation |
| F-9 | `tools/` and `scripts/` directory conventions | Establishes coding conventions |
| F-10 | Testing and license header conventions | Agents validate changes and apply correct frontmatter |
| F-11 | Key references table linking to all detailed docs | Link-not-duplicate for deep topics |

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
| DEC-1 | Lead with delivery system (process, agents, commands) not repo conventions | AGENTS.md must convey what this repo IS; conventions are secondary | 2026-03-07 |
| DEC-2 | Use link-not-duplicate pattern for detailed docs | Keeps AGENTS.md small and avoids sync burden | 2026-03-07 |
| DEC-3 | Include ADOS markdown frontmatter (copyright header) on AGENTS.md itself | Dogfooding the convention the file documents | 2026-03-07 |
| DEC-4 | Require `@toolsmith` delegation for agent/command modifications | Quality bar: prompt engineering is specialized work; hand-editing degrades the system | 2026-03-07 |
| DEC-5 | Include "Extending the system" section with design principles | Agents need a compass (not just a map) to evolve the OS correctly | 2026-03-07 |

## 16. AFFECTED COMPONENTS (HIGH-LEVEL)

| Component | Impact |
|-----------|--------|
| Repo root | New file `AGENTS.md` |

## 17. ACCEPTANCE CRITERIA

| ID | Criterion | Linked |
|----|-----------|--------|
| AC-F1-1 | AGENTS.md opens with mission statement conveying: agent prompts ARE the product, quality compounds, delivery process is self-referential | F-1 |
| AC-F2-1 | Documents the 10-phase delivery process with agent-per-phase table | F-2 |
| AC-F3-1 | Lists all 18 agents with roles, grouped by delivery phase | F-3 |
| AC-F4-1 | Lists all 15 commands with purposes | F-4 |
| AC-F5-1 | Documents both autopilot (`@pm deliver GH-456`) and manual workflow modes | F-5 |
| AC-F6-1 | Includes "Extending the system" section with: delegate to `@toolsmith`, tune agents together, check upstream/downstream contracts, test through the delivery process, keep prompts tight | F-6 |
| AC-F7-1 | Documents change artifact conventions: workItemRef format, folder/file naming, branch naming | F-7 |
| AC-F8-1 | Contains annotated repo structure tree showing `.opencode/`, `.ai/`, `scripts/`, `tools/`, `doc/` | F-8 |
| AC-F9-1 | Documents `tools/` convention (PATH-able, no `.sh`, MIT) and `scripts/` convention (repo-internal, `.sh`, `.tests/`) | F-9 |
| AC-F10-1 | Documents test pattern (`test-*.sh`) and license header convention with `add-header-location.sh` | F-10 |
| AC-F11-1 | Key references table links to all detailed docs without duplicating content | F-11 |
| AC-NFR1-1 | File is ≤ 200 lines | NFR-1 |

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
| 1.0 | 2026-03-07 | spec-writer | Initial spec (repo-conventions focus) |
| 2.0 | 2026-03-07 | pm | Scope expansion: delivery-system-first structure, agent team, commands, extension guidance, @toolsmith requirement |

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
