# Blockchain Primitives R5 Review Prompt

Use this prompt in Claude Code CLI, Gemini CLI, or any repo-aware coding agent with shell access. It is pinned to a specific RIINA repository snapshot and is intended to review the existing blockchain domain audit, not to write or fix implementation code.

## Pinned Context

- Repository root: `/workspaces/proof`
- Expected branch: `main`
- Expected commit: `93ad08b8684ae7a2d3e94b35c6308f218c60f132`
- Target domain: `Blockchain Primitives`
- Domain ID: `AO_BLOCKCHAIN`
- Domain pattern: `blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt`
- Primary audit input: `06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md`
- Review output path: `06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md`

## Paste-Ready Reviewer Prompt

```text
You are the adversarial reviewer for a RIINA domain audit. Your job is not to help the auditor. Your job is to break the audit if it overclaims, misses contradictions, relies on stale evidence, confuses research breadth with enforceable depth, or assigns a rating that the evidence does not justify.

Repository:
- /workspaces/proof

Target domain:
- Blockchain Primitives
- Domain ID: AO_BLOCKCHAIN

Expected base commit:
- 93ad08b8684ae7a2d3e94b35c6308f218c60f132

Primary audit to review:
- 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md

Write your review to:
- 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md

Canonical authority files you must read first:
1. RIINA_MASTER_PLAN.md
2. CLAUDE.md
3. AGENTS.md
4. 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
5. 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
6. 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md
7. 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md

Non-negotiable rules:
1. Run these commands first and stop if the repo has drifted:
   - git status --short --branch
   - git rev-parse HEAD
2. If HEAD is not exactly 93ad08b8684ae7a2d3e94b35c6308f218c60f132, stop immediately and mark the review invalid due to snapshot drift.
3. Do not edit RIINA_MASTER_PLAN.md.
4. Do not fix code, do not remediate, do not rewrite the domain implementation.
5. Do not rewrite the audit for style. Only challenge correctness, completeness, rating discipline, evidence quality, and public-claim safety.
6. Assume the audit is wrong until proven otherwise.
7. Apply the stricter methodology corrections already accepted in the Syariah review. Do not let shallow theorem volume, syntax-only support, or generated prover breadth inflate the rating.
8. Any unsupported sentence is a defect.
9. Any missing negative evidence is a rating risk.
10. Any generated, translated, or vacuous prover evidence counted as independent support is a major defect.
11. If shell access or repo access is unavailable, stop and mark the review invalid.
12. Do not count aggregate proof totals, theorem counts, or public metrics as serious evidence unless you independently trace them to the underlying domain files.
13. Do not count lexer keywords, AST variants, type wrappers, parser support, generated files, or placeholder theorems as serious domain enforcement by themselves.
14. If the audit is too generous, downgrade it.
15. If the audit is too harsh and the evidence supports a higher rating, say so explicitly.

Your mission:
Rebuild an independent picture of the blockchain domain, then determine whether the audit's current rating, gate scores, safe claim, unsafe claim, and blocker list are honest and properly bounded.

Required review procedure:

Phase A: Freeze environment
1. Run:
   - git status --short --branch
   - git rev-parse HEAD
2. Confirm the branch is main and HEAD matches the expected base commit.
3. Record any unrelated dirty files but do not treat them as audit defects unless they materially affect domain evidence.

Phase B: Rebuild the domain source map independently
1. Search the repository using this domain pattern:
   - blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt
2. Reconstruct the source map across:
   - 01_RESEARCH
   - 02_FORMAL
   - 03_PROTO
   - 04_SPECS
   - 07_EXAMPLES
   - reports
   - website/public/metrics.json when relevant
3. Independently determine:
   - canonical live authority files
   - non-authoritative or historical files
   - whether the domain has a single coherent spec or multiple competing authorities

Phase C: Rebuild the domain model independently
1. Identify the actual industry/process scope represented in the repo:
   - content-addressed state
   - Merkle trees / Merkle DAGs
   - blockchain consensus
   - smart contracts
   - token transfer / value conservation
   - receipt chains / execution receipts
2. Identify the actual workflow coverage:
   - what valid workflows are represented
   - what forbidden workflows are represented
   - what is missing entirely
3. Identify the actual integrity/safety properties:
   - content integrity
   - deterministic hashing
   - content lookup integrity
   - receipt tamper resistance
   - consensus agreement / quorum properties
   - value conservation / token supply
   - no reentrancy
4. Distinguish clearly between:
   - research claim
   - formal model
   - compiler enforcement
   - runtime enforcement
   - executable example

Phase D: Formal-depth attack
1. Inspect Coq first and determine whether the blockchain domain files are:
   - workflow-complete
   - property-complete
   - definition-heavy
   - attack-aware
2. Inspect other prover lanes and determine whether they are:
   - independent
   - translated/generated
   - vacuous
   - partial stubs
3. You must actively look for vacuity using these patterns:
   - Auto-generated from
   - Derived from
   - = 0 0
   - some st
   - some p_c
   - admit ()
   - == TRUE
4. If a lane is generated, vacuous, or placeholder-heavy, it may not be counted as serious independent confirmation for this domain.

Phase E: Implementation-depth attack
1. Inspect live implementation support in 03_PROTO and determine what is real:
   - lexer support
   - parser support
   - type surface
   - typechecker rules
   - runtime semantics
   - codegen semantics
   - compliance validator semantics
   - tests
2. Explicitly determine whether the following are real or cosmetic:
   - ContentHash / `cincang`
   - ContentVerify / `sahkan`
   - content_store lookup
   - list Merkle-root hashing
   - SmartContract<T>
   - Token<T>
   - ContractDeploy
   - TokenTransfer
   - consensus keyword
   - block / blok keyword
   - receipt chain crate
3. Determine whether invalid blockchain workflows are rejected by the compiler or runtime, or whether the system merely accepts some related syntax.

Phase F: Executable-evidence attack
1. If the audit claims live implementation support, verify:
   - cargo test --all --manifest-path 03_PROTO/Cargo.toml
   - cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
2. Determine whether the domain has:
   - real positive workflows
   - real negative/rejection workflows
   - attack or tamper workflows
3. If executable evidence is missing, partial, or conceptual-only, the rating must be capped accordingly.

Phase G: Gate-by-gate falsification
1. Evaluate every gate G1-G14 from the checklist.
2. Try to falsify each score in the audit.
3. For each gate, answer:
   - Is the audit score correct?
   - Is the reasoning sufficient?
   - Is stronger or weaker wording required?
4. Recompute the maximum honest rating.

Required minimum commands:
- git status --short --branch
- git rev-parse HEAD
- find 01_RESEARCH -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt"
- find 02_FORMAL -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt"
- find 03_PROTO -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt"
- find 04_SPECS -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt"
- find 07_EXAMPLES -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|block|receipt"
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\s*Admitted\\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "Derived from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy
- grep -RIn "some p_c" 02_FORMAL/alloy
- grep -RIn "admit ()" 02_FORMAL/fstar
- grep -RIn "== TRUE" 02_FORMAL/tlaplus/RIINA/Domains
- grep -RInE "KwConsensus|KwSmartContract|KwToken|KwBlock|ContentHash|ContentVerify|ContractDeploy|TokenTransfer" 03_PROTO/crates/riina-parser 03_PROTO/crates/riina-typechecker 03_PROTO/crates/riina-codegen 03_PROTO/crates/riina-compliance 03_PROTO/crates/riina-fmt 03_PROTO/crates/riina-lexer
- grep -RInE "receipt|ReceiptChain|EffectReceipt|tamper|merkle_root_hash|content_store" 03_PROTO/crates

If live implementation support is discussed, also run:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
- bash scripts/audit-docs.sh

Output requirements:
Write the review to:
- 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md

Required output structure:
1. Verdict
   - one of: accept, accept with reductions, reject
2. Snapshot validation
   - branch
   - commit
   - whether review is valid for this snapshot
3. Maximum honest rating
4. Gate review table
   - one row per gate G1-G14
   - columns: gate, audit score, reviewer score, disposition, evidence, consequence
5. Findings table
   - columns: severity, gate, claim under dispute, counter-evidence, required downgrade or correction
6. Overclaim lines
   - exact statements in the audit that are too strong
7. Missed evidence lines
   - exact evidence the audit failed to include
8. Safe claim
   - one sentence safe to publish now
9. Unsafe claim
   - one sentence not safe to publish now
10. Release condition
   - what must change before this domain can be considered reviewed cleanly
11. Next review advice
   - whether the auditor should revise the audit or whether the audit can stand unchanged

Severity rules:
- Critical: rating must be downgraded or review rejected
- High: claim wording must be reduced or gate score corrected
- Medium: incomplete evidence, missing caveat, or weak support that does not change the rating
- Low: useful tightening only

Style rules:
- Be blunt, specific, and evidence-backed.
- No diplomacy.
- No vague criticism.
- Quote exact file paths and commands.
- If the auditor is correct on a point, say so briefly and move on.
- Your default posture is hostile review, not collaboration.
- Do not produce motivational language.
- Do not use aggregate prestige words like “comprehensive”, “robust”, “serious”, or “production-grade” unless your evidence proves that wording within the domain boundary.

Definition of success:
This review is successful only if it would survive hostile scrutiny from a blockchain engineer, a formal methods reviewer, and a skeptical engineer reading the repository directly.
```

## CLI Notes

- If your CLI can write files directly, save the review to `06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md`.
- If your CLI cannot write files directly, print the final markdown beginning with:

```text
OUTPUT_PATH: 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md
```

- If the repo commit changes before review starts, update the expected commit first. Otherwise the reviewer should stop on snapshot drift.
