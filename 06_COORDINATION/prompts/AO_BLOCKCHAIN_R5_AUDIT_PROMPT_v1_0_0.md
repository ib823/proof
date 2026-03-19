# Verified Blockchain R5 Audit Prompt

Do not launch this audit until the Syariah review is complete.

Prerequisite review gate:
- `06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md` must exist.
- Any rating-method, gate-scoring, wording, or evidence-discipline corrections from that review must be incorporated before starting this audit.

This file is a launch-ready primary-audit prompt for the next domain in the R5 program. It is pinned to the current repository snapshot so the auditor stops on drift instead of producing a mixed-snapshot audit.

## Pinned Context

- Repository root: `/workspaces/proof`
- Expected branch: `main`
- Expected commit: `2005b8471995f6610bd9c841569154e3343ab247`
- Target domain: `Verified Blockchain`
- Domain ID: `AO_BLOCKCHAIN`
- Domain pattern: `blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt`
- Audit output path: `06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md`
- Review output path: `06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md`

## Paste-Ready Primary Auditor Prompt

```text
You are the primary domain auditor for the RIINA repository at /workspaces/proof.

Mission:
Produce one audit-grade domain assessment for Verified Blockchain (AO_BLOCKCHAIN) with zero overclaim, zero invented evidence, zero vague language, zero reliance on stale summary docs, and zero prestige inflation from proof counts alone. Your job is to determine the maximum honest rating from R0-R5 for this domain and write the result to:

- 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md

You are not here to fix the domain. You are here to audit it.

Hard prerequisite:
1. Confirm that the Syariah adversarial review exists at:
   - 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md
2. Read it.
3. Extract any methodology corrections it imposed on the audit process.
4. Apply those corrections to this blockchain audit.
5. If the Syariah review file does not exist, stop immediately and mark this audit as not yet authorized to start.
6. Apply these accepted method corrections from the Syariah review unless stricter evidence forces an even lower judgment:
   - `G4` is `Fail` if threat/failure modeling is only textual or conceptual and is not encoded in executable or formal state transitions.
   - `G6` is `Fail` if the formal theorem set is mainly boolean decomposition, definition unfolding, or direct assumption restatement.
   - `G7` is `Fail` if support is mainly syntax, wrappers, or thin plumbing without meaningful invalid-workflow rejection or invariant enforcement.
   - `G8` is `Fail` if examples are conceptual-only, unexecuted, or not part of a real verified workflow.
   - `G9` is `Fail` if the only negative tests are generic type mismatches rather than domain-specific adversarial cases.

Non-negotiable rules:
1. Read these files first, in this exact order:
   - RIINA_MASTER_PLAN.md
   - CLAUDE.md
   - AGENTS.md
   - 04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md
   - 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md
   - 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md
   - 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md
2. Run and record:
   - git status --short --branch
   - git rev-parse HEAD
3. If HEAD is not exactly 2005b8471995f6610bd9c841569154e3343ab247, stop and report environment drift.
4. If the tree is dirty, record the dirty files and proceed read-only unless explicitly instructed otherwise.
5. Do not edit RIINA_MASTER_PLAN.md.
6. Do not count aggregate proof totals, theorem totals, or public metrics as evidence unless you independently trace them to the actual blockchain domain files.
7. Do not count lexer keywords, AST variants, type wrappers, parser support, generated prover files, placeholder assertions, or vacuous theorems as serious blockchain support.
8. If evidence is missing, say "missing", not "likely".
9. If shell access or repo access is unavailable, stop and report the audit invalid.
10. If the Syariah review reduced the acceptable wording or changed gate interpretation, use the stricter interpretation here.
11. Do not use "formal model exists" as sufficient for `R2`; the theorem set must be nontrivial within the domain boundary.
12. Do not use "tests exist" as sufficient for executable evidence if those tests do not exercise a real blockchain workflow.

Target domain boundaries:
You are auditing the RIINA blockchain-related domain only. This includes content-addressing, Merkle structures, smart-contract semantics, token semantics, consensus semantics, execution receipts, and adjacent on-chain verification claims where they appear in research, formalization, implementation, examples, or reports.

This audit does not automatically inherit correctness from the Syariah audit. It must stand on its own evidence.

Domain pattern:
- blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt

Required procedure:

Phase A: Freeze environment
1. Run:
   - git status --short --branch
   - git rev-parse HEAD
2. Confirm:
   - branch is main
   - HEAD is exactly 2005b8471995f6610bd9c841569154e3343ab247
3. Record any unrelated dirty files without treating them as domain failures unless they affect blockchain evidence directly.

Phase B: Rebuild the domain source map
1. Discover candidate files across:
   - 01_RESEARCH
   - 02_FORMAL
   - 03_PROTO
   - 04_SPECS
   - 07_EXAMPLES
   - reports
   - website/public/metrics.json if relevant
2. Freeze the canonical source set:
   - live authority files
   - historical/non-authoritative files
   - generated translations
   - public summaries that are not suitable as primary evidence
3. Explicitly distinguish:
   - content-addressed state
   - Merkle tree / DAG support
   - smart-contract model
   - token model
   - consensus model
   - execution receipts
   - blockchain examples
   - blockchain-related compliance or runtime claims

Phase C: Rebuild the blockchain domain model
1. Determine the actual covered problem:
   - what blockchain problem is really represented
   - what chain model exists, if any
   - whether this is a ledger model, a smart-contract model, a token-transfer model, or merely a syntax surface
2. Determine excluded problem:
   - what is clearly not modeled
3. Identify:
   - actors
   - assets
   - trust boundaries
   - adversaries
   - lifecycle phases
   - assumptions
   - residual risks
4. Build the workflow matrix:
   - valid workflows
   - forbidden workflows
   - whether each is researched, formalized, enforced, tested, observable
5. Build the property matrix:
   - value conservation
   - no double-spend
   - no reentrancy
   - consensus safety / consistency
   - Merkle root determinism
   - content-address integrity
   - receipt-chain integrity
   - replay resistance
   - tamper evidence
   - asset ownership or transfer correctness
   - whatever else the repo actually proves or enforces

Phase D: Formal-depth audit
1. Inspect Coq first.
2. Determine whether the blockchain formalization is:
   - workflow-complete
   - property-complete
   - attack-aware
   - merely definitional
   - merely aspirational
3. Inspect other prover lanes and classify each as:
   - independent
   - translated/generated
   - vacuous
   - partial
   - serious
4. Actively look for vacuity or cosmetic support using patterns such as:
   - Auto-generated from
   - Derived from
   - = 0 0
   - some st
   - admit ()
   - TRUE-valued safety predicates
5. If a lane is generated, vacuous, or placeholder-heavy, do not count it as serious independent evidence.
6. If the strongest local proofs are mostly hash-definition unfolding, wrapper-preservation facts, or restatements of assumptions, do not count that as nontrivial theorem depth.

Phase E: Implementation-depth audit
1. Inspect live implementation in 03_PROTO.
2. Determine what is real today in:
   - lexer/parser
   - types/effects
   - typechecker
   - interpreter/runtime
   - codegen
   - compliance/tooling
   - tests
3. Explicitly assess whether the following are real or cosmetic:
   - smart_contract / kontrak_pintar
   - token
   - consensus
   - block / blok
   - content-addressed storage
   - Merkle hashing
   - content lookup
   - receipt chain
   - blockchain-related examples
4. Distinguish carefully between:
   - syntax accepted
   - type wrapper exists
   - runtime semantics exist
   - invalid workflow is rejected
   - invariant is enforced
   - attack case is prevented or detected

Phase F: Executable-evidence audit
1. If the domain claims live implementation support, verify:
   - cargo test --all --manifest-path 03_PROTO/Cargo.toml
   - cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings
2. Identify real executable evidence:
   - positive workflow
   - negative/rejection workflow
   - tamper/attack workflow
   - determinism/regression workflow
3. If evidence cannot be executed, cap the rating accordingly.
4. If examples are conceptual only, say so explicitly.
5. If the only negative evidence is parser/type rejection with no blockchain attack or tamper case, mark `G9` accordingly.

Phase G: Claim-discipline audit
1. Search for blockchain claims in research, plans, examples, docs, and implementation comments.
2. Determine whether any public wording outruns:
   - formal depth
   - implementation depth
   - negative test coverage
   - real observability
3. Separate:
   - safe claim
   - unsafe claim

Phase H: Gate scoring
1. Score every gate G1-G14 as pass, partial, or fail.
2. The rating is capped by the weakest failed or partial mandatory gate.
3. Write exact, evidence-backed reasons for every non-pass.

Required minimum commands:
- git status --short --branch
- git rev-parse HEAD
- test -f 06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md && echo REVIEW_PRESENT || echo REVIEW_MISSING
- find 01_RESEARCH -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt"
- find 02_FORMAL -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt"
- find 03_PROTO -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt"
- find 04_SPECS -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt"
- find 07_EXAMPLES -type f | grep -Ei "blockchain|merkle|content|address|smart_contract|kontrak_pintar|token|consensus|blok|receipt"
- grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"
- grep -rnP "^\s*Admitted\\." 02_FORMAL/coq --include="*.v"
- grep -RIn "Auto-generated from" 02_FORMAL
- grep -RIn "Derived from" 02_FORMAL
- grep -RIn "= 0 0" 02_FORMAL/smt
- grep -RIn "some st" 02_FORMAL/alloy
- grep -RIn "admit ()" 02_FORMAL/fstar
- grep -RIn "== TRUE" 02_FORMAL/tlaplus/RIINA/Domains
- grep -RInE "KwSmartContract|KwToken|KwConsensus|KwBlock" 03_PROTO/crates
- grep -RInE "ContentHash|ContentVerify|ContractDeploy|TokenTransfer|Receipt" 03_PROTO/crates

If live implementation support is present, also run:
- export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
- cargo test --all --manifest-path 03_PROTO/Cargo.toml
- cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings

Output requirements:
Write a complete audit record to:
- 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md

Use the worksheet structure from:
- 04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md

Required content:
1. Identity
2. Canonical sources
3. Scope
4. Workflow matrix
5. Property matrix
6. Formal evidence
7. Implementation evidence
8. Executable evidence
9. Gate scores G1-G14
10. Rating
11. Safe public wording
12. Blocking gaps
13. Promotion checklist
14. Sign-off

End the audit with:
- Current rating
- Rating cap
- Safe claim
- Unsafe claim
- Top 10 blockers to next level

Then append this exact handoff structure at the end:

## Next Audit Handoff

Current domain:
- Verified Blockchain

Audit outcome:
- <accepted / accepted with reductions / rejected / accepted pending adversarial review>

Current honest rating:
- <R0-R5>

Rating cap reason:
- <single sentence>

Safe public claim:
- <single sentence>

Unsafe public claim:
- <single sentence>

Resolved blockers this run:
- <list>

Unresolved blockers:
- <list>

Cross-domain risks discovered:
- <list>

Recommended next domain:
- <DOMAIN_NAME>

Next domain ID:
- <DOMAIN_ID>

Next domain pattern:
- <DOMAIN_PATTERN>

Why this should be next:
- <single sentence>

Next audit output path:
- <path>

Next review output path:
- <path>

Base commit for next run:
- <git rev-parse HEAD>

Style rules:
- No motivational language.
- No vague praise.
- No adjectives without proof.
- Prefer "missing", "partial", "cosmetic", "generated", "vacuous", "definition-level only", "not enforced", "not executable".
- Every substantive sentence must be traceable to a file path, command, or observed absence.
- This is an audit, not a repair session.

Definition of success:
This audit is successful only if a skeptical engineer, formal methods reviewer, and hostile domain reviewer could reproduce the evidence and agree that the rating does not overstate the repo.

If your CLI cannot write files directly:
- print the full audit in markdown
- begin with the exact line: OUTPUT_PATH: 06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md
- do not shorten any section
```

## Operator Notes

- Do not run this prompt until the Syariah review exists and any methodology corrections from that review are folded in.
- If the repository moves to a new commit before you launch, update the pinned commit first.
- This is the primary auditor prompt only. The adversarial review prompt should be generated after the Syariah review confirms the method is stable enough to reuse unchanged.
