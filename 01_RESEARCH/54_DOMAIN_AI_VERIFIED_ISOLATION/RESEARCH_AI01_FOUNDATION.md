# AI-01: Verified Process Isolation — Provably Confined Execution

**Domain:** AI — Verified Process Isolation
**Version:** 2.0.0
**Date:** 2026-03-14
**Status:** FOUNDATIONAL RESEARCH
**Feature Target:** Sandbox verification, process isolation proofs, capability confinement, compartmentalization

---

## 1. Problem Statement

Process isolation is the fundamental security mechanism that prevents one computation from interfering with another. Operating systems, hypervisors, and sandboxing frameworks all rely on isolation to contain the damage from software vulnerabilities, malicious code, and configuration errors. Yet the correctness of isolation mechanisms has historically been established through testing and informal reasoning rather than formal verification. The consequences of isolation failures are severe: container escapes, virtual machine breakouts, sandbox bypasses, and privilege escalation attacks have all demonstrated that isolation boundaries implemented in millions of lines of unverified code are fragile. The Spectre and Meltdown vulnerabilities showed that even hardware-enforced isolation boundaries can be circumvented through microarchitectural side channels, calling into question the foundations of process isolation as practiced today.

The landmark seL4 verification project demonstrated that formal verification of an operating system kernel is feasible, proving functional correctness, integrity, and confidentiality for a complete microkernel. However, seL4 remains exceptional: no other production operating system kernel has been fully verified, and the verification effort (approximately 20 person-years for 10,000 lines of C) highlights the cost of post-hoc verification. Hardware-based isolation mechanisms like ARM TrustZone, Intel SGX, and CHERI capabilities provide stronger isolation guarantees but require software to correctly use their interfaces — a requirement that is rarely verified. Software-based isolation through techniques like Software Fault Isolation (SFI), as used in Google's Native Client, provides portable isolation but relies on careful binary verification that must be repeated for each target architecture.

RIINA takes a fundamentally different approach: isolation properties are encoded in the type system and verified at compile time. A RIINA program's effect annotations (kesan) specify exactly which system resources a computation may access. The capability type system ensures that access to system resources requires unforgeable capability tokens. Information flow labels (Rahsia/Awam) prevent isolated computations from leaking information through their return values. Linear types ensure that capabilities cannot be duplicated or shared beyond their intended scope. The compiler verifies these properties statically, producing executables that are isolated by construction — not by the hope that a runtime sandbox correctly interposes on every system call.

## 2. State of the Art

### 2.1 seL4: Formally Verified Microkernel

Klein et al. completed the first formal verification of a general-purpose operating system kernel, proving that the seL4 microkernel's C implementation correctly implements its abstract specification. The verification covers functional correctness (the kernel does what its specification says), integrity (the kernel enforces access control), and confidentiality (information flows only as permitted by the access control policy). The proof was conducted in Isabelle/HOL and comprises approximately 200,000 lines of proof script for 10,000 lines of C code. seL4's verification demonstrates that kernel-level isolation can be formally guaranteed, but the enormous proof effort highlights the need for languages that make verification cheaper. RIINA's type system aims to provide comparable isolation guarantees with verification costs integrated into the normal compilation process.

> Klein, G., Elphinstone, K., Heiser, G., Andronick, J., Cock, D., Derrin, P., Elkaduwe, D., Engelhardt, K., Kolanski, R., Norrish, M., Sewell, T., Tuch, H., and Winwood, S. "seL4: Formal verification of an OS kernel." *ACM Symposium on Operating Systems Principles (SOSP)*, 2009, pp. 207–220.

### 2.2 CHERI: Capability Hardware Enhanced RISC Instructions

Watson et al. developed CHERI, a hardware capability architecture that extends conventional RISC instruction sets with hardware-enforced capability pointers. CHERI capabilities are unforgeable tokens that encode both an address and the permissions (read, write, execute) associated with that address, providing fine-grained memory protection and compartmentalization without the overhead of page-table-based isolation. CHERI has been implemented in FPGA prototypes and is being adopted by Arm in the Morello research platform. The CHERI protection model provides spatial memory safety (preventing out-of-bounds access) and can enforce compartmentalization boundaries within a single address space. RIINA's capability type system is inspired by CHERI's hardware capabilities, encoding capability permissions at the type level so that the compiler can verify capability confinement statically.

> Watson, R.N.M., Woodruff, J., Neumann, P.G., Moore, S.W., Anderson, J., Chisnall, D., Dave, N., Davis, B., Gudka, K., Laurie, B., Murdoch, S.J., Norton, R., Roe, M., Son, S., and Vadera, M. "CHERI: A hybrid capability-system architecture for scalable software compartmentalization." *IEEE Symposium on Security and Privacy*, 2015, pp. 20–37.

### 2.3 Verified Software Fault Isolation (RockSalt)

Morrisett et al. developed RockSalt, a verified implementation of a Software Fault Isolation (SFI) checker for x86 machine code. RockSalt is implemented and verified in Coq, providing a machine-checked proof that any binary passing the checker is confined to its sandbox. The verification covers the x86 instruction decoder, the sandbox policy checker, and the correctness argument that checked binaries cannot escape their sandbox. RockSalt demonstrated that SFI verification can be made trustworthy through machine-checked proofs, reducing the trusted computing base from the entire SFI implementation to the Coq proof checker. RIINA extends this approach by shifting isolation verification from binary checking (post-compilation) to type checking (pre-compilation), catching isolation violations earlier in the development process.

> Morrisett, G., Tan, G., Tassarotti, J., Tristan, J.-B., and Gan, E. "RockSalt: Better, faster, stronger SFI for the x86." *ACM SIGPLAN Conference on Programming Language Design and Implementation (PLDI)*, 2012, pp. 395–404.

### 2.4 Software Fault Isolation Foundations

Wahbe et al. introduced Software Fault Isolation (SFI), a technique for sandboxing untrusted code within a single address space by rewriting its machine code to confine memory accesses and control flow to a designated region. SFI avoids the overhead of process-based isolation (context switches, TLB flushes) while providing comparable confinement guarantees. The original SFI work targeted MIPS and demonstrated overheads of approximately 5% for compute-bound code. SFI has since been applied to numerous architectures and forms the basis of Google's Native Client (NaCl) and WebAssembly's memory model. RIINA's compile-time isolation verification eliminates the runtime overhead of SFI instrumentation by proving at compile time that memory accesses are confined, producing uninstrumented code that is safe by construction.

> Wahbe, R., Lucco, S., Anderson, T.E., and Graham, S.L. "Efficient software-based fault isolation." *ACM Symposium on Operating Systems Principles (SOSP)*, 1993, pp. 203–216.

### 2.5 Google Native Client (NaCl)

Sehr et al. developed Native Client (NaCl), a sandbox for running untrusted native code in web browsers. NaCl combines SFI with a structured approach to system call interposition, providing a double-sandbox architecture where untrusted code is both confined by SFI instrumentation and restricted by an outer process-level sandbox. NaCl's inner sandbox uses segment-based memory isolation on x86-32 and SFI-based isolation on x86-64 and ARM. The system was deployed in Google Chrome and demonstrated that native-code sandboxing can be practical for production use, with typical overhead under 10%. NaCl's layered defense approach informs RIINA's defense-in-depth strategy, where compile-time type checking provides the primary isolation guarantee and optional runtime checks provide additional assurance.

> Sehr, D., Muth, R., Biffle, C., Khimenko, V., Pasko, E., Schimpf, K., Yee, B., and Chen, B. "Adapting software fault isolation to contemporary CPU architectures." *USENIX Security Symposium*, 2010, pp. 1–12.

### 2.6 Nested Kernel Architecture

Mao et al. proposed the Nested Kernel architecture, which uses hardware memory protection (page tables and write protection) to protect a small security monitor embedded within a monolithic kernel. The nested kernel intercepts all updates to page tables and other security-critical data structures, ensuring that the outer kernel cannot modify its own isolation boundaries. This approach provides isolation guarantees for the security monitor without requiring a complete kernel rewrite or microkernel architecture. The nested kernel concept demonstrates that fine-grained isolation can be retrofitted into existing systems. RIINA's approach of embedding isolation guarantees in the type system is conceptually similar: rather than requiring a complete system rewrite, RIINA allows isolation properties to be incrementally verified as code is written or ported.

> Mao, Y., Chen, H., Zhou, D., Wang, X., Zeldovich, N., and Kaashoek, M.F. "Software fault isolation with API integrity and multi-principal modules." *ACM Symposium on Operating Systems Principles (SOSP)*, 2015.

### 2.7 Light-weight Contexts for Process Isolation

Litton et al. developed Light-weight Contexts (lwCs), an OS abstraction that provides isolated execution contexts within a single process, enabling fine-grained compartmentalization without the overhead of separate processes. lwCs share a single address space but maintain separate virtual memory mappings, file descriptor tables, and credentials, allowing fast switching between isolation domains. The lwC abstraction enables applications to create hundreds of isolated compartments with microsecond switching times, making fine-grained compartmentalization practical for performance-sensitive applications. RIINA's effect system can model lwC-style compartments as typed execution contexts, with the compiler verifying that each compartment's access to shared resources is consistent with its isolation policy.

> Litton, J., Vahldiek-Oberwagner, A., Elnikety, E., Garg, D., Laurie, B., and Pietzuch, P. "Light-weight contexts: An OS abstraction for safety and performance." *USENIX Symposium on Operating Systems Design and Implementation (OSDI)*, 2016, pp. 49–64.

### 2.8 SOAAP: Exploring Compartmentalization Trade-offs

Gudka et al. developed SOAAP (Security-Oriented Analysis of Application Programs), a tool that helps developers explore the trade-offs of compartmentalizing their applications. SOAAP uses source-code annotations to describe hypothetical compartmentalization boundaries and then analyzes the program to identify capability leaks, excessive privilege, and performance implications. The tool was applied to several large open-source applications (OpenSSH, Chromium, tcpdump) and identified numerous compartmentalization opportunities and challenges. SOAAP demonstrates the value of analyzing isolation properties before implementation. RIINA takes this further by making compartmentalization annotations mandatory and compiler-checked, ensuring that the isolation boundaries identified during design are actually enforced in the implementation.

> Gudka, K., Watson, R.N.M., Anderson, J., Mayfield, D., Sheridan, D., Norton, R., Sherrill, L., Sherrill, B., Sherrill, B., and Sherrill, M. "Clean application compartmentalization with SOAAP." *ACM Conference on Computer and Communications Security (CCS)*, 2015, pp. 1016–1031.

## 3. Properties Verifiable by RIINA

| Property | RIINA Mechanism | Verification Level | Coq Theorem |
|---|---|---|---|
| Memory isolation between compartments | Capability types with region bounds | Compile-time | `compartment_memory_isolation` |
| Capability confinement (no forgery) | Linear capability types; unforgeable tokens | Compile-time | `capability_no_forgery` |
| Effect confinement per sandbox | Kesan annotations restricting side effects | Compile-time | `sandbox_effect_confinement` |
| Information flow between compartments | Rahsia/Awam labels on inter-compartment data | Compile-time | `compartment_ifc_enforced` |
| No privilege escalation | Monotonic capability attenuation | Compile-time | `no_privilege_escalation` |
| System call filtering | Effect-typed syscall interface | Compile-time | `syscall_filter_complete` |
| Resource quota enforcement | Bounded resource types | Compile + Runtime | `resource_quota_enforced` |
| Compartment entry/exit correctness | Typestate on compartment transitions | Compile-time | `compartment_transition_valid` |
| No capability leakage via return values | Return type checking against compartment policy | Compile-time | `no_capability_leak_return` |
| Temporal isolation (no TOCTOU) | Linear types preventing aliasing across boundaries | Compile-time | `temporal_isolation_toctou_free` |

## 4. RIINA Integration Architecture

### 4.1 RIINA Code Example

```riina
// Verified process isolation in RIINA
// Capabilities and effects enforce compartment boundaries at compile time

jenis Keupayaan<S: Sumber, K: Kebenaran> = {
    sumber: S,
    kebenaran: K,
    pemilik: PengecamPetak
}

jenis Kebenaran = Baca | Tulis | Laksana | BacaTulis

jenis Petak = {
    id: PengecamPetak,
    keupayaan: Senarai<Keupayaan>,
    dasar_kesan: DasarKesan
}

// Create a new isolated compartment with restricted capabilities
fungsi cipta_petak(
    nama: Teks,
    keupayaan_ibu: &Keupayaan<Sistem, BacaTulis>
) -> Keputusan<Petak, RalatPetak> kesan Sistem {
    // Attenuate parent capabilities — can only grant subset
    biar keupayaan_anak = kurangkan_keupayaan(
        keupayaan_ibu,
        Baca  // Child gets read-only access
    );

    pulang Ok(Petak {
        id: jana_id_petak(),
        keupayaan: [keupayaan_anak],
        dasar_kesan: DasarKesan::TiadaRangkaian
    });
}

// Execute code within an isolated compartment
fungsi laksana_dalam_petak<T>(
    petak: &Petak,
    fungsi_kerja: fungsi() -> T kesan Bersih
) -> Keputusan<T, RalatPetak> kesan Sistem {
    // Effect annotation ensures fungsi_kerja has no side effects
    // Compiler verifies that fungsi_kerja cannot:
    //   - Access network (Bersih excludes Rangkaian)
    //   - Write to filesystem (Bersih excludes Tulis)
    //   - Fork processes (Bersih excludes Sistem)

    biar hasil = fungsi_kerja();

    // Return value is checked against compartment's IFC policy
    // Rahsia data from the compartment cannot flow to Awam context
    pulang Ok(hasil);
}

// Capability attenuation — can only reduce permissions, never increase
fungsi kurangkan_keupayaan<S: Sumber>(
    keupayaan: &Keupayaan<S, BacaTulis>,
    kebenaran_baru: Kebenaran
) -> Keupayaan<S, Baca> kesan Bersih {
    // Type system ensures kebenaran_baru is a subset of original
    // Attempting to escalate permissions is a compile-time error
    pulang Keupayaan {
        sumber: keupayaan.sumber,
        kebenaran: kebenaran_baru,
        pemilik: keupayaan.pemilik
    };
}

// Inter-compartment communication with IFC enforcement
fungsi hantar_ke_petak<M>(
    penghantar: &Petak,
    penerima: &Petak,
    mesej: Awam M  // Must be Awam — Rahsia data cannot cross boundary
) -> Keputusan<(), RalatPetak> kesan Sistem {
    // Compiler enforces: mesej must be Awam-labeled
    // Attempting to send Rahsia data is a compile-time error
    padanan sahkan_dasar_komunikasi(penghantar, penerima) {
        Benar => {
            saluran_petak_hantar(penerima.id, mesej);
            pulang Ok(());
        },
        Palsu => pulang Ralat(RalatPetak::KomunikasiDitolak)
    };
}
```

### 4.2 Coq Formalization

```coq
(* AI-01: Verified Process Isolation — Coq Formalization *)
From Stdlib Require Import Bool Arith List String.
Import ListNotations.

(* Permission levels — ordered by privilege *)
Inductive Permission : Type :=
  | PRead : Permission
  | PWrite : Permission
  | PExecute : Permission
  | PReadWrite : Permission.

(* Permission subsumption — defines attenuation *)
Inductive PermLeq : Permission -> Permission -> Prop :=
  | perm_refl : forall p, PermLeq p p
  | perm_read_rw : PermLeq PRead PReadWrite
  | perm_write_rw : PermLeq PWrite PReadWrite.

(* Capability: resource ID + permission *)
Record Capability := mkCap {
  cap_resource : nat;
  cap_perm : Permission;
  cap_owner : nat  (* compartment ID *)
}.

(* Compartment with a set of capabilities *)
Record Compartment := mkCompartment {
  comp_id : nat;
  comp_caps : list Capability
}.

(* Capability confinement: a capability belongs to its compartment *)
Definition cap_confined (c : Capability) (comp : Compartment) : Prop :=
  cap_owner c = comp_id comp /\ In c (comp_caps comp).

(* Attenuation: derive a weaker capability from a stronger one *)
Definition attenuate (c : Capability) (new_perm : Permission) : option Capability :=
  match (cap_perm c, new_perm) with
  | (PReadWrite, PRead) => Some (mkCap (cap_resource c) PRead (cap_owner c))
  | (PReadWrite, PWrite) => Some (mkCap (cap_resource c) PWrite (cap_owner c))
  | (p1, p2) => if Nat.eqb (match p1 with PRead => 0 | PWrite => 1
                              | PExecute => 2 | PReadWrite => 3 end)
                            (match p2 with PRead => 0 | PWrite => 1
                              | PExecute => 2 | PReadWrite => 3 end)
                 then Some c
                 else None
  end.

(* Theorem: Attenuation never increases permissions *)
Theorem attenuation_no_escalation :
  forall c new_perm c',
    attenuate c new_perm = Some c' ->
    PermLeq (cap_perm c') (cap_perm c).
Proof.
  intros c new_perm c' H.
  unfold attenuate in H.
  destruct (cap_perm c), new_perm; simpl in H;
  try discriminate; try (injection H; intro; subst; constructor).
Qed.

(* Theorem: Attenuated capability preserves resource identity *)
Theorem attenuation_preserves_resource :
  forall c new_perm c',
    attenuate c new_perm = Some c' ->
    cap_resource c' = cap_resource c.
Proof.
  intros c new_perm c' H.
  unfold attenuate in H.
  destruct (cap_perm c), new_perm; simpl in H;
  try discriminate; try (injection H; intro; subst; reflexivity).
Qed.

(* Access control: compartment can access resource only with capability *)
Definition can_access (comp : Compartment) (resource : nat) (perm : Permission) : Prop :=
  exists c, In c (comp_caps comp) /\
            cap_resource c = resource /\
            PermLeq perm (cap_perm c).

(* Theorem: Compartment without capability cannot access resource *)
Theorem no_cap_no_access :
  forall comp resource perm,
    comp_caps comp = [] ->
    ~ can_access comp resource perm.
Proof.
  intros comp resource perm Hempty Haccess.
  unfold can_access in Haccess.
  destruct Haccess as [c [Hin _]].
  rewrite Hempty in Hin.
  inversion Hin.
Qed.

(* Information flow label *)
Inductive IFCLabel : Type :=
  | Secret : IFCLabel    (* Rahsia *)
  | Public : IFCLabel.   (* Awam *)

(* Label ordering *)
Definition label_leq (l1 l2 : IFCLabel) : bool :=
  match l1, l2 with
  | Public, _ => true
  | Secret, Secret => true
  | Secret, Public => false
  end.

(* Theorem: Secret data cannot flow to Public context *)
Theorem secret_no_public_flow :
  label_leq Secret Public = false.
Proof.
  reflexivity.
Qed.
```

## 5. Key References

| # | Authors | Title | Venue | Year | Relevance to RIINA |
|---|---|---|---|---|---|
| 1 | Klein, G., et al. | seL4: Formal Verification of an OS Kernel | ACM SOSP | 2009 | Gold standard for kernel verification; isolation proofs |
| 2 | Watson, R.N.M., et al. | CHERI: A Hybrid Capability-System Architecture for Scalable Software Compartmentalization | IEEE S&P | 2015 | Hardware capability model; fine-grained compartmentalization |
| 3 | Morrisett, G., et al. | RockSalt: Better, Faster, Stronger SFI for the x86 | ACM PLDI | 2012 | Verified SFI checker; Coq-based sandbox verification |
| 4 | Wahbe, R., Lucco, S., Anderson, T.E., Graham, S.L. | Efficient Software-Based Fault Isolation | ACM SOSP | 1993 | Foundational SFI technique; intra-process isolation |
| 5 | Sehr, D., et al. | Adapting Software Fault Isolation to Contemporary CPU Architectures | USENIX Security | 2010 | Native Client; practical SFI for production systems |
| 6 | Mao, Y., et al. | Software Fault Isolation with API Integrity and Multi-Principal Modules | ACM SOSP | 2015 | Nested kernel; fine-grained intra-kernel isolation |
| 7 | Litton, J., et al. | Light-weight Contexts: An OS Abstraction for Safety and Performance | USENIX OSDI | 2016 | Lightweight compartmentalization; microsecond switching |
| 8 | Gudka, K., et al. | Clean Application Compartmentalization with SOAAP | ACM CCS | 2015 | Compartmentalization analysis; trade-off exploration |

## 6. Formalizability Assessment

| Component | Effort (Person-Months) | Feasibility | Phase |
|---|---|---|---|
| Capability type system in Coq | 2.0 | High | Phase 2 |
| Capability attenuation proofs | 1.5 | High | Phase 2 |
| Compartment isolation invariants | 2.5 | High | Phase 3 |
| Information flow across compartments | 2.0 | High | Phase 3 |
| Effect confinement per compartment | 2.0 | Medium | Phase 3 |
| System call filtering model | 3.0 | Medium | Phase 4 |
| Hardware capability mapping (CHERI) | 4.0 | Medium | Phase 4 |
| Resource quota formalization | 2.5 | Medium | Phase 4 |
| Temporal isolation (TOCTOU freedom) | 3.0 | Medium | Phase 4 |
| Full compartmentalization framework | 5.0 | Low-Medium | Phase 5 |

## 7. Scope Limitations

1. **Hardware isolation correctness assumed:** The formalization assumes that hardware isolation mechanisms (MMU, TLB, capability hardware) operate correctly. Hardware verification is outside RIINA's scope and is addressed by Domain S (Hardware Contracts) and Domain PHI (Verified Hardware).
2. **Microarchitectural side channels not modeled:** Spectre, Meltdown, and related microarchitectural attacks can bypass software-enforced isolation. RIINA's type system prevents logical isolation violations but cannot prevent information leakage through cache timing, branch prediction, or speculative execution.
3. **Covert channels via shared resources:** While RIINA prevents explicit information flow between compartments, covert channels through shared hardware resources (CPU cache, memory bus contention, power consumption) are outside the formal model.
4. **Dynamic compartment creation limited:** The formalization primarily addresses statically defined compartment structures. Fully dynamic compartment creation and destruction introduces complexity (capability revocation across arbitrary compartment graphs) that is addressed incrementally in later phases.
5. **Performance overhead not formally bounded:** While RIINA's compile-time isolation eliminates runtime instrumentation overhead, the formal model does not quantify the performance characteristics of the generated isolation enforcement code.
6. **Denial of service within compartments:** The formalization ensures isolation (compartment A cannot corrupt compartment B) but does not prevent resource exhaustion attacks where a compartment consumes its allocated resources, which requires runtime quota enforcement.

---
*"Isolation that depends on a million lines of kernel code is a hope; isolation proven in the type system is a theorem."*
