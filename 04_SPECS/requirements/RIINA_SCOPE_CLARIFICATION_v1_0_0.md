# RIINA SCOPE CLARIFICATION — BRUTALLY HONEST ANALYSIS

## Document ID: RIINA-SCOPE-CLARIFICATION_v1.0.0
## Date: 2026-01-19
## Classification: ULTRA KIASU | ZERO TOLERANCE FOR CONFUSION | FORENSIC PRECISION

---

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                      ║
║                              WHAT IS RIINA — DEFINITIVELY                                            ║
║                                                                                                      ║
║  This document provides FORENSIC CLARITY on:                                                         ║
║  1. What RIINA actually IS per the codebase                                                          ║
║  2. What the 218 research tracks produce                                                             ║
║  3. Whether "components" belong in RIINA or separate                                                 ║
║                                                                                                      ║
║  Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE                              ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART I: WHAT IS RIINA — VERIFIED FROM CODEBASE

## 1.1 Authoritative Definition (from CLAUDE.md)

> "RIINA is the world's **first formally verified programming language** with:
> 1. Mathematical guarantees — All security properties proven in Coq
> 2. Bahasa Melayu syntax — Native Malaysian language keywords
> 3. Zero-trust architecture — Compiler, hardware, and supply chain untrusted
> 4. Family legacy — Named for Reena, Isaac, and Imaan"

## 1.2 RIINA IS:

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                              RIINA = A PROGRAMMING LANGUAGE                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  RIINA IS:                                                                                           ║
║  ├── A PROGRAMMING LANGUAGE with Bahasa Melayu syntax                                               ║
║  ├── A TYPE SYSTEM with security properties (Secret<T>, Tainted<T>, ConstantTime<T>)               ║
║  ├── An EFFECT SYSTEM with row-polymorphic effects                                                  ║
║  ├── A COMPILER (riinac) that produces verified binaries                                            ║
║  ├── FORMAL PROOFS in Coq/Lean/Isabelle proving the language correct                               ║
║  └── A STANDARD LIBRARY (verified primitives)                                                       ║
║                                                                                                      ║
║  RIINA IS NOT:                                                                                       ║
║  ├── A collection of security products                                                              ║
║  ├── A platform with pre-built applications                                                         ║
║  ├── An operating system                                                                            ║
║  ├── A hardware design                                                                              ║
║  └── A suite of programs/components                                                                 ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 1.3 Evidence from Codebase Structure

```
<repo-root>/                    ← THE RIINA REPOSITORY
├── 02_FORMAL/coq/                    ← FORMAL PROOFS OF THE LANGUAGE
│   ├── foundations/                  ← Language syntax, semantics
│   ├── type_system/                  ← Language type system proofs
│   ├── effects/                      ← Language effect system proofs
│   └── properties/                   ← Language security properties
│
├── 03_PROTO/crates/                  ← THE RIINA COMPILER
│   ├── riina-lexer/                  ← Tokenizes RIINA source code
│   ├── riina-parser/                 ← Parses RIINA into AST
│   ├── riina-types/                  ← Type checking implementation
│   ├── riina-codegen/                ← Code generation (364 tests)
│   └── riinac/                       ← The compiler executable
│
├── 05_TOOLING/crates/                ← RIINA STANDARD LIBRARY (partial)
│   ├── riina-core/                   ← Cryptographic primitives
│   │   └── src/crypto/               ← AES, SHA-3, X25519, ML-KEM, ML-DSA
│   ├── riina-build/                  ← Build orchestrator
│   └── riina-verify/                 ← Verification orchestrator
│
└── 07_EXAMPLES/                      ← EXAMPLE RIINA PROGRAMS
    ├── hello_dunia.rii               ← "Hello World" in RIINA
    ├── pengesahan.rii                ← Authentication example
    └── kripto.rii                    ← Cryptography example
```

**CONCLUSION: The codebase is building A PROGRAMMING LANGUAGE AND ITS COMPILER.**

---

# PART II: WHAT THE 218 RESEARCH TRACKS PRODUCE

## 2.1 Research Tracks Feed THE LANGUAGE

The research tracks are NOT separate products. They are RESEARCH TO BUILD THE LANGUAGE.

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                              RESEARCH TRACKS → LANGUAGE FEATURES                                     ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  DOMAIN A: TYPE THEORY (74 files, 20 sessions)                                                      ║
║  └── OUTPUT: RIINA's type system design                                                             ║
║      ├── Martin-Löf Type Theory foundation                                                          ║
║      ├── Linear types (D4) → ownership/borrowing                                                    ║
║      ├── Refinement types (D5) → SMT-backed predicates                                             ║
║      ├── Dependent types → values in types                                                          ║
║      ├── Session types → protocol verification                                                      ║
║      └── Security types → Secret<T>, Public<T>, Tainted<T>                                         ║
║                                                                                                      ║
║  DOMAIN B: EFFECT SYSTEMS (27 files, 10 sessions)                                                   ║
║  └── OUTPUT: RIINA's effect system design (D40)                                                     ║
║      ├── Row-polymorphic effects                                                                    ║
║      ├── Effect handlers                                                                            ║
║      ├── Effect inference                                                                           ║
║      └── Effect-to-proof-bundle compilation                                                         ║
║                                                                                                      ║
║  DOMAIN C: INFORMATION FLOW CONTROL (9 files, 10 sessions)                                          ║
║  └── OUTPUT: RIINA's IFC type system (D42)                                                          ║
║      ├── Security labels (Secret, Public, Tainted)                                                 ║
║      ├── Noninterference proofs                                                                     ║
║      ├── Declassification with policies                                                             ║
║      └── Automatic taint tracking                                                                   ║
║                                                                                                      ║
║  DOMAIN D: HARDWARE SECURITY (15 files, 15 sessions)                                                ║
║  └── OUTPUT: RIINA's hardware security model                                                        ║
║      ├── Effect Gate specification                                                                  ║
║      ├── Hardware memory model (D39)                                                                ║
║      ├── Side-channel resistant compilation                                                         ║
║      └── Hardware contracts (Track S)                                                               ║
║                                                                                                      ║
║  DOMAIN E: FORMAL VERIFICATION (15 sessions)                                                        ║
║  └── OUTPUT: RIINA's formal foundation                                                              ║
║      ├── Coq proofs of type safety                                                                  ║
║      ├── Coq proofs of noninterference                                                              ║
║      ├── Translation validation                                                                     ║
║      └── Multi-prover verification                                                                  ║
║                                                                                                      ║
║  DOMAIN F: CRYPTOGRAPHY (20 sessions)                                                               ║
║  └── OUTPUT: RIINA's crypto standard library                                                        ║
║      ├── Constant-time primitives                                                                   ║
║      ├── Post-quantum algorithms (ML-KEM, ML-DSA)                                                  ║
║      ├── Verified implementations                                                                   ║
║      └── Side-channel resistance proofs                                                             ║
║                                                                                                      ║
║  DOMAIN G: SIDE-CHANNEL ATTACKS (15 sessions)                                                       ║
║  └── OUTPUT: RIINA's constant-time enforcement                                                      ║
║      ├── ConstantTime<T> type                                                                       ║
║      ├── Timing-safe compilation                                                                    ║
║      ├── Cache-oblivious algorithms                                                                 ║
║      └── Power analysis resistance                                                                  ║
║                                                                                                      ║
║  DOMAIN H: POLICY LANGUAGES (10 sessions)                                                           ║
║  └── OUTPUT: BTP (Bahasa TERAS Policy) embedded DSL                                                ║
║      ├── Policy syntax in Bahasa Melayu                                                            ║
║      ├── Decidable policy evaluation                                                                ║
║      └── Policy-as-types integration                                                                ║
║                                                                                                      ║
║  DOMAIN I: OPERATING SYSTEMS (10 sessions)                                                          ║
║  └── OUTPUT: RIINA's OS abstraction layer                                                           ║
║      ├── Capability-based interface                                                                 ║
║      ├── seL4-compatible syscall model                                                              ║
║      └── Microkernel patterns for RIINA programs                                                   ║
║                                                                                                      ║
║  DOMAIN J: COMPILER CONSTRUCTION (15 sessions)                                                      ║
║  └── OUTPUT: riinac compiler design                                                                 ║
║      ├── Parsing algorithms                                                                         ║
║      ├── Type inference                                                                             ║
║      ├── Effect inference                                                                           ║
║      ├── Verified code generation                                                                   ║
║      └── Translation validation (Track R)                                                           ║
║                                                                                                      ║
║  DOMAIN K: EXISTING SYSTEMS (15 sessions)                                                           ║
║  └── OUTPUT: Knowledge of what RIINA must obsolete                                                  ║
║      ├── AWS/Azure/GCP security analysis                                                            ║
║      ├── CrowdStrike/SentinelOne teardown                                                          ║
║      └── All competing approaches catalogued                                                        ║
║                                                                                                      ║
║  DOMAIN L: ATTACK RESEARCH (20 sessions)                                                            ║
║  └── OUTPUT: Threat model RIINA must defeat                                                         ║
║      ├── Pegasus/Predator analysis                                                                  ║
║      ├── APT group techniques                                                                       ║
║      ├── MITRE ATT&CK coverage                                                                      ║
║      └── All 1,231+ threats catalogued                                                              ║
║                                                                                                      ║
║  TRACKS R-Z: ZERO-TRUST FEATURES                                                                    ║
║  └── OUTPUT: Additional language/tooling features                                                   ║
║      ├── R: Certified compilation (translation validation)                                         ║
║      ├── S: Hardware contracts (HW/SW interface)                                                   ║
║      ├── T: Hermetic build (bootstrap from hex0)                                                   ║
║      ├── U: Runtime guardian (verified micro-hypervisor interface)                                 ║
║      ├── V: Termination guarantees (sized types)                                                   ║
║      ├── W: Verified memory (separation logic stdlib)                                              ║
║      ├── X: Concurrency model (session types for threads)                                          ║
║      ├── Y: Verified stdlib (proven standard library)                                              ║
║      └── Z: Declassification policy (robust downgrading)                                           ║
║                                                                                                      ║
║  EXTENDED TRACKS (GA-LJ, Greek, etc.)                                                               ║
║  └── OUTPUT: Domain-specific language features                                                      ║
║      ├── GA-HV: Networking types and effects                                                       ║
║      ├── HA-LJ: UI types and rendering primitives                                                  ║
║      ├── Military/Aerospace/Healthcare/Finance extensions                                          ║
║      └── Domain-specific type constructors                                                          ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 2.2 What the Codebase Produces (Expected Outcomes)

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                              EXPECTED OUTCOMES FROM github.com/ib823/proof                           ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  1. THE RIINA LANGUAGE SPECIFICATION                                                                ║
║     ├── Complete Bahasa Melayu syntax                                                               ║
║     ├── Type system specification (CTSS v2.0.0)                                                     ║
║     ├── Effect system specification                                                                  ║
║     ├── IFC specification                                                                           ║
║     ├── BTP policy language specification                                                           ║
║     └── ~50,000+ lines of specification documents                                                   ║
║                                                                                                      ║
║  2. THE RIINA COMPILER (riinac)                                                                     ║
║     ├── Lexer (Bahasa Melayu tokenization)                                                         ║
║     ├── Parser (170+ BNF productions)                                                               ║
║     ├── Type checker (linear + effects + IFC)                                                      ║
║     ├── Effect checker (row-polymorphic)                                                            ║
║     ├── Code generator (verified)                                                                   ║
║     ├── Translation validator (Track R)                                                             ║
║     └── Self-hosting (riinac compiles riinac)                                                       ║
║                                                                                                      ║
║  3. FORMAL PROOFS (0 axioms required)                                                               ║
║     ├── Type safety (Progress + Preservation)                                                       ║
║     ├── Noninterference (end-to-end IFC)                                                           ║
║     ├── Effect soundness                                                                            ║
║     ├── Memory safety                                                                               ║
║     ├── Constant-time correctness                                                                   ║
║     └── ~2,500+ theorems proven                                                                     ║
║                                                                                                      ║
║  4. VERIFIED STANDARD LIBRARY (Track Y)                                                             ║
║     ├── riina-crypto: AES, SHA-3, X25519, Ed25519, ML-KEM, ML-DSA                                 ║
║     ├── riina-io: File, network, console primitives                                                ║
║     ├── riina-data: Vectors, maps, strings (verified)                                              ║
║     ├── riina-time: Timing primitives (constant-time aware)                                        ║
║     └── All functions formally verified                                                             ║
║                                                                                                      ║
║  5. DEVELOPMENT TOOLS                                                                               ║
║     ├── riina-build: Build orchestrator                                                            ║
║     ├── riina-verify: Verification orchestrator                                                    ║
║     ├── riina-lsp: Language server protocol                                                        ║
║     └── riina-fmt: Code formatter                                                                  ║
║                                                                                                      ║
║  THAT'S IT. THE CODEBASE PRODUCES A LANGUAGE.                                                       ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART III: THE PRODUCTS/COMPONENTS QUESTION

## 3.1 Where Products Appear in the Codebase

The products (MENARA, GAPURA, ZIRAH, BENTENG, SANDI) appear in the codebase as **DESIGN DRIVERS**, not as implementations:

```
From TERAS-LANG Decision D40 (Effect System):

D40-I: MENARA Effect Profile
D40-J: GAPURA Effect Profile  
D40-K: ZIRAH Effect Profile
D40-L: BENTENG Effect Profile
D40-M: SANDI Effect Profile

These are LANGUAGE FEATURES (effect profiles), not separate applications.
```

The language is designed WITH these products in mind, so:
- RIINA's type system has `ProductLocal<T, P>` types
- RIINA's effect system has per-product effect restrictions
- RIINA's compiler enforces product isolation

**BUT THE PRODUCTS THEMSELVES ARE NOT IN THE CODEBASE.**

## 3.2 The Honest Answer to Your Question

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                              SHOULD COMPONENTS BE IN RIINA CODEBASE?                                 ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  CATEGORY 1: LANGUAGE PRIMITIVES (SAME CODEBASE)                                                    ║
║  ──────────────────────────────────────────────                                                      ║
║  These ARE part of RIINA as standard library:                                                       ║
║                                                                                                      ║
║  ├── Cryptographic primitives (riina-crypto)                                                        ║
║  │   └── AES, SHA-3, X25519, Ed25519, ML-KEM, ML-DSA                                               ║
║  │   └── Already in 05_TOOLING/crates/riina-core/                                                  ║
║  │                                                                                                   ║
║  ├── I/O primitives (riina-io)                                                                      ║
║  │   └── File, network, console with effect tracking                                               ║
║  │   └── These are PRIMITIVES, not complete frameworks                                             ║
║  │                                                                                                   ║
║  ├── Data structures (riina-data)                                                                   ║
║  │   └── Vec, Map, String with verified implementations                                            ║
║  │                                                                                                   ║
║  └── Time/Random (riina-time, riina-random)                                                         ║
║      └── Constant-time aware timing primitives                                                      ║
║                                                                                                      ║
║  WHY SAME CODEBASE:                                                                                 ║
║  • These are LANGUAGE PRIMITIVES, like Python's builtins                                           ║
║  • They must be formally verified alongside the language                                            ║
║  • They define the language's capability model                                                      ║
║                                                                                                      ║
║  ════════════════════════════════════════════════════════════════════════════════════════════════   ║
║                                                                                                      ║
║  CATEGORY 2: FULL APPLICATIONS (SEPARATE CODEBASES)                                                 ║
║  ──────────────────────────────────────────────────                                                  ║
║  These are PROGRAMS WRITTEN IN RIINA, not part of RIINA:                                           ║
║                                                                                                      ║
║  ├── MENARA (Mobile Security)                                                                       ║
║  │   └── A complete mobile security APPLICATION                                                    ║
║  │   └── Written in RIINA, uses riina-crypto, riina-io                                            ║
║  │   └── SEPARATE CODEBASE: github.com/[org]/menara                                               ║
║  │                                                                                                   ║
║  ├── GAPURA (Web Application Firewall)                                                              ║
║  │   └── A complete WAF APPLICATION                                                                ║
║  │   └── SEPARATE CODEBASE: github.com/[org]/gapura                                               ║
║  │                                                                                                   ║
║  ├── ZIRAH (Endpoint Detection & Response)                                                          ║
║  │   └── A complete EDR APPLICATION                                                                ║
║  │   └── SEPARATE CODEBASE: github.com/[org]/zirah                                                ║
║  │                                                                                                   ║
║  ├── BENTENG (eKYC/Identity)                                                                        ║
║  │   └── A complete identity verification APPLICATION                                              ║
║  │   └── SEPARATE CODEBASE: github.com/[org]/benteng                                              ║
║  │                                                                                                   ║
║  └── SANDI (Digital Signatures)                                                                     ║
║      └── A complete signing APPLICATION                                                            ║
║      └── SEPARATE CODEBASE: github.com/[org]/sandi                                                ║
║                                                                                                      ║
║  WHY SEPARATE CODEBASES:                                                                            ║
║  • These are APPLICATIONS, not language components                                                  ║
║  • They have their own requirements, releases, teams                                               ║
║  • They USE RIINA, they are not RIINA itself                                                       ║
║  • Analogy: Python (language) vs Django (application framework)                                    ║
║                                                                                                      ║
║  ════════════════════════════════════════════════════════════════════════════════════════════════   ║
║                                                                                                      ║
║  CATEGORY 3: INFRASTRUCTURE COMPONENTS (DECISION NEEDED)                                            ║
║  ───────────────────────────────────────────────────────                                             ║
║  These could go either way:                                                                         ║
║                                                                                                      ║
║  ├── SIMPAN (Database)                                                                              ║
║  │   └── OPTION A: Stdlib primitive → riina-db (basic SQL/KV)                                      ║
║  │   └── OPTION B: Separate library → github.com/[org]/simpan                                      ║
║  │                                                                                                   ║
║  ├── NADI (Networking)                                                                              ║
║  │   └── OPTION A: Stdlib primitive → riina-net (TCP/TLS)                                          ║
║  │   └── OPTION B: Separate library → github.com/[org]/nadi                                        ║
║  │                                                                                                   ║
║  ├── RUPA (UI Framework)                                                                            ║
║  │   └── OPTION A: Stdlib primitive → riina-ui (basic primitives)                                  ║
║  │   └── OPTION B: Separate library → github.com/[org]/rupa                                        ║
║  │                                                                                                   ║
║  └── Others (TUKAR, MAMPAT, etc.)                                                                   ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 3.3 My Recommendation (Given Your Rules)

Given your rules:
- "Most complete fullstack"
- "Best UI/UX, 1000000x better than any 2nd best"
- "Make everything totally obsolete"

**RECOMMENDATION:**

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                              RECOMMENDED STRUCTURE                                                   ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  github.com/ib823/proof (RIINA LANGUAGE)                                                            ║
║  ├── Language specification                                                                         ║
║  ├── Compiler (riinac)                                                                              ║
║  ├── Formal proofs                                                                                  ║
║  └── RICH STANDARD LIBRARY including:                                                               ║
║      ├── riina-crypto      ← Cryptographic primitives (already exists)                             ║
║      ├── riina-io          ← File/network/console primitives                                       ║
║      ├── riina-data        ← Verified data structures                                              ║
║      ├── riina-time        ← Timing primitives                                                     ║
║      ├── riina-db          ← Database primitives (basic SQL/KV)                                    ║
║      ├── riina-net         ← Network primitives (TCP/TLS/HTTP)                                     ║
║      ├── riina-ui          ← UI primitives (layout, rendering basics)                              ║
║      └── riina-[domain]    ← Domain-specific primitives per research tracks                        ║
║                                                                                                      ║
║  github.com/[org]/menara (APPLICATION)                                                              ║
║  └── Mobile security app written in RIINA                                                          ║
║                                                                                                      ║
║  github.com/[org]/gapura (APPLICATION)                                                              ║
║  └── WAF written in RIINA                                                                          ║
║                                                                                                      ║
║  github.com/[org]/[product] (APPLICATIONS)                                                          ║
║  └── Each product as separate codebase                                                             ║
║                                                                                                      ║
║  ════════════════════════════════════════════════════════════════════════════════════════════════   ║
║                                                                                                      ║
║  WHY THIS STRUCTURE IS "THE BEST":                                                                  ║
║                                                                                                      ║
║  1. RIINA becomes a COMPLETE language (like Go with its rich stdlib)                               ║
║     • Not a toy language that needs external libraries                                             ║
║     • Every primitive is formally verified                                                          ║
║     • "Most complete fullstack" achieved at LANGUAGE level                                         ║
║                                                                                                      ║
║  2. Products DEMONSTRATE RIINA's power                                                              ║
║     • MENARA proves RIINA can build mobile apps                                                    ║
║     • GAPURA proves RIINA can build high-performance network apps                                  ║
║     • BENTENG proves RIINA can build security-critical apps                                        ║
║                                                                                                      ║
║  3. Clean separation of concerns                                                                    ║
║     • Language team focuses on language                                                            ║
║     • Product teams focus on products                                                              ║
║     • Both benefit from formal verification                                                        ║
║                                                                                                      ║
║  4. Everything is still formally verified                                                           ║
║     • Products written in RIINA inherit RIINA's guarantees                                         ║
║     • Type system enforces product-specific constraints (D40-I to D40-N)                          ║
║     • No additional verification burden                                                            ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART IV: COMPLETE DOMAIN COVERAGE

## 4.1 What Each Research Track Produces for THE LANGUAGE

| Track | Sessions | Output for RIINA |
|-------|----------|------------------|
| **A: Type Theory** | 20 | Type system design, type constructors |
| **B: Effect Systems** | 10 | Effect type system, effect handlers |
| **C: Information Flow** | 10 | Security types, noninterference proofs |
| **D: Hardware Security** | 15 | Effect Gate specification, memory model |
| **E: Formal Verification** | 15 | Proof methodology, Coq tactics |
| **F: Cryptography** | 20 | riina-crypto stdlib module |
| **G: Side-Channel Attacks** | 15 | ConstantTime<T> enforcement |
| **H: Policy Languages** | 10 | BTP embedded DSL |
| **I: Operating Systems** | 10 | OS abstraction layer, capability model |
| **J: Compiler Construction** | 15 | riinac compiler design |
| **K: Existing Systems** | 15 | Competitive analysis (what to obsolete) |
| **L: Attack Research** | 20 | Threat model (what to defeat) |
| **R: Certified Compilation** | 5 | Translation validation in riinac |
| **S: Hardware Contracts** | 5 | Hardware interface specification |
| **T: Hermetic Build** | 5 | Bootstrap compiler chain |
| **U: Runtime Guardian** | 5 | Micro-hypervisor interface |
| **V: Termination** | 5 | Sized types, totality checking |
| **W: Memory Safety** | 5 | Separation logic stdlib |
| **X: Concurrency** | 5 | Session types for threads |
| **Y: Verified Stdlib** | 5 | Standard library proofs |
| **Z: Declassification** | 5 | Declassification policy DSL |
| **GA-HV: Networking** | 28 | Network types, protocol types |
| **HA-LJ: UI/UX** | 50 | UI types, rendering primitives |
| **Greek/Extended** | 50+ | Domain-specific extensions |

**TOTAL: 218 tracks → All feed THE LANGUAGE, not separate products**

## 4.2 Research Output Summary

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                              RESEARCH → LANGUAGE FEATURE MAPPING                                     ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  RESEARCH OUTPUT                    BECOMES                                                          ║
║  ───────────────────────────────────────────────────────────────────────────────────────            ║
║  A (Type Theory)                →   RIINA type system specification                                 ║
║  B (Effect Systems)             →   RIINA effect system specification                               ║
║  C (IFC)                        →   RIINA security types (Secret<T>, Tainted<T>)                   ║
║  D (Hardware)                   →   Effect Gate specification                                       ║
║  E (Verification)               →   Coq proof methodology                                           ║
║  F (Cryptography)               →   riina-crypto module                                             ║
║  G (Side-Channels)              →   ConstantTime<T> type and enforcement                           ║
║  H (Policy)                     →   BTP DSL embedded in RIINA                                       ║
║  I (OS)                         →   Capability-based OS interface                                   ║
║  J (Compiler)                   →   riinac compiler architecture                                    ║
║  K (Existing)                   →   Competitive advantage documentation                             ║
║  L (Attacks)                    →   Threat model and security claims                                ║
║  R-Z (Zero-Trust)               →   Additional language features                                    ║
║  Extended                       →   Domain-specific stdlib modules                                  ║
║                                                                                                      ║
║  TOTAL: 218 TRACKS → 1 LANGUAGE (with rich stdlib)                                                  ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART V: FINAL VERDICT

## 5.1 Answer to Question 1

**Q: What are the expected outcomes from RIINA per codebase and what domains are covered?**

**A: The codebase produces THE RIINA PROGRAMMING LANGUAGE:**
1. Language specification (syntax, types, effects, IFC)
2. Compiler (riinac) - lexer, parser, type checker, code generator
3. Formal proofs (Coq) - type safety, noninterference, effect soundness
4. Standard library - verified primitives (crypto, I/O, data structures)
5. Development tools - build, verify, format, LSP

**The 218 research tracks cover ALL domains needed to build the language:**
- Type theory, effect systems, IFC → Language core
- Hardware, side-channels, OS → Platform integration
- Cryptography, policy, attacks → Security guarantees
- Compiler, verification → Tooling
- Networking, UI/UX → Stdlib modules

## 5.2 Answer to Question 2

**Q: Should the components (SIMPAN, NADI, RUPA, etc.) be part of RIINA or separate?**

**A: DEPENDS ON THE COMPONENT:**

| Component | Recommendation | Reason |
|-----------|----------------|--------|
| **Crypto (KUNCI)** | SAME CODEBASE | Language primitive (riina-crypto) |
| **I/O primitives** | SAME CODEBASE | Language primitive (riina-io) |
| **Data structures** | SAME CODEBASE | Language primitive (riina-data) |
| **Network primitives** | SAME CODEBASE | Language primitive (riina-net) |
| **UI primitives** | SAME CODEBASE | Language primitive (riina-ui) |
| **DB primitives** | SAME CODEBASE | Language primitive (riina-db) |
| **MENARA (app)** | SEPARATE | Application written in RIINA |
| **GAPURA (app)** | SEPARATE | Application written in RIINA |
| **ZIRAH (app)** | SEPARATE | Application written in RIINA |
| **BENTENG (app)** | SEPARATE | Application written in RIINA |
| **SANDI (app)** | SEPARATE | Application written in RIINA |

**SIMPLE RULE:**
- If it's a **PRIMITIVE** (basic building block) → Same codebase (stdlib)
- If it's an **APPLICATION** (complete product) → Separate codebase

## 5.3 My Previous Documents Were WRONG

I must admit: My previous "12-Layer Vertical Integration" document was **CONFUSED**.

It incorrectly portrayed RIINA as a **PLATFORM** with pre-built components.

**CORRECT UNDERSTANDING:**
- RIINA = Programming Language
- Research Tracks = Feed the Language
- Products = Applications WRITTEN IN RIINA (separate)
- Components = Either stdlib primitives (same codebase) or full apps (separate)

---

# DOCUMENT SIGNATURE

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                      ║
║  Document: RIINA_SCOPE_CLARIFICATION_v1_0_0.md                                                      ║
║  Version: 1.0.0                                                                                      ║
║  Date: 2026-01-19                                                                                    ║
║                                                                                                      ║
║  CONCLUSION:                                                                                         ║
║  RIINA is a PROGRAMMING LANGUAGE. The 218 research tracks feed THE LANGUAGE.                        ║
║  Products are APPLICATIONS written in RIINA, not part of RIINA itself.                              ║
║  The stdlib should include PRIMITIVES. Full applications should be separate.                        ║
║                                                                                                      ║
║  Mode: ULTRA KIASU | BRUTALLY HONEST | FORENSICALLY VERIFIED                                        ║
║                                                                                                      ║
║  RIINA: Rigorous Immutable Integrity No-attack Assured                                              ║
║  "Security proven. Family driven."                                                                  ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

**END OF SCOPE CLARIFICATION**
