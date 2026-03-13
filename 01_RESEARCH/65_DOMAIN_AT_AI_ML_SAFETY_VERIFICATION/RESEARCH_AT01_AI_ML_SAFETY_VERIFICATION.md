# AT-01: AI/ML Safety Verification — Formal Guarantees for Neural Network Usage

**Domain:** AT — AI/ML Safety Verification
**Status:** Research Complete
**Date:** 2026-03-13
**RIINA Feature Target:** ML inference effect type, model capability tokens, input domain enforcement, output contract verification

---

## 1. Problem Statement

AI/ML models are increasingly deployed in safety-critical systems (autonomous vehicles, medical diagnosis, financial trading). But neural networks are opaque — their behavior on adversarial or out-of-distribution inputs is unpredictable.

RIINA cannot verify the neural network itself (that requires NN-specific tools). But RIINA **can** verify:
- **How ML models are used** in programs (correct API discipline)
- **Input domain membership** (inputs are within the certified region)
- **Output handling** (downstream code handles all possible outputs correctly)
- **Model confidentiality** (training data doesn't leak via IFC)
- **Non-determinism tracking** (stochastic inference is explicitly typed)

---

## 2. State of the Art

### 2.1 Alpha-Beta-CROWN (5-Time VNN-COMP Champion, 2021-2025)

Alpha-beta-CROWN is the state-of-the-art complete neural network verifier:

- **CROWN** (NeurIPS 2018): Linear bound propagation — propagates linear relaxations backward through the network
- **α-CROWN**: Gradient-optimized bounds using learnable α parameters per neuron
- **β-CROWN** (NeurIPS 2021): Branch-and-bound where ReLU split constraints are encoded as optimizable β parameters, eliminating expensive LP solver calls. Up to **3 orders of magnitude** speedup over LP-based methods.
- **GenBaB**: Branch-and-bound for general nonlinear activations beyond ReLU
- **GCP-CROWN / BICCOS**: Cutting plane methods for tighter bounds

**Supported properties:**
- L∞/L2/L1 perturbation robustness
- Lyapunov stability for neural network controllers
- Custom linear output constraints (VNNLIB format)

**Supported architectures:** Feedforward, convolutional, residual, transformer (attention), LSTM, irregular graph structures.

### 2.2 ERAN (ETH Zurich SRI Lab)

ERAN uses **abstract interpretation** for sound, precise, and scalable NN verification:

| Abstract Domain | Venue | Contribution |
|----------------|-------|-------------|
| **DeepZ** | NeurIPS 2018 | Zonotope transformers for ReLU/Sigmoid/Tanh |
| **DeepPoly** | POPL 2019 | Polyhedra + interval arithmetic — most cited abstract interpretation approach |
| **GPUPoly** | MLSys 2021 | GPU-accelerated DeepPoly |
| **PRIMA** | POPL 2022 | Multi-neuron convex relaxations (tighter than per-neuron) |

Handles MNIST, CIFAR-10, ACAS Xu benchmarks. **ACAS Xu** (Airborne Collision Avoidance System for unmanned aircraft) is the canonical safety-critical NN verification benchmark from the FAA.

### 2.3 VNN-COMP (International Verification of Neural Networks Competition)

Annual competition standardizing:
- **VNNLIB** property format (first-order constraints on network inputs/outputs)
- **ONNX** network format (standard neural network exchange format)
- Objective comparison of verification tools across categories:
  - Robustness benchmarks (MNIST, CIFAR-10)
  - Control system safety (Dubins Rejoin, ACAS Xu)
  - Complex architectures (transformers, ViT)

Alpha-beta-CROWN has won every year since the competition's inception (2021-2025).

### 2.4 Certified Training

Certified (provably robust) training incorporates the verifier's bound propagation into the training objective:

- **IBP** (Interval Bound Propagation): Simplest certified training method
- **CROWN-IBP**: Combines CROWN bounds with IBP for tighter training
- **SABR** (Smooth Adversarial Boundary Regions): State-of-art certified training

Result: networks with **verified robustness certificates**, not just empirical adversarial robustness. A certified-trained MNIST classifier can provably resist any L∞ perturbation of ε=0.3 on 90%+ of test images.

### 2.5 Formal Specification of ML Safety Properties

Beyond robustness, ML safety properties that have been formally addressed:

| Property | Formal Statement | Verification Method |
|----------|-----------------|---------------------|
| **Local robustness** | ∀x' ∈ B(x,ε): f(x') = f(x) | CROWN, MILP, abstract interpretation |
| **Lyapunov stability** | ∀x: V(f(x)) < V(x) for neural controller | α-β-CROWN + Lyapunov function search |
| **Fairness** | ∀x: change in protected attribute → no change in output | Constraint encoding in VNNLIB |
| **Monotonicity** | ∂f/∂xᵢ ≥ 0 for specified dimensions | Bound propagation on Jacobian |
| **Lipschitz bound** | ‖f(x)-f(y)‖ ≤ L·‖x-y‖ | SDP relaxation / LipSDP |

### 2.6 Neural Network Verification Complexity

The core verification problem: given network `f: Rⁿ → Rᵐ` and input spec `φ(x)`, prove `∀x. φ(x) → ψ(f(x))`.

For ReLU networks, this is equivalent to MILP — **NP-complete** in general. But tractable for small-to-medium networks via:
- Branch-and-bound with bound propagation (α-β-CROWN)
- Abstract interpretation over-approximation (ERAN)
- SMT-based case splitting (Marabou, Reluplex)

Comprehensive educational reference: "Introduction to Neural Network Verification" (Albarghouthi, arXiv:2109.10317).

---

## 3. What RIINA Can Enforce About ML Model Usage

### 3.1 The Language Enforcement Layer

RIINA is not trying to verify the neural network. It is ensuring that ML models are **used in compliance with their verified specifications.**

| Enforcement | RIINA Mechanism | What It Prevents |
|-------------|----------------|------------------|
| **ML calls are explicit** | `Infer` effect type | Hidden/unaudited ML inference |
| **Inputs are in certified region** | Dependent type / range check | Out-of-distribution inference |
| **Outputs handled correctly** | Exhaustive pattern matching | Missing edge case handling |
| **Model confidentiality** | IFC `Rahsia<Model>` label | Training data leakage |
| **Model access controlled** | Capability token `ModelCap` | Unauthorized model usage |
| **Non-determinism tracked** | `Rawak` (Random) effect | Stochastic inference in deterministic context |
| **Verification certificate required** | Type-level proof obligation | Using unverified models in safety-critical code |

---

## 4. RIINA Integration Architecture

### 4.1 ML Model Capability Type

```
// A verified ML model carries its specification
jenis ModelSahkan<Alg, Input, Output, Sifat> = struct {
    model: ModelData<Alg>,           // ONNX model bytes
    sijil: SijilPengesahan<Sifat>,   // Verification certificate
    domain: DomainInput<Input>,      // Certified input region
}

// Verification certificate: proof artifact from alpha-beta-CROWN or ERAN
jenis SijilPengesahan<S> = struct {
    alat_pengesah: Teks,       // "alpha-beta-crown-v4.0"
    sifat: S,                  // Property verified (e.g., L∞ robustness ε=0.3)
    keputusan: KeputusanSahkan, // Verified / Falsified / Timeout
    tarikh: Masa,              // When verified
}
```

### 4.2 Inference Effect Type

```
kesan Inferens    // ML inference — explicit, auditable

// Inference requires model capability + input domain proof
fungsi inferens<A, I, O, S>(
    model: &ModelSahkan<A, I, O, S>,
    input: I,
    bukti: DalamDomain<I, model.domain>  // Proof that input is in certified region
) -> O kesan Inferens {
    // Calls ONNX runtime / TFLite at FFI boundary
    // IFC: model data stays Rahsia if marked
    // Effect: Inferens is tracked and auditable
}
```

### 4.3 Input Domain Enforcement

```
// Domain specification matching VNNLIB format
jenis DomainInput<T> = enum {
    LInfBall { pusat: T, epsilon: F64 },     // L∞ perturbation ball
    L2Ball { pusat: T, epsilon: F64 },        // L2 perturbation ball
    BoxConstraint { min: T, max: T },          // Per-dimension bounds
    Custom { predikat: fn(T) -> Bool },        // Custom predicate
}

// Compile-time proof that input is within domain
fungsi sahkan_domain<T>(input: T, domain: DomainInput<T>) -> Pilihan<DalamDomain<T>>
    kesan Bersih
{
    padanan domain {
        LInfBall { pusat, epsilon } => {
            jika jarak_linf(input, pusat) <= epsilon {
                pulang Ada(DalamDomain::new(input));
            }
            pulang Tiada;
        }
        // ... other cases
    }
}
```

### 4.4 Output Contract Enforcement

```
// ACAS Xu example: collision avoidance advisory
jenis NasihatACAS = enum {
    ClearOfConflict,
    WeakLeft,
    StrongLeft,
    WeakRight,
    StrongRight,
}

// RIINA enforces exhaustive handling of all advisories
fungsi proses_nasihat(nasihat: NasihatACAS) -> Tindakan kesan Sistem {
    padanan nasihat {
        ClearOfConflict => tiada_tindakan(),
        WeakLeft => belok_kiri(15),
        StrongLeft => belok_kiri(30),
        WeakRight => belok_kanan(15),
        StrongRight => belok_kanan(30),
        // No default case allowed — all variants must be handled
    }
}
```

### 4.5 Non-Determinism Tracking

```
kesan Rawak  // Random/stochastic effect

// Stochastic inference (dropout at runtime, sampling)
fungsi inferens_rawak<A, I, O, S>(
    model: &ModelSahkan<A, I, O, S>,
    input: I,
    bukti: DalamDomain<I, model.domain>
) -> O kesan Inferens + Rawak {
    // Effect: both Inferens and Rawak — caller must handle non-determinism
}

// Deterministic context REJECTS stochastic inference
fungsi kritikal() -> Keputusan kesan Bersih {
    // ERROR: inferens_rawak requires Rawak effect, which is not Bersih
    // Forces developer to use deterministic inference for safety-critical code
}
```

---

## 5. VNNLIB Integration

RIINA's specification language can import VNNLIB-format properties:

```
// Import verification result from external tool
import_sahkan "acas_xu_prop1.vnnlib" sebagai sifat_acas;

// The imported property becomes a type-level constraint
biar model: ModelSahkan<ACASXU, SensorInput, NasihatACAS, sifat_acas> = muat_model("acas_xu.onnx", sijil);
```

This creates a bridge between the NN verification ecosystem (VNN-COMP tools) and RIINA's type system.

---

## 6. Key References

| Reference | Venue | Contribution |
|-----------|-------|-------------|
| Xu et al., "Fast and Complete: Enabling Complete Neural Network Verification with Rapid and Massively Parallel Incomplete Verifiers" | ICLR 2021 | β-CROWN: branch-and-bound with optimizable β parameters |
| Wang et al., "Beta-CROWN: Efficient Bound Propagation with Per-neuron Split Constraints" | NeurIPS 2021 | β-parameter encoding of split constraints |
| Singh et al., "An Abstract Domain for Certifying Neural Networks" | POPL 2019 | DeepPoly abstract interpretation |
| Müller et al., "PRIMA: General and Precise Neural Network Certification via Scalable Convex Hull Approximations" | POPL 2022 | Multi-neuron convex relaxations |
| Albarghouthi, "Introduction to Neural Network Verification" | arXiv:2109.10317 | Comprehensive survey/textbook |
| VNN-COMP | Annual (2021-2025) | Standardized benchmarks, VNNLIB format |
| Katz et al., "Reluplex: An Efficient SMT Solver for Verifying Deep Neural Networks" | CAV 2017 | First practical NN verification via SMT |
| Huang et al., "Safety Verification of Deep Neural Networks" | CAV 2017 | First complete verifier for DNNs |

---

## 7. Formalizability Assessment

| Component | Effort | Feasibility | Phase |
|-----------|--------|-------------|-------|
| `Inferens` effect type in Coq | Low | High | Phase 6 |
| Model capability typing rules | Medium | High (extends capability system) | Phase 6 |
| Input domain membership proof obligation | Medium | High (dependent type or runtime check) | Phase 6 |
| Output contract exhaustiveness | Low | Very High (already exists — pattern matching) | Current |
| IFC for model confidentiality | Low | Very High (already works via Rahsia<T>) | Current |
| VNNLIB property import | High | Medium (requires parser + type-level encoding) | Phase 7 |
| Certified training integration | Very High | Low (research frontier) | Out of scope |

**Bottom line:** RIINA provides a unique value proposition for ML safety. The key insight: RIINA doesn't verify the neural network — it verifies that the program using the neural network respects the network's verified specification. The combination of effect types (explicit inference), capabilities (authorized model access), IFC (model confidentiality), and dependent types (input domain proofs) creates a safety envelope around ML model usage that no other language provides.
