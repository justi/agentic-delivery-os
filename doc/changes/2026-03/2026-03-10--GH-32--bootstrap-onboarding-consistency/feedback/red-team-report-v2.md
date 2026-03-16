---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/changes/2026-03/2026-03-10--GH-32--bootstrap-onboarding-consistency/feedback/red-team-report-v2.md
---
# Red Team Collective Assessment v2 — GH-32: Bootstrap + Onboarding + Consistency

**Date:** 2026-03-11
**Review Panel:** 8 specialists (CEO, Product Manager, Customer Success, Technical Writer, CTO, UX Designer, QA Engineer, Security Officer)
**Material:** Full repository review post-v1 remediation — README.md optimization, install infrastructure, onboarding guide, bootstrapper agent, AGENTS.md, all delivered artifacts
**Prior Review:** [red-team-report-v1.md](red-team-report-v1.md) — 22 findings, 10 prioritized action items

---

## Overall Verdict: CONCERNS

GH-32 has made **substantial progress** since v1. Of the 10 prioritized v1 action items, **8 are fully resolved** — including all 4 consensus findings and all 3 security findings. The install infrastructure (`install.sh`, `uninstall.sh`) is production-grade with 50 passing tests. The onboarding guide is well-structured with time estimates, path selection, and acquisition instructions. The bootstrapper agent has proper trust boundaries and write allowlists.

**However, one critical gap remains: README.md — the #1 conversion surface for any GitHub project — has not been updated.** This was flagged as PROD-1 (HIGH) in v1 and recommended as follow-up ticket GH-34. It is now the **unanimous #1 finding across all 8 reviewers**. The README still says "18 agents" and "15 commands" (actual: 19/16), contains a private Jira URL, uses personal "I use this repo to..." framing, and has no mention of `install.sh`, `/bootstrap`, or the onboarding guide. Every adoption improvement delivered by GH-32 is invisible from the front door.

**Recommendation:** Fix the README.md (~1 hour of work) and the 4 other quick fixes below (~30 minutes total) before considering GH-32's adoption goal met. The core infrastructure is solid — the gap is entirely in presentation and discoverability.

---

## 1. v1 Finding Resolution Status

### Fully Resolved (8/10)

| v1 Item | Finding | Status | Evidence |
|---------|---------|--------|----------|
| #1 | SEC-1 + SEC-3: Trust boundary + write allowlist | ✅ **FIXED** | `bootstrapper.md` lines 225-256: explicit `<trust_boundary>` and `<write_allowlist>` sections |
| #2 | CF-1: Template count (6→7) | ✅ **FIXED** | Spec AC-F10-1 updated; `doc/00-index.md` lists all 7; `doc/templates/` contains 7 files |
| #3 | CF-2: AGENTS.md repo structure tree | ✅ **FIXED** | AGENTS.md lines 159-186 now include all new directories |
| #4 | CF-3: Onboarding guide missing acquisition URL | ✅ **FIXED** | "Getting ADOS" section with curl one-liner and git clone alternative |
| #5 | CF-4: /bootstrap buried as Step 5 | ✅ **FIXED** | "Choose Your Setup Path" decision point upfront; /bootstrap is primary recommended path |
| #6 | DOC-1: yaml code-block labels | ✅ **FIXED** | Changed to `markdown` with clarifying notes |
| #7 | DOC-2: Broken architect link | ✅ **FIXED** | Fixed to `../../.opencode/agent/architect.md` |
| #9 | SEC-2: Credential pattern detection | ✅ **FIXED** | Interview phase checks for `ghp_`, `sk-`, `xoxb-`, `AKIA`, `Bearer`, `token:`, `password:` |

### Partially Resolved (1/10)

| v1 Item | Finding | Status | Notes |
|---------|---------|--------|-------|
| #10 | PROD-2: Time estimates | ✅ **FIXED** | "What to expect" callout added with ~15 min / ~30 min / ~1 hour estimates |

### Not Resolved (1/10)

| v1 Item | Finding | Status | Notes |
|---------|---------|--------|-------|
| — | PROD-1: README.md stale | ❌ **NOT FIXED** | Deferred to GH-34 in v1 but not actioned. Now the unanimous #1 finding across all 8 v2 reviewers. |

### v1 Follow-up Items Status

| v1 Item | Status |
|---------|--------|
| DOC-3: Architect description stale | ✅ **FIXED** — Updated to "architecture decisions and decision record authoring (ADR/PDR/TDR/BDR/ODR)" |
| QA-1: Missing test coverage for pm.md/plan-change.md | ✅ **Out of scope** — correctly deferred; new scripts have 50 tests |
| QA-2: NFR-4 untestable | ✅ **Acknowledged** — NG-4 in spec explicitly defers automated testing |
| QA-3: Ghost reference false positives | ✅ **FIXED** — Test plan excludes `doc/changes/` from grep scope |
| PROD-3: OpenCode lock-in understated | ❌ **NOT FIXED** — Still says "Claude Code with OpenCode, Cursor, Windsurf" with no clarification |
| Jira transition IDs hardcoded | ❌ **NOT FIXED** — Still shows `21`, `31`, `41` as literal values |
| Spec status "Proposed" | ❌ **NOT FIXED** — Should be "Delivered" or "Accepted" |

---

## 2. Consensus Findings (flagged by 2+ reviewers — highest confidence)

### CF-v2-1: README.md Is the #1 Adoption Blocker — Unanimous (8/8 reviewers)

**Flagged by:** CEO (BLOCK), Product Manager, Customer Success, Technical Writer, CTO, UX Designer, QA Engineer, Security Officer

- **What:** README.md — the only file GitHub renders by default — has not been updated for GH-32. It contains:
  - Wrong agent/command counts: says "18 agents" and "15 commands" (actual: 19/16)
  - Missing agents: `@bootstrapper`, `@external-researcher`, `@toolsmith` absent from agent list
  - Missing commands: `/bootstrap`, `/design` absent from command list
  - Personal framing: "I use this repo to evolve and validate..." (line 57-59)
  - Private Jira URL: `menuvivo.atlassian.net/browse/PDEV-29` in autopilot example (line 88)
  - No Quick Start section, no install instructions, no link to onboarding guide
  - Stale repo structure tree: missing `tools/`, `doc/overview/`, `doc/templates/`, `doc/decisions/`, `doc/00-index.md`, `doc/planning/`, `doc/tools/`
- **Impact:** Every visitor to the GitHub repo sees a personal project with stale counts and no path to adoption. All GH-32 improvements (install.sh, onboarding guide, /bootstrap, AGENTS.md Quick Start) are invisible from the front door. The CEO reviewer issued a **BLOCK** verdict solely on this finding.
- **Action:** Update README.md: (1) Add Quick Start section with curl one-liner (mirror AGENTS.md), (2) Fix agent/command counts to 19/16, (3) Add missing agents and commands to lists, (4) Replace Menuvivo Jira URL with generic `GH-456` example, (5) Reframe "Intention" section for external audience, (6) Add link to onboarding guide in "Docs at a glance", (7) Update repo structure tree from AGENTS.md.

### CF-v2-2: Uninstall Command Path Is Broken — (3/8 reviewers)

**Flagged by:** Customer Success, UX Designer, Technical Writer

- **What:** Both AGENTS.md (line 112) and the onboarding guide (line 39) instruct users to run `scripts/uninstall.sh --global` or `scripts/uninstall.sh --local`. After a global install, the user is in their own project directory — not the ADOS repo. The correct path is `~/.ados/repo/scripts/uninstall.sh`.
- **Impact:** A user who wants to try ADOS and then remove it (the "low-risk trial" promise) gets "No such file or directory." This breaks the rollback story at exactly the moment trust matters most.
- **Action:** Change both references to `~/.ados/repo/scripts/uninstall.sh --global` (or `--local`).

### CF-v2-3: Onboarding Guide Template List Missing `north-star-template.md` — (3/8 reviewers)

**Flagged by:** Product Manager, QA Engineer, Technical Writer

- **What:** Section 2.4 of the onboarding guide lists 6 templates but omits `north-star-template.md`. The actual `doc/templates/` directory contains 7 templates. `doc/00-index.md` correctly lists all 7.
- **Impact:** A user following the manual setup path copies 6 of 7 templates. This is the same category of inconsistency GH-32 was designed to eliminate — ironic in a consistency-focused change.
- **Action:** Add `north-star-template.md` to the template list in Section 2.4.

### CF-v2-4: OpenCode Is an Undeclared Prerequisite — (3/8 reviewers)

**Flagged by:** Customer Success, Product Manager, CTO

- **What:** The entire install flow assumes the user has OpenCode installed. The onboarding guide says "AI coding agent that supports ADOS (e.g., Claude Code with OpenCode, Cursor, Windsurf)" but provides no link to install OpenCode, no explanation of what it is, and no guidance on which AI provider/API key is needed. The global install hardcodes `~/.config/opencode/` as the destination — this only works for OpenCode, not Claude Code, Cursor, or Windsurf.
- **Impact:** A user who runs the curl one-liner successfully, then types `/bootstrap` in their terminal gets "command not found." The time-to-AHA-moment becomes infinite for anyone who isn't already an OpenCode user.
- **Action:** (1) Add "Step 0: Install OpenCode" to the onboarding guide with a link. (2) Clarify which tools are actually supported. (3) Consider renaming `OPENCODE_GLOBAL_DIR` to `ADOS_GLOBAL_CONFIG_DIR` to decouple from a specific tool.

---

## 3. Critical Findings by Domain

### Security (3 new findings)

**SEC-v2-1: `safe_rmdir` Bypass via Path Variants** (Security Officer — HIGH)
- `uninstall.sh` line 171 uses exact string comparison against `/` and `$HOME`. Bypassable with `ADOS_HOME="${HOME}/"` (trailing slash), `ADOS_HOME="/home/user/."` (dot suffix), or symlinks. No path canonicalization.
- **Action:** Canonicalize with `realpath -m` before comparison. Add minimum path depth check. Add test cases for bypass vectors.

**SEC-v2-2: Environment Variable Injection Allows Arbitrary Clone URL and Write Targets** (Security Officer — WARNING)
- `install.sh` accepts `ADOS_REPO_URL`, `ADOS_HOME`, `OPENCODE_GLOBAL_DIR` from environment without validation. An attacker who can set env vars can redirect git clone to a malicious repo or overwrite arbitrary files.
- **Action:** Validate `ADOS_REPO_URL` starts with `https://github.com/`. Validate paths are under `$HOME`. Log warnings for non-default values.

**SEC-v2-3: Curl-Pipe Install Lacks Integrity Verification** (Security Officer, CTO — WARNING)
- `curl -fsSL ... | bash` is vulnerable to partial download and MITM. No checksum verification, no version pinning.
- **Action:** Offer two-step alternative (`curl -o install.sh && bash install.sh`). Publish SHA256 checksums for releases. Add `ADOS_REF` env var for version pinning.

### Architecture (2 new findings)

**ARCH-v2-1: Bootstrapper State Schema Has No Version Field** (CTO — HIGH)
- The `bootstrapper-context.yaml` schema has no `schema_version` field. When the schema evolves, the bootstrapper cannot detect old-format state files, causing silent corruption on resume.
- **Action:** Add `schema_version: 1` as the first field. Add resume-time version check. This is a 1-line change now and a painful migration later.

**ARCH-v2-2: Install Script Does Not Copy `AGENTS.md` to Target Project** (Product Manager, Customer Success — HIGH)
- `install.sh --local` copies templates, handbook, and pm-instructions but NOT `AGENTS.md`. The onboarding guide says to "copy AGENTS.md as a starting point" as a manual step. The gap between `--local` completing and `/bootstrap` running is undocumented.
- **Action:** Either have `--local` copy a template `AGENTS.md` with TODO markers, or add explicit post-install guidance that `/bootstrap` creates it.

### Quality (2 new findings)

**QA-v2-1: `copy_updatable_file` Is Untested** (QA Engineer — HIGH)
- `copy_updatable_file` (install.sh line 183) uses an implicit Bash scoping pattern (`_updatable` local variable visible to callee). No test exercises this function directly. Silent regression risk for users re-running `--local` to get handbook updates.
- **Action:** Add test for `copy_updatable_file` without `--force` flag.

**QA-v2-2: Dry-Run Summary Message Is Misleading** (QA Engineer — MEDIUM)
- Both scripts report "Done — N files removed/added" in dry-run mode even though nothing was actually changed. Users may believe operations occurred.
- **Action:** Change dry-run summary to "Would remove/add N files."

### Documentation (1 new finding)

**DOC-v2-1: AGENTS.md Quick Start Mixes Shell and AI Commands in One Code Block** (Technical Writer — HIGH)
- The "Set up a specific project" code block is labeled `bash` but contains `/bootstrap` — an AI agent command, not a shell command. Copy-pasting will fail.
- **Action:** Split into two blocks: `bash` for shell commands, `text` for AI commands with a label like "Then in your AI coding agent."

### Process (1 finding)

**PROC-v2-1: Spec Status Remains "Proposed" After Delivery** (Product Manager, QA Engineer — MEDIUM)
- `chg-GH-32-spec.md` front-matter still reads `status: Proposed`. Work is delivered and DoD passed.
- **Action:** Update to `status: Delivered`. 1-line fix.

---

## 4. Conflicts and Tensions

### Tension 1: README Update — In-Scope vs. Follow-Up

- **CEO** issued a BLOCK verdict, arguing README.md must be updated before GH-32 can be considered complete.
- **Product Manager** and **Customer Success** agree it's the #1 priority but note it was explicitly deferred to GH-34 in v1.
- **Resolution:** The v1 deferral was reasonable at the time (scope management), but the install infrastructure and AGENTS.md Quick Start have since been added — making the README gap more glaring, not less. **Recommend treating the README update as a GH-32 completion item, not a separate ticket.** The effort is ~1 hour and the impact is outsized.

### Tension 2: OpenCode Coupling vs. Tool-Agnostic Positioning

- **CTO** notes the global install hardcodes `~/.config/opencode/` — only works for OpenCode.
- **Product Manager** flags that the onboarding guide claims compatibility with "Claude Code, Cursor, Windsurf" without clarification.
- **Customer Success** notes users without OpenCode will hit a dead end at `/bootstrap`.
- **Resolution:** This is a genuine product positioning decision that cannot be resolved by documentation alone. **Recommend a two-part fix:** (1) Short-term: explicitly state that ADOS currently requires OpenCode, with a note that other tools may work with manual configuration. (2) Medium-term: create a compatibility guide or `--target` flag for the installer (tracked as a follow-up ticket).

### Tension 3: `curl | bash` Convenience vs. Security

- **Security Officer** flags partial download, MITM, and supply chain risks.
- **CTO** notes this is standard industry practice (Homebrew, Rust, nvm all use it).
- **Resolution:** Keep `curl | bash` as the primary install method (the convenience is essential for adoption), but (1) offer a two-step alternative in the docs, (2) publish SHA256 checksums for releases, and (3) add `ADOS_REF` for version pinning. This balances convenience with defense-in-depth.

---

## 5. Prioritized Action Items

| # | Action | Domain | Impact | Effort | Addresses |
|---|--------|--------|--------|--------|-----------|
| 1 | **Update README.md** — add Quick Start with curl one-liner, fix agent/command counts (19/16), add missing agents/commands, replace Menuvivo URL with `GH-456`, reframe "Intention" section, add onboarding guide link, update repo structure tree | Adoption | Highest — unanimous finding across all 8 reviewers; CEO BLOCK | ~1 hour | CF-v2-1 |
| 2 | **Fix uninstall command path** — change `scripts/uninstall.sh` to `~/.ados/repo/scripts/uninstall.sh` in AGENTS.md and onboarding guide | Adoption | High — breaks the "safe to try" rollback promise | 2 min | CF-v2-2 |
| 3 | **Add `north-star-template.md`** to onboarding guide Section 2.4 template list | Consistency | Medium — same category of drift GH-32 was designed to fix | 2 min | CF-v2-3 |
| 4 | **Harden `safe_rmdir`** — canonicalize paths with `realpath -m`, add minimum depth check, add test cases for bypass vectors | Security | High — prevents destructive `rm -rf` on home directory via env var manipulation | 30 min | SEC-v2-1 |
| 5 | **Add `schema_version: 1`** to bootstrapper state schema | Architecture | High — prevents silent state corruption on upgrade; cheap now, expensive later | 5 min | ARCH-v2-1 |
| 6 | **Split AGENTS.md Quick Start code block** — separate shell commands from AI commands | Documentation | Medium — copy-paste will fail for new users | 5 min | DOC-v2-1 |
| 7 | **Clarify OpenCode prerequisite** — add "Step 0: Install OpenCode" to onboarding guide, or explicitly state which tools are supported | Adoption | High — complete blocker for non-OpenCode users | 30 min | CF-v2-4 |
| 8 | **Update spec status** — `status: Proposed` → `status: Delivered` | Process | Low — self-hosting integrity; 1-line fix | 1 min | PROC-v2-1 |
| 9 | **Add test for `copy_updatable_file`** — verify updatable files are updated without `--force` | Quality | Medium — latent regression risk | 15 min | QA-v2-1 |
| 10 | **Validate environment variable paths** in install.sh — ensure paths are under `$HOME`, validate URL scheme | Security | Medium — prevents environment injection attacks | 30 min | SEC-v2-2 |

**Total estimated effort for top 10 items: ~3 hours**

### Follow-up Items (post-merge, tracked as new tickets)

| Item | Suggested Ticket | Priority |
|------|-----------------|----------|
| Offer two-step install alternative + SHA256 checksums for releases | GH-53 | Medium |
| Add `ADOS_REF` env var for version pinning in install.sh | GH-54 | Medium |
| Rename `OPENCODE_GLOBAL_DIR` → `ADOS_GLOBAL_CONFIG_DIR` | GH-55 | Medium |
| Document upgrade path prominently in onboarding guide | GH-56 | Medium |
| Expand credential pattern detection list in bootstrapper | GH-57 | Low |
| Add team adoption section to onboarding guide | GH-58 | Medium |
| Add "Setup Checklist" / success criteria to onboarding guide | GH-59 | Medium |
| Extract shared test framework from test files | GH-60 | Low |
| Set restrictive `umask 077` in install.sh | GH-61 | Low |
| Fix dry-run summary messages ("Would remove" vs "removed") | GH-62 | Low |
| Clarify `AGENTS.md` creation in `--local` install flow | GH-63 | Medium |
| Replace Jira transition ID literals with placeholders | GH-48 (from v1) | Low |
| Move Decision Records Setup to appendix in onboarding guide | GH-64 | Low |

---

## 6. Coverage Gaps

| Area | Gap | Risk |
|------|-----|------|
| **CFO / Cost analysis** | No reviewer assessed per-change token cost for adopters evaluating ROI. CEO flagged this as a cross-cutting concern. | Medium — enterprise adopters need cost estimates |
| **Legal / Licensing** | No reviewer assessed `curl \| bash` liability under MIT license, or whether license headers on copied files are sufficient for user projects. Security flagged this. | Low — MIT license is permissive, but worth a follow-up |
| **Real-world adoption testing** | No reviewer tested the full install → bootstrap → first change journey on an actual external project. All reviews are document-level. | Medium — the real-world experience may differ from documented expectations |
| **Model compatibility** | No reviewer assessed whether the bootstrapper works with non-Opus models. CTO noted this in v1 and it remains untested. | Medium — affects adoption breadth and cost |

---

## 7. Reviewer Verdicts Summary

| Reviewer | Verdict | Key Concern |
|----------|---------|-------------|
| CEO | **BLOCK** | README.md is the front door and it's locked — personal framing, wrong counts, no install path |
| Product Manager | CONCERNS | README stale, OpenCode/Claude Code ambiguity, spec status still "Proposed" |
| Customer Success | CONCERNS | README churn machine, OpenCode undeclared prerequisite, broken uninstall path, no team adoption guide |
| Technical Writer | CONCERNS | README agent/command counts wrong, AGENTS.md code block mixes shell/AI commands, onboarding template list incomplete |
| CTO | CONCERNS | Bootstrapper state schema needs versioning, `curl \| bash` needs version pinning, OpenCode coupling in global install |
| UX Designer | CONCERNS | README is a conversion dead-end, broken uninstall path, "Intention" section signals personal project |
| QA Engineer | CONCERNS | README stale counts, `copy_updatable_file` untested, spec status "Proposed", dry-run messages misleading |
| Security Officer | CONCERNS | `safe_rmdir` bypass via path variants, environment variable injection, curl-pipe integrity |

**Consensus:** 7 CONCERNS, 1 BLOCK. No APPROVE verdicts.

**Comparison to v1:** v1 had 6 CONCERNS, 2 APPROVE. v2 is stricter because the README gap — which was a deferrable follow-up in v1 — is now the dominant issue after all other v1 findings were resolved. The CEO escalated from APPROVE to BLOCK specifically because the install infrastructure makes the README gap more visible, not less.

---

## 8. What Improved Since v1

The v2 review confirms significant progress:

1. **Install infrastructure is production-grade** — `install.sh` (485 lines) and `uninstall.sh` (385 lines) with 50 passing tests, idempotent operations, `--dry-run` support, mockable wrappers, and proper error handling. This is the strongest new addition.
2. **Onboarding guide is well-structured** — "Choose Your Setup Path" decision point, time estimates, acquisition instructions, troubleshooting section. Major improvement over v1.
3. **AGENTS.md Quick Start is clear and actionable** — Three-step install sequence (global → local → /bootstrap) is correct and prominent.
4. **Bootstrapper security is solid** — Trust boundary, write allowlist, and credential detection form three layers of defense. All three v1 security findings resolved.
5. **Cross-document consistency improved** — Template counts match, repo structure tree is accurate in AGENTS.md, ghost references eliminated, broken links fixed.
6. **Time estimates set realistic expectations** — "~15 min bootstrap, ~30 min manual, ~1 hour first change" helps adopters plan.

---

## 9. Bottom Line

GH-32 has delivered its core promise: ADOS now has a real adoption path with install scripts, a bootstrapper agent, an onboarding guide, and security boundaries. The engineering quality is high — 50 tests, idempotent operations, defensive bash, proper trust boundaries. **8 of 10 v1 action items are fully resolved.**

**The single remaining gap is the README.md** — and it's now a bigger problem than in v1. Every adoption improvement (install.sh, /bootstrap, onboarding guide, AGENTS.md Quick Start) is invisible to the 90%+ of GitHub visitors who only see the README. The CEO's BLOCK verdict reflects a real business risk: significant engineering investment in adoption infrastructure that no visitor can discover from the front door.

**Fix the README (~1 hour), harden `safe_rmdir` (30 min), add `schema_version` to bootstrapper state (5 min), fix the uninstall path (2 min), and add the missing template to the onboarding guide (2 min) — and GH-32 delivers on its promise of making ADOS a product that any IT organization wants to adopt.**
