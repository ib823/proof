#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TRACKER_PATH="06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md"
LOG_DIR="06_COORDINATION/audit_outputs/domain_r5/logs"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/run-claude-hostile-review.sh [DOMAIN_ID]

Behavior:
  - If DOMAIN_ID is provided, review that domain.
  - If DOMAIN_ID is omitted, auto-select the first pending domain from
    AUDIT_PROGRAM_STATUS_v1_0_0.md with status:
      BLOCKED
      AUDIT_ONLY
      REVIEWED_PENDING_RECONCILIATION
      REVIEWED_NEEDS_RECONCILIATION

Expected convention:
  - primary audit at 06_COORDINATION/audit_outputs/domain_r5/<DOMAIN_ID>_R5_AUDIT.md
  - hostile review at 06_COORDINATION/audit_outputs/domain_r5/<DOMAIN_ID>_R5_REVIEW.md
EOF
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

detect_domain_from_tracker() {
  [[ -f "$TRACKER_PATH" ]] || return 1
  awk -F'|' '
    /^\| `/ {
      id = $2
      status = $11
      gsub(/^[ \t]+|[ \t]+$/, "", id)
      gsub(/^[ \t]+|[ \t]+$/, "", status)
      gsub(/`/, "", id)
      gsub(/`/, "", status)
      if (status == "BLOCKED" || status == "AUDIT_ONLY" || status == "REVIEWED_PENDING_RECONCILIATION" || status == "REVIEWED_NEEDS_RECONCILIATION") {
        print id
        exit
      }
    }
  ' "$TRACKER_PATH"
}

validate_review_markdown() {
  local path="$1"
  [[ -s "$path" ]] || {
    echo "Claude review output is empty: $path" >&2
    return 1
  }

  local line_count
  line_count="$(wc -l < "$path")"
  if (( line_count < 20 )); then
    echo "Claude review output is too short to be trusted: $path" >&2
    return 1
  fi

  local required_patterns=(
    '^#{1,6}[[:space:]]*Verdict([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Snapshot validation([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Maximum honest rating([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Gate review table([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Findings table([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Safe claim([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Unsafe claim([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Release condition([[:space:]]|$)'
    '^#{1,6}[[:space:]]*Next review advice([[:space:]]|$)'
  )

  local pattern
  for pattern in "${required_patterns[@]}"; do
    if ! grep -qiE "$pattern" "$path"; then
      echo "Claude review output is missing a required section: $pattern" >&2
      return 1
    fi
  done

  if grep -qiE '^(I (can'\''t|cannot|do not have|don'\''t have|am unable to)|I[[:space:]]*was unable to|I[[:space:]]*could not|I[[:space:]]*cannot access|I[[:space:]]*can'\''t access)' "$path"; then
    echo "Claude review output reports tool/access failure and cannot be accepted." >&2
    return 1
  fi

  return 0
}

sanitize_review_markdown() {
  local input_path="$1"
  local output_path="$2"
  awk '
    found || /^## Verdict([[:space:]]|$)/ {
      found = 1
      print
    }
  ' "$input_path" > "$output_path"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

DOMAIN_ID="${1:-}"
if [[ -z "$DOMAIN_ID" ]]; then
  DOMAIN_ID="$(detect_domain_from_tracker || true)"
fi

if [[ -z "$DOMAIN_ID" ]]; then
  echo "No pending domain found in $TRACKER_PATH and no DOMAIN_ID was provided." >&2
  exit 1
fi

AUDIT_PATH="06_COORDINATION/audit_outputs/domain_r5/${DOMAIN_ID}_R5_AUDIT.md"
REVIEW_PATH="06_COORDINATION/audit_outputs/domain_r5/${DOMAIN_ID}_R5_REVIEW.md"

if [[ ! -f "$AUDIT_PATH" ]]; then
  echo "Primary audit artifact not found: $AUDIT_PATH" >&2
  exit 1
fi

command -v claude >/dev/null 2>&1 || {
  echo "Claude Code CLI not found in PATH." >&2
  exit 1
}

CURRENT_COMMIT="$(git rev-parse HEAD)"
AUDIT_SNAPSHOT_COMMIT="$(grep -m1 -oE '[0-9a-f]{40}' "$AUDIT_PATH" || true)"
if [[ -z "$AUDIT_SNAPSHOT_COMMIT" ]]; then
  echo "Could not derive audit snapshot commit from $AUDIT_PATH" >&2
  exit 1
fi

DOMAIN_NAME="$(grep -m1 '^- Domain name:' "$AUDIT_PATH" | sed -E 's/^- Domain name:[[:space:]]*//')"
DOMAIN_NAME="$(trim "${DOMAIN_NAME:-$DOMAIN_ID}")"

mkdir -p "$LOG_DIR"

PROMPT_FILE="$(mktemp)"
STDOUT_FILE="$(mktemp)"
TMP_REVIEW_FILE="$(mktemp)"

cleanup() {
  rm -f "$PROMPT_FILE" "$STDOUT_FILE" "$TMP_REVIEW_FILE"
}
trap cleanup EXIT

cat >"$PROMPT_FILE" <<EOF
You are the adversarial reviewer for a RIINA domain audit. You are not helping the auditor. Your job is to find overclaim, weak evidence, stale evidence, vacuous proofs, superficial implementation support, and rating inflation.

Repository:
- /workspaces/proof

Target domain:
- ${DOMAIN_NAME}
- Domain ID: ${DOMAIN_ID}

Expected current commit:
- ${CURRENT_COMMIT}

Original audit snapshot commit:
- ${AUDIT_SNAPSHOT_COMMIT}

Primary audit to review:
- ${AUDIT_PATH}

Read these first:
1. RIINA_MASTER_PLAN.md
2. CLAUDE.md
3. AGENTS.md
4. 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
5. 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
6. ${AUDIT_PATH}
7. 06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md
8. 06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md

Run these commands first:
- git status --short --branch
- git rev-parse HEAD
- git diff --name-only ${AUDIT_SNAPSHOT_COMMIT}..HEAD
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\\s*Admitted\\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "Derived from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy
- grep -RIn "some p_c" 02_FORMAL/alloy
- grep -RIn "admit ()" 02_FORMAL/fstar
- grep -RIn "== TRUE" 02_FORMAL/tlaplus/RIINA/Domains

If the audit claims live implementation support, also run:
- export PATH="\$HOME/.cargo/bin:\$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:\$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
- bash scripts/audit-docs.sh

Non-negotiable rules:
1. If HEAD is not exactly ${CURRENT_COMMIT}, mark the review invalid due to snapshot drift.
2. If material evidence files changed since ${AUDIT_SNAPSHOT_COMMIT}, mark the review invalid due to evidence drift.
3. Do not count lexer keywords, AST variants, type wrappers, parser support, generated files, placeholder theorems, public metrics, or aggregate proof counts as serious evidence by themselves.
4. Generated or vacuous non-Coq lanes are negative evidence if the audit counted them as independent support.
5. Assume the audit is wrong until proven otherwise.
6. Attack every gate G1-G14.
7. Print markdown only to stdout. Do not write files. Do not print chatter before or after the markdown.

Required output structure, using markdown headings exactly:
## Verdict
## Snapshot validation
## Maximum honest rating
## Gate review table
## Findings table
## Overclaim lines
## Missed evidence lines
## Safe claim
## Unsafe claim
## Release condition
## Next review advice

Be blunt, precise, and evidence-backed. Quote exact paths and commands when making material claims.
EOF

echo "Running Claude hostile review for ${DOMAIN_ID} (${DOMAIN_NAME})" >&2
echo "Audit:  ${AUDIT_PATH}" >&2
echo "Review: ${REVIEW_PATH}" >&2

if ! timeout 45m claude -p --dangerously-skip-permissions <"$PROMPT_FILE" >"$STDOUT_FILE"; then
  echo "Claude hostile review failed for ${DOMAIN_ID}" >&2
  exit 1
fi

sanitize_review_markdown "$STDOUT_FILE" "$TMP_REVIEW_FILE"
if ! validate_review_markdown "$TMP_REVIEW_FILE"; then
  cp "$STDOUT_FILE" "$LOG_DIR/${DOMAIN_ID}.claude.invalid.review.txt"
  echo "Saved invalid Claude output to $LOG_DIR/${DOMAIN_ID}.claude.invalid.review.txt" >&2
  exit 1
fi

mv "$TMP_REVIEW_FILE" "$REVIEW_PATH"
echo "WROTE: ${REVIEW_PATH}"
