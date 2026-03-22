# Claude Code Audit Handoff — Current Snapshot

Use this in Claude Code to continue the RIINA domain-audit program from the current repository state.

## Repository

- Repo root: `/workspaces/proof`
- Branch required: `main`
- Expected current `HEAD`: `2d436b083b56005b101f18718a7bd0f0aab722e9`

## Read First

Read these files before taking any action:

1. `RIINA_MASTER_PLAN.md`
2. `CLAUDE.md`
3. `AGENTS.md`
4. `04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md`
5. `04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md`
6. `06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md`
7. `06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md`

Run and record:

- `git status --short --branch`
- `git rev-parse HEAD`

If `HEAD` is not exactly `2d436b083b56005b101f18718a7bd0f0aab722e9`, stop and report snapshot drift.

## Current Program Truth

- Closed umbrella audits in repo: `10 / 79`
- Current next ready umbrella under strict sequencing: `B_EFFECT_SYSTEMS`
- Current tracker says there is no incomplete cycle blocking a new primary audit

## Important Working Tree Note

At the moment this repository may contain unrelated dirty files outside audit-control scope. Do not silently ignore them. If they are still present when you start, report them explicitly and do not run the full coordinator blindly.

Known current dirty paths at handoff time:

- `reports/dim1_dim9_promotion_status.json`
- `reports/public_quality_status.json`
- `website/public/metrics.json`
- `image.png`
- `scripts/run-domain-audit-program.sh`
- `scripts/run-claude-hostile-review.sh`
- `scripts/run-hostile-review.sh`

The audit-control script changes are intentional. The reports/image files are not part of the hostile-review fallback work and must not be rewritten unless explicitly requested.

## What Was Just Added

The hostile-review automation now supports Claude Code CLI as a fallback reviewer:

- `scripts/run-claude-hostile-review.sh`
- `scripts/run-hostile-review.sh`
- `scripts/run-domain-audit-program.sh` now calls the dispatcher instead of Gemini directly

The Claude fallback was smoke-tested reversibly against `AN_SYARIAH` and produced a structurally valid review after sanitizing preamble text.

## Your Job

Continue the audit program with full rigor, without weakening the rules.

Default target:

- `B_EFFECT_SYSTEMS`

If strict queue conditions have changed, use the queue/tracker as authority.

## Non-Negotiable Rules

1. Do not edit `RIINA_MASTER_PLAN.md`.
2. Do not claim a domain is closed unless:
   - primary audit exists
   - hostile review exists in-repo
   - audit is reconciled in-repo
   - remediation package exists if required
3. Do not count lexer keywords, parser support, type wrappers, generated prover files, vacuous SMT/Alloy/TLA encodings, or aggregate proof counts as serious support by themselves.
4. If you cannot get a valid hostile review artifact, the domain remains `AUDIT_ONLY` or `BLOCKED`.
5. If you use ChatGPT web as a reviewer later, treat it as non-authoritative unless it was given the full evidence bundle and produced a structured adversarial review.

## Recommended Execution Path

If the working tree is clean enough for the audit program:

1. Run the primary audit for `B_EFFECT_SYSTEMS`
2. Write:
   - `06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_AUDIT.md`
3. Update:
   - `06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md`
   - `06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md`
4. Stop after the primary audit if the hostile review will be performed outside the repo

If the working tree is not clean enough:

1. Report the blocking dirty files
2. Do not run the full coordinator
3. If explicitly instructed, continue with a manual primary audit only

## Output Requirements

At the end of your run, report:

1. Whether snapshot drift was present
2. Whether the working tree blocked full automation
3. Which domain you audited
4. Exact artifact paths written
5. The provisional or final rating
6. Whether hostile review is still pending
7. The exact next required action
