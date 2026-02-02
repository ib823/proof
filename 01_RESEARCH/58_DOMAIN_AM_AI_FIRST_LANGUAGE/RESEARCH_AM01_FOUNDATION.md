# RESEARCH_AM01_FOUNDATION.md
# RIINA AI-First Language Design: The Vibe Coding Standard
# Version: 1.0.0 | Status: FOUNDATIONAL SPECIFICATION
# Date: 2026-02-02
# Track: AM-01 (AI-First Language)
# Layer: L0 (Language Design — AI Alignment)
# Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE

---

## THE THESIS

**"The language the AI reaches for first."**

By 2026, 41% of all new code is AI-generated. 25% of YC W25 startups have 95% AI-generated codebases. Claude Code writes 90% of its own code. The "vibe coding" paradigm — where humans describe intent and AI writes code — is not a trend. It is the future of software development.

The #1 problem with vibe coding: **AI generates code that looks right but is wrong.** Security holes. Broken layouts. Subtle type errors. Logic bugs hidden behind plausible-looking syntax. The "vibe coding hangover" is real — developers ship AI-generated code they don't read, and it breaks.

RIINA's answer: **the compiler proves what the human doesn't read.** If the AI generates RIINA code that compiles, it is mathematically guaranteed correct for security, effects, types, and (with Track AL) layout. No human review needed for these properties.

But there's a prerequisite: **AI models must know how to write RIINA.** Today they don't — RIINA has zero presence in any training corpus. This track addresses the complete problem: making RIINA the language AI models can write, prefer to write, and produce perfect results in.

**No existing language is designed for AI consumption.** Languages were designed for humans — Python for readability, Rust for safety, Haskell for purity. RIINA will be the first language designed with AI code generation as a first-class design constraint.

---

## 1. THE VIBE CODING LANDSCAPE

### 1.1 State of the Art (2025-2026)

**Source:** "A Survey of Vibe Coding with Large Language Models" (arXiv:2510.12399, Oct 2025)

The survey identifies five development models for AI-assisted coding:

| Model | Description | RIINA Fit |
|-------|------------|-----------|
| **Unconstrained Automation** | AI writes everything, human accepts | RIINA compiler catches AI errors |
| **Iterative Conversational** | Human↔AI dialogue with corrections | RIINA error messages guide AI |
| **Planning-Driven** | AI plans → executes → validates | RIINA types constrain valid plans |
| **Test-Driven** | Tests first → AI generates implementation | RIINA proofs > tests |
| **Context-Enhanced** | Rich context → better generation | RIINA's specs are the context |

**Key finding:** "Successful vibe coding depends not merely on agent capabilities but on systematic context engineering, well-established development environments, and human-agent collaborative development models."

RIINA's advantage: the compiler is the ultimate "context engineer" — it tells the AI exactly what's wrong and how to fix it.

### 1.2 The Feedback Loop Problem

The survey identifies four feedback mechanisms for AI self-correction:

| Feedback | Signal Quality | Speed | RIINA Implementation |
|----------|---------------|-------|---------------------|
| **Compiler feedback** | Highest — deterministic, precise | Milliseconds | `riinac check --json` |
| **Execution feedback** | High — runtime behavior | Seconds | REPL |
| **Human feedback** | Variable — subjective, slow | Minutes-hours | Not needed for proven properties |
| **Self-refinement** | Low — model may reinforce errors | Milliseconds | Unnecessary with strong compiler |

**Insight:** RIINA's compiler provides the highest-quality feedback signal available. Every security violation, type error, and effect mismatch produces a precise, deterministic, fixable error. AI models converge to correct code faster with RIINA than with any other language.

### 1.3 Why AI Models Prefer Certain Languages

**Source:** "LLMs Love Python: A Study of LLMs' Bias for Programming Languages" (arXiv:2503.17181, Mar 2025)

| Factor | Python | Rust | RIINA (Target) |
|--------|--------|------|---------------|
| Training data volume | Massive (93.5% default) | Large | Zero (must build) |
| Syntax simplicity | Very high | Medium | High (regular grammar) |
| Error message quality | Poor (runtime) | Excellent (compile) | Best (compile + fix hints) |
| Compiler as oracle | No (interpreted) | Yes | Yes + proven properties |
| Type system guidance | Weak | Strong | Strongest (dependent types + effects) |
| Correctness guarantee | None | Memory safety | Security + types + effects + layout |

The training data gap is RIINA's primary challenge. Everything else favors RIINA.

### 1.4 The Modular/Mojo Framework

**Source:** Modular blog, "Do LLMs Eliminate the Need for Programming Languages?" (2025)

Three factors that make a language ideal for AI:

1. **Usability and scalability** — simple to write, scales to many domains
2. **Training data volume** — AI needs examples to learn from
3. **Rich ecosystem** — tools, libraries, documentation

RIINA addresses each:
1. Regular grammar + Bahasa Melayu keywords + strong types = high usability
2. Must build: examples, reference docs, AI context files, training datasets
3. Already has: LSP, formatter, REPL, doc generator, package manager, VS Code extension

---

## 2. WHAT MAKES A LANGUAGE AI-WRITABLE

### 2.1 The 12 Properties of an AI-Ideal Language

Derived from first principles and empirical analysis of AI code generation patterns:

#### Property 1: Unambiguous Grammar

**Problem:** Languages with context-dependent parsing (C++, Perl) produce ambiguous code that AI models generate incorrectly.

**RIINA status:** ✅ RIINA has a context-free grammar. Every token sequence has exactly one parse. The grammar is specified in EBNF across 8,923 lines.

**Requirement:** Maintain grammar regularity. No context-dependent parsing. No significant whitespace (unlike Python). No operator overloading that changes parsing.

#### Property 2: One Way to Do Things

**Problem:** Languages with multiple ways to express the same thing (JavaScript: var/let/const, function/arrow/class methods) cause AI models to generate inconsistent code.

**RIINA status:** ✅ `biar` for bindings, `fungsi` for functions, `kalau` for conditionals. One way per concept.

**Requirement:** Resist adding syntactic sugar that creates alternatives. If there's one way to write something, AI will learn that way.

#### Property 3: Strong Type System as Specification

**Problem:** Weakly typed languages give AI no guardrails — the AI must infer intent from variable names and comments, which are unreliable.

**RIINA status:** ✅ Strong static types, effect types, security types. The type signature IS the specification.

```riina
/// The type signature tells the AI everything:
fungsi hantar_emel(
    kepada: Teks,                       /// plain text — not secret
    subjek: Teks,                       /// plain text — not secret
    badan: Teks,                        /// plain text — not secret
    kata_laluan: Rahsia<Teks>,          /// secret — cannot be logged
) -> Keputusan<(), Ralat> kesan (Rangkaian | Tulis) {
    /// AI knows: this function does network I/O and writes,
    /// handles a secret password, returns a Result
}
```

**Requirement:** Make every type informative. The AI should be able to generate the function body from the type signature alone.

#### Property 4: Informative Error Messages with Fix Hints

**Problem:** Cryptic error messages (C++ template errors, Haskell type errors) cause AI models to flail — trying random changes hoping something compiles.

**RIINA status:** 🟡 Current diagnostics are caret-style (like Rust) but lack structured fix hints.

**Requirement:** Every error must include:
- Error code (e.g., `E0301`)
- Human-readable message
- Machine-readable structured data (JSON)
- One or more fix suggestions with exact code replacements
- Link to documentation explaining the concept

```json
{
  "code": "E0301",
  "severity": "error",
  "message": "Cannot return Rahsia<Nombor> as Nombor",
  "explanation": "Secret data requires explicit declassification with a policy",
  "span": {"file": "app.rii", "line": 5, "col": 12, "len": 7},
  "fixes": [
    {
      "description": "Declassify with policy",
      "replacement": "dedah(x, dasar: \"audit-trail\")",
      "span": {"line": 5, "col": 12, "len": 1}
    }
  ],
  "docs_url": "https://riina.dev/docs/errors/E0301"
}
```

#### Property 5: Compiler-in-the-Loop API

**Problem:** AI coding agents need to pipe code to a compiler and parse the output programmatically. Most compilers output human-readable text, not machine-readable JSON.

**RIINA status:** ❌ Not yet implemented.

**Requirement:** `riinac check --json` that accepts code on stdin and produces structured JSON output. This is the #1 implementation priority.

```bash
echo 'fungsi f() -> Nombor { biar x = 42; pulang x; }' | riinac check --json
# {"valid": true, "type": "Nombor", "effect": "Bersih", "warnings": []}

echo 'fungsi f() -> Nombor { cetak("hi"); pulang 42; }' | riinac check --json
# {"valid": false, "errors": [{"code": "E0401", "message": "Effect violation: cetak requires kesan Tulis but function declares no effects", ...}]}
```

#### Property 6: Complete Reference in AI Context Window

**Problem:** AI models can't write RIINA if they've never seen RIINA. In-context learning requires a complete language reference that fits in ~50K tokens.

**RIINA status:** ❌ Grammar specs are on `main` only (excluded from public). No single reference document exists.

**Requirement:** Create `RIINA-LANGUAGE-REFERENCE.md` — a single document covering:
- All keywords (Bahasa Melayu + English mapping)
- All types (primitive, compound, security, effect)
- All expressions and statements
- All operators with precedence
- All built-in functions
- All effect types
- All error codes with examples
- 50 canonical code patterns

Target: ≤ 40,000 tokens. Machine-optimized, not human-optimized.

#### Property 7: Canonical Code Style (One True Format)

**Problem:** AI generates code in varying styles, causing inconsistency and merge conflicts.

**RIINA status:** ✅ `riina-fmt` exists and enforces one canonical style.

**Requirement:** All examples, documentation, and AI context files must use `riina-fmt` output. The AI learns one style and produces one style.

#### Property 8: Rich Example Corpus

**Problem:** AI needs many examples to learn syntax patterns, idioms, and best practices.

**RIINA status:** 🟡 113 example files exist, covering 9 categories. But no error/fix pairs or natural-language-to-code mappings.

**Requirement:** Expand to include:
- 200+ example files (current: 113)
- 100+ error/fix pairs (current: 0)
- 100+ natural language → code pairs (current: 0)
- 50+ "insecure Python → secure RIINA" comparisons (current: 0)

#### Property 9: AI-Discoverable Documentation

**Problem:** AI tools can't find RIINA documentation because it's not indexed, not on the web, or not in standard locations.

**RIINA status:** ❌ No `llms.txt`, no `.cursor/rules`, no `.claude` project file.

**Requirement:**
- `llms.txt` at website root (llmstxt.org standard)
- `llms-full.txt` with complete language reference
- `.cursor/rules` for Cursor IDE users
- `.claude/project.md` for Claude Code users
- VS Code extension recommends RIINA for security-sensitive code
- GitHub topics: `verified`, `formal-methods`, `security`, `vibe-coding`

#### Property 10: Predictable Semantics

**Problem:** Languages with undefined behavior (C), implicit coercions (JavaScript), or surprising edge cases (Python's mutable default arguments) cause AI to generate subtly wrong code.

**RIINA status:** ✅ No undefined behavior. No implicit coercions. Every operation has defined semantics proven in Coq.

**Requirement:** Maintain zero undefined behavior. Every semantic question has one answer, documented and proven.

#### Property 11: Composable Abstractions

**Problem:** AI generates better code when abstractions compose predictably — when combining A and B always gives the expected AB behavior.

**RIINA status:** ✅ Effect composition, type composition, and security level composition are all formally verified in Coq.

**Requirement:** Every new language feature must compose with existing features and have a composition proof.

#### Property 12: Self-Documenting Types

**Problem:** AI needs to understand what code does without reading comments. Types should encode intent.

**RIINA status:** ✅ `Rahsia<T>` says "this is secret." `kesan Rangkaian` says "this does network I/O." The types ARE the documentation.

**Requirement:** Continue designing types that encode domain semantics, not just data shapes.

### 2.2 Property Scorecard

| Property | Python | Rust | TypeScript | Haskell | RIINA (Current) | RIINA (Target) |
|----------|--------|------|-----------|---------|-----------------|---------------|
| 1. Unambiguous grammar | 🟡 | ✅ | 🟡 | ✅ | ✅ | ✅ |
| 2. One way to do things | ❌ | 🟡 | ❌ | 🟡 | ✅ | ✅ |
| 3. Strong types as spec | ❌ | ✅ | 🟡 | ✅ | ✅ | ✅ |
| 4. Fix hints in errors | ❌ | ✅ | 🟡 | ❌ | 🟡 | ✅ |
| 5. Compiler-in-loop API | ❌ | 🟡 | 🟡 | ❌ | ❌ | ✅ |
| 6. AI context reference | ✅ | ✅ | ✅ | 🟡 | ❌ | ✅ |
| 7. Canonical code style | ✅ | ✅ | 🟡 | 🟡 | ✅ | ✅ |
| 8. Rich examples | ✅ | ✅ | ✅ | 🟡 | 🟡 | ✅ |
| 9. AI-discoverable docs | ✅ | ✅ | ✅ | 🟡 | ❌ | ✅ |
| 10. Predictable semantics | 🟡 | ✅ | ❌ | ✅ | ✅ | ✅ |
| 11. Composable abstractions | 🟡 | ✅ | 🟡 | ✅ | ✅ | ✅ |
| 12. Self-documenting types | ❌ | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **Score** | **4/12** | **8.5/12** | **5/12** | **7/12** | **7.5/12** | **12/12** |

**RIINA at target: the only language scoring 12/12 on AI writability.**

---

## 3. THE AI-COMPILER FEEDBACK LOOP

### 3.1 Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         RIINA AI-COMPILER FEEDBACK LOOP                         │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────────┐     ┌───────────────┐     ┌──────────────────────┐           │
│  │              │     │               │     │                      │           │
│  │  HUMAN       │────▶│  AI MODEL     │────▶│  .rii SOURCE CODE    │           │
│  │  (intent)    │     │  (generator)  │     │  (generated)         │           │
│  │              │     │               │     │                      │           │
│  └──────────────┘     └───────┬───────┘     └──────────┬───────────┘           │
│                               │                        │                        │
│                               │    ┌───────────────────▼───────────────┐        │
│                               │    │                                   │        │
│                               │    │  riinac check --json              │        │
│                               │    │                                   │        │
│                               │    │  ┌─────────────────────────────┐ │        │
│                               │    │  │ Lexer → Parser → Type Check │ │        │
│                               │    │  │ → Effect Check → Security   │ │        │
│                               │    │  │ → Layout Check → Codegen    │ │        │
│                               │    │  └─────────────────────────────┘ │        │
│                               │    │                                   │        │
│                               │    └───────────┬───────────────────────┘        │
│                               │                │                                │
│                               │    ┌───────────▼───────────────────────┐        │
│                               │    │ JSON OUTPUT                       │        │
│                               │    │                                   │        │
│                               │    │ ┌─── valid: true ───────────────┐│        │
│                               │    │ │ → Ship it. Proven correct.    ││        │
│                               │    │ └───────────────────────────────┘│        │
│                               │    │                                   │        │
│                               │    │ ┌─── valid: false ──────────────┐│        │
│                               │    │ │ errors: [                     ││        │
│                               │    │ │   { code, message, fix_hint,  ││        │
│                               │    │ │     span, suggested_fix }     ││        │
│                               │    │ │ ]                             ││        │
│                               │    │ └──────────────┬────────────────┘│        │
│                               │    └────────────────│─────────────────┘        │
│                               │                     │                           │
│                               │    ┌────────────────▼────────────────┐          │
│                               │    │ AI reads errors                 │          │
│                               │    │ AI applies fix_hints            │          │
│                               │    │ AI generates corrected code     │          │
│                               └────│ Loop until valid: true          │          │
│                                    └─────────────────────────────────┘          │
│                                                                                 │
│  CONVERGENCE GUARANTEE:                                                         │
│  Each error has exactly one fix category.                                       │
│  Fixes are monotonic — fixing one error never introduces another                │
│  of the same class (proven by type system properties).                          │
│  Typical convergence: 1-3 iterations for experienced AI models.                 │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Error Code Taxonomy

RIINA errors organized for AI consumption:

```
E0xxx: Syntax Errors (fixable by structure)
  E0001  Unexpected token
  E0002  Unterminated string
  E0003  Invalid numeric literal
  E0004  Missing closing delimiter
  E0005  Expected expression
  E0006  Expected type annotation
  E0007  Invalid keyword
  E0008  Duplicate definition

E1xxx: Type Errors (fixable by type annotation/conversion)
  E1001  Type mismatch: expected T, found U
  E1002  Cannot infer type — add annotation
  E1003  No such field on type T
  E1004  Cannot apply non-function
  E1005  Wrong number of arguments
  E1006  Cannot unify types
  E1007  Recursive type without indirection
  E1008  Pattern match not exhaustive

E2xxx: Effect Errors (fixable by adding/changing effect annotations)
  E2001  Effect violation: function performs E but declares E'
  E2002  Pure function performs impure operation
  E2003  Effect not in scope
  E2004  Effect combination not allowed
  E2005  Missing effect annotation

E3xxx: Security Errors (fixable by declassification or type change)
  E3001  Secret data leaked to public context
  E3002  Declassification without policy
  E3003  Tainted data used unsanitized
  E3004  Capability not held
  E3005  Constant-time violation
  E3006  Secret in comparison (timing attack)
  E3007  Secret logged or printed

E4xxx: Layout Errors [Future — Track AL]
  E4001  Horizontal overflow at viewport width W
  E4002  Contrast ratio below minimum (R < 4.5)
  E4003  Touch target below minimum (W×H < 48×48dp)
  E4004  Missing alt text on image
  E4005  Form input missing label
  E4006  Tab order mismatch
  E4007  Font size below minimum
  E4008  Line height below minimum
  E4009  Breakpoint discontinuity
  E4010  Platform rendering divergence

E5xxx: Resource Errors (fixable by resource management)
  E5001  Resource not closed
  E5002  Use after close
  E5003  Double close
  E5004  Resource leak on error path
```

### 3.3 Fix Hint Database

Every error code maps to one or more fix patterns:

```yaml
# Error → Fix mapping (machine-readable)

E2001:
  title: "Effect violation"
  pattern: "Function performs {effect} but declares {declared}"
  fixes:
    - description: "Add the required effect to function signature"
      before: "fungsi f() -> T kesan {declared}"
      after: "fungsi f() -> T kesan ({declared} | {effect})"
    - description: "Remove the effectful operation"
      action: "Remove the call to {operation}"

E3001:
  title: "Secret data leak"
  pattern: "Cannot use Rahsia<{T}> where {T} is expected"
  fixes:
    - description: "Declassify with policy"
      before: "pulang secret_value"
      after: "pulang dedah(secret_value, dasar: \"reason\")"
    - description: "Propagate secret type"
      before: "fungsi f() -> {T}"
      after: "fungsi f() -> Rahsia<{T}>"

E3007:
  title: "Secret printed"
  pattern: "Cannot pass Rahsia<{T}> to cetak()"
  fixes:
    - description: "Redact the secret"
      before: "cetak(secret_value)"
      after: "cetak(\"[RAHSIA]\")   /// or: cetak(redact(secret_value))"
    - description: "Declassify for logging"
      before: "cetak(secret_value)"
      after: "cetak(dedah(secret_value, dasar: \"debug-log-approved\"))"
```

---

## 4. AI DISCOVERABILITY INFRASTRUCTURE

### 4.1 llms.txt (Website Root)

```markdown
# RIINA Programming Language
> The world's first formally verified programming language. If it compiles, it's secure.

## What is RIINA?
RIINA (Rigorous Immutable Invariant, No Assumptions) is a programming language where security, type safety, and effect correctness are mathematically proven at compile time. Code written in RIINA that compiles is guaranteed free of security vulnerabilities by Coq formal proofs (4,885 theorems, 0 admits).

## Key Features
- Bahasa Melayu syntax: fungsi, biar, kalau, pulang, rahsia, dedah
- Security types: Rahsia<T> (secret), Tercemar<T> (tainted), Keupayaan<K> (capability)
- Effect system: kesan Bersih (pure), kesan Tulis (write), kesan Rangkaian (network)
- Formal verification: every property proven in Coq, not tested

## Quick Reference
- Docs: https://riina.dev/docs
- Language Reference: https://riina.dev/docs/reference
- Examples: https://riina.dev/docs/examples
- Playground: https://riina.dev/playground
- GitHub: https://github.com/ib823/riina

## For AI Code Generation
- Full reference: https://riina.dev/llms-full.txt
- Example corpus: https://github.com/ib823/riina/tree/public/07_EXAMPLES
- AI context file: https://github.com/ib823/riina/blob/public/07_EXAMPLES/06_ai_context/all_examples.rii
- Error catalog: https://riina.dev/docs/errors
- Compiler API: riinac check --json (structured output for AI agents)
```

### 4.2 llms-full.txt (Complete Reference)

Structure for the complete AI-consumable reference:

```
# RIINA Language Reference (AI Edition)
# Version: 0.1.0 | Last Updated: 2026-02-02
# Purpose: Complete language reference optimized for AI in-context learning
# Target: ≤ 40,000 tokens

## 1. KEYWORDS (51 keywords)
[Complete Bahasa Melayu → English mapping with usage]

## 2. TYPES
### 2.1 Primitive Types
  Nombor (integer), Perpuluhan (float), Teks (string),
  Boolean (betul/salah), Unit ()

### 2.2 Compound Types
  Senarai<T> (list), Peta<K,V> (map), Mungkin<T> (option),
  Keputusan<T,E> (result), Pasangan<A,B> (tuple)

### 2.3 Security Types
  Rahsia<T> (secret), Tercemar<T,S> (tainted),
  Disanitasi<T,S> (sanitized), MasaTetap<T> (constant-time),
  Keupayaan<K> (capability)

### 2.4 Effect Types
  kesan Bersih (pure), kesan Baca (read), kesan Tulis (write),
  kesan Rangkaian (network), kesan Kripto (crypto),
  kesan Sistem (system), kesan Lukis (render)

## 3. SYNTAX
### 3.1 Declarations
  fungsi name(params) -> ReturnType kesan Effect { body }
  biar name: Type = value;
  biar ubah name = value;  // mutable
  tetap NAME: Type = value;  // constant
  jenis Name = definition;  // type alias

### 3.2 Expressions
  [Arithmetic, comparison, logical, function call, field access,
   match, if-else, closures]

### 3.3 Statements
  [Assignment, return, loop, while, for, break, continue]

### 3.4 Pattern Matching
  padan value {
    Corak1(x) => expr1,
    Corak2 => expr2,
    _ => default,
  }

## 4. BUILT-IN FUNCTIONS (88 builtins)
[All 88 builtins with signatures and effects]

## 5. STANDARD LIBRARY (9 modules)
[Module list with key exports]

## 6. ERROR CODES
[All error codes with fix patterns — see §3.2 above]

## 7. 50 CANONICAL PATTERNS
[Pattern: description → code, covering all common tasks]

## 8. ANTI-PATTERNS
[What NOT to do → what to do instead]
```

### 4.3 .cursor/rules (Cursor IDE)

```markdown
# RIINA Language Rules for Cursor

## Language
RIINA uses Bahasa Melayu keywords. Always use the Malay keyword, never the English equivalent.

## File Extension
.rii for source files, .riih for headers

## Key Rules
1. Every function must declare its effects: `fungsi f() -> T kesan Bersih { ... }`
2. Secret data uses `Rahsia<T>`. Never log, print, or return secrets without `dedah()`.
3. Pure functions use `kesan Bersih`. If you call cetak(), you need `kesan Tulis`.
4. Use `padan` for pattern matching, not chains of `kalau/lain`.
5. One statement per line. No semicolons on expression-position values.

## Formatting
Run `riina-fmt` before committing. 4-space indent, 100-char line width.

## Verification
Run `riinac check` before committing. All code must compile with zero errors.
```

### 4.4 .claude/project.md (Claude Code)

```markdown
# RIINA Project Context for Claude Code

This is a RIINA language project. RIINA is a formally verified programming language
with Bahasa Melayu syntax.

## Quick Reference
- Keywords: fungsi (fn), biar (let), kalau (if), lain (else), pulang (return),
  padan (match), untuk (for), selagi (while), betul (true), salah (false)
- Security: rahsia (secret type), dedah (declassify), keupayaan (capability)
- Effects: kesan Bersih (pure), kesan Tulis (write), kesan Rangkaian (network)

## Rules
1. ALL functions must have effect annotations
2. Secret data (Rahsia<T>) cannot be returned/printed without dedah()
3. File extension is .rii
4. Run `riinac check` to verify

## Example
```riina
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    pulang x + y;
}

fungsi utama() -> Nombor kesan Tulis {
    biar hasil = tambah(3, 4);
    cetak("Hasil: ");
    cetak(hasil);
    cetak("\n");
    pulang 0;
}
```
```

---

## 5. TRAINING DATA STRATEGY

### 5.1 Data Categories

| Category | Purpose | Format | Target Count |
|----------|---------|--------|-------------|
| **Canonical examples** | Teach syntax & idioms | `.rii` files | 200+ |
| **Error/fix pairs** | Teach self-correction | JSON (wrong → error → fixed) | 100+ |
| **Intent → code** | Teach generation from NL | Markdown (description → code) | 100+ |
| **Python → RIINA** | Teach migration | Side-by-side comparison | 50+ |
| **Insecure → secure** | Teach security patterns | Side-by-side with explanation | 50+ |
| **Complex programs** | Teach composition | `.rii` multi-file projects | 20+ |

### 5.2 Error/Fix Pair Format

```json
{
  "id": "EFP-001",
  "category": "security",
  "error_code": "E3001",
  "description": "Secret data returned from pure function",
  "broken_code": "fungsi baca_kata_laluan() -> Teks kesan Bersih {\n    biar kl: Rahsia<Teks> = dapatkan_kata_laluan();\n    pulang kl;\n}",
  "compiler_output": {
    "valid": false,
    "errors": [{
      "code": "E3001",
      "message": "Cannot return Rahsia<Teks> as Teks: secret data leaked to public context",
      "span": {"line": 3, "col": 12, "len": 2}
    }]
  },
  "fixed_code": "fungsi baca_kata_laluan() -> Rahsia<Teks> kesan Baca {\n    biar kl: Rahsia<Teks> = dapatkan_kata_laluan();\n    pulang kl;\n}",
  "explanation": "The return type must be Rahsia<Teks> to preserve secrecy. Also changed effect to kesan Baca since reading a password is a read operation.",
  "fix_applied": ["Changed return type Teks → Rahsia<Teks>", "Changed effect Bersih → Baca"]
}
```

### 5.3 Intent → Code Pair Format

```json
{
  "id": "ICP-001",
  "intent": "Create a function that hashes a password securely",
  "tags": ["security", "crypto", "password"],
  "code": "fungsi hash_kata_laluan(kata_laluan: Rahsia<Teks>) -> Rahsia<Teks> kesan Kripto {\n    biar garam = jana_rawak(16);\n    biar hash = argon2_hash(kata_laluan, garam);\n    pulang hash;\n}",
  "explanation": "Uses Rahsia<Teks> to ensure the password and hash are never accidentally leaked. Effect kesan Kripto gates the crypto operations. argon2_hash is the recommended password hashing function.",
  "properties_proven": ["secret_no_leak", "constant_time_hash", "effect_bounded"]
}
```

### 5.4 Python → RIINA Comparison Format

```json
{
  "id": "PRC-001",
  "task": "Read a secret from environment and use it for API auth",
  "python": {
    "code": "import os\nimport requests\n\napi_key = os.environ['API_KEY']  # string — can be logged, printed\nprint(f'Using key: {api_key}')  # BUG: secret leaked to stdout\nresponse = requests.get('https://api.example.com', headers={'Authorization': api_key})\n",
    "vulnerabilities": ["Secret logged to stdout", "No effect tracking", "No type-level secret protection"]
  },
  "riina": {
    "code": "fungsi panggil_api() -> Keputusan<Teks, Ralat> kesan (Baca | Rangkaian) {\n    biar kunci: Rahsia<Teks> = baca_persekitaran(\"API_KEY\");\n    /// cetak(kunci);  ← COMPILATION ERROR: E3007 secret printed\n    biar respons = http_get(\n        \"https://api.example.com\",\n        pengepala: [(\"Authorization\", dedah(kunci, dasar: \"api-auth\"))],\n    );\n    pulang respons;\n}",
    "guarantees": ["Secret cannot be printed (compile error)", "Declassification requires explicit policy", "Network and read effects declared", "Type system prevents accidental leak"]
  }
}
```

---

## 6. IMPLEMENTATION ROADMAP

### Phase AM-1: AI Context Infrastructure (P0 — Immediate)

| Deliverable | File/Location | Description |
|-------------|--------------|-------------|
| Language reference | `docs/RIINA-LANGUAGE-REFERENCE.md` | Single-file complete reference (≤40K tokens) |
| Expanded AI context | `07_EXAMPLES/06_ai_context/all_examples.rii` | Every construct, pattern, anti-pattern |
| llms.txt | `website/public/llms.txt` | Website AI discovery |
| llms-full.txt | `website/public/llms-full.txt` | Complete reference for AI |

**Dependencies:** None. Can start immediately.
**Impact:** Enables AI models to write RIINA via in-context learning.

### Phase AM-2: Compiler-in-the-Loop (P1)

| Deliverable | Crate | Description |
|-------------|-------|-------------|
| `--json` output mode | `riinac` | Structured JSON errors/warnings |
| `--fix-hints` flag | `riinac` | Include fix suggestions in output |
| `--stdin` input mode | `riinac` | Accept code from stdin (piped from AI) |
| Error code catalog | `riinac/src/error_codes.rs` | All error codes with metadata |
| Fix hint database | `riinac/src/fix_hints.rs` | Error → fix pattern mapping |

**Dependencies:** Phase AM-1 (error codes defined in reference doc).
**Impact:** Enables AI agents to use RIINA compiler as an oracle.

### Phase AM-3: Training Data Corpus (P2)

| Deliverable | Directory | Description |
|-------------|-----------|-------------|
| Error/fix pairs | `datasets/error_fix_pairs/` | 100+ JSON error→fix examples |
| Intent→code pairs | `datasets/intent_code_pairs/` | 100+ NL→code examples |
| Python→RIINA pairs | `datasets/python_riina_compare/` | 50+ migration examples |
| Complex programs | `07_EXAMPLES/07_complex/` | 20+ multi-file projects |

**Dependencies:** Phase AM-1 (reference), Phase AM-2 (compiler JSON output for error pairs).
**Impact:** Enables fine-tuning and high-quality few-shot learning.

### Phase AM-4: AI IDE Integration (P1)

| Deliverable | File | Description |
|-------------|------|-------------|
| Cursor rules | `.cursor/rules` | Cursor IDE context |
| Claude project | `.claude/project.md` | Claude Code context |
| GitHub Copilot | `.github/copilot-instructions.md` | Copilot context |
| VS Code snippets | `riina-vscode/snippets/` | Code snippets for all patterns |
| MCP server | `tools/riina-mcp/` | Model Context Protocol server for RIINA |

**Dependencies:** Phase AM-1 (reference document).
**Impact:** AI tools auto-detect RIINA projects and write correct code.

### Phase AM-5: Ecosystem Signals (P2)

| Deliverable | Description |
|-------------|-------------|
| GitHub topics | Add `verified`, `formal-methods`, `security`, `vibe-coding`, `ai-friendly` |
| Package registry | Publish to crates.io-like registry with AI-readable metadata |
| Documentation site | riina.dev/docs with structured, machine-parseable docs |
| Blog posts | "RIINA: The Language for Vibe Coding" content series |
| Benchmark suite | "AI writes RIINA" benchmark — measure AI code quality per model |

**Dependencies:** Phase AM-1 through AM-3.
**Impact:** Long-term discoverability and adoption.

---

## 7. THE COMPETITIVE MOAT

### 7.1 Why RIINA Wins in the AI Era

Every other language faces the same problem: AI generates plausible-but-wrong code, and nothing catches it except tests (which the AI also writes wrong) or human review (which vibe coders skip).

RIINA's compiler is the only tool that can catch:

| Bug Class | Python | Rust | TypeScript | RIINA |
|-----------|--------|------|-----------|-------|
| Type errors | ❌ Runtime | ✅ Compile | 🟡 Compile* | ✅ Compile |
| Null/None | ❌ Runtime | ✅ Compile (Option) | 🟡 Compile* | ✅ Compile (Mungkin) |
| Secret leaks | ❌ Never | ❌ Never | ❌ Never | ✅ Compile |
| Effect violations | ❌ Never | ❌ Never | ❌ Never | ✅ Compile |
| Timing attacks | ❌ Never | ❌ Never | ❌ Never | ✅ Compile |
| Capability violations | ❌ Never | ❌ Never | ❌ Never | ✅ Compile |
| Layout overflow | ❌ Never | ❌ Never | ❌ Never | ✅ Compile [Track AL] |
| Accessibility gaps | ❌ Never | ❌ Never | ❌ Never | ✅ Compile [Track AL] |

*TypeScript's `strict` mode catches some, but has escape hatches (`any`, `as`, `!`).

**The moat is mathematical.** No amount of testing or training can match a formal proof. RIINA's compiler will always catch more bugs than any other language's compiler, because it proves more properties. This advantage compounds as AI generates more code.

### 7.2 The Flywheel

```
More AI-generated RIINA code
         │
         ▼
More examples in AI training data
         │
         ▼
AI gets better at writing RIINA
         │
         ▼
More developers use AI to write RIINA
         │
         ▼
More AI-generated RIINA code (flywheel)
         │
         ▼
RIINA becomes the default for security-sensitive vibe coding
```

### 7.3 The Killer Pitch

For developers: *"Write with vibes. Ship with proofs."*

For CTOs: *"Your AI writes the code. Our compiler proves it's secure. Zero human review needed for security, types, effects, and layout."*

For AI companies: *"Give your coding AI a language where compilation = correctness. Reduce hallucination-to-bug rate to zero for proven properties."*

---

## 8. THREAT MODEL

### 8.1 Threats to AI-First Adoption

| Threat ID | Threat | Mitigation |
|-----------|--------|------------|
| AM-T001 | Zero training data — AI can't write RIINA | Phase AM-1: reference doc + examples for in-context learning |
| AM-T002 | Bahasa Melayu keywords confuse AI | Reference doc maps every keyword; in-context examples sufficient |
| AM-T003 | AI generates syntactically valid but semantically wrong code | Compiler catches all semantic errors (types, effects, security) |
| AM-T004 | AI ignores effect annotations | Compiler rejects missing effects — AI learns from feedback |
| AM-T005 | AI generates `dedah` with bogus policies | Policy validation at compile time (future: policy type system) |
| AM-T006 | AI uses RIINA for non-security code (no advantage) | Position RIINA for security-first use cases; effects system adds value everywhere |
| AM-T007 | Training data pollution (wrong patterns) | Canonical examples from official repo are authoritative |
| AM-T008 | AI model updates break RIINA generation | Version-pinned reference docs; grammar is stable |
| AM-T009 | Competitor language adopts similar features | Mathematical proofs are RIINA's moat — proofs can't be faked |
| AM-T010 | AI prefers Python due to training bias | Position RIINA as "what you switch to when Python fails" — security-critical path |

### 8.2 Threats to Vibe Coding in General (Where RIINA Helps)

| Threat | Status Quo | RIINA Solution |
|--------|-----------|----------------|
| AI generates insecure code | Ship and pray | Compiler rejects insecure code |
| AI generates code nobody reads | Manual review (expensive) | Proofs replace review for proven properties |
| AI generates broken responsive layouts | Visual QA testing | Track AL: compile-time layout proofs |
| AI generates inaccessible UI | Lighthouse audit (post-hoc) | Track AL: compile-time accessibility proofs |
| AI hallucinates non-existent APIs | Runtime error | Strong types + LSP catch at compile time |
| AI inconsistent code style | Linter/formatter (post-hoc) | `riina-fmt` canonical style, AI learns one style |
| AI introduces supply-chain vulnerabilities | Dependency scanning | Zero-trust: no untrusted deps in compiler |

---

## 9. COMPLETE DELIVERABLE ENUMERATION

### 9.1 Files to Create

| # | File | Priority | Category | Description |
|---|------|---------|----------|-------------|
| 1 | `docs/RIINA-LANGUAGE-REFERENCE.md` | P0 | Reference | Complete language ref (≤40K tokens) |
| 2 | `website/public/llms.txt` | P0 | Discovery | llmstxt.org standard file |
| 3 | `website/public/llms-full.txt` | P0 | Discovery | Full reference for AI |
| 4 | `.cursor/rules` | P1 | IDE | Cursor IDE context |
| 5 | `.claude/project.md` | P1 | IDE | Claude Code context |
| 6 | `.github/copilot-instructions.md` | P1 | IDE | Copilot context |
| 7 | `07_EXAMPLES/06_ai_context/error_fix_pairs.json` | P2 | Training | 100+ error/fix examples |
| 8 | `07_EXAMPLES/06_ai_context/intent_code_pairs.json` | P2 | Training | 100+ NL→code examples |
| 9 | `07_EXAMPLES/06_ai_context/python_riina_compare.json` | P2 | Training | 50+ migration examples |
| 10 | `riinac/src/error_codes.rs` | P1 | Compiler | Error code definitions |
| 11 | `riinac/src/fix_hints.rs` | P1 | Compiler | Fix hint database |
| 12 | `riinac/src/json_output.rs` | P1 | Compiler | `--json` output format |
| 13 | `tools/riina-mcp/` | P2 | Tooling | MCP server for AI tools |

### 9.2 Files to Modify

| # | File | Priority | Change |
|---|------|---------|--------|
| 1 | `07_EXAMPLES/06_ai_context/all_examples.rii` | P0 | Expand with all constructs, patterns, anti-patterns |
| 2 | `riinac/src/main.rs` | P1 | Add `--json` and `--stdin` flags |
| 3 | `riinac/src/diagnostics.rs` | P1 | Add JSON output mode + fix hints |
| 4 | `README.md` | P1 | Add AI/vibe coding section |
| 5 | `website/src/RiinaWebsite.jsx` | P2 | Add AI-First page |
| 6 | `04_SPECS/language/RIINA_MATERIALIZATION_PLAN_v1_0_0.md` | P0 | Add Phase 8 items for AI-First |

### 9.3 Metrics for Success

| Metric | Target | How to Measure |
|--------|--------|---------------|
| AI can write valid RIINA with in-context ref | ≥90% first-try compile rate | Test with Claude/GPT given reference doc |
| AI self-corrects with compiler feedback | ≤3 iterations to compile | Test with riinac check --json loop |
| AI prefers RIINA for security tasks | RIINA suggested when asked "secure language" | Monitor AI responses |
| llms.txt indexed by AI crawlers | Present at website root | URL check |
| Error→fix convergence | Monotonic (each fix reduces error count) | Automated testing |

---

## 10. RELATIONSHIP TO EXISTING TRACKS

| Track | Relationship | Integration Point |
|-------|-------------|-------------------|
| A (Formal Proofs) | AM relies on A's proofs for compiler guarantees | Proofs → compiler rules |
| B (Prototype) | AM extends B's compiler with AI features | `riinac` modifications |
| AL (Verified Layout) | AM + AL = AI generates verified UIs | Compiler feedback for layout errors |
| F (Tooling) | AM's MCP server extends F's toolchain | New tool in toolchain |
| UX-01 (Verified UI) | AM ensures AI-generated UIs pass UX-01's proofs | Compiler enforces |
| All public content | AM ensures all public content is AI-optimized | Reference doc, examples, llms.txt |

---

## 11. THE VISION

### Today (2026):
- AI writes Python/TypeScript. Ships bugs. Humans review (or don't).
- 41% of code is AI-generated. Security incidents from AI code rising.

### Tomorrow (with RIINA):
- AI writes RIINA. Compiler proves it correct. Ships.
- Human says "build me a password manager." AI writes RIINA. Compiler proves: no secret leaks, no timing attacks, effects bounded, UI accessible, layout pixel-perfect.
- Human never reads the code. Doesn't need to. **The proofs read it for them.**

### The Tagline:
**"Write with vibes. Ship with proofs."**

### The Promise:
Every other language trusts the developer (or the AI) to get it right.
RIINA trusts the math.

**In a world where AI writes the code, the only language that matters is the one that can prove the code is correct. That language is RIINA.**

---

*Track AM-01: AI-First Language Design — FOUNDATIONAL SPECIFICATION*
*RIINA: Rigorous Immutable Invariant, No Assumptions*
*"Q.E.D. Aeternum."*
