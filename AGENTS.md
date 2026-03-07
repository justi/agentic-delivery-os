---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
# Latest version: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/AGENTS.md
---
# AGENTS.md

Quick-reference for AI coding agents and human contributors working in this repo.

## Repo structure

```
.
├── AGENTS.md             # this file — conventions at a glance
├── .opencode/            # OpenCode agents and commands (repo-local tooling)
├── .ai/rules/            # language/tool rules (e.g., bash.md)
├── scripts/              # repo-internal automation (.sh extension)
│   └── .tests/           # test files for scripts (test-*.sh)
├── tools/                # PATH-able CLI utilities (no .sh extension) [planned]
│   └── .tests/           # test files for tools (test-*.sh) [planned]
└── doc/
    ├── changes/          # change artifacts (spec, plan, test-plan per workItemRef)
    ├── guides/           # how-to guides
    ├── spec/             # current system spec (reconciled after each change)
    └── documentation-handbook.md
```

## `tools/` convention

> The `tools/` directory does not exist yet — this convention is documented in advance.

| Aspect | Rule |
|--------|------|
| Purpose | PATH-able CLI utilities intended for use beyond this repo |
| Extension | **No** `.sh` extension — invoked by name (e.g., `tools/my-tool`) |
| License | Each tool carries the standard MIT license header (see below) |
| Tests | `tools/.tests/test-<tool-name>.sh` |

## `scripts/` convention

| Aspect | Rule |
|--------|------|
| Purpose | Repo-internal automation (build helpers, header management, etc.) |
| Extension | `.sh` extension required |
| Tests | `scripts/.tests/test-<script-name>.sh` |

Existing scripts:

- `scripts/add-header-location.sh` — adds/updates license header frontmatter in Markdown files.

## Running tests

Test files follow the pattern `test-*.sh` inside `.tests/` subdirectories:

```bash
# Run a single test
bash scripts/.tests/test-add-header-location.sh

# Run all tests for tools (when tools/ exists)
bash tools/.tests/test-*.sh

# Run all tests for scripts
bash scripts/.tests/test-*.sh
```

Convention: an aggregator `scripts/test-all.sh` may be added in the future to run everything.

## License headers

Every Markdown file in the repo carries a three-line YAML frontmatter header:

```markdown
---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (...)
# MIT License - see LICENSE file for full terms
# Latest version: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/<path>
---
```

To add or update the header automatically:

```bash
scripts/add-header-location.sh <file-or-directory>
```

## Key references

| Document | Description |
|----------|-------------|
| [.opencode/README.md](.opencode/README.md) | OpenCode agents and commands |
| [.ai/rules/bash.md](.ai/rules/bash.md) | Bash coding rules |
| [doc/guides/change-lifecycle.md](doc/guides/change-lifecycle.md) | Change delivery lifecycle (10-phase workflow) |
| [doc/guides/unified-change-convention-tracker-agnostic-specification.md](doc/guides/unified-change-convention-tracker-agnostic-specification.md) | Change naming convention (workItemRef, folders, branches) |
