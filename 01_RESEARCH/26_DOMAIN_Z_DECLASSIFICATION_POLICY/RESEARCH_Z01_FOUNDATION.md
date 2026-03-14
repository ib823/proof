# Z-01: Declassification Policy Language — Intentional Leaks, PROVEN Safe

**Domain:** Z — Declassification Policy Language
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Principal-based authorization, guard predicates, quantitative information budgets, robust declassification

---

## 1. Problem Statement

Non-interference — the property that secret inputs cannot influence public outputs — is the gold standard for information flow security. However, strict non-interference forbids ALL useful programs that process secrets: password checking must reveal "correct" or "incorrect" (1 bit of information about the password), encryption produces ciphertext derived from plaintext, statistical queries aggregate individual records into public summaries, and error messages may contain sensitive context.

Without controlled declassification, non-interference is too restrictive for practical use. But uncontrolled declassification (arbitrary `declassify` operations) opens the floodgates — an attacker who controls when declassification happens can leak arbitrary secrets bit by bit. RIINA's current `EDeclassify` construct requires a syntactic `declass_ok` proof, but this does not express WHO is authorized, WHAT data can be released, WHEN release is permitted, or HOW MUCH information can leak.

Domain Z defines a principled declassification policy language that makes intentional information releases explicit, authorized, auditable, and bounded, while proving that no more information is released than the policy permits.

## 2. State of the Art

### 2.1 Dimensions of Declassification

Sabelfeld and Sands systematized declassification into four dimensions: WHAT information is released, WHO authorizes the release, WHERE in the program the release occurs, and WHEN the release happens. Each dimension has its own formal treatment and enforcement mechanism. This taxonomy provides the foundation for principled declassification, showing that different applications need different combinations of these dimensions.

Sabelfeld, A., Sands, D., "Dimensions and Principles of Declassification", *Journal of Computer Security*, 17(5):517-548, 2009.

### 2.2 Robust Declassification

Myers, Sabelfeld, and Zdancewic introduced robust declassification: the requirement that an attacker cannot influence WHAT gets declassified. Formally, the set of declassified values must be the same regardless of the attacker's actions. This prevents "laundering" attacks where an attacker tricks the system into declassifying more information than intended. Robust declassification has become the standard security condition for practical information flow systems.

Zdancewic, S., Myers, A. C., "Robust Declassification", *CSF*, 2001.

Myers, A. C., Sabelfeld, A., Zdancewic, S., "Enforcing Robust Declassification and Qualified Robustness", *Journal of Computer Security*, 14(2):157-196, 2006.

### 2.3 Jif: Java Information Flow

Jif (Java + Information Flow) is a security-typed programming language that extends Java with labels that track information flow. Jif supports declassification with the `declassify` construct, controlled by a decentralized label model where principals own and control the confidentiality of data. Jif has been used to build practical security-critical applications including a voting system (Civitas) and a secure email client.

Myers, A. C., "JFlow: Practical Mostly-Static Information Flow Control", *POPL*, 1999.

Chong, S., Myers, A. C., "Decentralized Robustness", *CSF*, 2006.

### 2.4 Differential Privacy

Differential privacy, introduced by Dwork et al., provides a mathematical framework for releasing statistical information about a dataset while protecting individual records. A mechanism is ε-differentially private if the presence or absence of any single record changes the output distribution by at most a factor of e^ε. Differential privacy provides a formal budget that bounds cumulative information leakage across multiple queries.

Dwork, C., McSherry, F., Nissim, K., Smith, A., "Calibrating Noise to Sensitivity in Private Data Analysis", *TCC*, 2006.

Dwork, C., Roth, A., "The Algorithmic Foundations of Differential Privacy", *Foundations and Trends in Theoretical Computer Science*, 9(3-4):211-407, 2014.

### 2.5 Quantitative Information Flow

Quantitative information flow (QIF) measures the amount of information leaked by a program in bits, using information-theoretic quantities (Shannon entropy, min-entropy, Rényi entropy). QIF provides more nuanced analysis than non-interference (which is binary: leaks or doesn't leak) by quantifying HOW MUCH is leaked. Smith showed that min-entropy leakage captures the adversary's optimal guessing advantage.

Smith, G., "On the Foundations of Quantitative Information Flow", *FoSSaCS*, 2009.

Alvim, M. S., Chatzikokolakis, K., McIver, A., Morgan, C., Palamidessi, C., Smith, G., "The Science of Quantitative Information Flow", Springer, 2020.

### 2.6 FlowCaml: Information Flow for ML

FlowCaml is an extension of OCaml with an information flow type system based on the decentralized label model. FlowCaml supports polymorphic labels, subtyping, and controlled declassification. It demonstrated that information flow type systems can be integrated into practical functional programming languages with minimal annotation burden.

Simonet, V., "The Flow Caml System: Documentation and User's Manual", INRIA Technical Report, 2003.

### 2.7 Language-Based Information Flow Security

Sabelfeld and Myers' comprehensive survey established the field of language-based information flow security, covering non-interference, declassification, covert channels, and enforcement mechanisms. The survey identified key challenges including implicit flows (via control flow), termination channels, timing channels, and the tension between security and functionality.

Sabelfeld, A., Myers, A. C., "Language-Based Information-Flow Security", *IEEE Journal on Selected Areas in Communications*, 21(1):5-19, 2003.

### 2.8 Gradual Release and Delimited Release

Askarov and Sabelfeld introduced gradual release, which ensures that secrets are released only as explicitly permitted by declassification operations. Delimited release (Sabelfeld and Myers) restricts what information is released by specifying an "escape hatch" expression whose value is the only information allowed to flow to low-security outputs. These properties provide compositional reasoning about declassification.

Askarov, A., Sabelfeld, A., "Gradual Release: Unifying Declassification, Encryption, and Key Release Policies", *IEEE S&P*, 2007.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Robust declassification | Public-equivalence of declassified values | Type system checks guard conditions are low-security |
| Bounded information leakage | Quantitative information flow budget | Budget annotations track cumulative bits released |
| Principal authorization | Decentralized label model | `declass_ok` requires authorized principal proof |
| Guard correctness | Public guard predicate checking | Guards must not depend on secret data |
| Differential privacy | Noise calibration to sensitivity | Built-in DP mechanisms with proven ε bounds |
| Audit completeness | Declassification logging | Every `EDeclassify` operation logged with WHO/WHAT/WHEN |
| Non-circumvention | Type system enforcement | Secret data can only become public via `EDeclassify` |

## 4. RIINA Integration Architecture

### 4.1 Policy Language

```riina
// Declassification policy definition
polisi semak_kata_laluan {
    prinsipal: PerkhidmatanPengesahan,
    apa: bool,  // Only accept/reject
    bila: percubaan_dalam_tetingkap < 5,
    bajet: 1 bit,
    audit: WAJIB,
}

// Usage in code
fungsi semak(kata_laluan: Rahsia<Teks>, hash: Hash) -> Bool
    kesan Bersih
    polisi semak_kata_laluan
{
    biar hasil = hash_sama(kata_laluan, hash);
    pulang nyahrahsia(hasil, semak_kata_laluan);
    // Declassifies 1 bit (accept/reject) under policy
}
```

### 4.2 Budget Tracking

```riina
// Differential privacy policy
polisi analitik_perubatan {
    prinsipal: PenganalisisPenyelidikan,
    apa: Agregat<RekodPesakit>,
    bila: saiz_kohort >= 100,  // K-anonymity
    bajet: (1.0, 1e-5)-privasi_berbeza,
    audit: WAJIB,
}
```

### 4.3 Coq Formalization

```coq
(* Robust declassification *)
Theorem robust_declass : forall e s1 s2,
  low_equiv s1 s2 ->
  declassified_values e s1 = declassified_values e s2.

(* Budget bounded leakage *)
Theorem budget_bounded : forall prog policies,
  well_typed_declass prog policies ->
  mutual_information (secrets prog) (outputs prog) <=
    sum_budgets policies.

(* Non-circumvention *)
Theorem no_circumvention : forall G e T,
  has_type G e (TSecret T) ->
  flows_to_public e ->
  exists policy, uses_declassify_policy e policy.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Sabelfeld, A., Sands, D., "Dimensions and Principles of Declassification" (2009) | J. Computer Security | Four-dimensional taxonomy |
| Zdancewic, S., Myers, A. C., "Robust Declassification" (2001) | CSF | Attacker-resilient declassification |
| Myers, A. C., "JFlow" (1999) | POPL | Jif practical information flow |
| Dwork, C., et al., "Calibrating Noise to Sensitivity" (2006) | TCC | Differential privacy foundation |
| Smith, G., "On the Foundations of Quantitative Information Flow" (2009) | FoSSaCS | Min-entropy leakage |
| Sabelfeld, A., Myers, A. C., "Language-Based Information-Flow Security" (2003) | IEEE JSAC | Comprehensive survey |
| Askarov, A., Sabelfeld, A., "Gradual Release" (2007) | IEEE S&P | Compositional declassification |
| Dwork, C., Roth, A., "Algorithmic Foundations of Differential Privacy" (2014) | FnTTCS | DP reference text |
| Chong, S., Myers, A. C., "Decentralized Robustness" (2006) | CSF | Decentralized robust declassification |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Policy language syntax and semantics | 3-4 | High — well-understood theory | Phase 1 |
| Principal-based authorization | 2-3 | High — decentralized label model | Phase 1 |
| Robust declassification proof | 3-4 | High — standard formalization | Phase 2 |
| Guard predicate verification | 2-3 | High — public predicate checking | Phase 2 |
| Quantitative budget tracking | 4-6 | Medium — information-theoretic reasoning | Phase 3 |
| Differential privacy integration | 4-6 | Medium — noise calibration proofs | Phase 3 |
| Runtime budget enforcement (Domain U) | 3-4 | Medium — requires runtime support | Phase 4 |
| Audit log verification | 2-3 | High — append-only log proofs | Phase 4 |

## 7. Scope Limitations

1. **Quantitative information flow is undecidable.** Computing the exact mutual information between inputs and outputs is undecidable in general. RIINA uses conservative upper bounds, which may over-estimate leakage and reject safe programs.

2. **Differential privacy noise distortion.** Adding noise for differential privacy degrades data utility. For small datasets or high-sensitivity queries, the noise may overwhelm the signal. The privacy budget (ε) represents a fundamental tradeoff between privacy and utility.

3. **Composability challenges.** While differential privacy composes cleanly (budgets add), other declassification policies may not compose as easily. Two individually safe declassification policies could leak more information when combined than either alone.

4. **Implicit flows and timing channels.** Declassification policies control explicit releases but may not account for implicit information flows through control flow, termination behavior, or timing. A complete solution requires integration with Domain S (constant-time) and Domain V (termination).

5. **Policy specification burden.** Writing correct declassification policies requires understanding information theory and the specific security requirements. Incorrect policies (e.g., overly generous budgets) produce formally verified but insecure systems.

6. **No retroactive policy changes.** Once information has been declassified under a policy, it cannot be "re-classified." Policy changes only apply to future declassifications. This makes policy design a critical up-front decision.

---

*"Declassification is not a loophole. Declassification is a POLICY, and policies are PROVEN."*
