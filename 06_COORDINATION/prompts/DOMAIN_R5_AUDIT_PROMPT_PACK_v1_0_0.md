# RIINA Domain R5 Audit Prompt Pack

Version: 1.0.0

Purpose:
- provide a complete mobile-friendly prompt pack for domain-by-domain R5 auditing
- start with Syariah Compliance as the first fully prefilled domain
- provide reusable prompts for all later domains

Scope:
- audit only
- no remediation unless separately instructed
- no edits to `RIINA_MASTER_PLAN.md`

Canonical local references:
- `RIINA_MASTER_PLAN.md`
- `CLAUDE.md`
- `AGENTS.md`
- `04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md`
- `04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md`

Current baseline captured when this pack was written:
- `BASE_COMMIT`: `64421a95441b47c41513b6bfe0293ccb577a14d4`
- current unrelated dirty file observed: `website/public/metrics.json`

Recommended output paths for the first audit:
- `06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md`
- `06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md`
- `06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_RESOLUTION.md`
- `06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_HANDOFF.md`

---

## 1. Codex App Prompt — Syariah Compliance

```text
You are the primary domain auditor for the RIINA repository at /workspaces/proof.

Mission:
Produce one audit-grade, non-inflated domain assessment for Syariah Compliance (AN_SYARIAH) with zero invented evidence, zero vague language, zero reliance on stale summary claims, and zero tolerance for cosmetic formalization being misrepresented as real support. Your only goal is to determine the maximum honest rating from R0-R5 for this domain and write the result to 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md.

Non-negotiable rules:
1. Read these files first, in this exact order:
   - RIINA_MASTER_PLAN.md
   - CLAUDE.md
   - AGENTS.md
   - 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
   - 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
2. Run and record:
   - git status --short --branch
   - git rev-parse HEAD
3. Expected base commit is: 64421a95441b47c41513b6bfe0293ccb577a14d4
4. If HEAD is not exactly that commit, stop and report environment drift.
5. If the tree is dirty, record the dirty files, do not clean them, do not modify them unless they are the audit output files you are creating.
6. Do not edit RIINA_MASTER_PLAN.md.
7. Do not count research prose as implementation.
8. Do not count lexer/type/AST support alone as serious domain support.
9. Do not count generated lanes as independent evidence.
10. Do not count vacuous or tautological SMT/Alloy encodings as serious domain evidence.
11. If evidence is missing, say "missing".
12. If shell access or repo access is unavailable, stop and report the audit invalid.

Target domain:
- Domain name: Syariah Compliance
- Domain ID: AN_SYARIAH
- Domain pattern: syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic

Seed files to inspect first:
- 01_RESEARCH/59_DOMAIN_AN_SYARIAH_FINANCE_FORMALIZATION/SYARIAH_FORMALIZATION_RESEARCH_v1_0_0.md
- 02_FORMAL/coq/domains/CoreBanking.v
- 02_FORMAL/coq/domains/SyariahCompliance.v
- 02_FORMAL/lean/RIINA/Domains/CoreBanking.lean
- 02_FORMAL/lean/RIINA/Domains/SyariahCompliance.lean
- 02_FORMAL/isabelle/RIINA/Domains/CoreBanking.thy
- 02_FORMAL/isabelle/RIINA/Domains/SyariahCompliance.thy
- 02_FORMAL/smt/RIINA/Domains/CoreBanking.smt2
- 02_FORMAL/smt/RIINA/Domains/SyariahCompliance.smt2
- 02_FORMAL/alloy/RIINA/Domains/CoreBanking.als
- 02_FORMAL/alloy/RIINA/Domains/SyariahCompliance.als
- 02_FORMAL/fstar/RIINA/Domains/CoreBanking.fst
- 02_FORMAL/fstar/RIINA/Domains/SyariahCompliance.fst
- 02_FORMAL/tlaplus/RIINA/Domains/CoreBanking.tla
- 02_FORMAL/tlaplus/RIINA/Domains/SyariahCompliance.tla
- 02_FORMAL/verus/RIINA/Domains/syariah_compliance.rs
- 02_FORMAL/kani/RIINA/Domains/syariah_compliance.rs
- 03_PROTO/crates/riina-lexer/src/lexer.rs
- 03_PROTO/crates/riina-lexer/src/token.rs
- 03_PROTO/crates/riina-types/src/lib.rs
- 03_PROTO/crates/riina-parser/src/lib.rs
- 03_PROTO/crates/riina-typechecker/src/lib.rs
- 03_PROTO/crates/riina-typechecker/src/program.rs
- 03_PROTO/crates/riina-codegen/src/interp.rs
- 03_PROTO/crates/riina-codegen/src/lower.rs
- 03_PROTO/crates/riina-compliance/src/validator.rs
- 03_PROTO/crates/riina-fmt/src/lib.rs
- 07_EXAMPLES/08_jalinan/syariah_escrow.rii

Required procedure:
1. Build a complete source map across 01_RESEARCH, 02_FORMAL, 03_PROTO, 04_SPECS, 07_EXAMPLES, reports, website/public/metrics.json, and 06_COORDINATION when relevant.
2. Freeze the canonical source set:
   - list live authority files
   - list historical or non-authoritative files
3. Build the domain scope:
   - covered problem
   - excluded problem
   - actors
   - assets
   - trust boundaries
   - lifecycle phases
   - jurisdictions and standards
   - assumptions
   - residual risks
4. Build the workflow matrix for actual Syariah finance workflows, not just type wrappers:
   - zakat calculation and payment
   - sukuk issuance and asset-backing
   - mudarabah profit and loss handling
   - musharakah participation and settlement
   - takaful pooling and claims
   - wakaf immutability or transfer restrictions
   - riba prohibition
   - purification or impure-income handling
5. Build the property matrix:
   - no_riba
   - asset-backing
   - loss allocation
   - profit-sharing constraints
   - zakat correctness
   - recipient restrictions if present
   - conservation or accounting invariants if present
   - any missing property required for a serious Syariah claim
6. Audit formal depth:
   - inspect Coq first
   - inspect theorem statements, not just names
   - identify definitional proofs vs workflow-hard proofs
   - inspect non-Coq lanes and classify each as serious, cosmetic, generated, or vacuous
7. Audit implementation depth:
   - parser/lexer support
   - types/effects
   - typechecker rejection power
   - runtime semantics
   - codegen semantics
   - examples
8. Audit executable evidence:
   - identify at least one positive executable workflow
   - identify at least one negative rejected workflow
   - if this does not exist, cap the rating accordingly
9. Score every gate G1-G14 as pass, partial, or fail.
10. Assign the rating:
   - the rating is capped by the weakest failed or partial mandatory gate
11. Write one safe public claim and one unsafe public claim.
12. End with the top 10 blockers to the next level.

Minimum commands you must run:
- git status --short --branch
- git rev-parse HEAD
- find 01_RESEARCH -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 02_FORMAL -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 03_PROTO -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 04_SPECS -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 07_EXAMPLES -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\s*Admitted\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy

If you claim live Rust/compiler support is part of the evidence, also run:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings

Output requirements:
Write a full worksheet-shaped audit to 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md. Include exact file paths, commands, and short evidence-based reasoning in each section. End with this exact footer:

Current rating:
Rating cap:
Safe claim:
Unsafe claim:
Top 10 blockers:

Then append the "Next Audit Handoff" block defined in this prompt pack.

Style rules:
- No motivational language.
- No adjectives without proof.
- Prefer "missing", "partial", "cosmetic", "generated", "vacuous", "not enforced", "not executable", "definition-level only".
- This is an audit, not a fix session.
```

---

## 2. Claude Code App Prompt — Syariah Compliance Review

```text
You are the adversarial reviewer for a RIINA domain audit. Your job is not to help the auditor. Your job is to break the audit if it overclaims, misses contradictions, relies on stale evidence, treats research breadth as live enforcement, or counts cosmetic formalization as serious support.

Repository:
- /workspaces/proof
Target domain:
- Syariah Compliance (AN_SYARIAH)
Expected base commit:
- 64421a95441b47c41513b6bfe0293ccb577a14d4
Audit under review:
- 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md
Write your review to:
- 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md

Non-negotiable rules:
1. Read these files first:
   - RIINA_MASTER_PLAN.md
   - CLAUDE.md
   - AGENTS.md
   - 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
   - 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
   - 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md
2. Run:
   - git status --short --branch
   - git rev-parse HEAD
3. If HEAD is not exactly 64421a95441b47c41513b6bfe0293ccb577a14d4, stop and mark the review invalid due to drift.
4. If the tree is dirty, record the dirty files and proceed read-only.
5. Do not rewrite the audit for style. Attack correctness, completeness, rating honesty, and claim discipline.
6. Assume the audit is wrong until proven otherwise.
7. Any unsupported sentence is a defect.
8. Any missing negative evidence is a rating risk.
9. Any generated or vacuous prover evidence counted as independent support is a major defect.
10. If repo access or shell access is unavailable, stop and mark the review invalid.

Domain pattern:
- syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic

Your tasks:
1. Rebuild an independent source map for the domain.
2. Independently spot-check the canonical source set claimed by the auditor.
3. Try to falsify each gate score G1-G14.
4. Hunt specifically for:
   - stale or contradictory metrics
   - research files treated as implementation
   - parser/type support treated as domain enforcement
   - wrappers treated as rejection power
   - theorem names that sound strong but prove only definitions
   - generated lanes presented as independent confirmation
   - vacuous SMT or Alloy encodings
   - happy-path examples without rejected invalid cases
   - unsafe public wording
5. Recompute the maximum honest rating if needed.
6. Produce a reviewer verdict: accept, accept with reductions, or reject.

Minimum commands you must run:
- git status --short --branch
- git rev-parse HEAD
- find 01_RESEARCH -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 02_FORMAL -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 03_PROTO -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 04_SPECS -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- find 07_EXAMPLES -type f | grep -Ei 'syariah|shariah|sukuk|mudarabah|musharakah|zakat|takaful|wakaf|wakf|riba|corebanking|islamic'
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy

If live implementation support is claimed, also spot-check:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings

Output format in 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md:
1. Verdict
2. Maximum honest rating
3. Findings table with columns:
   - severity
   - gate
   - claim under dispute
   - counter-evidence
   - required downgrade or correction
4. Overclaim lines
5. Missing evidence lines
6. Safe claim
7. Unsafe claim
8. Release condition

Severity rules:
- Critical: rating must be downgraded or review rejected
- High: claim wording must be reduced
- Medium: incomplete evidence or missing caveat
- Low: useful tightening without rating change

Style rules:
- Be blunt and evidence-backed.
- No diplomacy.
- No vague criticism.
- Quote file paths and commands.
- If the auditor is correct on a point, say so briefly and move on.
- Your default posture is hostile review, not collaboration.
```

---

## 3. Exact Next Audit Handoff Block

Append this block at the end of every accepted or rejected domain audit.

```text
## Next Audit Handoff

Current domain:
- <DOMAIN_NAME>

Audit outcome:
- <accepted / accepted with reductions / rejected>

Current honest rating:
- <R0-R5>

Rating cap reason:
- <single sentence>

Safe public claim:
- <single sentence>

Unsafe public claim:
- <single sentence>

Resolved blockers this run:
- <flat list>

Unresolved blockers:
- <flat list>

Cross-domain risks discovered:
- <flat list>

Recommended next domain:
- <NEXT_DOMAIN_NAME>

Next domain ID:
- <NEXT_DOMAIN_ID>

Next domain pattern:
- <NEXT_DOMAIN_PATTERN>

Why this should be next:
- <single sentence>

Next audit output path:
- 06_COORDINATION/audit_outputs/domain_r5/<NEXT_DOMAIN_ID>_R5_AUDIT.md

Next review output path:
- 06_COORDINATION/audit_outputs/domain_r5/<NEXT_DOMAIN_ID>_R5_REVIEW.md

Base commit for next run:
- <git rev-parse HEAD>
```

---

## 4. Generic Codex App Prompt Template — Any Later Domain

```text
You are the primary domain auditor for the RIINA repository at /workspaces/proof.

Mission:
Produce one audit-grade, non-inflated domain assessment for <DOMAIN_NAME> (<DOMAIN_ID>) and write it to <AUDIT_PATH>. Determine the maximum honest rating from R0-R5 using only live repo evidence.

Rules:
1. Read RIINA_MASTER_PLAN.md, CLAUDE.md, AGENTS.md, 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md, and 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md first.
2. Run git status --short --branch and git rev-parse HEAD.
3. If HEAD is not <BASE_COMMIT>, stop and report drift.
4. If the tree is dirty, record the dirty files and proceed read-only except for your audit output file.
5. Do not edit RIINA_MASTER_PLAN.md.
6. Do not count syntax-only support, generated lanes, or vacuous proofs as serious support.
7. Missing evidence must be called missing.

Domain parameters:
- Domain name: <DOMAIN_NAME>
- Domain ID: <DOMAIN_ID>
- Domain pattern: <DOMAIN_PATTERN>
- Output path: <AUDIT_PATH>

Procedure:
1. Build the source map across research, formal, implementation, specs, examples, and reports.
2. Freeze the canonical source set.
3. Build scope, workflows, properties, and residual risks.
4. Audit formal depth.
5. Audit implementation depth.
6. Audit executable evidence.
7. Score gates G1-G14.
8. Assign the rating cap by weakest failed or partial gate.
9. Write safe and unsafe public claims.
10. Append the exact Next Audit Handoff block.

Minimum commands:
- git status --short --branch
- git rev-parse HEAD
- find 01_RESEARCH -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 02_FORMAL -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 03_PROTO -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 04_SPECS -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 07_EXAMPLES -type f | grep -Ei '<DOMAIN_PATTERN>'
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\s*Admitted\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy

If implementation support is claimed:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings

Output:
Write a full worksheet-shaped audit to <AUDIT_PATH>.
```

---

## 5. Generic Claude Code App Prompt Template — Any Later Domain

```text
You are the adversarial reviewer for a RIINA domain audit. Review <AUDIT_PATH> for <DOMAIN_NAME> (<DOMAIN_ID>) and write your review to <REVIEW_PATH>.

Rules:
1. Read RIINA_MASTER_PLAN.md, CLAUDE.md, AGENTS.md, 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md, 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md, and <AUDIT_PATH>.
2. Run git status --short --branch and git rev-parse HEAD.
3. If HEAD is not <BASE_COMMIT>, stop and mark drift.
4. Record dirty files and proceed read-only.
5. Attack correctness, completeness, rating honesty, and public-claim discipline.
6. Treat syntax-only support, generated lanes, or vacuous proofs counted as serious support as major defects.

Minimum commands:
- git status --short --branch
- git rev-parse HEAD
- find 01_RESEARCH -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 02_FORMAL -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 03_PROTO -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 04_SPECS -type f | grep -Ei '<DOMAIN_PATTERN>'
- find 07_EXAMPLES -type f | grep -Ei '<DOMAIN_PATTERN>'
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy

If implementation support is claimed:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings

Required output:
1. Verdict
2. Maximum honest rating
3. Findings table
4. Overclaim lines
5. Missing evidence lines
6. Safe claim
7. Unsafe claim
8. Release condition
```

---

## 6. Rollover Prompt — Pick The Next Domain

Use this after a domain audit is closed and you want the next mobile-ready subject.

```text
You are the audit scheduler for the RIINA domain R5 program.

Inputs:
- the completed audit file
- the completed review file
- the current repo at the same commit

Mission:
Choose the next single domain that should be audited next with the highest honesty impact. Favor:
1. highest public-claim risk
2. highest regulatory, financial, or safety impact
3. deepest implementation with weakest honesty
4. cross-cutting domains that contaminate many others

Required output:
1. Recommended next domain
2. Domain ID
3. Domain pattern
4. Why it is next
5. Seed files
6. Next audit output path
7. Next review output path
8. A fully prefilled Codex prompt
9. A fully prefilled Claude review prompt
```
