#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TRACKER_PATH="06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/run-gemini-hostile-review.sh [DOMAIN_ID]

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

CURRENT_COMMIT="$(git rev-parse HEAD)"
AUDIT_SNAPSHOT_COMMIT="$(grep -m1 -oE '[0-9a-f]{40}' "$AUDIT_PATH" || true)"
if [[ -z "$AUDIT_SNAPSHOT_COMMIT" ]]; then
  echo "Could not derive audit snapshot commit from $AUDIT_PATH" >&2
  exit 1
fi

DOMAIN_NAME="$(grep -m1 '^- Domain name:' "$AUDIT_PATH" | sed -E 's/^- Domain name:[[:space:]]*//')"
DOMAIN_NAME="$(trim "${DOMAIN_NAME:-$DOMAIN_ID}")"

PROMPT_FILE="$(mktemp)"
cleanup() {
  rm -f "$PROMPT_FILE"
}
trap cleanup EXIT

cat >"$PROMPT_FILE" <<EOF
You are the adversarial reviewer for a RIINA domain audit. Your job is not to help the auditor. Your job is to break the audit if it overclaims, misses contradictions, relies on stale evidence, confuses research breadth with enforceable depth, or assigns a rating that the evidence does not justify.

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

Write your review to:
- ${REVIEW_PATH}

Canonical authority files you must read first:
1. RIINA_MASTER_PLAN.md
2. CLAUDE.md
3. AGENTS.md
4. 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
5. 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
6. ${AUDIT_PATH}
7. 06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md
8. 06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md

Non-negotiable rules:
1. Run these commands first:
   - git status --short --branch
   - git rev-parse HEAD
   - git diff --name-only ${AUDIT_SNAPSHOT_COMMIT}..HEAD
2. If HEAD is not exactly ${CURRENT_COMMIT}, stop immediately and mark the review invalid due to snapshot drift.
3. Before reviewing the domain, determine whether any files changed since ${AUDIT_SNAPSHOT_COMMIT} materially affect this domain's evidence.
4. If the diff since ${AUDIT_SNAPSHOT_COMMIT} includes domain-relevant implementation, formal, or example files beyond audit/control docs, stop and mark the review invalid due to material evidence drift.
5. If the diff since ${AUDIT_SNAPSHOT_COMMIT} is only audit docs, prompts, remediation docs, tracker files, or unrelated website/docs changes, proceed and explicitly say the review remains materially valid for the domain evidence surface.
6. Do not edit RIINA_MASTER_PLAN.md.
7. Do not fix code, do not remediate, do not rewrite domain implementation.
8. Do not rewrite the audit for style. Only challenge correctness, completeness, rating discipline, evidence quality, and public-claim safety.
9. Assume the audit is wrong until proven otherwise.
10. Any unsupported sentence is a defect.
11. Any missing negative evidence is a rating risk.
12. Any generated, translated, or vacuous prover evidence counted as independent support is a major defect.
13. Do not count aggregate proof totals, theorem counts, or public metrics as serious evidence unless you independently trace them to the underlying domain files.
14. Do not count lexer keywords, AST variants, type wrappers, parser support, generated files, or placeholder theorems as serious domain enforcement by themselves.
15. If the audit is too generous, downgrade it.
16. If the audit is too harsh and the evidence supports a higher rating, say so explicitly.
17. If a cited path lookup fails, inspect the filesystem and resolve the exact case-sensitive path before treating it as missing evidence.
18. A case-only path mismatch is not domain evidence; it is an operational lookup issue. Resolve it and continue.

Your mission:
Rebuild an independent picture of the domain, then determine whether the audit's current rating, gate scores, safe claim, unsafe claim, and blocker list are honest and properly bounded.

Required review procedure:
1. Rebuild the source map independently across 01_RESEARCH, 02_FORMAL, 03_PROTO, 04_SPECS, 07_EXAMPLES, reports, and relevant public docs.
2. Use the primary audit's canonical source list as a seed, but do not trust it without verification.
3. Derive domain-specific search terms from:
   - the domain name
   - the domain ID
   - the canonical sources listed in the audit
4. Inspect Coq first, then other prover lanes.
5. Explicitly hunt for:
   - Auto-generated from
   - Derived from
   - = 0 0
   - some st
   - some p_c
   - admit ()
   - == TRUE
6. Inspect live implementation support where the audit claims it.
7. Re-run cargo tests / clippy / audit-docs if implementation or public wording is part of the evidence.
8. Recompute the maximum honest rating.
9. Attack every gate G1-G14.

Required minimum commands:
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

If live implementation support is claimed, also run:
- export PATH="\$HOME/.cargo/bin:\$HOME/.rustup/toolchains/1.94.1-x86_64-unknown-linux-gnu/bin:\$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
- bash scripts/audit-docs.sh

Output requirements:
Write the review to:
- ${REVIEW_PATH}

Required output structure:
1. Verdict
   - one of: accept, accept with reductions, reject
2. Snapshot validation
   - branch
   - commit
   - whether review is valid for this snapshot
   - whether drift from the original audit snapshot is materially harmless or materially invalidating
3. Maximum honest rating
4. Gate review table
   - one row per gate G1-G14
   - columns: gate, audit score, reviewer score, disposition, evidence, consequence
5. Findings table
   - columns: severity, gate, claim under dispute, counter-evidence, required downgrade or correction
6. Overclaim lines
7. Missed evidence lines
8. Safe claim
9. Unsafe claim
10. Release condition
11. Next review advice

At the end, write the review file to disk and print only:
WROTE: ${REVIEW_PATH}
EOF

echo "Running Gemini hostile review for ${DOMAIN_ID} (${DOMAIN_NAME})"
echo "Audit:  ${AUDIT_PATH}"
echo "Review: ${REVIEW_PATH}"

PROMPT_CONTENT="$(cat "$PROMPT_FILE")"
gemini -y --output-format text -p "$PROMPT_CONTENT"

if [[ ! -f "$REVIEW_PATH" ]]; then
  echo "Gemini did not write the expected review file: $REVIEW_PATH" >&2
  exit 1
fi

echo "WROTE: ${REVIEW_PATH}"
