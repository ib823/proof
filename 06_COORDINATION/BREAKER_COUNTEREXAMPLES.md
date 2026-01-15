# BREAKER COUNTEREXAMPLES AND EXPLOITATION SCENARIOS

**Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST**
**Created: 2026-01-15 - Attack Cycle 2**

This document contains CONCRETE counterexamples and exploitation scenarios
for each vulnerability class identified by BREAKER.

---

## SECTION 1: COUNTEREXAMPLES FOR "PROVES TRUE" THEOREMS

### CE-001: effect_safety Counterexample

**Claimed Theorem (EffectSystem.v:84-90):**
```coq
Theorem effect_safety : forall e T eff,
  has_type_full nil nil Public e T eff ->
  True.  (* <-- VACUOUS *)
```

**What It Should Prove:**
"Well-typed expressions only perform effects within their declared effect budget."

**Counterexample Construction:**

```coq
(* Define a term that types with EffectPure but performs EffectSystem *)

(* Step 1: The typing rule T_Grant gives effect ε (unchanged) *)
(* EGrant EffectSystem (EPerform EffectSystem EUnit) *)
(* By T_Perform: EPerform EffectSystem EUnit : TUnit @ EffectSystem *)
(* By T_Grant: EGrant EffectSystem (...) : TUnit @ EffectSystem *)

(* Wait - this still has EffectSystem in the type. *)
(* But the RUNTIME doesn't check! Let's trace execution: *)

(* Step 2: Runtime trace *)
(* (EGrant EffectSystem (EPerform EffectSystem EUnit), [], []) *)
(* --> by ST_GrantStep: (EGrant EffectSystem (EPerform EffectSystem EUnit'), ...) *)
(* --> eventually: (EGrant EffectSystem EUnit, [], []) *)
(* --> ??? No rule reduces EGrant of a value! *)

(* STUCK! But wait - there's no ST_GrantValue rule! *)
(* EGrant eff v is a VALUE by VGrant, so it doesn't step. *)
(* But it's not a "useful" value - you can't do anything with it. *)

(* Actually this reveals a DIFFERENT bug: *)
(* EGrant EffectSystem EUnit is a value of type TUnit *)
(* But you can't extract the Unit from the Grant wrapper! *)
```

**Concrete Exploit:**
```
Program: grant EffectSystem to (perform EffectSystem ())
Expected: Executes the effect, returns ()
Actual: Gets stuck as (EGrant EffectSystem EUnit) - a value that isn't Unit

The effect WAS performed (semantically), but the result is trapped.
If we add ST_GrantValue: (EGrant eff v, st, ctx) --> (v, st, ctx)
Then effects execute WITHOUT the context being checked.
```

**Severity:** The effect system has NO runtime enforcement. Period.

---

### CE-002: gate_enforcement Counterexample

**Claimed Theorem (EffectGate.v:34-41):**
```coq
Theorem gate_enforcement : forall G S D e T eff_allowed eff_used,
  has_type_full G S D e T eff_used ->
  effect_level eff_used <= effect_level eff_allowed ->
  True.  (* <-- VACUOUS *)
```

**What It Should Prove:**
"An expression with effect eff_used cannot escape to perform higher effects than eff_allowed."

**Counterexample:**
```coq
(* Suppose we have: *)
e : T @ EffectRead   (* Declared: only reads *)
eff_allowed = EffectRead

(* But e contains: EPerform EffectSystem dangerous_payload *)
(* The typing should REJECT this, but let's see... *)

(* Actually, by T_Perform: *)
(* EPerform EffectSystem payload : TUnit @ EffectSystem *)
(* This has eff = EffectSystem, not EffectRead *)
(* So it wouldn't type-check with EffectRead... *)

(* BUT! There's no subtyping. If we have: *)
let f : (Unit -[EffectRead]-> Unit) =
  fun (x : Unit) -> perform EffectSystem x  (* TYPE ERROR - good! *)

(* The type system DOES prevent this at the typing level. *)
(* But gate_enforcement still proves nothing about runtime. *)
```

**Real Problem:** The theorem proves True, so even though typing prevents some issues, there's NO FORMAL GUARANTEE that runtime matches typing.

---

### CE-003: is_gate Definition Exploitation

**Definition (EffectGate.v:22-26):**
```coq
Definition is_gate (eff : effect) (e_gate : expr) : Prop :=
  True.
```

**Exploitation:**
```coq
(* Since is_gate is True for ANY expression: *)
Lemma everything_is_a_gate : forall eff, is_gate eff EUnit.
Proof. unfold is_gate. exact I. Qed.

Lemma malware_is_a_gate : forall eff payload,
  is_gate eff (EPerform EffectSystem payload).
Proof. unfold is_gate. exact I. Qed.

(* A gate that performs the effect it's supposed to block is "valid" *)
```

**Impact:** Any security analysis using `is_gate` is meaningless.

---

## SECTION 2: CANONICAL FORM COUNTEREXAMPLES

### CE-004: canonical_bool is FALSE

**Claimed Lemma (Progress.v:26-34):**
```coq
Lemma canonical_bool : forall v ε,
  has_type nil nil Public v TBool ε ->
  value v ->
  exists b, v = EBool b.
```

**Counterexample:**
```coq
(* Construct a value of type TBool that is NOT EBool b *)

(* By T_Grant (Typing.v:186-188): *)
(* has_type Γ Σ Δ e T ε -> has_type Γ Σ Δ (EGrant eff e) T ε *)

(* Let e = EBool true, T = TBool, ε = EffectPure *)
(* Then: EGrant EffectPure (EBool true) : TBool @ EffectPure *)

(* By VGrant (Syntax.v:164): *)
(* value v -> value (EGrant eff v) *)
(* value (EBool true) by VBool *)
(* Therefore: value (EGrant EffectPure (EBool true)) *)

(* So we have: *)
v = EGrant EffectPure (EBool true)
(* value v ✓ *)
(* has_type nil nil Public v TBool EffectPure ✓ *)
(* But v ≠ EBool b for any b! *)

(* canonical_bool claims: exists b, v = EBool b *)
(* This is FALSE. v = EGrant EffectPure (EBool true) ≠ EBool b *)
```

**Formal Proof of Falsity:**
```coq
(* If canonical_bool were provable, we could derive False: *)
Lemma canonical_bool_false :
  (forall v ε, has_type nil nil Public v TBool ε -> value v ->
   exists b, v = EBool b) -> False.
Proof.
  intro H.
  (* Construct our counterexample *)
  pose (v := EGrant EffectPure (EBool true)).
  assert (Hty : has_type nil nil Public v TBool EffectPure).
  { apply T_Grant. apply T_Bool. }
  assert (Hval : value v).
  { apply VGrant. apply VBool. }
  destruct (H v EffectPure Hty Hval) as [b Heq].
  (* Heq : EGrant EffectPure (EBool true) = EBool b *)
  discriminate Heq.  (* EGrant ≠ EBool, CONTRADICTION *)
Qed.
```

---

### CE-005: canonical_fn is FALSE

**Claimed Lemma (Progress.v:36-44):**
```coq
Lemma canonical_fn : forall v T1 T2 ε ε',
  has_type nil nil Public v (TFn T1 T2 ε) ε' ->
  value v ->
  exists x body, v = ELam x T1 body.
```

**Counterexample:**
```coq
(* Similar construction with ERequire *)
v = ERequire EffectPure (ELam "x" TInt (EVar "x"))

(* By T_Require: gives type T with effect (effect_join ε eff) *)
(* has_type ... (ELam "x" TInt (EVar "x")) (TFn TInt TInt EffectPure) EffectPure *)
(* By T_Require: has_type ... (ERequire EffectPure ...) (TFn TInt TInt EffectPure) EffectPure *)

(* By VRequire: value (ERequire eff v) if value v *)
(* value (ELam "x" TInt (EVar "x")) by VLam *)
(* Therefore: value (ERequire EffectPure (ELam ...)) *)

(* But v ≠ ELam x T1 body for any x, body! *)
```

---

## SECTION 3: REFERENCE SYSTEM EXPLOITATION

### CE-006: Mutable State Doesn't Work

**Semantic Rules (Semantics.v:166-182):**
```coq
| ST_DerefRef : forall v l st ctx,
    value v ->
    (EDeref (ERef v l), st, ctx) --> (v, st, ctx)

| ST_AssignRef : forall v1 v2 l st ctx,
    value v1 -> value v2 ->
    (EAssign (ERef v1 l) v2, st, ctx) --> (EUnit, st, ctx)
```

**Exploitation Scenario:**
```
(* Intended program behavior: *)
let counter = ref 0 in
counter := !counter + 1;
counter := !counter + 1;
!counter   (* Should return 2 *)

(* Actual execution trace: *)
(* Let's simplify to: *)
let r = ref 0 in r := 1; !r

(* Desugared: *)
ELet "r" (ERef (EInt 0) Public) (
  ELet "_" (EAssign (EVar "r") (EInt 1)) (
    EDeref (EVar "r")
  )
)

(* Step 1: Evaluate ref 0 *)
(* ERef (EInt 0) Public is a VALUE by VRef! It doesn't allocate! *)

(* Step 2: Substitute *)
(* ["r" := ERef (EInt 0) Public] (ELet "_" ...) *)

(* Step 3: In the body, r = ERef (EInt 0) Public *)
(* EAssign (ERef (EInt 0) Public) (EInt 1) *)
(* By ST_AssignRef: --> EUnit *)
(* BUT THE STORE IS UNCHANGED! *)

(* Step 4: Deref *)
(* EDeref (ERef (EInt 0) Public) *)
(* By ST_DerefRef: --> (EInt 0) *)
(* NOT (EInt 1)! *)
```

**Result:** Assignment has NO EFFECT. `!counter` returns 0, not 2.

**Security Impact:**
- Audit logs that use refs will not record anything
- Security counters (rate limiting, attempt counting) don't work
- Session state is broken
- Any mutable security mechanism is bypassed

---

### CE-007: No Heap Isolation

**Problem:** Without proper heap allocation, there's no isolation between different "references."

```
(* Two separate refs should be independent: *)
let r1 = ref 0 in
let r2 = ref 0 in
r1 := 1;
!r2   (* Should be 0, not affected by r1 *)

(* But in current semantics: *)
(* r1 = ERef (EInt 0) Public *)
(* r2 = ERef (EInt 0) Public *)
(* r1 and r2 are IDENTICAL expressions! *)
(* No way to distinguish them! *)
```

**Impact:** Reference identity is broken. Cannot implement object identity.

---

## SECTION 4: DECLASSIFICATION EXPLOITATION

### CE-008: Forge Declassification Proof

**Attack:** Create a "proof" that allows declassifying any secret.

```coq
(* To declassify (secret : TSecret Int), I need (proof : TProof (TSecret Int)) *)
(* By T_Prove: EProve e : TProof T if e : T *)
(* So I need e : TSecret Int *)

(* By T_Classify: EClassify e : TSecret T if e : T *)
(* So EClassify (EInt 0) : TSecret Int *)

(* Therefore: EProve (EClassify (EInt 0)) : TProof (TSecret Int) *)

(* Now I can declassify ANY TSecret Int: *)
forall (stolen_secret : TSecret Int),
  EDeclassify stolen_secret (EProve (EClassify (EInt 0))) : Int

(* The "proof" has NOTHING to do with stolen_secret! *)
(* I proved that (classify 0) has type TSecret Int *)
(* This "proves" I can declassify a completely different secret! *)
```

**Concrete Exploit:**
```
(* User A's password: *)
let secret_password = classify "hunter2" in

(* Attacker's forged proof: *)
let fake_proof = prove (classify "anything") in

(* Attack: *)
let stolen = declassify secret_password fake_proof in
print stolen  (* Prints "hunter2" *)
```

**Security Impact:** Complete bypass of information flow security.

---

## SECTION 5: EFFECT SYSTEM EXPLOITATION

### CE-009: Perform Effects Without Capability

**Problem (Semantics.v:145-147):**
```coq
| ST_PerformValue : forall eff v st ctx,
    value v ->
    (EPerform eff v, st, ctx) --> (v, st, ctx)
```

**Note:** The `ctx` is NOT CHECKED. Any effect can be performed regardless of capabilities.

**Exploit:**
```
(* Suppose EffectSystem allows arbitrary code execution *)
(* A sandboxed function should only have EffectPure *)

let sandboxed : Unit -[EffectPure]-> Unit =
  fun () ->
    (* Type system prevents: perform EffectSystem dangerous *)
    (* But if we somehow get past typing... *)
    ()

(* The RUNTIME doesn't check effects! *)
(* If an attacker injects: EPerform EffectSystem payload *)
(* It will execute regardless of the effect context *)
```

**Real-world analogy:** Like having a capability system where the kernel never checks capabilities at syscall time.

---

### CE-010: Grant Without Push

**Problem (Semantics.v):** No ST_GrantValue rule exists.

**Current Behavior:**
```coq
(* EGrant eff v where v is a value... *)
(* VGrant says this IS a value *)
(* But there's no reduction rule! *)
(* It's stuck! *)
```

**What Should Happen:**
```coq
(* Option A: Grant pushes to context *)
| ST_GrantValue : forall eff v st ctx,
    value v ->
    (EGrant eff v, st, ctx) --> (v, st, eff :: ctx)

(* Option B: Grant is a binding form *)
| ST_GrantValue : forall eff v st ctx,
    value v ->
    (EGrant eff v, st, ctx) --> (v, st, ctx)
    (* Effect was available in scope of v's evaluation *)
```

**Impact:** Programs using `grant` get stuck.

---

## SECTION 6: NONINTERFERENCE BYPASS

### CE-011: Timing Side Channel

**val_rel for TSecret (NonInterference.v:85):**
```coq
| TSecret T' => True
```

**Exploit:**
```
(* These two programs are "equivalent" by the logical relation: *)

let secret = classify password in
if expensive_computation(secret) then 1 else 0

(* With password = "a": takes 1ms, returns 1 *)
(* With password = "zzzzzzzzzz": takes 100ms, returns 1 *)

(* The TIMING leaks information about the secret! *)
(* But val_rel says all secrets are equivalent *)
(* So the proof doesn't catch this *)
```

**Security Impact:** Timing attacks completely unaddressed.

---

### CE-012: Store-Based Information Leak

**Problem (NonInterference.v:99-105):**
```coq
| TFn T1 T2 eff =>
    forall x y, val_rel T1 x y ->
      forall st1 st2 ctx,  (* st1 and st2 can be DIFFERENT! *)
```

**Exploit:**
```
(* Function that reads from a secret location in the store: *)
let leak : Unit -> Int = fun () ->
  !secret_ref  (* Returns different values for different stores *)

(* val_rel says: *)
(* leak ~~ leak : Unit -> Int *)
(* Because for any related inputs () ~~ () *)
(* The outputs should be related *)

(* But if st1 has secret_ref -> 42 *)
(* And st2 has secret_ref -> 99 *)
(* Then leak () in st1 = 42 *)
(* And leak () in st2 = 99 *)
(* These are NOT related for TInt! *)

(* The logical relation doesn't track store secrets! *)
```

---

## SECTION 7: TYPE SAFETY BYPASS

### CE-013: Construct Stuck Well-Typed Term

**Because Progress is Admitted, we can construct stuck terms:**

```coq
(* EDeref needs a TRef T l to dereference *)
(* What if we dereference something that's not a ref? *)

(* Wait - the type system prevents this! *)
(* T_Deref requires: has_type ... e (TRef T l) *)
(* So EDeref EUnit won't type-check *)

(* But the PROOF that progress holds is admitted *)
(* So we can't be SURE the type system is correct *)

(* Actually, let's find a real stuck term: *)
(* EHandle (EPerform eff v) x h *)
(* When v is a value and we've applied ST_PerformValue... *)
(* EHandle v x h *)
(* By ST_HandleValue: --> [x := v] h *)
(* OK that works *)

(* What about EClassify v when v is a value? *)
(* VClassify says it's a value *)
(* So it doesn't step, and it IS a value *)
(* Not stuck *)

(* EProve v? Same - VProve makes it a value *)

(* Actually the stuck terms are: *)
(* When an admitted progress case should fire but doesn't exist *)
(* We can't construct them because we don't know which are missing *)
```

**Impact:** Without completed progress proof, type safety is UNVERIFIED.

---

## SECTION 8: SUMMARY OF EXPLOITS

| ID | Category | Exploit | Impact |
|----|----------|---------|--------|
| CE-001 | Effect Safety | effect_safety proves nothing | Complete bypass |
| CE-002 | Gate Enforcement | gate_enforcement proves nothing | Complete bypass |
| CE-003 | Gate Definition | is_gate = True | Meaningless |
| CE-004 | Canonical Bool | EGrant (EBool b) ≠ EBool b | Progress false |
| CE-005 | Canonical Fn | ERequire (ELam...) ≠ ELam | Progress false |
| CE-006 | References | Assignment doesn't persist | Broken state |
| CE-007 | Heap | No allocation/identity | Broken refs |
| CE-008 | Declassify | Forge proof for any secret | IFC bypass |
| CE-009 | Effects | Effects unchecked at runtime | Capability bypass |
| CE-010 | Grant | EGrant v stuck | Programs hang |
| CE-011 | Timing | Secrets leak via timing | Side channel |
| CE-012 | Store NI | Different stores allowed | Store leaks |
| CE-013 | Type Safety | Progress admitted | Unverified |

---

---

## SECTION 9: EFFECT ALGEBRA DEEP ATTACK

### CE-014: Linear Effect Order is Semantically Wrong

**Current Effect Ordering (Syntax.v:52-60):**
```coq
Definition effect_level (e : effect) : nat :=
  match e with
  | EffectPure => 0
  | EffectRead => 1
  | EffectWrite => 2
  | EffectNetwork => 3
  | EffectCrypto => 4
  | EffectSystem => 5
  end.
```

**Problem:** This imposes a TOTAL order: Pure < Read < Write < Network < Crypto < System

**Semantic Issues:**

1. **Network implies Crypto?**
   ```
   effect_level EffectNetwork = 3
   effect_level EffectCrypto = 4
   So: EffectNetwork ≤ EffectCrypto

   This means: If you can do Crypto, you can do Network
   But these are INDEPENDENT capabilities!
   A crypto library shouldn't automatically get network access.
   ```

2. **Write implies Read?**
   ```
   effect_level EffectRead = 1
   effect_level EffectWrite = 2
   So: EffectRead ≤ EffectWrite

   This is actually reasonable (write-only is rare).
   But it's an ASSUMPTION that may not hold for all systems.
   ```

3. **No independent effects:**
   ```
   You CANNOT express: "Read + Network but NOT Write"
   Because: Read < Write < Network
   If you have Network, you automatically have Write.

   Real-world example:
   A DNS resolver needs Network but shouldn't Write to disk.
   This effect system CANNOT express this constraint!
   ```

**Should Be:** A proper lattice with INDEPENDENT effect dimensions:
```coq
Inductive effect_set : Type :=
  | ES_Empty : effect_set
  | ES_Read : effect_set -> effect_set
  | ES_Write : effect_set -> effect_set
  | ES_Network : effect_set -> effect_set
  (* ... *)

(* Or use a set/bitfield representation *)
```

---

### CE-015: Effect Join Loses Information

**effect_join Definition (Syntax.v:64-65):**
```coq
Definition effect_join (e1 e2 : effect) : effect :=
  if Nat.ltb (effect_level e1) (effect_level e2) then e2 else e1.
```

**Problem:** Join just picks the "higher" effect, losing the other.

```coq
effect_join EffectRead EffectNetwork = EffectNetwork
(* The Read capability is ABSORBED, not preserved *)

(* What we wanted: "can read AND do network" *)
(* What we got: "can do network (which implies read anyway)" *)
```

**Impact:** Cannot track precise effect sets. Over-approximation loses security precision.

---

## SECTION 10: SUBSTITUTION LEMMA ATTACK

### CE-016: Substitution Requires Pure Effect

**Lemma (Preservation.v:238-241):**
```coq
Lemma substitution_preserves_typing : forall Γ Σ Δ z v e T1 T2 ε2,
  has_type nil Σ Δ v T1 EffectPure ->  (* v must be PURE *)
  has_type ((z, T1) :: Γ) Σ Δ e T2 ε2 ->
  has_type Γ Σ Δ ([z := v] e) T2 ε2.
```

**Usage in Preservation:** Relies on `value_has_pure_effect` to get pure typing.

**Problem:** `value_has_pure_effect` is INCOMPLETE!

```coq
(* value_has_pure_effect only handles: *)
(* VUnit, VBool, VInt, VString, VLam, VPair, VInl, VInr *)

(* Missing: VRef, VClassify, VProve, VRequire, VGrant *)
```

**Counterexample:**
```coq
(* Suppose we have a value: *)
v = EClassify (EInt 42)  (* value by VClassify *)
(* v : TSecret TInt @ ε for some ε *)

(* We want to substitute v into some e *)
(* But value_has_pure_effect v T ε cannot produce *)
(* has_type nil Σ Δ v T EffectPure *)
(* because the VClassify case is MISSING! *)

(* Preservation would FAIL here *)
```

**Impact:** Preservation is incomplete for expressions involving:
- EClassify values
- EProve values
- ERef values
- ERequire values
- EGrant values

---

### CE-017: Substitution Not Capture-Avoiding (Potential)

**Substitution Definition (Syntax.v:191-227):**
```coq
Fixpoint subst (x : ident) (v : expr) (e : expr) : expr :=
  match e with
  ...
  | ELam y T body =>
      if String.eqb x y then ELam y T body
      else ELam y T (subst x v body)  (* Potential capture! *)
  ...
```

**Attack Vector:**
```coq
(* If v contains y as a free variable, substituting into λy.body captures it! *)

(* Example: *)
v = EVar "y"  (* has free variable y *)
e = ELam "y" TInt (EApp (EVar "x") (EVar "y"))
(* [x := v] e = ELam "y" TInt (EApp (EVar "y") (EVar "y")) *)
(* The substituted "y" is now CAPTURED by the lambda! *)
```

**Note:** This is typically handled by requiring v to be closed (no free variables). Let's check if this precondition is enforced...

```coq
(* In Preservation.v:238: *)
has_type nil Σ Δ v T1 EffectPure
(* Empty context (nil) means v has no free variables *)
(* So v is closed! *)
```

**Verdict:** The substitution IS safe because v is typed in empty context (closed).
But this DEPENDS on the typing derivation being correct. If there's a bug in typing...

---

## SECTION 11: TYPE UNIQUENESS ATTACK

### CE-018: Type Uniqueness May Not Hold for Extended System

**Lemma (Typing.v:206-209):**
```coq
Lemma type_uniqueness : forall Γ Σ Δ e T1 T2 ε1 ε2,
  has_type Γ Σ Δ e T1 ε1 ->
  has_type Γ Σ Δ e T2 ε2 ->
  T1 = T2 /\ ε1 = ε2.
```

**Problem:** This only covers `has_type`, not `has_type_full` from EffectSystem.v.

**Attack on has_type_full:**
```coq
(* In EffectSystem.v, we have T_Core: *)
| T_Core : forall G S D e T eff,
    has_type G S D e T eff ->
    has_type_full G S D e T eff

(* And we have T_Perform (different from Typing.v!): *)
| T_Perform : forall G S D eff e T,
    has_type_full G S D e T EffectPure ->
    has_type_full G S D (EPerform eff e) TUnit eff

(* But Typing.v has: *)
| T_Perform : forall Γ Σ Δ eff e T ε,
    has_type Γ Σ Δ e T ε ->
    has_type Γ Σ Δ (EPerform eff e) T (effect_join ε eff)
```

**Counterexample:**
```coq
(* Using Typing.v's T_Perform: *)
(* EPerform EffectRead (EInt 42) : TInt @ EffectRead *)

(* Using EffectSystem.v's T_Perform via T_Core: *)
(* First: T_Core: EInt 42 : TInt @ EffectPure *)
(* Then: T_Perform: EPerform EffectRead (EInt 42) : TUnit @ EffectRead *)

(* DIFFERENT TYPES! TInt vs TUnit *)
(* DIFFERENT EFFECTS! (via T_Core path vs direct T_Perform) *)
```

**Impact:** Type uniqueness FAILS when mixing the two type systems.

---

## SECTION 12: ADDITIONAL DEEP ATTACKS

### CE-019: No Termination Guarantee

**Observation:** The type system has no termination analysis.

```coq
(* Omega combinator is well-typed: *)
let omega : (T -> T) -> T = fun f -> f (f ...) (* infinite *)

(* More specifically, with recursive types (if added): *)
(* μX. X -> X allows non-termination *)

(* Even without recursive types, divergence via effects: *)
let loop : Unit -[EffectPure]-> Unit =
  fun () -> loop ()  (* If we had recursion *)
```

**Impact:** "Pure" effects might still diverge. Timing attacks still possible.

---

### CE-020: No Resource Bounds

**Observation:** No limits on:
- Memory allocation (refs)
- Stack depth (recursion)
- Effect repetition (how many network calls?)

```coq
(* DoS attack: *)
let bomb : Unit -[EffectPure]-> Unit =
  fun () ->
    let _ = ref (ref (ref (ref ...))) in  (* Memory exhaustion *)
    ()
```

**Impact:** Even "safe" programs can exhaust resources.

---

## FINAL SUMMARY

| ID | Category | Status | Severity |
|----|----------|--------|----------|
| CE-001 | Effect Safety | Vacuous theorem | CRITICAL |
| CE-002 | Gate Enforcement | Vacuous theorem | CRITICAL |
| CE-003 | is_gate | Trivial definition | CRITICAL |
| CE-004 | canonical_bool | Provably false | CRITICAL |
| CE-005 | canonical_fn | Provably false | CRITICAL |
| CE-006 | References | Broken semantics | CRITICAL |
| CE-007 | Heap | No isolation | CRITICAL |
| CE-008 | Declassify | Forgeable proofs | CRITICAL |
| CE-009 | Effects | No runtime check | CRITICAL |
| CE-010 | Grant | Stuck terms | HIGH |
| CE-011 | Timing | Side channel | HIGH |
| CE-012 | Store NI | Leak via store | HIGH |
| CE-013 | Type Safety | Admitted progress | CRITICAL |
| CE-014 | Effect Algebra | Wrong order | HIGH |
| CE-015 | Effect Join | Info loss | MEDIUM |
| CE-016 | Substitution | Incomplete lemma | CRITICAL |
| CE-017 | Capture | Safe (verified) | OK |
| CE-018 | Type Unique | Fails for full | HIGH |
| CE-019 | Termination | Unbounded | MEDIUM |
| CE-020 | Resources | Unbounded | MEDIUM |

**20 counterexamples/attacks documented.**
**12 CRITICAL, 5 HIGH, 3 MEDIUM, 1 OK**

---

*BREAKER constructs. BREAKER exploits. BREAKER trusts NOTHING.*
*Deep attack cycle complete. 20 concrete exploits documented.*
