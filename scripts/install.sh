#!/usr/bin/env bash
# Copyright (c) 2025-2026 Juliusz Ćwiąkalski (https://www.cwiakalski.com | https://www.linkedin.com/in/juliusz-cwiakalski/ | https://x.com/cwiakalski)
# MIT License - see LICENSE file for full terms
# Latest version: https://github.com/juliusz-cwiakalski/agentic-delivery-os/blob/main/scripts/install.sh
# install.sh — Install or update Agentic Delivery OS (ADOS) globally or into a local project
#
# Dependencies: bash>=4, git, diff, cp, mkdir
# Usage: ./install.sh [--global|--local] [options]
#
# Three modes:
#   --global (-g)  Clone ADOS repo to ~/.ados/ and install agent+command definitions
#                  to ~/.config/opencode/ so they're available in every project.
#                  Re-running --global updates to the latest version (idempotent).
#   --local  (-l)  Copy ADOS artifacts into the CURRENT project directory.
#                  This is the default mode when neither flag is specified.
#                  Re-running --local updates templates and handbook while preserving
#                  project-specific files (pm-instructions.md).
#
# One-liner install:
#   curl -fsSL https://raw.githubusercontent.com/juliusz-cwiakalski/agentic-delivery-os/main/scripts/install.sh | bash -s -- --global
#
# Environment:
#   ADOS_REPO_URL          - Override ADOS git clone URL
#   ADOS_RAW_URL           - Override raw GitHub content URL
#   ADOS_HOME              - Override ADOS home directory (default: ~/.ados)
#   ADOS_REPO_DIR          - Override cloned repo location (default: ~/.ados/repo)
#   OPENCODE_GLOBAL_DIR    - Override opencode config dir (default: ~/.config/opencode)
#   ADOS_SOURCE_DIR        - Override source repo for local install (default: auto-detected)
#   DRY_RUN                - Set to 'true' to skip destructive operations
#   VERBOSE                - Set to 'true' for debug output
#
# Exit codes:
#   0 - Success
#   2 - Usage error
#   3 - Configuration error
#   4 - Runtime error
#   5 - External command failure

set -Eeuo pipefail
set -o errtrace
shopt -s inherit_errexit 2>/dev/null || true
IFS=$'\n\t'

# ============================================================================
# SETTINGS
# ============================================================================
readonly APP_NAME="ados-install"
readonly APP_VERSION="1.0.0"
readonly LOG_TAG="(${APP_NAME})"

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_USAGE=2
readonly EXIT_CONFIG=3
readonly EXIT_RUNTIME=4
readonly EXIT_EXTERNAL=5

# Configurable via environment
readonly ADOS_REPO_URL="${ADOS_REPO_URL:-https://github.com/juliusz-cwiakalski/agentic-delivery-os.git}"
readonly ADOS_RAW_URL="${ADOS_RAW_URL:-https://raw.githubusercontent.com/juliusz-cwiakalski/agentic-delivery-os/main}"
readonly ADOS_HOME="${ADOS_HOME:-${HOME}/.ados}"
readonly ADOS_REPO_DIR="${ADOS_REPO_DIR:-${ADOS_HOME}/repo}"
readonly OPENCODE_GLOBAL_DIR="${OPENCODE_GLOBAL_DIR:-${HOME}/.config/opencode}"

DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
FORCE="${FORCE:-false}"

# Install mode: "global" or "local"
INSTALL_MODE=""

# ============================================================================
# TRAPS
# ============================================================================
_on_err() {
  local -r line="$1" cmd="$2" code="$3"
  log_err "line ${line}: '${cmd}' exited with ${code}"
}

_on_exit() {
  :
}

_on_interrupt() {
  log_warn "Interrupted"
  exit 130
}

trap '_on_err $LINENO "$BASH_COMMAND" $?' ERR
trap '_on_exit' EXIT
trap '_on_interrupt' INT TERM

# ============================================================================
# UTILITIES
# ============================================================================
log_info()  { printf '[INFO]  %s %s\n' "${LOG_TAG}" "$*"; }
log_warn()  { printf '[WARN]  %s %s\n' "${LOG_TAG}" "$*"; }
log_err()   { printf '[ERROR] %s %s\n' "${LOG_TAG}" "$*" >&2; }
log_debug() { [[ "${VERBOSE}" == "true" ]] && printf '[DEBUG] %s %s\n' "${LOG_TAG}" "$*"; true; }
log_fatal() { log_err "$@"; exit "${EXIT_RUNTIME}"; }

die() { log_err "$@"; exit "${EXIT_USAGE}"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

run_cmd() {
  if [[ "${DRY_RUN}" == "true" ]]; then
    log_info "[DRY-RUN] Would execute: $*"
    return 0
  fi
  "$@"
}

# ============================================================================
# MOCKABLE WRAPPERS (for testing)
# ============================================================================
_git() { command git "$@"; }
_diff() { command diff "$@"; }
_cp() { command cp "$@"; }
_mkdir() { command mkdir "$@"; }

# ============================================================================
# DOMAIN FUNCTIONS — Shared
# ============================================================================

# Copy a single file with diff-check. Returns 0 if copied, 1 if skipped.
# Sets global counters: _added, _updated, _unchanged
_added=0
_updated=0
_unchanged=0

reset_counters() {
  _added=0
  _updated=0
  _unchanged=0
}

copy_file_with_diff() {
  local -r src="$1"
  local -r dest="$2"
  local -r label="${3:-$(basename "${dest}")}"

  if [[ ! -f "${src}" ]]; then
    log_warn "Source file not found: ${src}"
    return 1
  fi

  if [[ -L "${dest}" ]]; then
    # Replace old symlinks
    run_cmd rm -f "${dest}"
    run_cmd _cp "${src}" "${dest}"
    log_info "update ${label} (replaced symlink with copy)"
    ((_updated++)) || true
  elif [[ -f "${dest}" ]]; then
    if _diff -q "${src}" "${dest}" >/dev/null 2>&1; then
      log_debug "skip   ${label} (already up to date)"
      ((_unchanged++)) || true
    else
      # In global mode: always update (agents/commands should track upstream)
      # In local mode with --force: always update
      # In local mode with updatable files: update (templates, handbook)
      # In local mode with project-specific files: skip (pm-instructions, etc.)
      if [[ "${FORCE}" == "true" || "${INSTALL_MODE}" == "global" || "${_updatable:-false}" == "true" ]]; then
        run_cmd _cp "${src}" "${dest}"
        log_info "update ${label}"
        ((_updated++)) || true
      else
        log_info "skip   ${label} (exists, has local changes; use --force to overwrite)"
        ((_unchanged++)) || true
      fi
    fi
  else
    run_cmd _mkdir -p "$(dirname "${dest}")"
    run_cmd _cp "${src}" "${dest}"
    log_info "add    ${label}"
    ((_added++)) || true
  fi
}

# Copy a file that should always be updated to match upstream (templates, handbook)
copy_updatable_file() {
  local _updatable=true
  copy_file_with_diff "$@"
}

# Ensure a directory exists; create stub if missing
ensure_dir() {
  local -r dir="$1"
  local -r label="${2:-${dir}}"

  if [[ -d "${dir}" ]]; then
    log_debug "skip   ${label}/ (already exists)"
  else
    run_cmd _mkdir -p "${dir}"
    log_info "create ${label}/"
  fi
}

# Check if a pattern exists in a file
file_contains_line() {
  local -r file="$1"
  local -r pattern="$2"

  [[ -f "${file}" ]] && grep -qF "${pattern}" "${file}" 2>/dev/null
}

# Add line to .gitignore if not already present
ensure_gitignore_entry() {
  local -r gitignore="$1"
  local -r entry="$2"

  if file_contains_line "${gitignore}" "${entry}"; then
    log_debug "skip   .gitignore entry '${entry}' (already present)"
    return 0
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    log_info "[DRY-RUN] Would add '${entry}' to ${gitignore}"
    return 0
  fi

  # Create .gitignore if it doesn't exist
  if [[ ! -f "${gitignore}" ]]; then
    printf '%s\n' "${entry}" > "${gitignore}"
  else
    printf '\n%s\n' "${entry}" >> "${gitignore}"
  fi
  log_info "add    .gitignore entry '${entry}'"
}

# Validate that configurable paths are safe
validate_paths() {
  local canonical_home
  canonical_home="$(realpath -m "${HOME}" 2>/dev/null || readlink -m "${HOME}" 2>/dev/null || printf '%s' "${HOME}")"

  # Validate ADOS_HOME is under $HOME
  local canonical_ados_home
  canonical_ados_home="$(realpath -m "${ADOS_HOME}" 2>/dev/null || readlink -m "${ADOS_HOME}" 2>/dev/null || printf '%s' "${ADOS_HOME}")"
  if [[ "${canonical_ados_home}" != "${canonical_home}"/* ]]; then
    log_warn "ADOS_HOME is outside \$HOME: ${ADOS_HOME}"
  fi

  # Validate OPENCODE_GLOBAL_DIR is under $HOME
  local canonical_opencode
  canonical_opencode="$(realpath -m "${OPENCODE_GLOBAL_DIR}" 2>/dev/null || readlink -m "${OPENCODE_GLOBAL_DIR}" 2>/dev/null || printf '%s' "${OPENCODE_GLOBAL_DIR}")"
  if [[ "${canonical_opencode}" != "${canonical_home}"/* ]]; then
    log_warn "OPENCODE_GLOBAL_DIR is outside \$HOME: ${OPENCODE_GLOBAL_DIR}"
  fi

  # Validate ADOS_REPO_URL scheme (warn on non-https)
  if [[ -n "${ADOS_REPO_URL:-}" && "${ADOS_REPO_URL}" != https://* ]]; then
    log_warn "ADOS_REPO_URL does not use HTTPS: ${ADOS_REPO_URL}"
  fi
}

# ============================================================================
# DOMAIN FUNCTIONS — Global Install
# ============================================================================

clone_or_update_repo() {
  local before_sha=""

  if [[ -d "${ADOS_REPO_DIR}/.git" ]]; then
    before_sha="$(_git -C "${ADOS_REPO_DIR}" rev-parse --short HEAD 2>/dev/null || true)"
    log_info "Updating existing ADOS repo at ${ADOS_REPO_DIR} (current: ${before_sha:-unknown})"
    run_cmd _git -C "${ADOS_REPO_DIR}" pull --ff-only
  else
    log_info "Cloning ADOS repo to ${ADOS_REPO_DIR}"
    run_cmd _mkdir -p "${ADOS_HOME}"
    run_cmd _git clone "${ADOS_REPO_URL}" "${ADOS_REPO_DIR}"
  fi

  # Report installed version
  if [[ -d "${ADOS_REPO_DIR}/.git" && "${DRY_RUN}" != "true" ]]; then
    local after_sha
    after_sha="$(_git -C "${ADOS_REPO_DIR}" rev-parse --short HEAD 2>/dev/null || true)"
    if [[ -n "${before_sha}" && "${before_sha}" != "${after_sha}" ]]; then
      log_info "Updated: ${before_sha} → ${after_sha}"
    elif [[ -z "${before_sha}" ]]; then
      log_info "Installed at: ${after_sha:-unknown}"
    else
      log_info "Already at latest: ${after_sha}"
    fi
  fi
}

install_global_files() {
  local -r agent_src="${ADOS_REPO_DIR}/.opencode/agent"
  local -r command_src="${ADOS_REPO_DIR}/.opencode/command"
  local -r agent_dest="${OPENCODE_GLOBAL_DIR}/agent"
  local -r command_dest="${OPENCODE_GLOBAL_DIR}/command"

  ensure_dir "${agent_dest}" "~/.config/opencode/agent"
  ensure_dir "${command_dest}" "~/.config/opencode/command"

  # Copy agent definitions
  if [[ -d "${agent_src}" ]]; then
    local agent_file
    for agent_file in "${agent_src}"/*.md; do
      [[ -f "${agent_file}" ]] || continue
      local name
      name="$(basename "${agent_file}")"
      copy_file_with_diff "${agent_file}" "${agent_dest}/${name}" "agent/${name}"
    done
  else
    log_warn "Agent source directory not found: ${agent_src}"
  fi

  # Copy command definitions
  if [[ -d "${command_src}" ]]; then
    local cmd_file
    for cmd_file in "${command_src}"/*.md; do
      [[ -f "${cmd_file}" ]] || continue
      local name
      name="$(basename "${cmd_file}")"
      copy_file_with_diff "${cmd_file}" "${command_dest}/${name}" "command/${name}"
    done
  else
    log_warn "Command source directory not found: ${command_src}"
  fi
}

do_global_install() {
  require_cmd git
  validate_paths

  log_info "=== ADOS Global Install ==="
  log_info "ADOS_HOME:          ${ADOS_HOME}"
  log_info "ADOS_REPO_DIR:      ${ADOS_REPO_DIR}"
  log_info "OPENCODE_GLOBAL_DIR: ${OPENCODE_GLOBAL_DIR}"

  clone_or_update_repo
  reset_counters
  install_global_files

  printf '\n'
  log_info "Done — ${_added} added, ${_updated} updated, ${_unchanged} unchanged"
  log_info "ADOS agents and commands are now available globally"
  printf '\n'
  log_info "To update: re-run this same command (idempotent — only changed files are updated)"
  log_info "To set up a project: run '${ADOS_REPO_DIR}/scripts/install.sh --local' in a project root"
}

# ============================================================================
# DOMAIN FUNCTIONS — Local Install
# ============================================================================

# Resolve the ADOS source directory (where to copy artifacts from)
resolve_source_dir() {
  # 1. Explicit override via environment
  if [[ -n "${ADOS_SOURCE_DIR:-}" ]]; then
    if [[ -d "${ADOS_SOURCE_DIR}" ]]; then
      printf '%s' "${ADOS_SOURCE_DIR}"
      return 0
    else
      log_err "ADOS_SOURCE_DIR does not exist: ${ADOS_SOURCE_DIR}"
      return "${EXIT_CONFIG}"
    fi
  fi

  # 2. Running from the ADOS repo itself (script's own repo)
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
  local candidate="${script_dir}/.."
  if [[ -f "${candidate}/AGENTS.md" && -d "${candidate}/.opencode/agent" ]]; then
    printf '%s' "$(cd "${candidate}" && pwd -P)"
    return 0
  fi

  # 3. Global install location
  if [[ -d "${ADOS_REPO_DIR}/.opencode/agent" ]]; then
    printf '%s' "${ADOS_REPO_DIR}"
    return 0
  fi

  log_err "Cannot find ADOS source. Install globally first (--global) or set ADOS_SOURCE_DIR"
  return "${EXIT_CONFIG}"
}

# Verify we're in a project root (has .git directory)
require_project_root() {
  if [[ ! -d ".git" ]]; then
    die "Not a project root (no .git directory). Run from your project's root directory."
  fi
}

install_local_files() {
  local -r source_dir="$1"

  # --- Project-specific files (preserve local edits, skip if exists) ---
  # These are customized per-project; don't overwrite on update
  copy_file_with_diff \
    "${source_dir}/.ai/agent/pm-instructions.md" \
    ".ai/agent/pm-instructions.md" \
    ".ai/agent/pm-instructions.md"

  # --- Shared files (always update to match upstream ADOS) ---
  # These should track upstream; projects should not customize them
  copy_updatable_file \
    "${source_dir}/doc/documentation-handbook.md" \
    "doc/documentation-handbook.md" \
    "doc/documentation-handbook.md"

  copy_updatable_file \
    "${source_dir}/doc/00-index.md" \
    "doc/00-index.md" \
    "doc/00-index.md"

  # doc/templates/ (always update to latest)
  if [[ -d "${source_dir}/doc/templates" ]]; then
    ensure_dir "doc/templates" "doc/templates"
    local tmpl_file
    for tmpl_file in "${source_dir}/doc/templates"/*.md; do
      [[ -f "${tmpl_file}" ]] || continue
      local name
      name="$(basename "${tmpl_file}")"
      copy_updatable_file "${tmpl_file}" "doc/templates/${name}" "doc/templates/${name}"
    done
  else
    log_warn "Templates directory not found: ${source_dir}/doc/templates"
  fi

  # --- Directory stubs ---
  ensure_dir "doc/overview" "doc/overview"
  ensure_dir "doc/spec/features" "doc/spec/features"
  ensure_dir "doc/decisions" "doc/decisions"
  ensure_dir "doc/changes" "doc/changes"
  ensure_dir "doc/guides" "doc/guides"
  ensure_dir ".ai/local" ".ai/local"

  # --- .gitignore entries ---
  ensure_gitignore_entry ".gitignore" ".ai/local/"
  ensure_gitignore_entry ".gitignore" ".ai/local"
}

do_local_install() {
  require_project_root
  validate_paths

  local source_dir
  source_dir="$(resolve_source_dir)" || exit $?

  log_info "=== ADOS Local Install ==="
  log_info "Source:  ${source_dir}"
  log_info "Target:  $(pwd)"
  [[ "${FORCE}" == "true" ]] && log_info "Mode:    force (overwrite existing files)"

  reset_counters
  install_local_files "${source_dir}"

  printf '\n'
  log_info "Done — ${_added} added, ${_updated} updated, ${_unchanged} unchanged"
  printf '\n'
  if [[ "${_added}" -gt 0 ]]; then
    log_info "Run /bootstrap to complete setup with AI-guided configuration"
  else
    log_info "Project artifacts updated to latest ADOS version"
    log_info "Templates and handbook updated; project-specific files preserved"
  fi
}

# ============================================================================
# CLI
# ============================================================================
usage() {
  cat <<EOF
Usage: ${APP_NAME} [--global|--local] [options]

Install or update Agentic Delivery OS (ADOS) globally or into a local project.
Re-running is safe and idempotent — only changed files are updated.

Modes:
  -g, --global    Clone/update ADOS repo at ~/.ados/ and install agent/command
                  definitions to ~/.config/opencode/ (available everywhere).
                  Re-running pulls latest changes and updates all definitions.
  -l, --local     Copy ADOS artifacts into the current project (default).
                  Re-running updates templates and handbook to latest ADOS
                  while preserving project-specific files (pm-instructions.md).

Options:
  -h, --help      Show this help message
  -V, --version   Show version
  -n, --dry-run   Show what would be done without doing it
  -v, --verbose   Enable debug output
  -f, --force     Overwrite existing files during local install

One-liner global install:
  curl -fsSL ${ADOS_RAW_URL}/scripts/install.sh | bash -s -- --global

Local project install (after global install):
  ${ADOS_REPO_DIR}/scripts/install.sh --local

Environment:
  ADOS_REPO_URL          Override git clone URL
  ADOS_HOME              Override ~/.ados directory
  ADOS_REPO_DIR          Override ~/.ados/repo directory
  OPENCODE_GLOBAL_DIR    Override ~/.config/opencode directory
  ADOS_SOURCE_DIR        Override source repo for local install
  DRY_RUN                Set to 'true' to preview changes
  VERBOSE                Set to 'true' for debug output
EOF
}

parse_args() {
  while (($#)); do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      -V|--version) printf '%s %s\n' "${APP_NAME}" "${APP_VERSION}"; exit 0 ;;
      -g|--global) INSTALL_MODE="global" ;;
      -l|--local) INSTALL_MODE="local" ;;
      -n|--dry-run) DRY_RUN=true ;;
      -v|--verbose) VERBOSE=true ;;
      -f|--force) FORCE=true ;;
      --) shift; break ;;
      -*) die "Unknown option: $1" ;;
      *) break ;;
    esac
    shift
  done
}

# ============================================================================
# MAIN
# ============================================================================
main() {
  parse_args "$@"

  # Default to local if no mode specified
  if [[ -z "${INSTALL_MODE}" ]]; then
    INSTALL_MODE="local"
  fi

  log_debug "INSTALL_MODE=${INSTALL_MODE}"
  log_debug "DRY_RUN=${DRY_RUN}"
  log_debug "VERBOSE=${VERBOSE}"
  log_debug "FORCE=${FORCE}"

  case "${INSTALL_MODE}" in
    global) do_global_install ;;
    local)  do_local_install ;;
    *)      die "Invalid install mode: ${INSTALL_MODE}" ;;
  esac
}

# Testable main guard
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
