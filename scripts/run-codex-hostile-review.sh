#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TRACKER_PATH="06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md"
LOG_DIR="06_COORDINATION/audit_outputs/domain_r5/logs"

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
      id = $2; status = $11
      gsub(/^[ \t]+|[ \t]+$/, "", id); gsub(/^[ \t]+|[ \t]+$/, "", status)
      gsub(/`/, "", id); gsub(/`/, "", status)
      if (status == "BLOCKED" || status == "AUDIT_ONLY" || status == "REVIEWED_PENDING_RECONCILIATION" || status == "REVIEWED_NEEDS_RECONCILIATION") {
        print id; exit
      }
    }
  ' "$TRACKER_PATH"
}

DOMAIN_ID="${1:-}"
if [[ -z "$DOMAIN_ID" ]]; then
  DOMAIN_ID="$(detect_domain_from_tracker || true)"
fi

if [[ -z "$DOMAIN_ID" ]]; then
  echo "No pending domain found and no DOMAIN_ID provided." >&2
  exit 1
fi

AUDIT_PATH="06_COORDINATION/audit_outputs/domain_r5/${DOMAIN_ID}_R5_AUDIT.md"
REVIEW_PATH="06_COORDINATION/audit_outputs/domain_r5/${DOMAIN_ID}_R5_REVIEW.md"

if [[ ! -f "$AUDIT_PATH" ]]; then
  echo "Primary audit not found: $AUDIT_PATH" >&2
  exit 1
fi

command -v codex >/dev/null 2>&1 || { echo "codex CLI not found." >&2; exit 1; }

CURRENT_COMMIT="$(git rev-parse HEAD)"
AUDIT_SNAPSHOT_COMMIT="$(grep -m1 -oE '[0-9a-f]{40}' "$AUDIT_PATH" || true)"
DOMAIN_NAME="$(grep -m1 '^- Domain name:' "$AUDIT_PATH" | sed -E 's/^- Domain name:[[:space:]]*//')"
DOMAIN_NAME="$(trim "${DOMAIN_NAME:-$DOMAIN_ID}")"

mkdir -p "$LOG_DIR"
PROMPT_FILE="$(mktemp)"
LAST_MSG="$LOG_DIR/${DOMAIN_ID}.codex.last.txt"
TRANSCRIPT="$LOG_DIR/${DOMAIN_ID}.codex.transcript.txt"
cleanup() { rm -f "$PROMPT_FILE"; }
trap cleanup EXIT

cat >"$PROMPT_FILE" <<EOF
You are the adversarial reviewer for a RIINA domain audit. Your job is to break the audit if it overclaims, misses contradictions, relies on stale evidence, confuses research breadth with enforceable depth, or assigns a rating that the evidence does not justify.

Repository: /workspaces/proof
Target domain: ${DOMAIN_NAME} (${DOMAIN_ID})
Expected commit: ${CURRENT_COMMIT}
Original audit snapshot: ${AUDIT_SNAPSHOT_COMMIT}
Primary audit: ${AUDIT_PATH}

Write your review to: ${REVIEW_PATH}

Read first:
1. RIINA_MASTER_PLAN.md
2. CLAUDE.md
3. AGENTS.md
4. 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
5. 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
6. ${AUDIT_PATH}

Run these commands first:
- git status --short --branch
- git rev-parse HEAD
- git diff --name-only ${AUDIT_SNAPSHOT_COMMIT}..HEAD
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\\s*Admitted\\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "Derived from" 02_FORMAL

If live implementation is claimed:
- export PATH="\$HOME/.cargo/bin:\$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:\$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml

Non-negotiable rules:
1. If HEAD != ${CURRENT_COMMIT}, mark invalid.
2. Do not count lexer keywords, type wrappers, parser support, generated files, or placeholder theorems as serious evidence.
3. Generated or vacuous non-Coq lanes are negative evidence if counted as independent.
4. Check Coq proof bodies for vacuity (True/trivial, reflexivity on boolean records, Definition := False, A->A tautologies).
5. Assume the audit is wrong until proven otherwise.
6. Attack every gate G1-G14.

Required output structure (use these exact markdown headings):
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

Write the review file to disk and print: WROTE: ${REVIEW_PATH}
EOF

echo "Running Codex hostile review for ${DOMAIN_ID} (${DOMAIN_NAME})" >&2
echo "Audit:  ${AUDIT_PATH}" >&2
echo "Review: ${REVIEW_PATH}" >&2

codex exec \
  --disable shell_snapshot \
  --ephemeral \
  --color never \
  --dangerously-bypass-approvals-and-sandbox \
  -C "$ROOT_DIR" \
  -o "$LAST_MSG" \
  - < "$PROMPT_FILE" | tee "$TRANSCRIPT"

if [[ ! -f "$REVIEW_PATH" ]]; then
  echo "Codex did not write: $REVIEW_PATH" >&2
  exit 1
fi

echo "WROTE: ${REVIEW_PATH}"
