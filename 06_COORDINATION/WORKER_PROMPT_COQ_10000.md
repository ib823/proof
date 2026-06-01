# WORKER: Coq Proof Growth 9,171→10,000 Qed (Claude Code App)

**Mission:** Add 829+ new Coq Qed proofs to reach the 10,000 milestone. Zero Admitted, zero Axioms.

## CURRENT STATE
- 9,171 Qed proofs across 260 active .v files
- 0 Admitted, 0 Axioms, 0 Assumptions
- Compiler: Rocq 9.2 (files use `From Stdlib`)
- Build: `eval $(opam env --switch=rocq) && cd 02_FORMAL/coq && make`

## WHERE TO ADD PROOFS

### Option A: Expand existing domain files (easiest)
Each domain file in `02_FORMAL/coq/domains/` has 20-60 Qed proofs. Add more lemmas to existing files:

- `MemorySafety.v` — add bounds checking lemmas, use-after-free prevention
- `CryptographicSecurity.v` — add more algorithm correctness properties
- `NetworkSecurity.v` — add TLS handshake properties, certificate validation
- `SessionTypes.v` — add more session duality and progress lemmas
- `LinearTypes.v` — add resource tracking, linearity composition lemmas
- `CapabilitySecurity.v` — add capability delegation, revocation proofs
- `SmartContractSecurity.v` — add reentrancy, integer overflow proofs

### Option B: New domain files (more impactful)
Create new `.v` files in `02_FORMAL/coq/domains/` for uncovered domains:

- `QuantumResistance.v` — post-quantum security properties
- `AIModelSecurity.v` — ML model integrity, adversarial robustness
- `PrivacyPreservation.v` — differential privacy, k-anonymity
- `BlockchainConsensus.v` — Byzantine fault tolerance
- `IoTSecurity.v` — device attestation, firmware integrity
- `CloudSecurity.v` — multi-tenancy isolation, data residency

### Option C: Strengthen existing property proofs
Files in `02_FORMAL/coq/properties/` can have deeper proofs:

- More substitution lemmas
- More canonical forms lemmas
- Deeper store relation properties
- Additional effect monotonicity lemmas

## PROOF TEMPLATE

```coq
(* New lemma in an existing file *)
Lemma new_property : forall x y,
  some_condition x y ->
  some_conclusion x y.
Proof.
  intros x y H.
  (* Proof body — use induction, destruct, auto, simpl, omega as needed *)
  auto.
Qed.
```

## RULES

1. **NEVER use `Admitted`** — every proof must end with `Qed`
2. **NEVER add `Axiom`** — derive everything from existing definitions
3. **All files must compile**: `eval $(opam env --switch=rocq) && cd 02_FORMAL/coq && rocq compile -Q . RIINA <file>`
4. **Add new files to `_CoqProject`** if creating new .v files
5. **Use `From Stdlib`** not `From Coq` (Rocq 9.2)

## BUILD & VERIFY

```bash
eval $(opam env --switch=rocq)
cd 02_FORMAL/coq

# Build specific file
rocq compile -Q . RIINA domains/NewFile.v

# Build all
make

# Count Qed
grep -c "^Qed\." domains/NewFile.v
```

## FILE OWNERSHIP
ONLY touch: `02_FORMAL/coq/domains/` and `02_FORMAL/coq/_CoqProject`

Do NOT touch: `02_FORMAL/coq/foundations/`, `02_FORMAL/coq/properties/`, `02_FORMAL/coq/type_system/`, `02_FORMAL/coq/effects/`, `02_FORMAL/coq/termination/`

## COMMIT FORMAT
```
[TRACK_A] PROOF: Add N Coq proofs in domains/ (total: M Qed)
```

## SUCCESS CRITERIA
- Total Qed ≥ 10,000 (need 829+ new)
- 0 Admitted, 0 Axioms
- `make` passes in `02_FORMAL/coq/`
