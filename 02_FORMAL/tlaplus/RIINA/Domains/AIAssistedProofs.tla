\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE AIAssistedProofs ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/AIAssistedProofs.v (30 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* proof_source (matches Coq: Inductive proof_source)
CONSTANTS HumanProver, AI_LLM, AI_AutoVerus, AI_APOLLO, HybridHumanAI

\* proof_certificate (matches Coq: Inductive proof_certificate)
CONSTANTS CertAxiom, CertIntro, CertElim, CertRefl

\* kernel_result (matches Coq: Inductive kernel_result)
CONSTANTS KernelAccept, KernelReject

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* cert_valid (matches Coq: Definition cert_valid)
cert_valid(c) == TRUE

\* kernel_check (matches Coq: Definition kernel_check)
kernel_check(c) == TRUE

\* run_kernel (matches Coq: Definition run_kernel)
run_kernel(cand, cert) == TRUE

\* is_hallucinated (matches Coq: Definition is_hallucinated)
is_hallucinated(cand) == TRUE

\* reject_hallucinated (matches Coq: Definition reject_hallucinated)
reject_hallucinated(cand, cert) == TRUE

\* untrusted_ai_proof (matches Coq: Definition untrusted_ai_proof)
untrusted_ai_proof(cand) == TRUE

\* trusted_certificate (matches Coq: Definition trusted_certificate)
trusted_certificate(cert) == TRUE

\* crosses_trust_boundary (matches Coq: Definition crosses_trust_boundary)
crosses_trust_boundary(cand, cert) == TRUE

\* verify_exploit (matches Coq: Definition verify_exploit)
verify_exploit(ex) == TRUE

\* kernel_independent_of_source (matches Coq: Theorem kernel_independent_of_source)
THEOREM kernel_independent_of_source == Init => TypeOK

\* valid_cert_passes_kernel (matches Coq: Theorem valid_cert_passes_kernel)
THEOREM valid_cert_passes_kernel == Init => TypeOK

\* hallucinated_never_trusted (matches Coq: Theorem hallucinated_never_trusted)
THEOREM hallucinated_never_trusted == Init => TypeOK

\* kernel_accept_implies_valid (matches Coq: Theorem kernel_accept_implies_valid)
THEOREM kernel_accept_implies_valid == Init => TypeOK

\* cert_valid_deterministic (matches Coq: Theorem cert_valid_deterministic)
THEOREM cert_valid_deterministic == Init => TypeOK

\* refl_always_valid (matches Coq: Theorem refl_always_valid)
THEOREM refl_always_valid == Init => TypeOK

\* elim_preserves_validity (matches Coq: Theorem elim_preserves_validity)
THEOREM elim_preserves_validity == Init => TypeOK

\* intro_preserves_validity (matches Coq: Theorem intro_preserves_validity)
THEOREM intro_preserves_validity == Init => TypeOK

\* confidence_irrelevant_to_kernel (matches Coq: Theorem confidence_irrelevant_to_kernel)
THEOREM confidence_irrelevant_to_kernel == Init => TypeOK

\* untrusted_not_invalid (matches Coq: Theorem untrusted_not_invalid)
THEOREM untrusted_not_invalid == Init => TypeOK

\* kernel_deterministic (matches Coq: Theorem kernel_deterministic)
THEOREM kernel_deterministic == Init => TypeOK

\* non_hallucinated_may_cross (matches Coq: Theorem non_hallucinated_may_cross)
THEOREM non_hallucinated_may_cross == Init => TypeOK

\* axiom_always_valid (matches Coq: Theorem axiom_always_valid)
THEOREM axiom_always_valid == Init => TypeOK

\* exploit_verify_source_independent (matches Coq: Theorem exploit_verify_source_independent)
THEOREM exploit_verify_source_independent == Init => TypeOK

\* invalid_cert_rejected (matches Coq: Theorem invalid_cert_rejected)
THEOREM invalid_cert_rejected == Init => TypeOK

\* human_not_untrusted_ai (matches Coq: Theorem human_not_untrusted_ai)
THEOREM human_not_untrusted_ai == Init => TypeOK

\* llm_is_untrusted (matches Coq: Theorem llm_is_untrusted)
THEOREM llm_is_untrusted == Init => TypeOK

\* autoverus_is_untrusted (matches Coq: Theorem autoverus_is_untrusted)
THEOREM autoverus_is_untrusted == Init => TypeOK

\* apollo_is_untrusted (matches Coq: Theorem apollo_is_untrusted)
THEOREM apollo_is_untrusted == Init => TypeOK

\* hybrid_is_untrusted (matches Coq: Theorem hybrid_is_untrusted)
THEOREM hybrid_is_untrusted == Init => TypeOK

\* kernel_check_commutes_intro (matches Coq: Theorem kernel_check_commutes_intro)
THEOREM kernel_check_commutes_intro == Init => TypeOK

\* reject_hallucinated_negation (matches Coq: Theorem reject_hallucinated_negation)
THEOREM reject_hallucinated_negation == Init => TypeOK

\* cert_composition_elim (matches Coq: Theorem cert_composition_elim)
THEOREM cert_composition_elim == Init => TypeOK

\* kernel_check_monotone (matches Coq: Theorem kernel_check_monotone)
THEOREM kernel_check_monotone == Init => TypeOK

\* trust_boundary_one_way (matches Coq: Theorem trust_boundary_one_way)
THEOREM trust_boundary_one_way == Init => TypeOK

\* exploit_safety_independent (matches Coq: Theorem exploit_safety_independent)
THEOREM exploit_safety_independent == Init => TypeOK

\* non_hallucinated_rejection_succeeds (matches Coq: Theorem non_hallucinated_rejection_succeeds)
THEOREM non_hallucinated_rejection_succeeds == Init => TypeOK

\* kernel_reject_means_invalid (matches Coq: Theorem kernel_reject_means_invalid)
THEOREM kernel_reject_means_invalid == Init => TypeOK

\* cert_valid_compositional_intro (matches Coq: Theorem cert_valid_compositional_intro)
THEOREM cert_valid_compositional_intro == Init => TypeOK

\* all_ai_untrusted (matches Coq: Theorem all_ai_untrusted)
THEOREM all_ai_untrusted == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
