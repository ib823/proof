# NU-01: Verified AI/ML — Formal Guarantees for Machine Learning Systems

**Domain:** NU (ν) — Verified AI/ML
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Verified inference pipelines, certified adversarial robustness, fairness constraint enforcement, model safety properties, verified training loop invariants, abstract interpretation for neural networks, numeric stability guarantees

---

## 1. Problem Statement

Machine learning systems are increasingly deployed in safety-critical contexts — autonomous vehicles, medical diagnosis, criminal sentencing, financial trading, and military target identification — yet they remain among the least formally verified software artifacts in production. A neural network is, at its core, a composition of linear algebra and nonlinear activations: a mathematical function with billions of parameters whose behavior can be analyzed, bounded, and in restricted cases, formally verified. The discovery of adversarial examples by Szegedy et al. in 2014 demonstrated that imperceptible input perturbations can cause catastrophic misclassification, shattering the assumption that high test accuracy implies reliable deployment behavior.

The verification challenge for neural networks is fundamentally one of scale and nonlinearity. A network with n neurons and ReLU activations defines a piecewise linear function with up to 2^n linear regions, making exact verification NP-complete in general. However, practical progress has been dramatic: tools like Reluplex, ERAN, and alpha-beta-CROWN can verify properties of networks with hundreds of thousands of neurons by combining abstract interpretation, SMT solving, and branch-and-bound techniques. Certified training approaches such as randomized smoothing and interval bound propagation produce models with provable robustness guarantees, trading accuracy for formal assurance.

RIINA's contribution to verified AI/ML is not to reimagine neural network architectures, but to provide a formally verified language for expressing and enforcing ML pipeline invariants. Through RIINA's type system, a neural network inference function can carry type-level guarantees about input preprocessing bounds, output probability normalization, numerical stability of floating-point operations, and fairness constraints on protected attributes. The effect system tracks side effects of model loading, GPU computation, and randomness, ensuring that verified inference pipelines cannot silently degrade.

## 2. State of the Art

### 2.1 Adversarial Examples and Robustness

Szegedy et al. first demonstrated that deep neural networks are vulnerable to adversarial examples: inputs crafted by adding small, human-imperceptible perturbations that cause the network to misclassify with high confidence. This finding spawned an arms race between attack methods (FGSM, PGD, C&W) and empirical defenses, most of which were subsequently broken. The phenomenon is not merely an artifact of particular architectures but appears to be an inherent property of high-dimensional classifiers operating in regimes where the decision boundary is close to the data manifold. Goodfellow et al. provided a linear explanation for adversarial vulnerability, showing that even linear models are susceptible in high dimensions.

> Szegedy, C., Zaremba, W., Sutskever, I., Bruna, J., Erhan, D., Goodfellow, I., and Fergus, R. "Intriguing Properties of Neural Networks." *Proceedings of the 2nd International Conference on Learning Representations (ICLR)*, 2014.

### 2.2 SMT-Based Neural Network Verification (Reluplex)

Katz et al. introduced Reluplex, the first practical SMT-based approach to verifying properties of deep neural networks with ReLU activations. Reluplex extends the simplex method with lazy ReLU constraint handling, enabling verification of properties such as "no input within an epsilon-ball of a given point is classified differently." While Reluplex's scalability was initially limited to networks with hundreds of neurons, the subsequent Marabou framework extended the approach with split-and-conquer strategies, support for additional activation functions, and integration with abstract interpretation for bound tightening. This line of work established that neural network verification, while NP-complete in general, is practically tractable for safety-critical networks of moderate size.

> Katz, G., Barrett, C., Dill, D.L., Julian, K., and Kochenderfer, M.J. "Reluplex: An Efficient SMT Solver for Verifying Deep Neural Networks." *Proceedings of the 29th International Conference on Computer Aided Verification (CAV)*, pp. 97-117, 2017.

### 2.3 Abstract Interpretation for Deep Neural Networks (ERAN)

Singh et al. developed the ETH Robustness Analyzer for Neural Networks (ERAN), which applies abstract interpretation — a framework originally developed by Cousot and Cousot for program analysis — to neural networks. ERAN uses abstract domains such as DeepPoly and DeepZono to compute sound over-approximations of the set of possible outputs for a given set of inputs, enabling efficient certification of local robustness. The key insight is that abstract interpretation trades precision for scalability: while it may fail to certify some robust inputs (incompleteness), it never falsely certifies a non-robust input (soundness). ERAN has been scaled to verify properties of networks with over 100,000 neurons.

> Singh, G., Gehr, T., Puschel, M., and Vechev, M. "An Abstract Domain for Certifying Neural Networks." *Proceedings of the ACM on Programming Languages (POPL)*, 3:41:1-41:30, 2019.

### 2.4 Certified Robustness via Randomized Smoothing

Cohen, Rosenfeld, and Kolter introduced randomized smoothing as a scalable approach to certified robustness that is agnostic to the base classifier architecture. The key idea is to construct a "smoothed classifier" by averaging the predictions of a base classifier over Gaussian perturbations of the input, then deriving a certified L2 radius within which the smoothed classifier's prediction is guaranteed not to change. This approach scales to ImageNet-scale models, providing the first certified robustness guarantees for large networks. The theoretical foundation rests on the Neyman-Pearson lemma, connecting certified robustness to hypothesis testing.

> Cohen, J., Rosenfeld, E., and Kolter, J.Z. "Certified Adversarial Robustness via Randomized Smoothing." *Proceedings of the 36th International Conference on Machine Learning (ICML)*, pp. 1310-1320, 2019.

### 2.5 Safety Verification of Deep Neural Networks

Huang et al. developed one of the first systematic approaches to safety verification of deep neural networks, formulating verification as a layer-by-layer search problem. Their framework defines safety in terms of a region around each input within which the classification must remain constant, and uses discretization and SMT solving to verify or find counterexamples. This work was among the first to frame neural network verification as a formal verification problem amenable to techniques from the programming languages and software verification communities, bridging the gap between the ML and formal methods communities.

> Huang, X., Kwiatkowska, M., Wang, S., and Wu, M. "Safety Verification of Deep Neural Networks." *Proceedings of the 29th International Conference on Computer Aided Verification (CAV)*, pp. 3-29, 2017.

### 2.6 Provably Robust Deep Learning via Convex Relaxations

Wong and Kolter proposed training neural networks with provable robustness guarantees by incorporating verification bounds directly into the training objective. Their approach uses convex relaxations of the ReLU activation to compute an upper bound on the worst-case loss over all inputs within an epsilon-ball, then minimizes this bound during training. The resulting networks have certified robustness guarantees by construction, eliminating the need for post-hoc verification. This "verified training" paradigm represents a shift from verifying existing models to training models that are designed to be verifiable.

> Wong, E. and Kolter, J.Z. "Provable Defenses against Adversarial Examples via the Convex Outer Adversarial Polytope." *Proceedings of the 35th International Conference on Machine Learning (ICML)*, pp. 5286-5295, 2018.

### 2.7 Fairness Verification and Algorithmic Bias

Algorithmic fairness requires that ML models do not discriminate based on protected attributes such as race, gender, or age. Formal definitions of fairness (demographic parity, equalized odds, individual fairness) can be expressed as mathematical properties of the classifier, enabling formal verification approaches. Bastani et al. developed methods for verifying individual fairness using abstract interpretation, while Albarghouthi and Vinitsky applied program analysis techniques to verify group fairness properties. The challenge is that different fairness definitions are mathematically incompatible (the impossibility theorem of Chouldechova and Kleinberg-Mullainathan-Raghavan), requiring explicit choice and formal specification of which fairness properties are guaranteed.

> Galhotra, S., Brun, Y., and Meliou, A. "Fairness Testing: Testing Software for Discrimination." *Proceedings of the 11th Joint Meeting on Foundations of Software Engineering (ESEC/FSE)*, pp. 498-510, 2017.

### 2.8 Verified Numerical Computation

Neural network inference involves extensive floating-point computation, and numerical stability is essential for reproducible and reliable results. Boldo et al. formalized IEEE 754 floating-point arithmetic in Coq, enabling machine-checked proofs of numerical properties. The Flocq library provides a comprehensive Coq formalization of floating-point arithmetic that can be used to verify bounds on rounding errors in neural network computations. For RIINA, this foundational work enables type-level guarantees about numerical precision, ensuring that verified inference produces results within formally bounded error margins.

> Boldo, S. and Melquiond, G. "Flocq: A Unified Library for Proving Floating-Point Algorithms in Coq." *Proceedings of the 20th IEEE Symposium on Computer Arithmetic (ARITH)*, pp. 243-252, 2011.

## 3. Properties Verifiable by RIINA

| Property | Verification Method | RIINA Mechanism |
|----------|-------------------|-----------------|
| Input bound enforcement | Refinement types | `Tensor { t \| norm(t) <= epsilon }` |
| Output probability normalization | Dependent types | Return type constrained to sum to 1.0 |
| Adversarial robustness (local) | Abstract interpretation integration | `#[sahkan_keteguhan(epsilon=0.01)]` annotation |
| Numerical stability | Verified floating-point | `kesan Nombor` effect tracking precision loss |
| Fairness constraints | Type-level demographic constraints | Protected attribute erasure in type system |
| Model integrity | Hash-verified model loading | `kesan MuatModel` with cryptographic attestation |
| Inference determinism | Purity enforcement | `kesan Bersih` for deterministic inference paths |
| Training convergence bounds | Refinement types on loss | `Kerugian { l \| l <= bound }` after n epochs |
| Data pipeline correctness | Session types | Verified preprocessing protocol types |
| Gradient computation correctness | Automatic differentiation verification | Verified AD combinators in type system |

## 4. RIINA Integration Architecture

### 4.1 Verified Inference Pipeline

```riina
// Type-safe neural network inference with verified properties
jenis Tensor<N: Nat, M: Nat> = Matriks(N, M, Apungan64);

jenis ModelDisahkan = {
    berat: Tensor<784, 256>,
    berat2: Tensor<256, 10>,
    bukti_keteguhan: BuktiKeteguhan(epsilon=0.01),
    hash: Hash256
};

// Inference function with formal guarantees
fungsi inferens(
    model: ModelDisahkan,
    input: Tensor<1, 784> { t | setiap_elemen(t, -1.0, 1.0) }
) -> Kebarangkalian<10> kesan Bersih {
    // Return type Kebarangkalian<10> enforces:
    //   - exactly 10 elements
    //   - all non-negative
    //   - sum equals 1.0
    biar h = relu(darab_matriks(input, model.berat));
    biar output = softmax(darab_matriks(h, model.berat2));
    pulang output;
}
```

### 4.2 Fairness-Constrained Classification

```riina
// Attribute-blind classifier: protected attributes cannot influence output
jenis Ciri<T: JenisCiri> = {
    nilai: Apungan64,
    dilindungi: Bool  // marks protected attributes
};

fungsi klasifikasi_adil(
    ciri: Senarai<Ciri<Umum>>,
    model: ModelAdil
) -> Keputusan kesan Bersih {
    // Type system ensures no Ciri with dilindungi=Benar
    // can flow into the classification decision
    biar ciri_ditapis = tapis(ciri, |c| tidak(c.dilindungi));
    pulang model.ramal(ciri_ditapis);
}
```

### 4.3 Coq Formalization of Robustness Property

```coq
(* Neural network robustness formalization *)
Require Import Reals.
Open Scope R_scope.

(* A classifier is a function from R^n to labels *)
Definition classifier (n : nat) (k : nat) := 
  (nat -> R) -> nat.

(* L-infinity ball around a point *)
Definition linf_ball (n : nat) (x : nat -> R) (eps : R) (y : nat -> R) : Prop :=
  forall i, (i < n)%nat -> Rabs (x i - y i) <= eps.

(* Local robustness: classification is constant within epsilon-ball *)
Definition locally_robust (n k : nat) (f : classifier n k) 
  (x : nat -> R) (eps : R) : Prop :=
  forall y, linf_ball n x eps y -> f y = f x.

(* Lipschitz continuity implies robustness for margin classifiers *)
Definition lipschitz (n : nat) (g : (nat -> R) -> R) (L : R) : Prop :=
  forall x y, 
    (forall i, (i < n)%nat -> Rabs (x i - y i) <= 1) ->
    Rabs (g x - g y) <= L.

(* Certified radius from margin and Lipschitz constant *)
Theorem certified_radius :
  forall (n : nat) (g : (nat -> R) -> R) (L : R) (x : nat -> R) (margin : R),
    lipschitz n g L ->
    L > 0 ->
    margin > 0 ->
    g x >= margin ->
    forall y, linf_ball n x (margin / L) y -> g y > 0.
Proof.
  intros n g L x margin Hlip HL Hm Hgx y Hball.
  (* The proof follows from Lipschitz bound on |g(x) - g(y)| *)
  (* and the margin condition g(x) >= margin *)
Admitted. (* Full proof requires real analysis automation *)
```

**Note:** The `Admitted` above is for the research document only. Production Coq code in `02_FORMAL/coq/` must never contain `Admitted`.

## 5. Key References

| # | Reference | Venue | Year | Contribution |
|---|-----------|-------|------|-------------|
| 1 | Szegedy, C. et al. "Intriguing Properties of Neural Networks" | ICLR 2014 | 2014 | Discovery of adversarial examples in DNNs |
| 2 | Katz, G. et al. "Reluplex: An Efficient SMT Solver for Verifying Deep Neural Networks" | CAV 2017 | 2017 | First practical SMT-based neural network verifier |
| 3 | Singh, G. et al. "An Abstract Domain for Certifying Neural Networks" | POPL 2019 | 2019 | Abstract interpretation for scalable DNN certification |
| 4 | Cohen, J., Rosenfeld, E., Kolter, J.Z. "Certified Adversarial Robustness via Randomized Smoothing" | ICML 2019 | 2019 | Architecture-agnostic certified L2 robustness |
| 5 | Huang, X. et al. "Safety Verification of Deep Neural Networks" | CAV 2017 | 2017 | Layer-by-layer safety verification framework |
| 6 | Wong, E., Kolter, J.Z. "Provable Defenses against Adversarial Examples via the Convex Outer Adversarial Polytope" | ICML 2018 | 2018 | Verified training with convex relaxations |
| 7 | Galhotra, S., Brun, Y., Meliou, A. "Fairness Testing: Testing Software for Discrimination" | ESEC/FSE 2017 | 2017 | Systematic fairness testing methodology |
| 8 | Boldo, S., Melquiond, G. "Flocq: A Unified Library for Proving Floating-Point Algorithms in Coq" | ARITH 2011 | 2011 | Coq formalization of floating-point arithmetic |
| 9 | Goodfellow, I., Shlens, J., Szegedy, C. "Explaining and Harnessing Adversarial Examples" | ICLR 2015 | 2015 | Linear explanation of adversarial vulnerability (FGSM) |
| 10 | Tjeng, V., Xiao, K., Tedrake, R. "Evaluating Robustness of Neural Networks: An Extreme Value Theory Approach" | ICLR 2019 | 2019 | MIP-based complete verification of neural networks |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Input bound refinement types | 1.5 | High | Phase 3 |
| Output normalization verification | 1 | High | Phase 3 |
| Lipschitz bound formalization | 3 | Medium | Phase 4 |
| Abstract interpretation integration | 6 | Medium | Phase 5 |
| Floating-point error bounds | 4 | Medium | Phase 4 |
| Fairness property encoding | 2 | Medium | Phase 4 |
| Certified robustness proof extraction | 5 | Low-Medium | Phase 5 |
| Verified training loop invariants | 4 | Low | Phase 6 |
| Model loading integrity | 1.5 | High | Phase 3 |
| End-to-end pipeline verification | 6 | Low | Phase 6+ |
| **Total** | **34** | | |

## 7. Scope Limitations

1. **Verification scalability wall.** Current neural network verification techniques scale to networks with at most hundreds of thousands of neurons. State-of-the-art production models (GPT-scale transformers with billions of parameters) are far beyond the reach of any existing verification approach. RIINA can verify properties of inference pipelines and small safety-critical models, but cannot verify the internal behavior of large foundation models.

2. **Floating-point nondeterminism.** GPU floating-point computation is inherently nondeterministic due to parallel reduction ordering, hardware-specific fused multiply-add behavior, and driver-level optimizations. RIINA can verify properties of a mathematical model of the computation, but the gap between IEEE 754 semantics and actual GPU execution introduces an irreducible trust assumption.

3. **Specification completeness for fairness.** Different mathematical definitions of fairness (demographic parity, equalized odds, individual fairness, counterfactual fairness) are provably incompatible. RIINA can verify that a model satisfies a chosen formal fairness definition, but cannot determine which definition is ethically appropriate for a given application — that remains a human judgment.

4. **Training verification is largely out of scope.** Verifying that a training procedure converges to a model satisfying desired properties requires reasoning about stochastic optimization over non-convex loss landscapes, which is beyond current formal methods capabilities. RIINA can verify properties of trained models but not the training process itself, except for simple invariants.

5. **Adversarial robustness is not safety.** Certified robustness within an epsilon-ball is a necessary but insufficient condition for safe deployment. Real-world distribution shift, out-of-distribution inputs, and novel attack modalities are not captured by local robustness certificates. RIINA's verification provides formal guarantees within explicitly stated threat models, not universal safety.

6. **Abstraction gap in abstract interpretation.** Sound over-approximation inherently introduces imprecision: some inputs that are actually robust will fail to be certified. The trade-off between precision and scalability means that RIINA's robustness certificates may be conservative, potentially rejecting safe deployments.

---

*"An AI that cannot be verified cannot be trusted."*
