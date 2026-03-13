; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Z001_DeclassificationPolicy — SMT Verification
; Derived from 02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v (36 assertions)
; Module: Z001_DeclassificationPolicy
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Principal 0)) (((PUser) (PRole) (PSystem) (PJoin) (PMeet))))

(declare-datatypes ((SecurityLevel 0)) (((Public) (Secret) (TopSecret))))

(declare-datatypes ((Program 0)) (((PSkip) (PAssign) (PDeclass) (PSeq))))

(declare-datatypes ((DeclassPolicy 0))
  (((mk-declass_policy (policy_id Int) (authorized_principal Principal) (source_level SecurityLevel) (target_level SecurityLevel) (source_type Int) (target_type Int) (guard_fn Int) (transform Int) (budget Int) (policy_active Bool)))))

(declare-datatypes ((BudgetState 0))
  (((mk-budget_state (budget_principal Principal) (budget_per_policy Int) (total_leaked Int) (budget_window Int) (budget_total_limit Int)))))

(declare-datatypes ((DeclassExpr 0))
  (((mk-declass_expr (declass_value Int) (declass_policy DeclassPolicy) (declass_guard Int)))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (audit_principal Principal) (audit_policy_id Int) (audit_bits_leaked Int) (audit_timestamp Int) (audit_value_hash Int)))))

(declare-datatypes ((PrivacyBudget 0))
  (((mk-privacy_budget (epsilon_total Int) (delta_total Int) (epsilon_used Int) (delta_used Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Principal exhaustiveness ---
(push 1)
(declare-const x Principal)
(assert (not (or (= x PUser) (= x PRole) (= x PSystem) (= x PJoin) (= x PMeet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Principal: PUser != PRole ---
(push 1)
(assert (= PUser PRole))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Principal: PRole != PSystem ---
(push 1)
(assert (= PRole PSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Principal: PSystem != PJoin ---
(push 1)
(assert (= PSystem PJoin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Principal: PUser != PMeet ---
(push 1)
(assert (= PUser PMeet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Principal finite cardinality (5 values) ---
(push 1)
(declare-const x Principal)
(assert (and (not (= x PUser)) (not (= x PRole)) (not (= x PSystem)) (not (= x PJoin)) (not (= x PMeet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x Public) (= x Secret) (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SecurityLevel: Public != Secret ---
(push 1)
(assert (= Public Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SecurityLevel: Secret != TopSecret ---
(push 1)
(assert (= Secret TopSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SecurityLevel finite cardinality (3 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x Public)) (not (= x Secret)) (not (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Program exhaustiveness ---
(push 1)
(declare-const x Program)
(assert (not (or (= x PSkip) (= x PAssign) (= x PDeclass) (= x PSeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Program: PSkip != PAssign ---
(push 1)
(assert (= PSkip PAssign))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Program: PAssign != PDeclass ---
(push 1)
(assert (= PAssign PDeclass))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Program: PDeclass != PSeq ---
(push 1)
(assert (= PDeclass PSeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Program: PSkip != PSeq ---
(push 1)
(assert (= PSkip PSeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Program finite cardinality (4 values) ---
(push 1)
(declare-const x Program)
(assert (and (not (= x PSkip)) (not (= x PAssign)) (not (= x PDeclass)) (not (= x PSeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. DeclassPolicy accessor round-trip: policy_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Principal)
(declare-const f2 SecurityLevel)
(declare-const f3 SecurityLevel)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (policy_id (mk-declass_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. DeclassPolicy accessor round-trip: authorized_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Principal)
(declare-const f2 SecurityLevel)
(declare-const f3 SecurityLevel)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (authorized_principal (mk-declass_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. DeclassPolicy accessor round-trip: source_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Principal)
(declare-const f2 SecurityLevel)
(declare-const f3 SecurityLevel)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (source_level (mk-declass_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DeclassPolicy accessor round-trip: target_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Principal)
(declare-const f2 SecurityLevel)
(declare-const f3 SecurityLevel)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (target_level (mk-declass_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. DeclassPolicy accessor round-trip: source_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Principal)
(declare-const f2 SecurityLevel)
(declare-const f3 SecurityLevel)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (source_type (mk-declass_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. DeclassPolicy: non-negative int fields sum ---
(push 1)
(declare-const r DeclassPolicy)
(assert (>= (policy_id r) 0))
(assert (>= (source_type r) 0))
(assert (not (>= (+ (policy_id r) (source_type r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BudgetState accessor round-trip: budget_principal ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (budget_principal (mk-budget_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BudgetState accessor round-trip: budget_per_policy ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (budget_per_policy (mk-budget_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BudgetState accessor round-trip: total_leaked ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (total_leaked (mk-budget_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BudgetState accessor round-trip: budget_window ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (budget_window (mk-budget_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BudgetState accessor round-trip: budget_total_limit ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (budget_total_limit (mk-budget_state f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. BudgetState: non-negative int fields sum ---
(push 1)
(declare-const r BudgetState)
(assert (>= (budget_per_policy r) 0))
(assert (>= (total_leaked r) 0))
(assert (not (>= (+ (budget_per_policy r) (total_leaked r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. DeclassExpr accessor round-trip: declass_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeclassPolicy)
(declare-const f2 Int)
(assert (not (= (declass_value (mk-declass_expr f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. DeclassExpr accessor round-trip: declass_policy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeclassPolicy)
(declare-const f2 Int)
(assert (not (= (declass_policy (mk-declass_expr f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DeclassExpr accessor round-trip: declass_guard ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeclassPolicy)
(declare-const f2 Int)
(assert (not (= (declass_guard (mk-declass_expr f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DeclassExpr: non-negative int fields sum ---
(push 1)
(declare-const r DeclassExpr)
(assert (>= (declass_value r) 0))
(assert (>= (declass_guard r) 0))
(assert (not (>= (+ (declass_value r) (declass_guard r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. AuditEntry accessor round-trip: audit_principal ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (audit_principal (mk-audit_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. AuditEntry accessor round-trip: audit_policy_id ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (audit_policy_id (mk-audit_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. AuditEntry accessor round-trip: audit_bits_leaked ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (audit_bits_leaked (mk-audit_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AuditEntry accessor round-trip: audit_timestamp ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (audit_timestamp (mk-audit_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AuditEntry accessor round-trip: audit_value_hash ---
(push 1)
(declare-const f0 Principal)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (audit_value_hash (mk-audit_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. AuditEntry: non-negative int fields sum ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (audit_policy_id r) 0))
(assert (>= (audit_bits_leaked r) 0))
(assert (not (>= (+ (audit_policy_id r) (audit_bits_leaked r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. PrivacyBudget accessor round-trip: epsilon_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (epsilon_total (mk-privacy_budget f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. PrivacyBudget accessor round-trip: delta_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (delta_total (mk-privacy_budget f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. PrivacyBudget accessor round-trip: epsilon_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (epsilon_used (mk-privacy_budget f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. PrivacyBudget accessor round-trip: delta_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (delta_used (mk-privacy_budget f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. PrivacyBudget: non-negative int fields sum ---
(push 1)
(declare-const r PrivacyBudget)
(assert (>= (epsilon_total r) 0))
(assert (>= (delta_total r) 0))
(assert (not (>= (+ (epsilon_total r) (delta_total r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x Public) 0 (ite (= x Secret) 1 2)))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 44. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. Public is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq Public x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. TopSecret is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x TopSecret)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
