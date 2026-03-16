---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/feedback/red-team-report-v1.md
---
# Red Team Collective Assessment — GH-32: Bootstrap + Onboarding + Consistency

**Date:** 2026-03-11
**Review Panel:** 8 specialists (CEO, Product Manager, Customer Success, Technical Writer, CTO, UX Designer, QA Engineer, Security Officer)
**Material:** Change spec, implementation plan, test plan, PM notes, and all delivered artifacts (bootstrapper agent, onboarding guide, decision records standard, templates, documentation fixes)

---

## Overall Verdict: CONCERNS

GH-32 is a strategically essential, well-architected change that transforms ADOS from an internal tool into an adoptable framework. The 5-part scope is coherent, the delivery order is correct, and the bootstrapper design is thoughtful. However, **22 findings across 8 reviewers** — including 4 consensus findings flagged by 3+ reviewers — reveal a pattern of "last mile" gaps that would undermine the very adoption goal this change serves. None are individually blocking, but together they create a trust and friction problem for first-time adopters.

**Recommendation:** Address the 10 prioritized action items below (estimated 4-6 hours of work) before presenting this as the canonical onboarding experience. The core infrastructure is solid — the gaps are in messaging, consistency, and defensive hardening.

---

## 1. Consensus Findings (flagged by 3+ reviewers — highest confidence)

### CF-1: Template Count Discrepancy — Spec Says 6, Reality Is 7

**Flagged by:** QA Engineer, Product Manager, CTO, UX Designer, CEO (5 reviewers)

- **What:** The spec (F-10, AC-F10-1), test plan (TC-TMPL-001), and `doc/00-index.md` all say "exactly 6 templates." The repo contains 7 (`north-star-template.md` was added post-delivery). The `doc/templates/README.md` correctly lists 7.
- **Impact:** TC-TMPL-001 will fail on first execution (expects 7 files, finds 8). AC-F10-1 is technically failing. This is ironic — a consistency discrepancy in a change specifically designed to eliminate consistency discrepancies.
- **Action:** Update AC-F10-1 to "exactly 7 templates," add `north-star-template.md` to the explicit list. Update TC-TMPL-001 expected count to 8. Add `north-star-template.md` to `doc/00-index.md` Templates table. Update spec status from `Proposed` to `Delivered`.

### CF-2: AGENTS.md Repo Structure Tree Is Stale Post-GH-32

**Flagged by:** Product Manager, Technical Writer, UX Designer (3 reviewers)

- **What:** The `AGENTS.md` "Repo structure" section (lines 140-161) omits `doc/overview/`, `doc/templates/`, `doc/decisions/`, `doc/00-index.md`, and `doc/planning/` — all created by this change.
- **Impact:** `AGENTS.md` is the first file every AI agent reads. An outdated tree means agents won't know these directories exist, defeating the discoverability goal. Also undermines G-3 (self-hosting integrity).
- **Action:** Update the `doc/` subtree in `AGENTS.md` to reflect the actual post-GH-32 structure including all new directories.

### CF-3: Onboarding Guide Missing ADOS Repository URL / Acquisition Step

**Flagged by:** Product Manager, Customer Success, CEO (3 reviewers)

- **What:** The onboarding guide repeatedly says "copy from the ADOS repository" but never provides the repository URL, a `git clone` command, or a download link. External adopters — the primary audience — have no way to get the files.
- **Impact:** This is the single most likely point of abandonment for a first-time adopter. The guide's stated goal is "frictionless adoption" but the very first action is unguided.
- **Action:** Add a "Getting ADOS" section before Step 1 with the canonical GitHub URL and a `git clone --depth=1` one-liner. Alternatively, promote `/bootstrap` as the primary path that handles file acquisition automatically.

### CF-4: `/bootstrap` Buried as "Step 5 (Alternative)" — Should Be Primary Path

**Flagged by:** UX Designer, Customer Success, CEO (3 reviewers)

- **What:** The onboarding guide presents the automated `/bootstrap` path as Step 5 after 4 manual steps. First-time users following the guide linearly will commit to the manual path before learning the automated one exists.
- **Impact:** The majority of new adopters will follow the harder path by default, undermining the change's primary goal of frictionless adoption.
- **Action:** Restructure the guide to present a path-selection decision point immediately after prerequisites: "Automated (recommended): Run `/bootstrap`" vs. "Manual (for full control): Follow Steps 1-5." Make `/bootstrap` the default recommendation.

---

## 2. Critical Findings by Domain

### Security (3 findings)

**SEC-1: Bootstrapper Repo Scan Has No Prompt Injection Defense** (Security Officer — HIGH)
- The bootstrapper reads arbitrary files from target repos during Phase 1 with no trust boundary declaration. A malicious repo could embed prompt injection payloads that manipulate the agent's behavior.
- **Action:** Add an explicit `<trust_boundary>` section to the bootstrapper prompt declaring all scanned content as untrusted input.

**SEC-2: "No Secrets" Constraint Is Unenforceable** (Security Officer — HIGH)
- The prohibition against storing secrets in the state file relies solely on prompt instruction. During the interview phase, users might paste API tokens or credentials. No programmatic validation exists.
- **Action:** Add interview-phase guidance to warn users about secrets. Add a post-write scan for common credential patterns (`ghp_`, `sk-`, `xoxb-`, `AKIA`, `Bearer`).

**SEC-3: No Write Path Allowlist for Bootstrapper** (Security Officer — HIGH)
- The bootstrapper has `mode: all` (full filesystem access) with no allowlist of permitted write paths. Combined with SEC-1, this creates a viable attack chain.
- **Action:** Add an explicit `<write_allowlist>` to the bootstrapper prompt constraining writes to known ADOS artifact paths.

### Documentation Quality (3 findings)

**DOC-1: `yaml` Code-Block Label on Markdown Content** (Technical Writer — HIGH)
- The onboarding guide's pm-instructions examples use ` ```yaml ` for content that is actually Markdown. Users copying this will create broken config files.
- **Action:** Change to ` ```markdown ` and add a note that the file is Markdown, not YAML.

**DOC-2: Broken Relative Link to `@architect` Agent** (Technical Writer, UX Designer — HIGH)
- `doc/guides/decision-records-management.md` line 257 links to `.opencode/agent/architect.md` — resolves to a non-existent path from `doc/guides/`.
- **Action:** Fix to `../../.opencode/agent/architect.md`.

**DOC-3: AGENTS.md `architect` Description Is Stale** (Technical Writer — HIGH)
- Still says "ADR authoring" but GH-32 expanded to 5 decision types. `/write-adr` command description is also ADR-specific.
- **Action:** Update to reflect all decision types.

### Quality Assurance (3 findings)

**QA-1: Two Modified Files Have Zero Test Coverage** (QA Engineer — CRITICAL)
- `pm.md` and `plan-change.md` were modified but have no positive test coverage. The `@pm` agent is the orchestrator of the entire 10-phase workflow.
- **Action:** Add TC-DREC-005 and TC-DREC-006 for positive verification of `doc/decisions/` references.

**QA-2: NFR-4 (State Resilience) Is Untestable as Written** (QA Engineer — HIGH)
- No test verifies actual resume behavior from a pre-existing state file. The bootstrapper's core value proposition is untested.
- **Action:** Add TC-BOOT-006: manual smoke test with pre-populated state file.

**QA-3: Ghost Reference Sweep Has False Positive Risk** (QA Engineer — HIGH)
- `doc/spec/features/feature-decision-records.md` contains descriptive references to `doc/adr/` that would trigger false failures in TC-NFR-001.
- **Action:** Update TC-NFR-001 to exclude `doc/spec/` or document acceptable descriptive matches.

### Product & Strategy (3 findings)

**PROD-1: README.md Still Positions ADOS as Personal Project** (CEO — HIGH)
- The README — the #1 conversion surface — still reads as "I use this repo to..." with no "Get Started" CTA, no mention of `/bootstrap`, and pre-GH-32 agent/command counts.
- **Action:** Elevate README update from post-merge afterthought to in-scope deliverable. Add prominent "Get Started" section.

**PROD-2: No "Time to First Value" Metric** (CEO, Customer Success — HIGH)
- No time estimate for setup, no "what to expect" section, no success benchmark. IT organizations evaluate tools by time-to-value.
- **Action:** Add "What to expect" callout: "Manual setup: ~30 min. Automated bootstrap: ~15 min. First change: ~1 hour."

**PROD-3: OpenCode Platform Lock-in Is Understated** (CEO — HIGH)
- The system is built on `.opencode/` conventions but the onboarding guide implies compatibility with Cursor/Windsurf. This creates trust issues.
- **Action:** Make a deliberate positioning decision: either explicitly position as OpenCode-native or create a compatibility guide.

---

## 3. Conflicts and Tensions

### Tension 1: Bootstrapper Model Cost vs. Accessibility

- **CTO** notes `anthropic/claude-opus-4-6` is appropriate for the bootstrapper's complexity.
- **CEO** and **Customer Success** flag that Opus is the most expensive model, creating a cost barrier for new adopters.
- **Resolution:** Keep Opus as default (the bootstrapper genuinely needs it), but document minimum model requirements in the onboarding guide and note approximate token cost for a typical bootstrap run. Consider a follow-up to test whether Sonnet suffices for scan/interview phases.

### Tension 2: Decision Records — 5 Types vs. Adoption Simplicity

- **CTO** says 5 types is the right granularity for the standard taxonomy.
- **UX Designer** and **CEO** say 5 types upfront overwhelms new adopters.
- **Resolution:** Keep all 5 types in the standard (they're correct), but restructure the guide to lead with "Quick Start: ADR only" and progressively disclose the full taxonomy. This is a content ordering fix, not a content removal.

### Tension 3: `subtask: false` — Security Isolation vs. UX Continuity

- **Security Officer** notes `subtask: false` shares full conversation context, which could include sensitive information.
- **CTO** confirms `subtask: false` is correct for multi-session workflows needing main context.
- **Resolution:** Keep `subtask: false` (the UX requirement is real), but add the write path allowlist (SEC-3) and trust boundary (SEC-1) to limit blast radius.

---

## 4. Prioritized Action Items

| # | Action | Domain | Impact | Effort | Addresses |
|---|--------|--------|--------|--------|-----------|
| 1 | **Add trust boundary + write path allowlist to bootstrapper prompt** | Security | Highest — closes prompt injection + arbitrary write attack chain | 30 min | SEC-1, SEC-3 |
| 2 | **Fix template count: update spec AC-F10-1 to 7, update TC-TMPL-001, update `doc/00-index.md`** | Quality | High — test will fail on first execution without this | 15 min | CF-1 |
| 3 | **Update AGENTS.md repo structure tree** to include new directories | Consistency | High — agents read this first; stale tree defeats discoverability | 15 min | CF-2 |
| 4 | **Add ADOS repository URL + acquisition step** to onboarding guide | Adoption | High — external adopters can't start without this | 15 min | CF-3 |
| 5 | **Restructure onboarding guide: `/bootstrap` as primary path** upfront, manual as alternative | Adoption | High — most adopters will follow the wrong path otherwise | 30 min | CF-4 |
| 6 | **Fix `yaml` → `markdown` code-block labels** in onboarding guide pm-instructions examples | Documentation | High — every adopter who copies this gets a broken config | 5 min | DOC-1 |
| 7 | **Fix broken relative link** to `@architect` in decision-records-management.md | Documentation | Medium — broken link in a guide about documentation trust | 2 min | DOC-2 |
| 8 | **Add missing test coverage** for `pm.md` and `plan-change.md` (TC-DREC-005/006) | Quality | Medium — highest-blast-radius agent has no positive test | 10 min | QA-1 |
| 9 | **Add "no secrets" interview guidance + credential pattern scan** to bootstrapper | Security | Medium — users will paste tokens during tracker setup | 20 min | SEC-2 |
| 10 | **Add "What to expect" time estimates** to onboarding guide | Adoption | Medium — IT orgs evaluate by time-to-value | 10 min | PROD-2 |

**Total estimated effort for top 10 items: ~2.5 hours**

### Follow-up Items (post-merge, tracked as new tickets)

| Item | Suggested Ticket | Priority |
|------|-----------------|----------|
| README.md rewrite for external adoption positioning | GH-34 | High |
| OpenCode platform dependency — positioning decision | GH-35 | High |
| Bootstrapper state schema versioning + validation | GH-36 | Medium |
| Template-prompt version alignment mechanism | GH-37 | Medium |
| Bootstrapper reset/abort capability (`/bootstrap --reset`) | GH-38 | Medium |
| Team adoption guide (parallel-running, pilot approach) | GH-39 | Medium |
| Linear + "no tracker" pm-instructions examples | GH-40 | Low |
| Competitive positioning section in README | GH-41 | Low |
| "Removing ADOS" rollback guide | GH-42 | Low |
| Bootstrapper resume smoke test (TC-BOOT-006) | GH-43 | Low |
| `/write-adr` front-matter key alignment (`adr:` → `decisions:`) | GH-44 | Medium |
| `/write-adr` ID generation bug (PDR gets `ADR-` prefix) | GH-45 | Medium |
| `doc/planning/` — add to Handbook §3 or remove | GH-46 | Low |
| `doc/quality/` — add to `doc/00-index.md` and AGENTS.md | GH-47 | Low |
| Jira transition ID placeholders — replace hardcoded values | GH-48 | Low |
| Decision records guide — add "Quick Start: ADR only" section | GH-49 | Medium |
| Onboarding guide — "Verify Your Setup" checklist | GH-50 | Medium |
| Bootstrapper — `.gitignore` verification for `.ai/local/` | GH-51 | Medium |
| Bootstrapper — pre-existing artifact detection + overwrite UX | GH-52 | Medium |

---

## 5. Coverage Gaps

| Area | Gap | Risk |
|------|-----|------|
| **Prompt engineering** | No dedicated prompt engineering reviewer exists on the panel. Bootstrapper interview logic quality assessed by CTO but not by a prompt specialist. | Low — CTO review is adequate for v1 |
| **Developer experience** | No dedicated DX reviewer. Covered partially by Customer Success and UX. | Low — the combined perspective is sufficient |
| **Real-world adoption testing** | No reviewer tested the bootstrapper on an actual external project. All reviews are document-level. | Medium — the bootstrapper's real-world behavior is untested |
| **Model compatibility** | No reviewer assessed whether the bootstrapper works with non-Opus models or non-Anthropic providers. | Medium — affects adoption breadth |

---

## 6. Reviewer Verdicts Summary

| Reviewer | Verdict | Key Concern |
|----------|---------|-------------|
| CEO | APPROVE | README.md is the front door — update it |
| Product Manager | CONCERNS | Template count drift, missing acquisition URL, stale AGENTS.md tree |
| Customer Success | CONCERNS | "Last mile" gaps: no time estimate, no acquisition step, no team transition guide |
| Technical Writer | CONCERNS | `yaml` code-block label, broken link, stale descriptions |
| CTO | APPROVE with CONCERNS | State management fragility, template-prompt drift risk |
| UX Designer | CONCERNS | `/bootstrap` buried as Step 5, dual-path confusion |
| QA Engineer | CONCERNS | TC-TMPL-001 will fail, two modified files untested |
| Security Officer | CONCERNS | No trust boundary on repo scan, unenforceable "no secrets" constraint |

**Consensus:** 6 CONCERNS, 2 APPROVE (with concerns). No BLOCK verdicts.

---

## 7. Bottom Line

GH-32 is the right change at the right time — it's the inflection point from "internal tool" to "adoptable framework." The execution is thorough: 5 well-sequenced parts, 16 functional capabilities, 26 acceptance criteria, and a thoughtful bootstrapper design. The core infrastructure is solid.

**The gap is not in what was built, but in how it presents itself.** The onboarding guide buries the automated path, omits the acquisition URL, and uses wrong code-block labels. The AGENTS.md — the first file every agent reads — doesn't reflect the new directories. The spec has a template count that doesn't match reality. The bootstrapper lacks basic security hardening (trust boundary, write allowlist).

**Fix the 10 prioritized items (~2.5 hours of work) and this change delivers on its promise of making ADOS a product that any IT organization wants to adopt.** The follow-up items (README rewrite, team adoption guide, competitive positioning) are the next wave that turns "adoptable" into "irresistible."
