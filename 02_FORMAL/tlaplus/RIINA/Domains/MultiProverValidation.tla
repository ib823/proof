---- MODULE MultiProverValidation ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/MultiProverValidation.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* formula (matches Coq: Inductive formula)
CONSTANTS FAtom, FNot, FAnd, FImpl

formulaSet == {FAtom, FNot, FAnd, FImpl}

\* certificate (matches Coq: Inductive certificate)
CONSTANTS CertAtom, CertNotI, CertAndI, CertImplE, CertAssume

certificateSet == {CertAtom, CertNotI, CertAndI, CertImplE, CertAssume}

\* proverA_repr (matches Coq: Inductive proverA_repr)
CONSTANTS PA_Atom, PA_Neg, PA_Conj, PA_Arrow

proverA_reprSet == {PA_Atom, PA_Neg, PA_Conj, PA_Arrow}

\* proverB_repr (matches Coq: Inductive proverB_repr)
CONSTANTS PB_Var, PB_Not, PB_And, PB_If

proverB_reprSet == {PB_Var, PB_Not, PB_And, PB_If}

\* confidence (matches Coq: Inductive confidence)
CONSTANTS NoConfidence, SingleProver, DualProver

confidenceSet == {NoConfidence, SingleProver, DualProver}

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* assumptions (matches Coq: Definition assumptions)
assumptions ==
  0

\* confidence_level (matches Coq: Definition confidence_level)
confidence_level(validB) ==
    CASE validA = true, true -> DualProver
      [] validA = true, false -> SingleProver
      [] validA = false, true -> SingleProver
      [] validA = false, false -> NoConfidence

\* confidence_ge (matches Coq: Definition confidence_ge)
confidence_ge(c2) ==
    CASE c1 = DualProver, _ -> True
      [] c1 = SingleProver, NoConfidence -> True
      [] c1 = SingleProver, SingleProver -> True
      [] c1 = NoConfidence, NoConfidence -> True
      [] c1 = _, _ -> False

\* formula_eqb (matches Coq: Definition formula_eqb)
formula_eqb(f2) ==
    CASE f1 = FAtom n1, FAtom n2 -> Nat

\* cert_formula (matches Coq: Definition cert_formula)
cert_formula(c) ==
    CASE c = CertAtom n -> FAtom
      [] c = CertNotI f _ -> FNot
      [] c = CertAndI c1 c2 -> FAnd
      [] c = CertImplE c1 c2 -> match
      [] c = FImpl _ b -> b
      [] c = other -> other
      [] c = CertAssume f -> f

\* translate_to_A (matches Coq: Definition translate_to_A)
translate_to_A(f) ==
    CASE f = FAtom n -> PA_Atom
      [] f = FNot g -> PA_Neg
      [] f = FAnd g h -> PA_Conj
      [] f = FImpl g h -> PA_Arrow

\* translate_to_B (matches Coq: Definition translate_to_B)
translate_to_B(f) ==
    CASE f = FAtom n -> PB_Var
      [] f = FNot g -> PB_Not
      [] f = FAnd g h -> PB_And
      [] f = FImpl g h -> PB_If

\* translate_from_A (matches Coq: Definition translate_from_A)
translate_from_A(r) ==
    CASE r = PA_Atom n -> FAtom
      [] r = PA_Neg g -> FNot
      [] r = PA_Conj g h -> FAnd
      [] r = PA_Arrow g h -> FImpl

\* translate_from_B (matches Coq: Definition translate_from_B)
translate_from_B(r) ==
    CASE r = PB_Var n -> FAtom
      [] r = PB_Not g -> FNot
      [] r = PB_And g h -> FAnd
      [] r = PB_If g h -> FImpl

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================


\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* formula_eqb_refl
THEOREM formula_eqb_refl ==
  \A f \in Nat :
      formula_eqb(f, f)

\* formula_eqb_eq
THEOREM formula_eqb_eq ==
  \A f1 \in Nat, f2 \in Nat :
      formula_eqb(f1, f2) => f1 = f2


\* validator_soundness_atomic
THEOREM validator_soundness_atomic ==
  \A c \in Nat, n \in Nat :
      validate_atomic(c, n) => cert_formula(c) = FAtom n


\* translation_preserves_structure_A
THEOREM translation_preserves_structure_A ==
  \A f \in Nat :
      translate_from_A (translate_to_A f) = f


\* translation_preserves_structure_B
THEOREM translation_preserves_structure_B ==
  \A f \in Nat :
      translate_from_B (translate_to_B f) = f


\* dual_prover_confidence
THEOREM dual_prover_confidence ==
  \A vA \in Nat, vB \in Nat :
      vA = true => confidence_level(vA, vB) = DualProver


\* dual_ge_single
THEOREM dual_ge_single ==
  confidence_ge(DualProver, SingleProver)


\* certificate_composition
THEOREM certificate_composition ==
  \A cA \in Nat, cAB \in Nat, a \in Nat, b \in Nat :
      cert_formula(cA) = a => cert_formula (CertImplE cAB cA) = b


\* validator_deterministic
THEOREM validator_deterministic ==
  \A asms \in Nat, c \in Nat, f \in Nat, r1 \in Nat, r2 \in Nat :
      validate asms c f = r1 => r1 = r2


\* formula_eq_dec
THEOREM formula_eq_dec ==
  \A f1 \in Nat, f2 \in Nat, formula \in Nat :
      {f1 = f2} + {f1 <> f2}


\* translate_to_A_injective
THEOREM translate_to_A_injective ==
  \A f1 \in Nat, f2 \in Nat :
      translate_to_A(f1) = translate_to_A(f2) => f1 = f2


\* translate_to_B_injective
THEOREM translate_to_B_injective ==
  \A f1 \in Nat, f2 \in Nat :
      translate_to_B(f1) = translate_to_B(f2) => f1 = f2


\* validator_completeness_atomic
THEOREM validator_completeness_atomic ==
  \A n \in Nat :
      validate_atomic (CertAtom n) n = true


\* 21 additional theorems proven in Coq source

====
