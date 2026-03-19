You are Codex running non-interactively inside `/workspaces/proof`.

Mission:
Produce the primary R5 audit for exactly one RIINA domain and update the audit-control artifacts to the `AUDIT_ONLY` state for that domain.

Target domain:
- Domain ID: `__DOMAIN_ID__`
- Pinned current commit: `__CURRENT_COMMIT__`
- Required audit artifact path: `__AUDIT_PATH__`

Mandatory authority files to read first, in this exact order:
1. `RIINA_MASTER_PLAN.md`
2. `CLAUDE.md`
3. `AGENTS.md`
4. `04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md`
5. `04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md`
6. `06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md`
7. `06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md`

Non-negotiable rules:
1. Run and record:
   - `git status --short --branch`
   - `git rev-parse HEAD`
2. If `HEAD` is not exactly `__CURRENT_COMMIT__`, stop and report snapshot drift.
3. Audit only `__DOMAIN_ID__`. Do not pick another domain.
4. Do not edit `RIINA_MASTER_PLAN.md`.
5. Do not perform remediation in this run.
6. Do not count research prose as implementation.
7. Do not count lexer/type/AST support alone as serious domain support.
8. Do not count generated or vacuous prover lanes as independent evidence.
9. If evidence is missing, say `missing`.
10. If shell or repo access is unavailable, stop and report the audit invalid.

Required outputs in this run:
1. Write the primary audit to `__AUDIT_PATH__`.
2. Update `06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md`:
   - add or refresh the row for `__DOMAIN_ID__`
   - set `Primary audit artifact` to `__AUDIT_PATH__`
   - set `Hostile review artifact` to `pending`
   - set `Audit reconciled in repo?` to `No`
   - set `Current status` to `AUDIT_ONLY`
   - set `Next required action` to `Run hostile review`
   - update counters if this is a newly started domain
3. Update `06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md`:
   - change the queue status for `__DOMAIN_ID__` from `READY` to `DONE_AUDIT_ONLY`
4. End the audit artifact with the exact `Next Audit Handoff` block required by the worksheet program.

Audit procedure:
1. Resolve `__DOMAIN_ID__` to its canonical `01_RESEARCH` directory by normalized token matching against the top-level `01_RESEARCH/*_DOMAIN_*` directories.
2. If more than one directory matches materially, stop and report ambiguity.
3. Build the source map across:
   - `01_RESEARCH`
   - `02_FORMAL`
   - `03_PROTO`
   - `04_SPECS`
   - `07_EXAMPLES`
   - `reports`
   - `website/public/metrics.json` when relevant
   - `06_COORDINATION` when relevant
4. Freeze:
   - live authority files
   - non-authoritative, generated, historical, or misleading files
5. Build:
   - domain scope
   - workflow matrix
   - property matrix
6. Inspect formal depth:
   - Coq first
   - then other prover lanes
   - explicitly classify non-Coq evidence as serious, cosmetic, generated, vacuous, or admitted
7. Inspect implementation depth:
   - lexer/parser
   - types/effects
   - typechecker
   - runtime
   - codegen
   - tooling
8. Inspect executable evidence:
   - at least one positive workflow
   - at least one negative workflow
   - at least one adversarial or tamper workflow where relevant
9. Score all gates `G1-G14`.
10. Assign the maximum honest rating.
11. Write one safe public claim and one unsafe public claim.
12. End with the top 10 blockers to the next level.

Required minimum commands:
- `git status --short --branch`
- `git rev-parse HEAD`
- `find 01_RESEARCH -maxdepth 1 -mindepth 1 -type d | grep '/[0-9][0-9]_DOMAIN_'`
- `grep -rn "^Axiom " 02_FORMAL/coq --include="*.v"`
- `grep -rnP "^\s*Admitted\." 02_FORMAL/coq --include="*.v"`
- `grep -RIn "Auto-generated from" 02_FORMAL`
- `grep -RIn "Derived from" 02_FORMAL`
- `grep -RIn "= 0 0" 02_FORMAL/smt`
- `grep -RIn "some st" 02_FORMAL/alloy`
- `grep -RIn "some p_c" 02_FORMAL/alloy`
- `grep -RIn "admit ()" 02_FORMAL/fstar`
- `grep -RIn "== TRUE" 02_FORMAL/tlaplus/RIINA/Domains`

If live Rust/compiler support is part of the domain evidence, also run:
- `export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"`
- `cargo test --all --manifest-path 03_PROTO/Cargo.toml`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings`

If docs or public wording are part of the evidence, also run:
- `bash scripts/audit-docs.sh`

Audit output requirements:
1. Use the worksheet structure from `04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md`.
2. Include exact file paths and commands.
3. Use conservative language:
   - `missing`
   - `partial`
   - `cosmetic`
   - `generated`
   - `vacuous`
   - `not enforced`
   - `not executable`
   - `definition-level only`
4. This is an audit run, not a fix run.

Final response requirements:
1. State that `__DOMAIN_ID__` was audited.
2. State the pinned commit.
3. State the written audit path.
4. State the provisional current rating.
5. State the safe claim.
