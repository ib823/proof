# WORKER: Compliance Rules 43→100+ (Claude Code App)

**Mission:** Expand riina-compliance from 43 rules to 100+ unique rules. Every rule must have 2+ tests.

## CURRENT STATE
- 43 unique rules across 15 profiles (some shared across profiles)
- 263 tests passing
- File: `03_PROTO/crates/riina-compliance/src/rules.rs` (1508 lines)
- Tests: `03_PROTO/crates/riina-compliance/src/tests.rs` (1643 lines)

## PROFILES NEEDING MORE RULES

| Profile | Current | Target | Gap |
|---------|---------|--------|-----|
| PCI-DSS | 20 refs | 25 | +5 |
| PDPA | 14 | 18 | +4 |
| BNM RMiT | 13 | 18 | +5 |
| HIPAA | 12 | 18 | +6 |
| GDPR | 12 | 18 | +6 |
| NIST 800-53 | 12 | 18 | +6 |
| ISO 27001 | 12 | 18 | +6 |
| DO-178C | 13 | 18 | +5 |
| SOX | 10 | 15 | +5 |
| MAS TRM | 10 | 15 | +5 |
| CMMC | 8 | 12 | +4 |
| IEC 62443 | 8 | 12 | +4 |
| NERC CIP | 7 | 10 | +3 |
| FDA 21CFR | 7 | 10 | +3 |
| ITAR | 6 | 8 | +2 |

## RULE PATTERNS TO ADD

Focus on NEW detection patterns not already covered:

1. **Hardcoded IP addresses** — string literals matching `\d+\.\d+\.\d+\.\d+`
2. **Hardcoded ports** — numeric literals in network contexts (80, 443, 8080, etc.)
3. **Missing TLS** — `http://` without `https://` in string literals
4. **Debug code in production** — `debug`, `println`, `console.log` patterns
5. **Temporal data without TTL** — data with `timestamp`/`date` but no expiry handling
6. **Excessive permissions** — `Grant` with multiple high-level effects
7. **Missing input bounds** — numeric input without range validation
8. **Insecure defaults** — boolean flags defaulting to `false` for security settings
9. **Missing error propagation** — `Handle` blocks that swallow errors
10. **Cross-origin data flow** — data crossing security level boundaries without declassify

## FILE OWNERSHIP
ONLY touch: `03_PROTO/crates/riina-compliance/src/rules.rs` and `tests.rs`

## TESTING
Every new rule needs 2 tests (violation + compliance). Run:
```bash
cargo test --manifest-path 03_PROTO/Cargo.toml -p riina-compliance
```

## COMMIT FORMAT
```
[TRACK_B] IMPL: Add N compliance rules (total: M rules, K tests)
```
