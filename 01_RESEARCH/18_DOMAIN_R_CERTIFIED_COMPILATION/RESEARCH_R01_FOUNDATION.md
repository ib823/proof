# R-01: Certified Compilation & Translation Validation — Eliminating the Compiler from the TCB

**Domain:** R — Certified Compilation
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Translation validation pass, verified binary lifting, SMT proof certificate checking

---

## 1. Problem Statement

Ken Thompson's 1984 "Reflections on Trusting Trust" demonstrated that a compiler can be subverted to inject backdoors into the binaries it produces, including into future versions of itself. No amount of source code auditing can detect this class of attack, as the backdoor exists only in the compiler binary. This establishes a fundamental trust problem: formal verification of source code is meaningless if the compiler that produces the executable is compromised.

RIINA currently trusts `rustc`, LLVM, and the host linker. If any of these are compromised, the formally verified source-level proofs provide no guarantees about the actual executing binary. The goal of Domain R is to eliminate the compiler from the Trusted Computing Base (TCB) through translation validation — a technique where a separate, verified checker confirms that the compiled binary preserves the semantics of the source program.

Unlike the approach of building a fully verified compiler (as CompCert does), translation validation decouples correctness checking from compilation, allowing use of aggressive optimizing compilers while independently verifying their output.

## 2. State of the Art

### 2.1 CompCert: The Verified Optimizing C Compiler

CompCert, developed by Xavier Leroy at INRIA, is the first formally verified optimizing compiler for a substantial subset of C (ISO C99). Written and verified in Coq, CompCert proves that every compilation pass preserves the observable behavior of the source program. The compiler targets multiple architectures (x86, ARM, PowerPC, RISC-V) and includes approximately 20 compilation passes, each with a machine-checked simulation proof. CompCert's correctness theorem guarantees that if the source program has defined semantics, the generated assembly produces the same observable trace.

CompCert demonstrated that verified compilation is feasible for real-world languages, but its approach requires re-verifying the compiler for every new optimization. This creates a tension between optimization capability and verification effort. CompCert's generated code is typically 10-15% slower than GCC -O1, reflecting the cost of conservative optimization strategies that are tractable to verify.

Leroy, X., "A Formally Verified Compiler Back-end", *Journal of Automated Reasoning*, 43(4):363-446, 2009.

Leroy, X., "Formal Verification of a Realistic Compiler", *Communications of the ACM*, 52(7):107-115, 2009.

### 2.2 CakeML: Verified Compilation for ML

CakeML is a verified compiler for a substantial subset of Standard ML, developed at Chalmers University and UNSW. Unlike CompCert, CakeML is bootstrapped — the compiler is written in CakeML itself and compiled by a verified version of itself. The CakeML project includes a verified parser, type checker, and compiler targeting x86-64, ARM, MIPS, and RISC-V, all verified in HOL4.

CakeML's key innovation is its end-to-end verification story: from source syntax through parsing, type inference, compilation, and code generation, every phase is verified. The project also pioneered verified compilation of pattern matching, garbage collection, and bignum arithmetic. CakeML's bootstrapping capability directly addresses the trust problem by providing a verified path from source to binary.

Tan, Y. K., Owens, S., Kumar, R., Myreen, M. O., et al., "The Verified CakeML Compiler Backend", *Journal of Functional Programming*, 29:e2, 2019.

Kumar, R., Myreen, M. O., Norrish, M., Owens, S., "CakeML: A Verified Implementation of ML", *POPL*, 2014.

### 2.3 Vellvm: Verified LLVM

The Vellvm project (Verified LLVM) formalizes the semantics of LLVM's intermediate representation (IR) in Coq, enabling formal reasoning about LLVM-based compilation. Vellvm defines both a static semantics (well-formedness) and a dynamic semantics (evaluation) for LLVM IR, and provides a framework for proving the correctness of LLVM optimization passes.

Vellvm is particularly relevant to RIINA because RIINA uses LLVM (via Rust/rustc) as its compilation backend. By formalizing LLVM IR semantics, Vellvm enables translation validation between RIINA's source-level semantics and the LLVM IR produced by the Rust compiler.

Zhao, J., Nagarakatte, S., Martin, M. M. K., Zdancewic, S., "Formalizing the LLVM Intermediate Representation for Verified Program Transformations", *POPL*, 2012.

Zakowski, Y., Beck, C., Yoon, I., Zaichuk, I., Zaliva, V., Zdancewic, S., "An Interaction Tree Semantics for Vellvm", *PLDI*, 2021.

### 2.4 Alive2: Automated Translation Validation for LLVM

Alive2, developed by Nuno Lopes et al. at Microsoft Research and the University of Utah, automatically verifies the correctness of LLVM optimization passes by encoding source and target IR programs as SMT formulas and checking refinement. Alive2 has found over 50 confirmed bugs in LLVM's optimization passes, demonstrating that even mature, heavily-tested compilers contain semantic-altering bugs.

Alive2 operates at the LLVM IR level and checks that the optimized program refines the original for all inputs. It handles undefined behavior, poison values, and LLVM's memory model. This tool is directly applicable to RIINA's translation validation strategy, as it demonstrates that SMT-based checking is effective for catching real compiler bugs.

Lopes, N. P., Lee, J., Hur, C.-K., Liu, Z., Regehr, J., "Alive2: Bounded Translation Validation for LLVM", *PLDI*, 2021.

### 2.5 Translation Validation: The Pnueli-Siegel-Singerman Approach

Translation validation was introduced by Pnueli, Siegel, and Singerman as an alternative to verified compilation. Rather than proving the compiler correct once-and-for-all, a validator checks each individual compilation run. This approach is more modular: the compiler can be any black box, and the validator independently confirms semantic preservation. The original framework used simulation relations and was demonstrated on optimizing transformations including dead code elimination, code motion, and strength reduction.

Pnueli, A., Siegel, M., Singerman, E., "Translation Validation", *TACAS*, LNCS 1384, 1998.

### 2.6 Necula's Translation Validation via Credible Compilation

George Necula extended translation validation with the concept of "credible compilation," where the compiler produces both target code and a proof of semantic equivalence. A small, trusted proof checker then validates this proof. This reduces the TCB to the proof checker rather than the full compiler, and the approach was demonstrated for the GNU C compiler.

Necula, G. C., "Translation Validation for an Optimizing Compiler", *PLDI*, 2000.

### 2.7 Sewell et al.: ISA Formal Semantics with Sail

The Sail ISA specification language, developed by the REMS group at Cambridge, provides machine-readable formal semantics for instruction set architectures including ARM (ARMv8-A), RISC-V, and MIPS. These formal models enable rigorous reasoning about the behavior of compiled machine code, which is essential for translation validation at the binary level.

Armstrong, A., Bauereiss, T., Campbell, B., Reid, A., Gray, K. E., Norton, R. M., Mundkur, P., Wassell, M., French, J., Sheridan, C., Pulte, C., Sewell, P., "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS", *POPL*, 2019.

### 2.8 Certified SMT Solving and Proof Certificates

Translation validation often relies on SMT solvers, which are themselves complex and potentially buggy software. The Alethe proof format and LFSC (Logical Framework with Side Conditions) provide standardized proof certificate formats that enable a small, trusted checker to verify SMT solver outputs. This adds an additional layer of trust to the validation pipeline.

Barbosa, H., Blanchette, J. C., Fleury, M., Fontaine, P., "Scalable Fine-Grained Proofs for Formula Processing", *Journal of Automated Reasoning*, 64(3):485-510, 2020.

Stump, A., Oe, D., Reynolds, A., Hadarean, L., Tinelli, C., "SMT Proof Checking Using a Logical Framework", *Formal Methods in System Design*, 42(1):91-118, 2013.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Semantic preservation across compilation | Simulation proof / SMT refinement checking | Translation validator compares source IR and binary IR |
| Absence of compiler-injected backdoors | Observational equivalence verification | Validator rejects semantically divergent binaries |
| Optimization correctness | Per-pass or per-function refinement | SMT-based checking at LLVM IR level (Alive2-style) |
| Binary-source correspondence | Control-flow graph isomorphism checking | Verified binary lifter produces comparable IR |
| Constant-time preservation | Leakage model comparison | Extended validator checks timing-observable equivalence |
| Stack safety | Stack frame bounds verification | Validator proves stack access within allocated frames |
| Information flow preservation | Security label propagation through compilation | Extended non-interference proof across source/binary |

## 4. RIINA Integration Architecture

### 4.1 Translation Validation Pipeline

The RIINA translation validator (RIINA-TV) operates as a post-compilation verification pass:

```
Source (.rii) → Compiler (untrusted) → Binary
     ↓                                    ↓
Source IR ←──── RIINA-TV Validator ────→ Binary IR (lifted)
                     ↓
              Proof Certificate
                     ↓
              Verified Checker (Coq-extracted)
```

The validator compares source-level semantics (from RIINA's MIR) against binary-level semantics (obtained by lifting the binary through a verified lifter). For each function, it generates SMT verification conditions and produces a proof certificate in Alethe format.

### 4.2 Effect System Integration

RIINA's effect system provides additional structure for translation validation:

```riina
// Source-level effect annotation constrains binary behavior
fungsi baca_fail(f: Fail) -> Nombor kesan Baca {
    // Validator must prove binary performs only Read effects
    // Any additional I/O in the binary = compilation bug or backdoor
    pulang baca_data(f);
}
```

The validator checks that the binary's observable effects (system calls, memory-mapped I/O) are a subset of the source-level effect annotation. This provides a strong semantic contract between source and binary.

### 4.3 Coq Formalization

```coq
(* Core translation validation theorem *)
Theorem translation_sound : forall src bin,
  validate src bin = Valid ->
  forall input, eval_source src input = eval_binary bin input.

(* SMT certificate checking *)
Theorem certificate_checker_sound : forall cert formula,
  check_certificate cert formula = true ->
  valid formula.

(* Effect preservation *)
Theorem effects_preserved : forall src bin,
  validate src bin = Valid ->
  effects_of_binary bin ⊆ effects_of_source src.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Leroy, X., "A Formally Verified Compiler Back-end" (2009) | J. Automated Reasoning | CompCert: first verified optimizing compiler |
| Kumar, R., Myreen, M. O., et al., "CakeML: A Verified Implementation of ML" (2014) | POPL | Verified bootstrapping compiler for ML |
| Zhao, J., et al., "Formalizing the LLVM Intermediate Representation" (2012) | POPL | Vellvm: formal LLVM IR semantics in Coq |
| Lopes, N. P., et al., "Alive2: Bounded Translation Validation for LLVM" (2021) | PLDI | Automated LLVM optimization verification; found 50+ bugs |
| Pnueli, A., Siegel, M., Singerman, E., "Translation Validation" (1998) | TACAS | Foundational framework for translation validation |
| Necula, G. C., "Translation Validation for an Optimizing Compiler" (2000) | PLDI | Credible compilation with proof certificates |
| Armstrong, A., et al., "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS" (2019) | POPL | Sail: machine-readable ISA formal semantics |
| Zakowski, Y., et al., "An Interaction Tree Semantics for Vellvm" (2021) | PLDI | Modern Vellvm with interaction trees for I/O |
| Tan, Y. K., et al., "The Verified CakeML Compiler Backend" (2019) | J. Functional Programming | End-to-end verified compiler backend |
| Barbosa, H., et al., "Scalable Fine-Grained Proofs for Formula Processing" (2020) | J. Automated Reasoning | Alethe SMT proof format |
| Thompson, K., "Reflections on Trusting Trust" (1984) | Communications of the ACM | Foundational trust problem in compilation |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Source IR formalization | 3-4 | High — extends existing RIINA Coq semantics | Phase 1 |
| Binary lifter for RISC-V | 6-9 | Medium — requires formal ISA model (Domain S) | Phase 2 |
| SMT-based equivalence checker | 4-6 | High — Alive2 demonstrates feasibility | Phase 2 |
| Proof certificate checker (Coq) | 2-3 | High — small trusted kernel | Phase 2 |
| Effect preservation checker | 2-3 | High — leverages RIINA effect system | Phase 3 |
| Constant-time preservation | 4-6 | Medium — requires leakage model (Domain S) | Phase 3 |
| End-to-end integration | 3-4 | Medium — connecting all components | Phase 4 |
| x86-64/ARM binary lifters | 6-12 | Low-Medium — complex ISAs | Phase 5 |

## 7. Scope Limitations

1. **Undecidability of disassembly.** Disassembling arbitrary x86-64 binaries is undecidable in the general case. RIINA-TV requires compiler-emitted metadata (debug info, stack maps) to guide the lifter. This metadata is not trusted but must be present; stripping it makes validation impossible.

2. **SMT solver soundness.** The translation validator relies on SMT solvers (Z3, CVC5) for checking verification conditions. While proof certificates mitigate this, the certificate checker itself is part of the TCB. A bug in the checker could cause false validation.

3. **Floating-point semantics.** IEEE 754 floating-point operations involve rounding modes, NaN propagation, and platform-specific behavior that make precise semantic comparison between source and binary extremely difficult. RIINA-TV initially targets integer-only code; floating-point validation is deferred.

4. **Linking and whole-program validation.** Translation validation at the function level does not capture cross-function optimizations (inlining, interprocedural analysis) or linker-introduced transformations. Whole-program validation requires a separate phase after final linking.

5. **Performance overhead.** Translation validation adds a verification phase to every build. For large codebases, this could significantly increase build times. Incremental validation (only re-checking changed functions) mitigates this but requires dependency tracking.

6. **No verified binary lifter exists today.** While Sail provides formal ISA semantics, no production-quality verified binary lifter currently exists. Building one is a multi-year effort and a prerequisite for end-to-end validation.

---

*"If you cannot prove it matches, it does not exist."*
