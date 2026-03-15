# TRACK B1 WORKER PROMPT — Isabelle, F*, TLA+, Alloy Mechanization

**READ `RIINA_MASTER_PLAN.md` AND `CLAUDE.md` FIRST. They are root authority.**

---

## MISSION

Bring 4 verification lanes from `generated` → `compiled` → `mechanized` claim level.

| Lane | Files | Extension | Directory | Raw Decls | Current Status |
|------|-------|-----------|-----------|-----------|----------------|
| Isabelle/HOL | 275 | `.thy` | `02_FORMAL/isabelle/RIINA/` | 9,165 lemmas | generated (0 sorry, 0 oops, never compiled) |
| F* | 265 | `.fst` | `02_FORMAL/fstar/RIINA/` | 219 lemmas | generated (75 files have `assume val` holes) |
| TLA+ | 267 | `.tla` | `02_FORMAL/tlaplus/RIINA/` | 5,893 theorems | generated (never TLC-checked) |
| Alloy 6 | 260 | `.als` | `02_FORMAL/alloy/RIINA/` | 8,434 assertions | generated (never Alloy-checked) |

**These files were auto-generated from Coq originals by `scripts/generate-multiprover.py` and `scripts/generate-full-stack.py`. They have NEVER been compiled. Expect significant errors.**

---

## ENVIRONMENT CONSTRAINT

**You DO NOT have Isabelle, F*, TLA2tools, or Alloy installed.** You cannot run builds.
You CAN read files, write fixes, and commit. A separate environment will verify builds.

**Your job: Fix every file so it WOULD compile if the tool were present.**

This means:
- Fix syntax errors a compiler would reject
- Fix type errors you can identify from language knowledge
- Fix import/module structure issues
- Remove or replace broken proof tactics
- Ensure zero `sorry`/`oops`/`assume val` holes

---

## LANE 1: ISABELLE/HOL

### What you need to know
- Isabelle version: Isabelle2024 (target)
- Theory files use `theory Name imports Main begin ... end`
- Proofs end with `by auto`, `by simp`, `by blast`, `by (induction ...) auto`, etc.
- `sorry` and `oops` are forbidden — they are proof holes
- `lemma` and `theorem` are interchangeable
- Imports use `imports Main` or `imports "~~/src/HOL/Library/..."`

### Current state
- 275 `.thy` files across Foundations/, Properties/, TypeSystem/, Domains/, Industries/, etc.
- 0 files with `sorry` or `oops` in source
- 9,165 raw lemma/theorem declarations
- Generated from Coq via `generate-multiprover.py` — auto-translated structure

### What to fix
1. **Theory headers**: Ensure `theory X imports Main begin` at top, `end` at bottom
2. **Type definitions**: Verify `datatype`, `fun`, `definition` syntax
3. **Proof structure**: Every `lemma`/`theorem` must have a proof (`by auto`, `by simp`, `by blast`, etc.)
4. **Import chains**: Files that reference other RIINA theories need proper `imports`
5. **Isabelle-specific syntax**: `\<forall>`, `\<exists>`, `\<Rightarrow>`, etc. — or ASCII equivalents
6. **No `sorry` or `oops`**: If a proof is too hard, simplify the lemma statement, don't add sorry

### Priority order
1. `Foundations/` (Syntax.thy, Typing.thy, Semantics.thy) — these are imported by everything
2. `TypeSystem/` (Progress.thy, Preservation.thy, TypeSafety.thy)
3. `Properties/` (SecurityProperties.thy, NonInterference.thy, etc.)
4. `Effects/` (EffectSystem.thy, EffectAlgebra.thy)
5. `Termination/` (StrongNorm.thy, Reducibility.thy)
6. `Domains/` (alphabetical)
7. `Industries/` (alphabetical)
8. `Compliance/` (alphabetical)

---

## LANE 2: F*

### What you need to know
- F* is a dependently-typed ML-like language
- Modules use `module RIINA.Foundations.Syntax`
- `assume val` is an axiom hole — equivalent to `sorry`. **FORBIDDEN.**
- `val` + `let` defines a function with its type
- Proofs are just programs — `let lemma_name () : Lemma (...) = ()`
- `Tot` = total, `Lemma` = proof obligation, `GTot` = ghost

### Current state
- 265 `.fst` files
- **75 files have `assume val` holes** — these MUST be replaced with real implementations
- Generated from Coq — many stubs use `nat` incorrectly (F* uses `int` or `nat` from `FStar.Mul`)
- Broken `match` expressions (matching on `nat` as if it were an inductive type)

### What to fix
1. **Replace ALL `assume val` with real definitions** — even simple stubs like `let f x = 0`
2. **Fix module structure**: `module RIINA.X.Y` must match file path
3. **Fix types**: F* `nat` is not Coq `nat`. Use `FStar.UInt32.t` or `int` for numbers
4. **Fix match expressions**: F* doesn't pattern-match on `nat` like Coq. Use `if/then/else`
5. **Ensure `open` statements reference real F* modules** (e.g., `open FStar.All`, not made-up names)

### Priority order
Same as Isabelle: Foundations → TypeSystem → Properties → Effects → Termination → Domains

---

## LANE 3: TLA+

### What you need to know
- TLA+ specs are `.tla` files using `---- MODULE Name ----` ... `====`
- `EXTENDS Naturals, FiniteSets, Sequences` for standard modules
- `CONSTANTS`, `VARIABLES`, operator definitions
- `THEOREM` declarations with `PROOF BY ...` or `OBVIOUS` or `BY DEF ...`
- TLC (the model checker) requires `SPECIFICATION Spec` and bounded constants for checking
- `ASSUME` is used for constant assumptions, not proof holes

### Current state
- 267 `.tla` files
- 5,893 `THEOREM` declarations
- 0 known `sorry`-equivalents
- Structure mirrors Coq modules

### What to fix
1. **Module headers**: `---- MODULE X ----` at top, `====` at bottom
2. **EXTENDS**: Ensure standard modules are imported correctly
3. **Operator definitions**: TLA+ uses `==` for definitions, not `=`
4. **THEOREM proofs**: Must end with `PROOF` clause or `OBVIOUS`
5. **CASE syntax**: TLA+ uses `CASE` with `[]` separators
6. **No dangling references**: Operators used must be defined or imported

### Priority order
Same hierarchy: Foundations → TypeSystem → Properties → Domains

---

## LANE 4: ALLOY 6

### What you need to know
- Alloy 6 models are `.als` files
- `module riina/foundations/Typing`
- `sig` for signatures, `fact` for constraints, `pred` for predicates, `assert` for assertions
- `check` commands run bounded model checking on assertions
- `fun` for functions, `run` for finding instances

### Current state
- 260 `.als` files
- 8,434 raw assertions
- Structure mirrors Coq modules

### What to fix
1. **Module declarations**: `module riina/x/Y` matching file path
2. **Sig hierarchy**: `abstract sig`, `extends`, `one sig`
3. **Fact/pred/assert syntax**: Alloy-specific quantifiers (`all`, `some`, `no`, `lone`, `one`)
4. **Check commands**: Every `assert` should have a matching `check` with bounded scope
5. **No `expect 0` without a real check**: Ensure assertions are meaningful

### Priority order
Same hierarchy: Foundations → TypeSystem → Properties → Domains

---

## EXECUTION PROTOCOL

### Branch Policy
**All work on `main` branch. No exceptions.**

### Commit Format
```
[TRACK_A] PROOF: Description     — for proof work
```
Examples:
```
[TRACK_A] PROOF: Fix Isabelle Foundations theories (Syntax, Typing, Semantics)
[TRACK_A] PROOF: Replace F* assume val holes in Properties/
[TRACK_A] PROOF: Fix TLA+ module headers and THEOREM proofs in Domains/
[TRACK_A] PROOF: Fix Alloy sig hierarchy and check commands
```

### Work Pattern
1. **Pick a lane and subdirectory** (e.g., Isabelle Foundations/)
2. **Read every file** in that subdirectory
3. **Fix all errors** you can identify from language knowledge
4. **Commit the batch** with descriptive message
5. **Move to next subdirectory**
6. **After each lane is complete**, move to the next lane

### Per-file checklist
- [ ] Header/module declaration correct
- [ ] All imports/extends valid
- [ ] All type definitions syntactically correct
- [ ] All lemma/theorem/assert bodies present (no holes)
- [ ] No `sorry`, `oops`, `assume val`, or equivalent holes
- [ ] File ends properly (Isabelle: `end`, TLA+: `====`, etc.)

---

## FORBIDDEN ACTIONS

1. **NEVER** add `sorry`, `oops`, `assume val`, or any proof hole
2. **NEVER** delete theorems/lemmas to make files compile — fix them instead
3. **NEVER** create new planning documents — update `RIINA_MASTER_PLAN.md` only
4. **NEVER** modify files outside `02_FORMAL/isabelle/`, `02_FORMAL/fstar/`, `02_FORMAL/tlaplus/`, `02_FORMAL/alloy/`
5. **NEVER** touch `02_FORMAL/coq/` or `02_FORMAL/lean/` — those are Track A and already mechanized
6. **NEVER** modify `03_PROTO/` (Rust code) — that is Track B compiler work
7. **NEVER** force push or commit to `public` branch
8. **NEVER** run `scripts/sync-public.sh` — the CLI environment handles that

---

## FILE OWNERSHIP (CONFLICT AVOIDANCE)

This worker ONLY touches:
```
02_FORMAL/isabelle/   ← Track B1
02_FORMAL/fstar/      ← Track B1
02_FORMAL/tlaplus/    ← Track B1
02_FORMAL/alloy/      ← Track B1
```

These directories are EXCLUSIVELY yours. No other worker touches them.
The CLI environment works on `02_FORMAL/smt/`, `02_FORMAL/verus/`, `02_FORMAL/kani/`, `02_FORMAL/tv/`.

---

## SUCCESS CRITERIA

A lane is "mechanized" when:
1. Zero `sorry`/`oops`/`assume val` holes in any file
2. All files have syntactically valid structure for their language
3. The tool binary (when provisioned) compiles the full lane without errors

**You control criteria 1-2. Criteria 3 is verified by the CLI environment after your work.**

---

## QUALITY OVER SPEED

If a theorem is genuinely unprovable without the original Coq proof context:
- **Simplify the statement** to something provable (e.g., weaken the conclusion)
- **Add a comment**: `(* Simplified from Coq original — strengthen when build environment available *)`
- **NEVER add sorry/oops** — a weaker true theorem beats an admitted false one

---

## VERIFICATION AFTER COMPLETION

After all 4 lanes are fixed, the CLI environment will:
1. Run `bash scripts/provision-smoke-toolchains.sh`
2. Run `isabelle build`, `fstar.exe`, `java -jar tla2tools.jar`, `java -jar alloy.jar`
3. Feed any errors back to you for a second fix round
4. Repeat until all 4 lanes compile clean

**Target: 6/10 provers mechanized (Coq + Lean + Isabelle + F* + TLA+ + Alloy)**
