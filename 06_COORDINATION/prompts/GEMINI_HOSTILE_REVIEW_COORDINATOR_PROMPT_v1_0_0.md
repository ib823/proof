# Gemini Hostile Review Coordinator Prompt v1.0.0

This is the generic Gemini hostile-review prompt pattern for the RIINA audit program.

Recommended use:
- automated path: `bash scripts/run-gemini-hostile-review.sh <DOMAIN_ID>`
- manual path: copy the template below, fill the placeholders, and run with:
  - `gemini -y -p "<filled prompt>"`

Best practice:
- let the primary audit be written here first
- then run Gemini as the hostile reviewer
- then bring the review artifact back here for reconciliation
- do not let Gemini remediate or update queue/tracker files

## Automated Command

```bash
bash scripts/run-gemini-hostile-review.sh AO_BLOCKCHAIN
```

If omitted, `scripts/run-gemini-hostile-review.sh` will try to auto-detect the first pending domain from:
- [AUDIT_PROGRAM_STATUS_v1_0_0.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md)

## Manual Template

Replace:
- `<DOMAIN_NAME>`
- `<DOMAIN_ID>`
- `<CURRENT_COMMIT>`
- `<AUDIT_SNAPSHOT_COMMIT>`
- `<AUDIT_PATH>`
- `<REVIEW_PATH>`

```text
You are the adversarial reviewer for a RIINA domain audit. Your job is not to help the auditor. Your job is to break the audit if it overclaims, misses contradictions, relies on stale evidence, confuses research breadth with enforceable depth, or assigns a rating that the evidence does not justify.

Repository:
- /workspaces/proof

Target domain:
- <DOMAIN_NAME>
- Domain ID: <DOMAIN_ID>

Expected current commit:
- <CURRENT_COMMIT>

Original audit snapshot commit:
- <AUDIT_SNAPSHOT_COMMIT>

Primary audit to review:
- <AUDIT_PATH>

Write your review to:
- <REVIEW_PATH>

Canonical authority files you must read first:
1. RIINA_MASTER_PLAN.md
2. CLAUDE.md
3. AGENTS.md
4. 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
5. 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
6. <AUDIT_PATH>
7. 06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md
8. 06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md

Non-negotiable rules:
1. Run these commands first:
   - git status --short --branch
   - git rev-parse HEAD
   - git diff --name-only <AUDIT_SNAPSHOT_COMMIT>..HEAD
2. If HEAD is not exactly <CURRENT_COMMIT>, stop immediately and mark the review invalid due to snapshot drift.
3. Before reviewing the domain, determine whether any files changed since <AUDIT_SNAPSHOT_COMMIT> materially affect this domain's evidence.
4. If the diff since <AUDIT_SNAPSHOT_COMMIT> includes domain-relevant implementation, formal, or example files beyond audit/control docs, stop and mark the review invalid due to material evidence drift.
5. If the diff since <AUDIT_SNAPSHOT_COMMIT> is only audit docs, prompts, remediation docs, tracker files, or unrelated website/docs changes, proceed and explicitly say the review remains materially valid for the domain evidence surface.
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
- git diff --name-only <AUDIT_SNAPSHOT_COMMIT>..HEAD
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\s*Admitted\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "Derived from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy
- grep -RIn "some p_c" 02_FORMAL/alloy
- grep -RIn "admit ()" 02_FORMAL/fstar
- grep -RIn "== TRUE" 02_FORMAL/tlaplus/RIINA/Domains

If live implementation support is claimed, also run:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
- bash scripts/audit-docs.sh

Output requirements:
Write the review to:
- <REVIEW_PATH>

Required output structure:
1. Verdict
2. Snapshot validation
3. Maximum honest rating
4. Gate review table
5. Findings table
6. Overclaim lines
7. Missed evidence lines
8. Safe claim
9. Unsafe claim
10. Release condition
11. Next review advice

At the end, write the review file to disk and print only:
WROTE: <REVIEW_PATH>
```
