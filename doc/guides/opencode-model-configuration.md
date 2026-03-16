---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/guides/opencode-model-configuration.md
id: GUIDE-OPENCODE-MODEL-CONFIG
status: Accepted
created: 2026-03-05
owners: ["engineering"]
summary: "How to configure AI models for OpenCode agents — per-project, globally, and per-provider."
---

# OpenCode Model Configuration Guide

This guide explains how to assign AI models to OpenCode agents so you can control quality, cost, and speed across your delivery workflow.

<!-- TOC -->
* [OpenCode Model Configuration Guide](#opencode-model-configuration-guide)
  * [1. How Configuration Works](#1-how-configuration-works)
    * [1.1 Config File Locations](#11-config-file-locations)
    * [1.2 Merge Order (Precedence)](#12-merge-order-precedence)
  * [2. Setting Models Per Agent](#2-setting-models-per-agent)
    * [2.1 Basic Structure](#21-basic-structure)
    * [2.2 Model ID Format](#22-model-id-format)
    * [2.3 Other Agent Overrides](#23-other-agent-overrides)
  * [3. Provider Profiles](#3-provider-profiles)
    * [3.1 Anthropic (API or Max Subscription)](#31-anthropic-api-or-max-subscription)
    * [3.2 GitHub Copilot](#32-github-copilot)
    * [3.3 Switching Between Profiles](#33-switching-between-profiles)
  * [4. Cost Optimization Strategy](#4-cost-optimization-strategy)
    * [4.1 Tiering Agents by Role](#41-tiering-agents-by-role)
    * [4.2 GitHub Copilot Cost Multipliers](#42-github-copilot-cost-multipliers)
  * [5. Environment Variables](#5-environment-variables)
  * [6. Quick Start](#6-quick-start)
  * [7. Related Documentation](#7-related-documentation)
<!-- TOC -->

## 1. How Configuration Works

OpenCode uses JSONC (JSON with Comments) configuration files that are **merged** — not replaced — across multiple levels. Non-conflicting settings combine; conflicting keys are overridden by higher-precedence sources.

### 1.1 Config File Locations

| Level | Location | Use case |
|---|---|---|
| **Global** | `~/.config/opencode/opencode.json` | User-wide defaults (preferred provider, API keys, permissions) |
| **Project** | `opencode.json` or `opencode.jsonc` in project root | Project-specific settings (safe to commit to Git) |
| **`.opencode/` directory** | `.opencode/opencode.jsonc` and related files | Agents, commands, plugins, and additional config |
| **Custom path** | Path set via `OPENCODE_CONFIG` env var | CI/CD or team-specific overrides |
| **Inline** | `OPENCODE_CONFIG_CONTENT` env var | Runtime overrides (e.g., in scripts) |

### 1.2 Merge Order (Precedence)

Settings are merged in this order (later overrides earlier):

1. Remote config (`.well-known/opencode` — organizational defaults)
2. Global config (`~/.config/opencode/opencode.json`)
3. Custom config (`OPENCODE_CONFIG` env var)
4. Project config (`opencode.json` in project root)
5. `.opencode/` directory configs
6. Inline config (`OPENCODE_CONFIG_CONTENT` env var)

**Key takeaway:** Project-level config overrides global config. Inline env vars override everything.

---

## 2. Setting Models Per Agent

### 2.1 Basic Structure

Override the model for any agent in the `"agent"` section of your config:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "coder": {
      "model": "anthropic/claude-opus-4-6"
    },
    "runner": {
      "model": "anthropic/claude-sonnet-4-6"
    }
  }
}
```

Each agent key matches the agent filename (without `.md`) from `.opencode/agent/`.

### 2.2 Model ID Format

Model IDs use the format `provider/model-name`. Common providers:

| Provider prefix | Description |
|---|---|
| `anthropic/` | Anthropic direct API |
| `github-copilot/` | GitHub Copilot subscription |
| `openai/` | OpenAI direct API |
| `deepseek/` | DeepSeek API |
| `google-vertex-ai/` | Google Vertex AI |
| `openrouter/` | OpenRouter (multi-provider) |
| `ollama/` | Local models via Ollama |

See the [OpenCode providers documentation](https://opencode.ai/docs/providers) for the full list.

### 2.3 Other Agent Overrides

Beyond `model`, you can override per agent:

```jsonc
{
  "agent": {
    "pm": {
      "model": "anthropic/claude-opus-4-6",
      "tools": {
        "github*": true,
        "bash": false
      },
      "temperature": 0.2,
      "steps": 50
    }
  }
}
```

Available overrides: `model`, `tools`, `permission`, `temperature`, `steps`, `topP`, `prompt`, `disable`, `mode`, `hidden`, `color`.

---

## 3. Provider Profiles

This repo ships two pre-built model configurations as reference profiles:

| File | Provider | When to use |
|---|---|---|
| `.opencode/opencode-anthropic.jsonc` | Anthropic (API or Max subscription) | You have an Anthropic API key or a Max subscription and want maximum model quality |
| `.opencode/opencode-github-copilot.jsonc` | GitHub Copilot | You have a Copilot subscription and want cost-optimized model assignment |

### 3.1 Anthropic (API or Max Subscription)

This profile works with either access method:

- **Anthropic API** — pay-per-token via an API key. Set `ANTHROPIC_API_KEY`.
- **Anthropic Max subscription** — flat-rate plan that includes Claude usage. Authentication is handled through your subscription login (no API key needed).

Uses two tiers — Opus for complex reasoning, Sonnet for everything else:

```jsonc
{
  "agent": {
    // Opus — deep reasoning, orchestration, code, review
    "pm":          { "model": "anthropic/claude-opus-4-6" },
    "architect":   { "model": "anthropic/claude-opus-4-6" },
    "coder":       { "model": "anthropic/claude-opus-4-6" },
    // ...

    // Sonnet — well-scoped tasks
    "committer":   { "model": "anthropic/claude-sonnet-4-6" },
    "runner":      { "model": "anthropic/claude-sonnet-4-6" },
    // ...
  }
}
```

**Requires:** `ANTHROPIC_API_KEY` environment variable (API access) or an active Anthropic Max subscription.

### 3.2 GitHub Copilot

Uses five cost tiers to optimize against Copilot's usage multipliers:

```jsonc
{
  "agent": {
    // Tier 1 (3.0x) — only where deep reasoning is irreplaceable
    "architect":   { "model": "github-copilot/claude-opus-4.6" },
    "reviewer":    { "model": "github-copilot/claude-opus-4.6" },

    // Tier 2 (1.0x) — core work
    "pm":          { "model": "github-copilot/claude-sonnet-4.6" },
    "coder":       { "model": "github-copilot/gpt-5.2-codex" },
    // ...

    // Tier 3 (0.33x) — well-scoped tasks
    "committer":   { "model": "github-copilot/claude-haiku-4.5" },
    // ...

    // Tier 4 (0.25x) — fast/cheap
    "external-researcher": { "model": "github-copilot/grok-code-fast-1" },

    // Tier 5 (free) — trivial
    "runner":      { "model": "github-copilot/gpt-5-mini" }
  }
}
```

**Requires:** Active GitHub Copilot subscription.

### 3.3 Switching Between Profiles

OpenCode does not have built-in profile switching. To switch between provider configurations:

**Option A — Copy the profile you want:**

```bash
# Use Anthropic models
cp .opencode/opencode-anthropic.jsonc .opencode/opencode.jsonc

# Use GitHub Copilot models
cp .opencode/opencode-github-copilot.jsonc .opencode/opencode.jsonc
```

> **Note:** The base `.opencode/opencode.jsonc` contains MCP server config and tool permissions that are provider-independent. The profile files only contain `"agent"` model overrides. Copying a profile over the base config will lose MCP settings. Instead, merge the `"agent"` block from the profile into your base config.

**Option B — Use the `OPENCODE_CONFIG` env var:**

```bash
# Point to a specific profile
export OPENCODE_CONFIG=.opencode/opencode-anthropic.jsonc
opencode

# Or inline for a single session
OPENCODE_CONFIG=.opencode/opencode-github-copilot.jsonc opencode
```

**Option C — Use `OPENCODE_CONFIG_CONTENT` for runtime overrides:**

```bash
# Override just the coder model for this session
export OPENCODE_CONFIG_CONTENT='{"agent":{"coder":{"model":"anthropic/claude-opus-4-6"}}}'
opencode
```

---

## 4. Cost Optimization Strategy

### 4.1 Tiering Agents by Role

Not all agents need the most powerful model. Assign models based on task complexity:

| Tier | Agent role | Example agents | Model class |
|---|---|---|---|
| **Critical reasoning** | Architecture decisions, thorough code review | `architect`, `reviewer` | Opus / top-tier |
| **Core work** | Orchestration, code generation, planning, specs, debugging | `pm`, `coder`, `fixer`, `plan-writer`, `spec-writer`, `test-plan-writer`, `toolsmith` | Sonnet / Codex / mid-tier |
| **Well-scoped tasks** | Commits, doc sync, PR descriptions, image analysis, copy editing | `committer`, `doc-syncer`, `pr-manager`, `image-reviewer`, `image-generator`, `editor`, `designer` | Haiku / Flash / budget-tier |
| **Lightweight** | External research (MCP-heavy), simple edits | `external-researcher` | Fast / cheap models |
| **Trivial** | Command execution, log capture | `runner` | Free / smallest models |

### 4.2 GitHub Copilot Cost Multipliers

When using GitHub Copilot, each model has a usage multiplier against your subscription quota:

| Multiplier | Models | Best for |
|---|---|---|
| **3.0x** | Claude Opus 4.5, Claude Opus 4.6 | Reserve for highest-value reasoning only |
| **1.0x** | Claude Sonnet 4.5/4.6, GPT-5.1/5.2, GPT-5.2-Codex, Gemini 2.5 Pro, Gemini 3 Pro | Core delivery work |
| **0.33x** | Claude Haiku 4.5, Gemini 3 Flash, GPT-5.1-Codex-Mini | Well-scoped tasks with clear inputs/outputs |
| **0.25x** | Grok Code Fast 1 | Fast, cheap tasks |
| **free** | GPT-4.1, GPT-4o, GPT-5 mini | Zero-cost tasks (command execution, log capture) |

**Tip:** Putting `runner` on a free model and `committer` on a 0.33x model can save significant quota without impacting delivery quality.

---

## 5. Environment Variables

| Variable | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` | API key for `anthropic/` models |
| `OPENAI_API_KEY` | API key for `openai/` models |
| `OPENCODE_CONFIG` | Path to a custom config file |
| `OPENCODE_CONFIG_CONTENT` | Inline JSON config (highest precedence) |

You can also reference env vars inside config files using the `{env:VARIABLE_NAME}` syntax:

```jsonc
{
  "provider": {
    "anthropic": {
      "apiKey": "{env:ANTHROPIC_API_KEY}"
    }
  }
}
```

---

## 6. Quick Start

1. **Pick a profile** that matches your provider:
   - Anthropic API → `.opencode/opencode-anthropic.jsonc`
   - GitHub Copilot → `.opencode/opencode-github-copilot.jsonc`

2. **Merge the `"agent"` block** from the profile into your `.opencode/opencode.jsonc` (or use `OPENCODE_CONFIG` to point to the profile).

3. **Set your API key** (if using Anthropic API — not needed for Max subscription or Copilot):
   ```bash
   export ANTHROPIC_API_KEY=sk-ant-...
   ```

4. **Customize** — adjust individual agent models to match your priorities:
   ```jsonc
   // Want the coder to use Opus for a complex refactor?
   "coder": { "model": "anthropic/claude-opus-4-6" }
   ```

5. **Run OpenCode** — agents will use the configured models automatically.

---

## 7. Related Documentation

- [OpenCode Agents & Commands Guide](opencode-agents-and-commands-guide.md) — full agent/command reference and workflows
- [OpenCode README](../../.opencode/README.md) — tooling conventions and agent inventory
- [OpenCode Configuration Docs](https://opencode.ai/docs/config) — upstream configuration reference
- [OpenCode Providers Docs](https://opencode.ai/docs/providers) — supported model providers
