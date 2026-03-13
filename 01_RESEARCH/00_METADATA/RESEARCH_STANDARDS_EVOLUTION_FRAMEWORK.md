# AP-02: Standards Evolution Framework — Maintaining 100% Research Coverage Over Time

**Domain:** Cross-cutting (applies to all domains)
**Status:** Research Complete
**Date:** 2026-03-13
**Purpose:** Defines how RIINA maintains research coverage as standards evolve

---

## 1. Problem Statement

Research coverage decays because:
- Regulatory standards evolve (Malaysia PDPA amendments, Singapore PDPC updates, NIST PQC revisions)
- New academic results invalidate or supersede existing research
- New domains emerge (quantum, AI safety, post-quantum crypto)
- Industry best practices shift

Without a maintenance framework, today's 100% coverage becomes tomorrow's 85%.

---

## 2. Standards Tracked by RIINA

### 2.1 Regulatory Compliance Standards (Active Tracking Required)

| Standard | Jurisdiction | Current Version | RIINA File | Review Cadence |
|----------|-------------|-----------------|------------|----------------|
| **PDPA** | Malaysia | Act 709 (2024 amendments) | `04_SPECS/industries/REGULATORY_COMPLIANCE_MALAYSIA_SINGAPORE_2026.md` | Annual |
| **PDPC/PDPA** | Singapore | 2024 revision | Same file | Annual |
| **NIST PQC** | USA | FIPS 203/204/205 (Aug 2024) | `01_RESEARCH/64_DOMAIN_AS/` | On new NIST publication |
| **NIST 800-171** | USA | Rev 3 (May 2024) | `04_SPECS/industries/IND_N_MILITARY.md` | On revision |
| **DO-178C** | International (aviation) | 2011 (stable) | `04_SPECS/industries/IND_O_AEROSPACE.md` | Stable — review every 3 years |
| **ISO 26262** | International (automotive) | 2018 Ed 2 | `04_SPECS/industries/IND_A_TRANSPORTATION.md` | On new edition |
| **IEC 62443** | International (industrial) | 2024 update | `04_SPECS/industries/IND_I_MANUFACTURING.md` | On update |
| **HIPAA** | USA (healthcare) | 2024 updates | `04_SPECS/industries/IND_H_HEALTHCARE.md` | Annual |
| **PCI DSS** | International (payments) | v4.0.1 (2024) | `04_SPECS/industries/IND_F_FINANCIAL.md` | On version bump |

### 2.2 Academic Standards (Tracked by Venue)

| Venue | Cadence | Domains Affected |
|-------|---------|-----------------|
| **POPL** | Annual (January) | Type theory, effects, abstract interpretation |
| **PLDI** | Annual (June) | Compilers, runtime, hw-sw verification |
| **CCS** | Annual (November) | Crypto, system security |
| **S&P (Oakland)** | Annual (May) | All security domains |
| **USENIX Security** | Annual (August) | Systems security, crypto |
| **NeurIPS** | Annual (December) | ML safety, NN verification |
| **VNN-COMP** | Annual | ML model verification benchmarks |
| **CAV** | Annual (July) | Formal verification tools |

### 2.3 Tool/Framework Standards

| Tool | Current Version | RIINA Integration | Update Trigger |
|------|----------------|-------------------|----------------|
| **CompCert** | 3.14 | Domain AR (hw-sw co-verification) | On release |
| **HACL*** | Latest F* extraction | Domain AS (PQC) | On algorithm addition |
| **Iris** | iris-dev (Coq-compatible) | Domain AQ (concurrency) | On Coq version update |
| **Alpha-beta-CROWN** | v4.x | Domain AT (ML safety) | On VNN-COMP results |

---

## 3. Maintenance Protocol

### 3.1 Quarterly Review Cycle

Every quarter, check:
1. **NIST publications** — Any new FIPS, SP 800-series, or PQC announcements
2. **Major venue proceedings** — Scan POPL/PLDI/CCS/S&P for directly relevant papers
3. **Standard body updates** — Check ISO, IEC, FAA for standard revisions
4. **Jurisdiction changes** — Malaysia/Singapore regulatory gazette notices

### 3.2 Update Procedure

When a standard changes:
1. Update the corresponding research document with new version info
2. Assess impact on RIINA formalization (does a typing rule need to change?)
3. If Coq proof impact: create a TODO in RIINA_MASTER_PLAN.md
4. If industry spec impact: update the corresponding `04_SPECS/industries/IND_*.md`
5. Update this tracking document's version table

### 3.3 New Domain Procedure

When a new domain emerges:
1. Create `01_RESEARCH/XX_DOMAIN_YY_NAME/` directory
2. Write research document following the standard template (Problem → State of Art → Properties → Integration → References → Formalizability)
3. Update `04_SPECS/scope/RIINA_DEFINITIVE_SCOPE.md` Part VI/VII
4. Update `06_COORDINATION/DOMAIN_COVERAGE_MATRIX.md`

---

## 4. Empirical Validation Framework

### 4.1 What RIINA Needs (Currently Missing)

| Empirical Data Type | Purpose | How to Obtain |
|---------------------|---------|---------------|
| **Compilation benchmarks** | Measure riinac compile time vs codebase size | Run riinac on test corpus, record times |
| **Runtime performance** | Measure compiled RIINA vs hand-written C | Run standard benchmark suite (e.g., Computer Language Benchmarks Game subset) |
| **Type checking overhead** | Measure effect/IFC checking cost | Profile riinac typechecker on increasing program sizes |
| **Proof compilation time** | Measure Coq build time scaling | Track `make` time across Coq codebase growth |
| **Binary size** | Measure output binary sizes | Compare RIINA-generated C compiled output vs equivalent C |
| **Developer usability** | Measure time-to-complete for common tasks | User study (requires human participants) |

### 4.2 Automated Benchmark Infrastructure

```bash
# Proposed benchmark runner (Phase 5+)
riinac bench --corpus=07_EXAMPLES/ --output=benchmarks.json
riinac bench --compare-to=c --suite=microbenchmarks
```

This infrastructure does not exist yet. When it does, benchmark results should be stored in `01_RESEARCH/00_METADATA/BENCHMARKS/` and referenced from research documents.

### 4.3 What Can Be Done Now

Without full benchmark infrastructure:
1. **Coq proof compilation time** — Already measurable: `time make` in `02_FORMAL/coq/`
2. **Rust test suite time** — Already measurable: `time cargo test --all`
3. **Binary sizes** — Already measurable for end-to-end tests
4. **Lines of code metrics** — Already tracked in metrics.json

---

## 5. Coverage Completeness Definition

### 5.1 What "100% Research Coverage" Means

For RIINA, 100% research coverage means:

> **Every domain listed in RIINA_DEFINITIVE_SCOPE.md Part VI has a substantive research document in 01_RESEARCH/ that (a) surveys the state of the art, (b) identifies properties verifiable by RIINA, (c) proposes integration architecture, and (d) assesses formalizability.**

This is a finite, well-defined set. The scope document lists 65 domains (A through AT). Each domain needs at least one substantive research document.

### 5.2 What 100% Does NOT Mean

- NOT: every possible research paper has been read
- NOT: every possible domain has been considered
- NOT: empirical validation has been performed on all claims
- NOT: all research has been formalized into Coq proofs

### 5.3 Current Status After This Session

| Category | Before | After | Delta |
|----------|--------|-------|-------|
| Domains with substantive research | 55/60 (pre-session count) | 65/65 | +5 new domains (AP-AT) |
| Domains with placeholder research | 5 | 0 | Resolved |
| Missing domains (out of scope) | 5 (quantum, distributed, hw-sw, PQC, ML safety) | 0 | Added as domains 61-65 |
| Standards tracking framework | None | This document | New |
| Empirical benchmark framework | None | Defined (not yet implemented) | New |

---

## 6. Conclusion

Research coverage is now defined, bounded, and maintainable:
1. **65 domains** — each with substantive research documents
2. **Quarterly review cycle** — prevents standards decay
3. **New domain procedure** — handles emerging areas
4. **Empirical framework defined** — implementation is Phase 5+

The remaining work to maintain 100% is operational (quarterly reviews), not research.
