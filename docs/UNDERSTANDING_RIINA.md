# Understanding RIINA

## The Complete Guide to a Programming Language with a Coq-Verified Core Model

---

> *"What if you could build software where security failures are not just unlikely, but mathematically impossible?"*

---

## What Is RIINA?

RIINA stands for **Rigorous Immutable Invariant, No Assumptions**. It is a programming language with a Coq-verified core model: its core type and effect rules are proven in Coq for the language model — checked by machine, not by human opinion — and the compiler is tested against that model.

Most software security today works like a lock on a door: it deters attackers, but a sufficiently skilled person can pick it. RIINA aims to build a room with no door at all. For the core of the language model, a class of vulnerability does not exist there because mathematics proves it cannot; outside that core, and in the shipped compiler, the checks are tested rather than proven.

RIINA is also the first programming language with native **Bahasa Melayu** (Malaysian language) syntax — its keywords are in Malay, so its Coq-verified core model is built on a non-English foundation.

---

## The Analogy: A Country Where Crime Is Mathematically Impossible

To understand RIINA's architecture, imagine building an entire country from scratch — not just its laws, but its physics. In this country, crime is not merely illegal; it is physically impossible. A thief cannot steal because the laws of physics in this country prevent objects from being moved without authorization. A spy cannot eavesdrop because sound waves in this country cannot travel to unauthorized ears.

This is not science fiction. This is what formal verification aims to do for software. For the core of its language model, RIINA does not hope its rules work: Coq proves they do, the same way mathematicians prove that 2 + 2 = 4. No amount of cleverness, funding, or computing power can make 2 + 2 equal 5 — but a proof covers only the model it is about. RIINA's proofs cover the core of the language model; the compiler that turns your program into machine code is tested against that model, not proven.

Every part of RIINA maps to a part of this country:

---

## The Foundation: Tracks and What They Build

### Track A — The Constitution (Formal Proofs)

Every country needs a constitution — the foundational law that all other laws derive from. Track A is RIINA's constitution, written not in legal language but in mathematical logic, verified by a proof assistant called Coq (now Rocq).

**What it contains:**
- **Type Safety** — Every value in a RIINA program has a guaranteed type. You cannot accidentally treat a number as a password or a password as a public message. This is proven as a mathematical theorem about the language model, not enforced by a runtime check; the compiler's type checker is tested against that model.
- **Non-Interference (proven for the reference-free, recursion-free core; enforced by tests beyond it)** — Secret data should not flow to public outputs. For the reference-free, `fix`-free core, Coq proves it (`ref_free_noninterference`, closed under the global context): two runs that differ only in their secret inputs return the same observable result, and take the same number of evaluation steps (`ref_free_constant_time`: reduction-count independence from secrets in the model, for the core fragment — not a wall-clock timing guarantee). With references or general recursion it is not yet a theorem (REQ-89); beyond the core it is enforced by tests of the compiler's information-flow typing rules.
- **Effect Safety** — Every side effect (reading a file, sending a network request, accessing the clock) must be declared, and the compiler rejects a function that performs an undeclared one. In Coq, every configuration reachable by evaluating a well-typed term performs only effects within its *declared* effect (`effect_sound_multi_step_declared`). That bound orders effects by a single level (a total order); separately, Coq proves a set-based fact that needs no ordering: evaluation never produces an effect that is not written somewhere in the program or its initial store (`reachable_effects_from_program_text`).
- **Declassification Correctness** — When secrets do need to be revealed (e.g., showing the last 4 digits of a credit card), this can only happen through an explicit, auditable process with a proof that the policy is followed. This is proven in the Coq model; aligning the shipped compiler with it is still in progress.

**Current state:** 1,679 core Qed (foundations, type system, properties, effects, termination and the compiler-linked crypto policy), 9,719 model Qed (domain, industry, compliance, crypto and runtime models — facts about their own definitions, not verified systems), 1,443 excluded Qed (vacuous patterns, examples, counterexamples or test files); 0 Admitted, 0 `Axiom`, 29 `Parameter`s (trusted hardware interface; none of the capstone theorems depends on them); 335 active proof files.
**Last synced:** 2026-10-20, from `website/public/metrics.json`. No independent audit published yet.

Nine capstone theorems are kernel-attested closed under the global context (axiom-free): `type_safety`, `progress`, `preservation`, `accepts_uses_only_current`, `effect_sound_multi_step_declared`, `reachable_effects_from_program_text`, `ref_free_well_typed_SN`, `ref_free_noninterference` and `ref_free_constant_time`. The 29 `Parameter`s are the build's named trusted assumptions; historical/archived files may still contain others.

### Track B — The Government (Compiler & Runtime)

The constitution means nothing without a government to enforce it. Track B is RIINA's compiler — the program that reads RIINA source code and produces executable software.

**What it contains:**
- **Lexer** — Reads RIINA source code character by character and identifies tokens (keywords, numbers, strings). Recognizes Bahasa Melayu keywords like `fungsi` (function), `biar` (let), `kalau` (if).
- **Parser** — Arranges tokens into a structured tree (Abstract Syntax Tree) that represents the program's logic.
- **Type Checker** — Verifies that the program obeys all type rules, security labels, and effect declarations. This is where the constitution's rules become enforceable law; the checker is tested against the Coq model, not proven to match it.
- **Code Generator** — Translates the type-checked program into executable code. Currently targets C (native), WASM (web), Android (JNI), and iOS (Swift bridge); the WASM and mobile backends are scaffolding. The C/native backend is not formally verified; it is differential-tested against the interpreter.
- **Standard Library** — 88 built-in functions across 9 modules (strings, lists, math, maps, sets, testing, time, files, JSON).
- **Developer Tools** — Formatter (`riina-fmt`), language server (`riina-lsp`), documentation generator (`riina-doc`), VS Code extension, package manager (`riina-pkg`), REPL.

**Current state:** 18 crates (Rust packages) in the compiler workspace, 3,569 tests, all passing, plus the tooling workspace's own tests. 0 third-party runtime dependencies in the shipped compiler; development and CI use separate tools (Rocq toolchain, `cc`, `wasmtime`, `z3`, fuzz harnesses, NIST test vectors).

### Track C — The Legal Code (Specifications)

A constitution establishes principles; a legal code spells out specific rules. Track C contains RIINA's formal specifications — the precise documents that define what every language feature means, how every syntax element behaves, and what every compliance rule requires.

**What it contains:**
- Language grammar and syntax specification
- Type system specification (CTSS v1.0.1)
- Bahasa Melayu keyword mapping
- 15 industry compliance specifications (PCI-DSS, HIPAA, GDPR, PDPA, and 11 others)
- The master 8-phase materialization plan

### Track F — Public Works (Tooling & Infrastructure)

Every country needs infrastructure — roads, utilities, communication networks. Track F provides the build system, CI/CD pipeline, cryptographic primitives, and deployment tools.

**What it contains:**
- Build orchestrator, verification orchestrator
- Cryptographic primitives (HMAC-SHA256, AES-256-GCM, SHA-2/SHA-3, X25519, Ed25519, ML-KEM-768, ML-DSA-65 — all implemented without third-party dependencies; ChaCha20-Poly1305 is not implemented). This in-house cryptography (`riina-core`) is experimental and has not been audited — do not use it to protect real secrets yet. ML-KEM and ML-DSA are tested against NIST known-answer (ACVP) vectors; not validated (no CMVP/CAVP certificate)
- Release system (versioning, changelog, deployment scripts)
- Docker and Nix packaging

---

## The Zero-Trust Bureau: Tracks R, S, T, U

Most security systems trust something — the compiler, the hardware, the operating system, the build tools. RIINA aims to trust as little as possible and to name what it does trust: today its Coq build declares 29 `Parameter`s for the trusted hardware interface. Tracks R through U are the country's anti-corruption agencies, each responsible for ensuring that no component of the system can silently betray the user.

### Track R — The Inspector General (Certified Compilation)

**Question it answers:** "How do we know the compiler did not secretly insert a backdoor?"

When the compiler translates RIINA source code into machine code, Track R's goal is to verify that the translation is faithful: the compiled program must behave identically to the source code, proven mathematically. This would prevent the "trusting trust" attack (where a compromised compiler inserts vulnerabilities that persist even when the compiler is recompiled).

**Current state:** Translation validation is modelled in Coq (`TranslationValidation.v`, plus a WASM backend model); these are model results about their own definitions, not a verified compiler. The shipped C/native backend is not formally verified; it is differential-tested against the interpreter. Research foundation complete; production hardening is Phase 8 work.

### Track S — The Physics Inspector (Hardware Contracts)

**Question it answers:** "How do we know the CPU itself is not leaking secrets?"

Modern CPUs can leak information through timing differences, power consumption, and speculative execution (Spectre, Meltdown). Track S models these hardware behaviors mathematically, with the goal of proving that RIINA's generated code does not expose secrets through these side channels. That is not proven today: what Coq proves is reduction-count independence from secrets in the model, for the core fragment (`ref_free_constant_time`), not timing on a real CPU.

**Current state:** Research foundation complete. Constant-time operation types exist in the compiler. Full hardware contract verification is Phase 8 work.

### Track T — The Birth Certificate (Hermetic Build)

**Question it answers:** "How do we know the build tools themselves were not compromised?"

Track T aims to ensure that RIINA can be built from nothing — bootstrapped from a minimal, auditable seed (conceptually from raw hex). This means you do not need to trust any existing software to verify RIINA. You can rebuild everything from scratch and check that the result matches.

**Current state:** Research foundation complete. Production implementation is Phase 8 work.

### Track U — The Bodyguard (Runtime Guardian)

**Question it answers:** "How do we know the operating system is not tampering with our program at runtime?"

Even after compilation, a malicious OS could modify program memory, intercept system calls, or tamper with I/O. Track U designs a micro-hypervisor meant to be verified — a minimal runtime environment that protects RIINA programs from the OS itself. Today it is a Coq model only.

**Current state:** Research foundation complete. Production implementation is Phase 8 work.

---

## The Completeness Bureau: Tracks V, W, X, Y, Z

Security alone is not enough if the program can crash, leak memory, or deadlock. Tracks V through Z aim to ensure RIINA programs are not just secure but correct and complete.

### Track V — The Termination Office

**What it proves:** Strong normalization for the **reference-free, `fix`-free core** — every well-typed program there finishes, with no premises (`ref_free_well_typed_SN`). References had to be excluded: a function stored in a reference can call itself through that reference (Landin's knot), and Coq proves that such a well-typed program diverges, so the older `well_typed_SN` statement for the full calculus is false (REQ-84). Programs using general recursion (`fungsi`/`fix`) are Turing-complete and *can* loop by design; for them the guarantee is **type safety** (they never crash or get stuck — progress + preservation, mechanized for `fix`), not termination. Structurally-decreasing recursion is covered by **sized types**. Techniques: a Tait-style logical relation with closed-value substitution + sized types.

### Track W — The Memory Authority

**What it models:** Memory is always used correctly. No buffer overflows, no use-after-free, no double-free, no memory leaks. Uses separation logic — a mathematical framework for reasoning about memory ownership. Today this is a Coq model about its own definitions, not a proof about the shipped compiler or runtime.

### Track X — The Traffic Controller (Concurrency)

**What it proves:** When multiple parts of a program run simultaneously, they cannot interfere with each other in harmful ways. No data races, no deadlocks — proven for the session *calculus* mechanized in Coq; the compiler's projection mirrors those definitions but is not itself a verified compiler (see `docs/papers/04_session_types.md` for the precise scope). Uses session types — mathematical descriptions of communication protocols.

### Track Y — The Standards Bureau (Verified Standard Library)

**What it models:** Every function in the standard library does exactly what its specification says. The sort function actually sorts. The search function actually finds. The encryption function actually encrypts. Today this is a Coq model of a standard library, not a proof about the shipped builtins.

### Track Z — The Declassification Authority

**What it models:** When secrets must be partially revealed (e.g., showing a masked credit card number), the revelation follows a strict, auditable policy with mathematical budget constraints on how much information can be released. This is a Coq model; the shipped compiler's alignment with it is still in progress.

**Current state for V-Z:** Research foundations complete. Type safety and dynamic effect soundness are fully proven in the active build; strong normalization, non-interference and reduction-count independence from secrets in the model are proven for the reference-free, recursion-free (`fix`-free) core, and enforced by tests beyond it. Extending them to references and recursion is REQ-89. Extended properties are Phase 8 work.

---

## Industry Compliance: Domain Tracks

RIINA does not just model generic security properties. It maps them to specific industry regulations as Coq models of each regulation's rules — facts about their own definitions — and as compiler checks. The result is evidence toward a profile; not a conformity assessment or certification.

| Domain | Regulation | What RIINA Models |
|--------|-----------|-------------------|
| Military & Defense | CMMC, ITAR | Classified-data flow and export-control rules |
| Healthcare | HIPAA | Patient data flowing only to authorized recipients |
| Financial Services | PCI-DSS, SOX | Card-data encryption and tamper-evident audit trails |
| Data Protection | GDPR, PDPA | Consent and purpose limitations on personal-data processing |
| Aviation | DO-178C | Selected airborne-software objectives (no certification) |
| Industrial | IEC 62443 | Selected control-system security requirements |
| Energy | NERC CIP | Selected critical-infrastructure protection rules |
| Pharmaceutical | FDA 21 CFR Part 11 | Electronic-record integrity requirements |
| Government | NIST 800-53, ISO 27001 | Selected federal and international security controls |

The compiler checks a subset of these rules itself. Running `riinac check --compliance pci-dss` does not call an external scanner — the compiler runs regulation-specific heuristic checks on your code. Their output is evidence toward the profile; not a conformity assessment or certification.

**Current state:** 606 heuristic rules across 19 profiles (`riinac check --list-compliance`). Each is evidence toward a profile, not a conformity assessment or certification.

---

## The Eight Phases: How RIINA Was Built

RIINA was constructed in eight phases, each building on the previous:

| Phase | Name | What It Built | Status |
|-------|------|---------------|--------|
| 1 | Compiler Completion | The core compiler: lexer, parser, type checker, code generator, REPL | Done |
| 2 | Standard Library | 88 built-in functions across 9 modules | Done |
| 3 | Formal Verification | Coq (mechanized): 1,679 core Qed, 9,719 model Qed, 1,443 excluded Qed; 0 Admitted, 0 `Axiom`, 29 `Parameter`s (trusted hardware interface; none of the capstone theorems depends on them) | Stable |
| 4 | Developer Experience | Formatter, language server, doc generator, VS Code extension, examples (172 today; 84 pass `riinac check`) | Done |
| 5 | Ecosystem | Package manager, CI/CD, Docker, Nix, release system, Proprietary license | Done |
| 6 | Adoption | C FFI, demo apps, community setup, enterprise compliance-profile checks, public repository | Done |
| 7 | Platform Universality | WASM backend, mobile backends (scaffolding), in-browser playground, backend differential tests | Done |
| 8 | Long-term Vision | Self-hosting compiler, hardware verification, verified OS | Future |

Phases 1 through 7 are complete. Phase 8 represents the long-term vision where RIINA becomes fully self-sufficient — compiling itself, verifying its own hardware, and running on a verified operating system.

---

## What Makes RIINA Different

### Compared to Traditional Security

| Traditional Approach | RIINA Approach |
|---------------------|----------------|
| Penetration testing finds *some* bugs | For the core language model, mathematical proof rules out *entire classes* of bugs |
| Code review depends on human attention | For the core model, machine-checked proof covers every possible execution path |
| Security scanners detect known patterns | Within the core model, formal proofs cover all patterns, including unknown ones |
| Compliance is audited periodically | Compliance-profile checks run at every compilation (evidence toward a profile; not a conformity assessment or certification) |
| Updates can introduce new vulnerabilities | Proven properties of the model stay proven — the proofs are re-checked on every build |

### Compared to Formally Verified Systems

RIINA is not the first project to use formal verification. Operating systems (seL4), compilers (CompCert), and cryptographic libraries (HACL*) have been formally verified. In RIINA the security properties are part of the type system itself: programs that compile pass the type and effect checks the compiler implements, and for the core fragment those rules are proven in Coq. The compiler itself is tested against that model, not verified.

### The Quantum and AI Argument

Quantum computers threaten current encryption. AI can find vulnerabilities faster than humans can patch them. Neither threatens a proven property of RIINA's core model. A mathematical proof that "secret data cannot flow to public outputs" does not depend on encryption strength or human response time. In RIINA that proof covers the reference-free, recursion-free core of the language model; beyond it the property is enforced by tests, and the compiler is tested against the model, not proven.

Post-quantum cryptographic algorithms can be implemented in RIINA and their usage is checked by the same type system, for rules the compiler implements. Attack vectors — AI-discovered or not — that exploit type confusion or information leaks are ruled out in the proven core model and blocked by the checks the compiler implements; they are not mathematically eliminated from the shipped compiler.

---

## Key Numbers (Living Reference)

These numbers reflect the current verified state of the codebase:

| Metric | Value |
|--------|-------|
| Coq proofs (Qed, active build) | 1,679 core Qed; 9,719 model Qed (facts about their own definitions, not verified systems); 1,443 excluded Qed (vacuous patterns, examples, counterexamples or test files) |
| Incomplete proofs (Admitted) | 0 |
| Axioms (active build) | 0 `Axiom`, 29 `Parameter`s (trusted hardware interface; none of the capstone theorems depends on them) |
| Active proof files | 334 |
| Rust tests | 3,560 (compiler workspace), plus the tooling workspace's own tests |
| Compiler crates | 18 |
| Example programs | 172 (84 pass `riinac check`) |
| Standard library builtins | 88 |
| Compliance profiles | 15 (3 with implemented heuristic checks; evidence toward a profile, not a conformity assessment or certification) |
| Target platforms | 4 (native, WASM, Android, iOS; WASM and mobile are scaffolding) |
| Independent audit | No independent audit published yet |

*These numbers are updated as the codebase evolves. `website/public/metrics.json` is the source of truth; the Coq counts follow its counting policy (core, model and excluded Qed are never summed into one public total).*

---

## The Name

**RIINA** — Rigorous Immutable Invariant, No Assumptions.

- **Rigorous**: Every claim is either backed by a Coq proof or labelled as tested, modelled or open.
- **Immutable**: Proven properties cannot be weakened without the proof failing to build; checks cannot be bypassed, for rules the compiler implements.
- **Invariant**: Properties that hold true in every possible execution of the model they are proved for.
- **No Assumptions**: The goal is zero trust from compiler to hardware to build chain; today the remaining assumptions are named — 0 `Axiom`, 29 `Parameter`s (trusted hardware interface; none of the capstone theorems depends on them).

The language syntax uses **Bahasa Melayu** — the Malaysian national language. Functions are `fungsi`, variables are bound with `biar`, conditionals are `kalau`. This is not decoration; it is a statement that formal verification and world-class security are not exclusive to any language or culture.

---

*RIINA: Where security is not a feature. It is a theorem.*

*Q.E.D. Aeternum.*
