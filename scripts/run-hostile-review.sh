#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PREFERENCE="${RIINA_HOSTILE_REVIEW_PREFERENCE:-gemini-first}"
LOG_DIR="06_COORDINATION/audit_outputs/domain_r5/logs"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/run-hostile-review.sh [DOMAIN_ID]

Environment:
  RIINA_HOSTILE_REVIEW_PREFERENCE=gemini-first|claude-first|gemini-only|claude-only

Behavior:
  - Tries the configured hostile-review runner order.
  - Accepts success only when the runner exits 0 and the final review artifact exists.
  - Falls back from Gemini to Claude when Gemini fails, does not write a valid artifact,
    or is unavailable.
EOF
}

review_exists() {
  local domain_id="$1"
  local review_path="06_COORDINATION/audit_outputs/domain_r5/${domain_id}_R5_REVIEW.md"
  [[ -s "$review_path" ]]
}

validate_review_artifact() {
  local path="$1"
  [[ -s "$path" ]] || return 1

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
      return 1
    fi
  done

  return 0
}

run_one() {
  local runner="$1"
  local domain_id="$2"

  case "$runner" in
    gemini)
      if ! command -v gemini >/dev/null 2>&1; then
        echo "Skipping Gemini hostile review: gemini binary not found." >&2
        return 1
      fi
      bash scripts/run-gemini-hostile-review.sh "$domain_id"
      ;;
    claude)
      if ! command -v claude >/dev/null 2>&1; then
        echo "Skipping Claude hostile review: claude binary not found." >&2
        return 1
      fi
      bash scripts/run-claude-hostile-review.sh "$domain_id"
      ;;
    codex)
      if ! command -v codex >/dev/null 2>&1; then
        echo "Skipping Codex hostile review: codex binary not found." >&2
        return 1
      fi
      bash scripts/run-codex-hostile-review.sh "$domain_id"
      ;;
    *)
      echo "Unknown hostile-review runner: $runner" >&2
      return 1
      ;;
  esac
}

run_order() {
  case "$PREFERENCE" in
    gemini-first)
      printf '%s\n' gemini claude
      ;;
    claude-first)
      printf '%s\n' claude gemini
      ;;
    gemini-only)
      printf '%s\n' gemini
      ;;
    claude-only)
      printf '%s\n' claude
      ;;
    *)
      echo "Invalid RIINA_HOSTILE_REVIEW_PREFERENCE: $PREFERENCE" >&2
      exit 1
      ;;
  esac
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

DOMAIN_ID="${1:-}"
mkdir -p "$LOG_DIR"

while IFS= read -r runner; do
  [[ -n "$runner" ]] || continue
  echo "Attempting hostile review with: $runner" >&2
  if run_one "$runner" "$DOMAIN_ID"; then
    if review_exists "$DOMAIN_ID"; then
      review_path="06_COORDINATION/audit_outputs/domain_r5/${DOMAIN_ID}_R5_REVIEW.md"
      if ! validate_review_artifact "$review_path"; then
        invalid_copy="$LOG_DIR/${DOMAIN_ID}.${runner}.invalid.review.md"
        cp "$review_path" "$invalid_copy"
        rm -f "$review_path"
        echo "Runner $runner produced an invalid review artifact; saved copy to $invalid_copy" >&2
        continue
      fi
      echo "HOSTILE_REVIEW_RUNNER: $runner"
      exit 0
    fi
    echo "Runner $runner exited successfully but no review artifact was written." >&2
  else
    echo "Runner $runner failed." >&2
  fi
done < <(run_order)

echo "No hostile-review runner succeeded." >&2
exit 1
