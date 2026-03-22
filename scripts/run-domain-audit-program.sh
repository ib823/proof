#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

QUEUE_PATH="06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md"
TRACKER_PATH="06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md"
PRIMARY_TEMPLATE="06_COORDINATION/prompts/CODEX_DOMAIN_PRIMARY_AUDIT_EXEC_TEMPLATE_v1_0_0.md"
RECON_TEMPLATE="06_COORDINATION/prompts/CODEX_DOMAIN_RECONCILE_AND_REMEDIATE_EXEC_TEMPLATE_v1_0_0.md"
HOSTILE_REVIEW_SCRIPT="scripts/run-hostile-review.sh"
LOG_DIR="06_COORDINATION/audit_outputs/domain_r5/logs"

COUNT=1
EXPLICIT_DOMAIN=""
CONTINUE_ON_FAILURE=0

usage() {
  cat <<'EOF'
Usage:
  bash scripts/run-domain-audit-program.sh [options]

Options:
  --count N                Run N fully closed audit cycles. Default: 1
  --domain DOMAIN_ID       Start with this domain instead of auto-selecting the next READY domain
  --continue-on-failure    Continue to the next domain after a failed cycle
  -h, --help               Show this help

Behavior:
  1. Select the next allowed domain from the audit queue
  2. Run Codex non-interactively for the primary audit
  3. Run the hostile-review coordinator non-interactively for the hostile review
  4. Run Codex non-interactively for reconciliation + remediation
  5. Stop immediately on drift or unresolved failures unless --continue-on-failure is set

This is a gated coordinator. It is meant to be resumable, not reckless.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --count)
      COUNT="$2"
      shift 2
      ;;
    --domain)
      EXPLICIT_DOMAIN="$2"
      shift 2
      ;;
    --continue-on-failure)
      CONTINUE_ON_FAILURE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

require_file() {
  local path="$1"
  [[ -f "$path" ]] || {
    echo "Required file missing: $path" >&2
    exit 1
  }
}

require_bin() {
  local bin="$1"
  command -v "$bin" >/dev/null 2>&1 || {
    echo "Required binary not found: $bin" >&2
    exit 1
  }
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

material_dirty_files() {
  git status --porcelain | awk '{print $2}' | grep -Ev '^(06_COORDINATION/|website/public/metrics\.json$|scripts/run-gemini-hostile-review\.sh$|scripts/run-claude-hostile-review\.sh$|scripts/run-hostile-review\.sh$|scripts/run-domain-audit-program\.sh$)' || true
}

ensure_repo_preconditions() {
  require_file "$QUEUE_PATH"
  require_file "$TRACKER_PATH"
  require_file "$PRIMARY_TEMPLATE"
  require_file "$RECON_TEMPLATE"
  require_file "$HOSTILE_REVIEW_SCRIPT"
  require_bin codex

  local branch
  branch="$(git branch --show-current)"
  if [[ "$branch" != "main" ]]; then
    echo "Refusing to run outside main. Current branch: $branch" >&2
    exit 1
  fi

  local dirty
  dirty="$(material_dirty_files)"
  if [[ -n "$dirty" ]]; then
    echo "Refusing to run with material dirty files outside audit-control scope:" >&2
    printf '%s\n' "$dirty" >&2
    exit 1
  fi
}

detect_incomplete_cycle() {
  awk -F'|' '
    /^\| `/ {
      id = $2
      status = $11
      gsub(/^[ \t]+|[ \t]+$/, "", id)
      gsub(/^[ \t]+|[ \t]+$/, "", status)
      gsub(/`/, "", id)
      gsub(/`/, "", status)
      if (status == "AUDIT_ONLY" || status == "REVIEWED_PENDING_RECONCILIATION" || status == "REVIEWED_NEEDS_RECONCILIATION" || status == "BLOCKED") {
        print id "|" status
        exit
      }
    }
  ' "$TRACKER_PATH"
}

phase1_ready_domain() {
  local ids
  ids="$(
    awk '
      /^### Phase 1: Finish current high-risk umbrellas first/ {in_phase1=1; next}
      /^### / && in_phase1 {exit}
      in_phase1 && /^[0-9]+\.[[:space:]]+audit `/ {
        line = $0
        sub(/^[0-9]+\.[[:space:]]+audit `/, "", line)
        sub(/`.*/, "", line)
        print line
      }
    ' "$QUEUE_PATH"
  )"
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    if grep -Fq "\`$id\` — \`READY\`" "$QUEUE_PATH"; then
      printf '%s\n' "$id"
      return 0
    fi
  done <<< "$ids"
  return 1
}

next_ready_domain() {
  phase1_ready_domain && return 0
  awk '
    /^## Umbrella Audit Queue/ {in_queue=1; next}
    /^## / && in_queue {exit}
    in_queue && /^[0-9]+\.[[:space:]]+`/ {
      if ($0 ~ /— `READY`/) {
        line = $0
        sub(/^[0-9]+\.[[:space:]]+`/, "", line)
        sub(/`.*/, "", line)
        print line
        exit
      }
    }
  ' "$QUEUE_PATH"
}

render_template() {
  local template="$1"
  local output="$2"
  local domain_id="$3"
  local current_commit="$4"
  local audit_path="$5"
  local review_path="${6:-}"

  local escaped_domain_id escaped_current_commit escaped_audit_path escaped_review_path
  escaped_domain_id="$(escape_sed_replacement "$domain_id")"
  escaped_current_commit="$(escape_sed_replacement "$current_commit")"
  escaped_audit_path="$(escape_sed_replacement "$audit_path")"
  escaped_review_path="$(escape_sed_replacement "$review_path")"

  sed \
    -e "s/__DOMAIN_ID__/${escaped_domain_id}/g" \
    -e "s/__CURRENT_COMMIT__/${escaped_current_commit}/g" \
    -e "s#__AUDIT_PATH__#${escaped_audit_path}#g" \
    -e "s#__REVIEW_PATH__#${escaped_review_path}#g" \
    "$template" > "$output"
}

run_codex_exec() {
  local prompt_file="$1"
  local last_message_file="$2"
  local transcript_file="$3"

  mkdir -p "$LOG_DIR"
  codex exec \
    --disable shell_snapshot \
    --ephemeral \
    --color never \
    --dangerously-bypass-approvals-and-sandbox \
    -C "$ROOT_DIR" \
    -o "$last_message_file" \
    - < "$prompt_file" | tee "$transcript_file"
}

extract_audit_rating() {
  local audit_path="$1"
  grep -m1 '^- Current rating:' "$audit_path" | sed -E 's/^- Current rating:[[:space:]]*`?([^`]+)`?/\1/'
}

extract_audit_safe_claim() {
  local audit_path="$1"
  awk '
    /^- Safe claim:/ {capture=1; next}
    capture && /^  - / {sub(/^  - /, ""); print; exit}
  ' "$audit_path"
}

verify_queue_status() {
  local domain_id="$1"
  local expected="$2"
  grep -F "\`$domain_id\` — \`$expected\`" "$QUEUE_PATH" >/dev/null 2>&1
}

verify_tracker_status() {
  local domain_id="$1"
  local expected="$2"
  awk -F'|' -v target="$domain_id" -v wanted="$expected" '
    /^\| `/ {
      id = $2
      status = $11
      gsub(/^[ \t]+|[ \t]+$/, "", id)
      gsub(/^[ \t]+|[ \t]+$/, "", status)
      gsub(/`/, "", id)
      gsub(/`/, "", status)
      if (id == target && status == wanted) {
        found = 1
      }
    }
    END { exit(found ? 0 : 1) }
  ' "$TRACKER_PATH"
}

run_primary_audit() {
  local domain_id="$1"
  local current_commit="$2"
  local audit_path="06_COORDINATION/audit_outputs/domain_r5/${domain_id}_R5_AUDIT.md"
  local prompt_file last_message transcript

  prompt_file="$(mktemp)"
  last_message="$LOG_DIR/${domain_id}.primary.last.txt"
  transcript="$LOG_DIR/${domain_id}.primary.transcript.txt"
  trap 'rm -f "$prompt_file"' RETURN

  render_template "$PRIMARY_TEMPLATE" "$prompt_file" "$domain_id" "$current_commit" "$audit_path"
  run_codex_exec "$prompt_file" "$last_message" "$transcript"

  [[ -f "$audit_path" ]] || {
    echo "Primary audit not written: $audit_path" >&2
    return 1
  }
  verify_queue_status "$domain_id" "DONE_AUDIT_ONLY" || {
    echo "Queue was not updated to DONE_AUDIT_ONLY for $domain_id" >&2
    return 1
  }
  verify_tracker_status "$domain_id" "AUDIT_ONLY" || {
    echo "Tracker was not updated to AUDIT_ONLY for $domain_id" >&2
    return 1
  }
}

run_hostile_review() {
  local domain_id="$1"
  local transcript="$LOG_DIR/${domain_id}.review.transcript.txt"
  mkdir -p "$LOG_DIR"
  bash "$HOSTILE_REVIEW_SCRIPT" "$domain_id" | tee "$transcript"
  [[ -f "06_COORDINATION/audit_outputs/domain_r5/${domain_id}_R5_REVIEW.md" ]] || {
    echo "Hostile review not written for $domain_id" >&2
    return 1
  }
}

run_reconcile_and_remediate() {
  local domain_id="$1"
  local current_commit="$2"
  local audit_path="06_COORDINATION/audit_outputs/domain_r5/${domain_id}_R5_AUDIT.md"
  local review_path="06_COORDINATION/audit_outputs/domain_r5/${domain_id}_R5_REVIEW.md"
  local prompt_file last_message transcript remediation_readme

  prompt_file="$(mktemp)"
  last_message="$LOG_DIR/${domain_id}.reconcile.last.txt"
  transcript="$LOG_DIR/${domain_id}.reconcile.transcript.txt"
  remediation_readme="06_COORDINATION/remediation/${domain_id}/README.md"
  trap 'rm -f "$prompt_file"' RETURN

  render_template "$RECON_TEMPLATE" "$prompt_file" "$domain_id" "$current_commit" "$audit_path" "$review_path"
  run_codex_exec "$prompt_file" "$last_message" "$transcript"

  verify_queue_status "$domain_id" "DONE_REVIEWED" || {
    echo "Queue was not updated to DONE_REVIEWED for $domain_id" >&2
    return 1
  }
  verify_tracker_status "$domain_id" "CLOSED" || {
    echo "Tracker was not updated to CLOSED for $domain_id" >&2
    return 1
  }
  [[ -f "$remediation_readme" ]] || {
    echo "Remediation README not written: $remediation_readme" >&2
    return 1
  }
}

run_one_cycle() {
  local domain_id="$1"
  local current_commit="$2"

  echo "=== DOMAIN: $domain_id ==="
  echo "=== SNAPSHOT: $current_commit ==="

  run_primary_audit "$domain_id" "$current_commit"
  run_hostile_review "$domain_id"
  run_reconcile_and_remediate "$domain_id" "$current_commit"

  local audit_path="06_COORDINATION/audit_outputs/domain_r5/${domain_id}_R5_AUDIT.md"
  local rating safe_claim
  rating="$(extract_audit_rating "$audit_path" || true)"
  safe_claim="$(extract_audit_safe_claim "$audit_path" || true)"

  echo "CLOSED: $domain_id"
  [[ -n "$rating" ]] && echo "RATING: $rating"
  [[ -n "$safe_claim" ]] && echo "SAFE CLAIM: $safe_claim"
}

ensure_repo_preconditions
mkdir -p "$LOG_DIR"

completed=0
while (( completed < COUNT )); do
  local_blocker="$(detect_incomplete_cycle || true)"
  if [[ -n "$local_blocker" ]]; then
    echo "Cannot start a new cycle while another domain is incomplete: $local_blocker" >&2
    exit 1
  fi

  domain_id=""
  if [[ -n "$EXPLICIT_DOMAIN" ]]; then
    domain_id="$EXPLICIT_DOMAIN"
    EXPLICIT_DOMAIN=""
  else
    domain_id="$(next_ready_domain || true)"
  fi

  if [[ -z "$domain_id" ]]; then
    echo "No READY domain found. Audit queue is exhausted or waiting on another phase."
    exit 0
  fi

  current_commit="$(git rev-parse HEAD)"
  if ! run_one_cycle "$domain_id" "$current_commit"; then
    if (( CONTINUE_ON_FAILURE )); then
      echo "Cycle failed for $domain_id; continuing because --continue-on-failure is set." >&2
    else
      echo "Cycle failed for $domain_id; stopping." >&2
      exit 1
    fi
  else
    completed=$((completed + 1))
  fi
done

echo "Completed $completed closed audit cycle(s)."
