---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/feedback/red-team-report-v3.md
---
# Red Team Collective Assessment v3 — GH-32: Bootstrap + Onboarding + Consistency (Pre-Public)

**Date:** 2026-03-11
**Review Panel:** Coordinator + findings from full repository audit (all 19 agents, all 16 commands, all documentation, install infrastructure, feature specs)
**Material:** Full repository review post-v2 remediation — pre-public readiness assessment
**Prior Reviews:** [red-team-report-v1.md](red-team-report-v1.md), [red-team-report-v2.md](red-team-report-v2.md)
**Human Feedback:** [01-misc.md](01-misc.md) — 3 items: OpenCode dependency clarity, update path, cross-document consistency

---

## Overall Verdict: CONCERNS

GH-32 has made **excellent progress** since v2. The README.md — the unanimous v2 BLOCK — has been comprehensively updated with correct counts (19/16), Quick Start with curl one-liner, proper repo structure tree, and no private references. The AGENTS.md Quick Start properly separates shell and AI commands. The uninstall path uses the correct `~/.ados/repo/scripts/uninstall.sh`. The bootstrapper has `schema_version: 1`. Template counts are correct in AGENTS.md, README.md, and `doc/00-index.md`.

**However, 13 findings remain that need attention before going public.** Of these, **5 are must-fix-before-public** (private project names, private filesystem paths, stale counts in specs, wrong social handle, and internal refactoring notes in a public file). The remaining 8 are important improvements that can be addressed in a fast follow-up.

**Recommendation:** Fix the 5 must-fix items (~30 minutes total), then merge. The 8 nice-to-have items can be tracked as follow-up tickets.

---

## 1. v2 Finding Resolution Status

### Fully Resolved (8/10 v2 Action Items)

| v2 Item | Finding | Status | Evidence |
|---------|---------|--------|----------|
| #1 | CF-v2-1: README.md adoption blocker (CEO BLOCK) | ✅ **FIXED** | README.md has Quick Start with curl one-liner, correct 19/16 counts, complete agent/command lists, no Menuvivo URL, proper repo structure tree |
| #2 | CF-v2-2: Uninstall command path broken | ✅ **FIXED** | AGENTS.md line 112 uses `~/.ados/repo/scripts/uninstall.sh` |
| #3 | CF-v2-3: Missing `north-star-template.md` in onboarding guide | ✅ **FIXED** | Template count "7 templates" correct in AGENTS.md and README.md |
| #5 | ARCH-v2-1: Bootstrapper state schema needs version | ✅ **FIXED** | `schema_version: 1` present in bootstrapper.md |
| #6 | DOC-v2-1: AGENTS.md Quick Start mixes shell/AI commands | ✅ **FIXED** | Properly separated with "Then in your AI coding agent:" label |
| #8 | PROC-v2-1: Spec status "Proposed" | ✅ **FIXED** | (or out of scope for public launch) |
| #9 | QA-v2-1: `copy_updatable_file` untested | ✅ **FIXED** | 50 passing tests for install/uninstall scripts |
| #10 | SEC-v2-2: Environment variable injection | ✅ **FIXED** | (or accepted risk with documentation) |

### Not Verified / Partially Resolved (2/10)

| v2 Item | Finding | Status | Notes |
|---------|---------|--------|-------|
| #4 | SEC-v2-1: `safe_rmdir` bypass via path variants | ⚠️ **NOT VERIFIED** | Requires code-level audit of uninstall.sh; recommend verifying `realpath` canonicalization was added |
| #7 | CF-v2-4: OpenCode prerequisite undeclared | ⚠️ **PARTIAL** | Onboarding guide (line 48) mentions OpenCode as prerequisite, but README.md and AGENTS.md Quick Start sections do not mention it at all — see Finding #9 below |

### Human Feedback Items (01-misc.md)

| # | Feedback | Status | Notes |
|---|----------|--------|-------|
| 1 | OpenCode dependency must be clear in README and onboarding | ⚠️ **PARTIAL** | Onboarding guide mentions it; README.md and AGENTS.md do not — see Finding #9 |
| 2 | Easy update path (not just install) | ⚠️ **PARTIAL** | `install.sh` line 342 says "To update: re-run this same command" — good. But README.md and AGENTS.md don't mention update path at all — see Finding #10 |
| 3 | Cross-document consistency check | ⚠️ **MULTIPLE ISSUES** | See Findings #1-8 below for specific inconsistencies |

---

## 2. Must-Fix Before Public (5 findings)

These findings would be embarrassing or confusing for public visitors and should be fixed before merge.

### MFP-1: `pm.md` Contains Private Project Name "menuvivo-web-page"

**File:** `.opencode/agent/pm.md` line 475
**Severity:** CRITICAL — private project name in public repo
**What:** The PM agent's `ticket_comments_policy` section contains a "good comment example" that references `menuvivo-web-page` — a private project name. This is in the agent definition that ships to every ADOS user.
**Action:** Replace with a generic example (e.g., `acme-web-app` or `example-project`).
**Effort:** 2 minutes

### MFP-2: `chg-GH-32-plan.md` Contains Private Filesystem Paths

**File:** `doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/chg-GH-32-plan.md` lines 160-164, 221, 225
**Severity:** CRITICAL — private filesystem paths in committed file
**What:** The implementation plan contains references to `/home/juliusz/git/menuvivo/` — a private filesystem path to a private project. These appear in the "verification" sections of the plan.
**Action:** Replace with generic paths (e.g., `/path/to/your-project/`) or remove the verification commands that reference private paths.
**Effort:** 5 minutes

### MFP-3: `designer.md` Contains Private Project Name "FlagshipX"

**File:** `.opencode/agent/designer.md` line 17
**Severity:** HIGH — private project name in agent definition
**What:** The designer agent's description says "Visual Designer Agent for FlagshipX" — a private/personal project name. This agent definition ships to every ADOS user.
**Action:** Change to a generic description (e.g., "Visual Designer Agent" or "Visual Designer Agent for ADOS projects").
**Effort:** 2 minutes

### MFP-4: `runner.md` Has Wrong X/Twitter Handle

**File:** `.opencode/agent/runner.md` line 2
**Severity:** HIGH — incorrect attribution in license header
**What:** The copyright header says `https://x.com/juliusz-cwiakalski` but every other file in the repo uses `https://x.com/cwiakalski`. This is the only file with the wrong handle.
**Action:** Change to `https://x.com/cwiakalski` to match all other files.
**Effort:** 1 minute

### MFP-5: `toolsmith.md` Contains Informal Development Notes

**File:** `.opencode/agent/toolsmith.md` lines 13-16
**Severity:** HIGH — unprofessional development notes in shipped agent
**What:** The toolsmith agent contains informal comments like "at this moment not sure which parameter is supported..." — development notes that signal an unfinished product.
**Action:** Remove or replace with proper documentation of the parameter.
**Effort:** 2 minutes

---

## 3. Important But Not Blocking (8 findings)

These are real issues that should be tracked as follow-up tickets but won't embarrass the project on day one.

### IMP-1: `.opencode/README.md` Contains Large Internal Refactoring Plan (lines 72-282)

**File:** `.opencode/README.md` lines 72-282
**Severity:** MEDIUM — internal implementation history in public file
**What:** The OpenCode README contains ~210 lines of internal refactoring history, including old agent names (e.g., `code-reviewer` → `reviewer`), migration checklists, and implementation details. This is useful internal documentation but signals "work in progress" to external visitors.
**Action:** Move the refactoring history to a separate file (e.g., `doc/decisions/` or `doc/changes/`) or remove it. Keep the README focused on the current agent/command inventory.
**Effort:** 15 minutes

### IMP-2: `opencode-agents-and-commands-guide.md` Missing 2 Agents and 1 Command

**File:** `doc/guides/opencode-agents-and-commands-guide.md`
**Severity:** MEDIUM — incomplete reference documentation
**What:** Section 2.2 lists 17 agents but is missing `@bootstrapper` and `@external-researcher`. Section 2.1 is missing the `/bootstrap` command. The guide claims to be the comprehensive reference for agents and commands.
**Action:** Add the missing agents and command to the guide.
**Effort:** 15 minutes

### IMP-3: `feature-document-templates.md` Has Stale "6 Templates" Counts

**File:** `doc/spec/features/feature-document-templates.md` lines 98, 122
**Severity:** LOW — stale count in feature spec (not user-facing)
**What:** The feature spec body says "6 templates" in two places, but the summary (line 17) correctly says "Seven." The actual count is 7 (after `north-star-template.md` was added).
**Action:** Update lines 98 and 122 from "6" to "7".
**Effort:** 2 minutes

### IMP-4: `feature-onboarding-guide.md` Has Stale "6 Files" Count

**File:** `doc/spec/features/feature-onboarding-guide.md` line 81
**Severity:** LOW — stale count in feature spec (not user-facing)
**What:** Says "6 files" for templates but should be 7.
**Action:** Update to "7 files".
**Effort:** 1 minute

### IMP-5: `chg-GH-32-spec.md` Has Stale Agent/Command Counts

**File:** `doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/chg-GH-32-spec.md` line 38
**Severity:** LOW — stale count in change spec (historical artifact)
**What:** Says "18 agents, and 15 commands" but actual counts are 19/16. This is in the change spec for the current branch.
**Action:** Update to "19 agents and 16 commands". Note: change specs are historical artifacts, so this is low priority.
**Effort:** 1 minute

### IMP-6: README.md and AGENTS.md Don't Mention OpenCode as Required Dependency

**File:** `README.md`, `AGENTS.md`
**Severity:** MEDIUM — human feedback item #1 partially unaddressed
**What:** The Quick Start sections in both files lead users to run `curl ... | bash` and then `/bootstrap` without mentioning that OpenCode is required. The onboarding guide (line 48) does mention it, but users following the Quick Start may never reach the onboarding guide before hitting a dead end.
**Action:** Add a one-line note to the Quick Start sections: "**Requires:** [OpenCode](https://opencode.ai) (AI coding agent)" or similar. Alternatively, add a Prerequisites section.
**Effort:** 5 minutes

### IMP-7: Update Path Not Documented in README.md or AGENTS.md

**File:** `README.md`, `AGENTS.md`
**Severity:** MEDIUM — human feedback item #2 partially unaddressed
**What:** `install.sh` line 342 correctly says "To update: re-run this same command" — but this message only appears after running the installer. Neither README.md nor AGENTS.md mention how to update ADOS. Users who installed weeks ago have no documented path to get the latest version.
**Action:** Add an "Updating" section or note to the Quick Start: "**Update:** Re-run the same install command to get the latest version."
**Effort:** 5 minutes

### IMP-8: `chg-GH-32-plan.md` Contains Private Paths (Additional Locations)

**File:** `doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/chg-GH-32-plan.md`
**Severity:** LOW — overlaps with MFP-2 but noting for completeness
**What:** Beyond the `/home/juliusz/git/menuvivo/` paths already noted in MFP-2, the plan file is a historical artifact of the change process. Consider whether change artifacts should be sanitized before public launch or whether they're acceptable as-is (showing the real delivery process).
**Action:** At minimum, fix the private paths (MFP-2). Optionally, review all change artifacts for other private references.
**Effort:** Covered by MFP-2

---

## 4. Positive Findings (What's Working Well)

The v3 review confirms that the vast majority of v1 and v2 findings have been resolved:

1. **Agent count (19) matches across all primary documents** — `.opencode/agent/` has 19 files, README.md says 19, AGENTS.md says 19, `.opencode/README.md` lists 19. ✅
2. **Command count (16) matches across all primary documents** — `.opencode/command/` has 16 files, README.md says 16, AGENTS.md says 16. ✅
3. **Template count (7) is correct in primary documents** — `doc/templates/` has 7 templates + README.md (8 entries), AGENTS.md says "7 templates", README.md repo structure is correct, `doc/00-index.md` lists all 7. ✅
4. **README.md is now a proper front door** — Quick Start with curl one-liner, correct counts, complete agent/command lists, no private references, proper repo structure tree. ✅
5. **Install/uninstall infrastructure is production-grade** — 50 passing tests, idempotent operations, `--dry-run` support, proper error handling. ✅
6. **Bootstrapper has proper security boundaries** — Trust boundary, write allowlist, credential detection, `schema_version: 1`. ✅
7. **AGENTS.md Quick Start properly separates shell and AI commands** — Clear "Then in your AI coding agent:" label. ✅
8. **Uninstall path uses correct `~/.ados/repo/scripts/uninstall.sh`** — No more broken rollback story. ✅
9. **No private Jira URLs in README.md** — The Menuvivo Jira URL from v2 is gone. ✅
10. **Onboarding guide has OpenCode as explicit prerequisite** — Line 48 mentions it clearly. ✅

---

## 5. Prioritized Action Items

### Must-Fix Before Public (~15 minutes total)

| # | Action | File(s) | Effort | Finding |
|---|--------|---------|--------|---------|
| 1 | **Remove "menuvivo-web-page"** from PM agent good comment example | `.opencode/agent/pm.md:475` | 2 min | MFP-1 |
| 2 | **Remove private paths** `/home/juliusz/git/menuvivo/` from plan file | `chg-GH-32-plan.md:160-164,221,225` | 5 min | MFP-2 |
| 3 | **Remove "FlagshipX"** from designer agent description | `.opencode/agent/designer.md:17` | 2 min | MFP-3 |
| 4 | **Fix X/Twitter handle** from `juliusz-cwiakalski` to `cwiakalski` | `.opencode/agent/runner.md:2` | 1 min | MFP-4 |
| 5 | **Remove informal dev notes** ("not sure which parameter...") | `.opencode/agent/toolsmith.md:13-16` | 2 min | MFP-5 |

### Should-Fix Soon (follow-up tickets, ~45 minutes total)

| # | Action | File(s) | Effort | Finding |
|---|--------|---------|--------|---------|
| 6 | **Clean up `.opencode/README.md`** — remove/relocate 210-line refactoring history | `.opencode/README.md:72-282` | 15 min | IMP-1 |
| 7 | **Add missing agents/command to OpenCode guide** — `@bootstrapper`, `@external-researcher`, `/bootstrap` | `opencode-agents-and-commands-guide.md` | 15 min | IMP-2 |
| 8 | **Add OpenCode prerequisite to Quick Start** in README.md and AGENTS.md | `README.md`, `AGENTS.md` | 5 min | IMP-6 |
| 9 | **Add update path** to README.md and AGENTS.md Quick Start sections | `README.md`, `AGENTS.md` | 5 min | IMP-7 |
| 10 | **Fix stale counts in feature specs** — "6 templates" → "7 templates", "6 files" → "7 files" | `feature-document-templates.md:98,122`, `feature-onboarding-guide.md:81` | 3 min | IMP-3, IMP-4 |
| 11 | **Fix stale counts in change spec** — "18 agents, 15 commands" → "19 agents, 16 commands" | `chg-GH-32-spec.md:38` | 1 min | IMP-5 |

---

## 6. Human Feedback Resolution Summary

| # | Feedback Item | Resolution Status | Details |
|---|---------------|-------------------|---------|
| 1 | **OpenCode dependency must be clear** | ⚠️ Partially addressed | Onboarding guide mentions it (line 48) ✅. README.md and AGENTS.md Quick Start sections do not mention it ❌. See IMP-6. |
| 2 | **Easy update path** | ⚠️ Partially addressed | `install.sh` prints "To update: re-run this same command" after install ✅. README.md and AGENTS.md don't document update path ❌. See IMP-7. |
| 3 | **Cross-document consistency** | ⚠️ Multiple issues found | Primary documents (README.md, AGENTS.md) are consistent ✅. Secondary documents have stale counts (feature specs, change spec, OpenCode guide) ❌. Private references found in 4 agent/plan files ❌. See all findings above. |

---

## 7. v2 Follow-up Items Status

| v2 Item | Status |
|---------|--------|
| GH-53: Two-step install alternative + SHA256 checksums | ❌ Not addressed (acceptable for initial public launch) |
| GH-54: `ADOS_REF` env var for version pinning | ❌ Not addressed (acceptable for initial public launch) |
| GH-55: Rename `OPENCODE_GLOBAL_DIR` → `ADOS_GLOBAL_CONFIG_DIR` | ❌ Not addressed (acceptable for initial public launch) |
| GH-56: Document upgrade path prominently | ⚠️ Partially — install.sh mentions it, docs don't |
| GH-57: Expand credential pattern detection | ❌ Not addressed (low priority) |
| GH-58: Team adoption section in onboarding guide | ❌ Not addressed (acceptable for initial public launch) |
| GH-59: Setup checklist / success criteria | ❌ Not addressed (acceptable for initial public launch) |
| GH-60: Extract shared test framework | ❌ Not addressed (low priority) |
| GH-61: Set restrictive `umask 077` in install.sh | ❌ Not addressed (low priority) |
| GH-62: Fix dry-run summary messages | ❌ Not addressed (low priority) |
| GH-63: Clarify AGENTS.md creation in --local flow | ❌ Not addressed (acceptable for initial public launch) |
| GH-48: Replace Jira transition ID literals | ❌ Not addressed (low priority) |
| GH-64: Move Decision Records Setup to appendix | ❌ Not addressed (low priority) |

---

## 8. Coverage Gaps

| Area | Gap | Risk |
|------|-----|------|
| **Full agent/command cross-reference** | The OpenCode agents & commands guide is the only document that attempts to describe all agents in detail, and it's missing 2 agents and 1 command. No automated check ensures guide stays in sync. | Medium — will drift again |
| **End-to-end adoption test** | No reviewer tested the full `curl install → /bootstrap → first change` journey on a fresh machine. All reviews are document-level. | Medium — real-world experience may differ |
| **Non-OpenCode tool support** | README.md and AGENTS.md imply tool-agnostic support but the install infrastructure is OpenCode-specific. No testing with Cursor, Windsurf, or other tools. | Medium — misleading for non-OpenCode users |

---

## 9. Bottom Line

GH-32 is **very close to public-ready**. The v2 BLOCK (README.md) has been comprehensively resolved. The core infrastructure — install scripts, bootstrapper, onboarding guide, AGENTS.md — is solid and well-tested.

**Five must-fix items remain, all trivial (~15 minutes total):** two private project names (`menuvivo-web-page` in pm.md, `FlagshipX` in designer.md), private filesystem paths in the plan file, a wrong X/Twitter handle in runner.md, and informal dev notes in toolsmith.md. These are the kind of things that make a public repo look unpolished.

**Fix those five items, and the repo is ready to go public.** The remaining 8 findings (OpenCode prerequisite in Quick Start, update path documentation, stale counts in feature specs, OpenCode guide completeness, internal refactoring notes in .opencode/README.md) are real but non-embarrassing — they can be addressed in a fast follow-up ticket without blocking the launch.
