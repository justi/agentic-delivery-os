---
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
source: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/doc/templates/pr-instructions-template.md
---
# PR/MR Platform Instructions

<!-- Template for `.ai/agent/pr-instructions.md` — repo-local PR/MR platform configuration.
     Copy this file to `.ai/agent/pr-instructions.md` and uncomment the section matching your platform.
     Agents read this file to determine HOW to interact with the pull/merge request platform.
     See doc/guides/pr-platform-integration.md for setup details and a decision flowchart. -->

## Platform

<!-- Uncomment and fill ONE of the following platform sections. -->

<!-- === GitHub CLI ===
- **Type**: GitHub
- **Access method**: CLI (`gh`)
- **Host**: `github.com`
- **Auth**: `gh auth login` (pre-configured; agents verify via `gh auth status`)
-->

<!-- === GitLab CLI ===
- **Type**: GitLab
- **Access method**: CLI (`glab`)
- **Host**: `gitlab.com`
- **Auth**: `glab auth login` (pre-configured; agents verify via `glab auth status`)
-->

<!-- === GitHub MCP ===
- **Type**: GitHub
- **Access method**: MCP (GitHub tools)
- **Host**: `github.com`
- **Auth**: MCP server handles authentication
-->

<!-- === Azure DevOps MCP (future) ===
- **Type**: Azure DevOps
- **Access method**: MCP (Azure DevOps tools)
- **Host**: `dev.azure.com`
- **Auth**: MCP server handles authentication
-->

## Operations Reference

<!-- Each row maps an abstract operation to the concrete command for your platform.
     Agents reference this table for every PR/MR operation.
     Uncomment the table matching your platform and adapt as needed. -->

<!-- === GitHub CLI Operations ===

| Operation | Command | Notes |
|-----------|---------|-------|
| **List open PRs for branch** | `gh pr list --head "$BRANCH" --state open --json number,baseRefName,url,title,body,headRefName,updatedAt --jq 'sort_by(.updatedAt) \| reverse \| .[0]'` | Returns most recently updated open PR |
| **Fetch PR diff** | `gh pr diff "$NUMBER"` | Full unified diff to stdout |
| **Fetch PR metadata** | `gh pr view "$NUMBER" --json number,baseRefName,headRefName,title,body,url,author,labels,reviewRequests,comments,reviews --jq '.'` | JSON metadata |
| **Fetch inline review comments** | `gh api "repos/{owner}/{repo}/pulls/$NUMBER/comments" --paginate` | Inline (diff-level) comments |
| **Fetch issue comments** | `gh api "repos/{owner}/{repo}/issues/$NUMBER/comments" --paginate` | Top-level PR comments |
| **Fetch reviews** | `gh api "repos/{owner}/{repo}/pulls/$NUMBER/reviews" --paginate` | Review objects |
| **Publish summary comment** | `gh pr comment "$NUMBER" --body-file "$FILE"` | Post top-level comment from file |
| **Publish inline review** | `gh api "repos/{owner}/{repo}/pulls/$NUMBER/reviews" -X POST --input "$PAYLOAD_FILE"` | Submit review with inline comments |
| **Create PR** | `gh pr create --base "$BASE" --title "$TITLE" --body-file "$BODY_FILE"` | Creates new PR |
| **Update PR** | `gh pr edit "$NUMBER" --base "$BASE" --title "$TITLE" --body-file "$BODY_FILE"` | Updates existing PR |
| **View PR (confirm)** | `gh pr view "$NUMBER" --json number,baseRefName,url --jq '{number,baseRefName,url}'` | Confirm state after create/update |
| **Check auth** | `gh auth status` | Verify CLI is authenticated |
| **Detect platform** | `git remote get-url origin` | Parse for `github.com` host |

-->

<!-- === GitLab CLI Operations ===

| Operation | Command | Notes |
|-----------|---------|-------|
| **List open MRs for branch** | `glab mr list --source-branch "$BRANCH" --output json` | Filter with jq for most recently updated |
| **Fetch MR diff** | `glab mr diff "$IID"` | Full unified diff to stdout |
| **Fetch MR metadata** | `glab mr view "$IID" --output json` | JSON metadata |
| **Fetch MR discussions** | `glab api "projects/:id/merge_requests/$IID/discussions" --paginate` | Threaded discussions |
| **Fetch MR notes** | `glab api "projects/:id/merge_requests/$IID/notes" --paginate` | All notes/comments |
| **Publish summary note** | `glab mr note "$IID" --message "$(cat "$FILE")"` | Post top-level note |
| **Publish inline discussion** | `glab api "projects/:id/merge_requests/$IID/discussions" -X POST ...` | Inline discussion at diff position |
| **Create MR** | `glab mr create --source-branch "$BRANCH" --target-branch "$BASE" --title "$TITLE" --description "$(cat "$BODY_FILE")" --yes` | Creates new MR |
| **Update MR** | `glab mr update "$IID" --target-branch "$BASE" --title "$TITLE" --description "$(cat "$BODY_FILE")" --yes` | Updates existing MR |
| **View MR (confirm)** | `glab mr view "$IID" --output json` | Confirm state after create/update |
| **Check auth** | `glab auth status` | Verify CLI is authenticated |
| **Detect platform** | `git remote get-url origin` | Parse for `gitlab.com` host |

-->

<!-- === GitHub MCP Operations ===

| Operation | Command | Notes |
|-----------|---------|-------|
| **List open PRs for branch** | `github_list_pull_requests` with `head: "$BRANCH"`, `state: "open"` | MCP tool call |
| **Fetch PR diff** | `github_get_pull_request_diff` with `pull_number: $NUMBER` | MCP tool call |
| **Fetch PR metadata** | `github_get_pull_request` with `pull_number: $NUMBER` | MCP tool call |
| **Fetch review comments** | `github_list_pull_request_comments` with `pull_number: $NUMBER` | MCP tool call |
| **Publish summary comment** | `github_create_issue_comment` with `issue_number: $NUMBER`, `body: "$CONTENT"` | MCP tool call |
| **Publish inline review** | `github_create_pull_request_review` with `pull_number: $NUMBER`, `comments: [...]` | MCP tool call |
| **Create PR** | `github_create_pull_request` with `base: "$BASE"`, `head: "$BRANCH"`, `title: "$TITLE"`, `body: "$BODY"` | MCP tool call |
| **Update PR** | `github_update_pull_request` with `pull_number: $NUMBER`, `title: "$TITLE"`, `body: "$BODY"` | MCP tool call |
| **Check auth** | MCP server availability check | MCP handles auth |

-->

<!-- === Azure DevOps MCP Operations (future) ===

| Operation | Command | Notes |
|-----------|---------|-------|
| **List open PRs for branch** | `ado_list_pull_requests` with `sourceRefName: "$BRANCH"`, `status: "active"` | MCP tool call |
| **Fetch PR diff** | `ado_get_pull_request_diff` with `pullRequestId: $ID` | MCP tool call |
| **Fetch PR metadata** | `ado_get_pull_request` with `pullRequestId: $ID` | MCP tool call |
| **Fetch PR threads** | `ado_list_pull_request_threads` with `pullRequestId: $ID` | MCP tool call |
| **Publish comment** | `ado_create_pull_request_thread` with `pullRequestId: $ID`, `comments: [...]` | MCP tool call |
| **Create PR** | `ado_create_pull_request` with `sourceRefName: "$BRANCH"`, `targetRefName: "$BASE"`, `title: "$TITLE"` | MCP tool call |
| **Update PR** | `ado_update_pull_request` with `pullRequestId: $ID`, `title: "$TITLE"` | MCP tool call |
| **Check auth** | MCP server availability check | MCP handles auth |

-->
