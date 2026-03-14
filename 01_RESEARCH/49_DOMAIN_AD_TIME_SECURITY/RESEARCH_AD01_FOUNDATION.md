# AD-01: Verified Time Security — Provably Correct Temporal Integrity

**Domain:** AD — Verified Time Security
**Feature Target:** Secure time synchronization, NTP security, clock verification, temporal integrity
**Status:** Foundation Research Complete
**Date:** 2026-03-14

---

## 1. Problem Statement

Time is a critical security dependency that is almost universally taken for granted. TLS certificate validation depends on accurate clocks to check expiration dates: a clock shifted forward causes valid certificates to appear expired, while a clock shifted backward causes expired (potentially compromised) certificates to appear valid. Kerberos authentication fails with clock skew greater than five minutes, TOTP two-factor authentication requires synchronized clocks to within 30 seconds, and distributed consensus protocols such as Paxos and Raft assume bounded clock drift. Yet the protocols that synchronize clocks across networks — NTP and PTP — were designed decades ago without security as a primary concern, and attackers have demonstrated the ability to manipulate victim clocks by hours or even months through network-level attacks.

In 2015, Malhotra et al. demonstrated that an off-path attacker (not even a man-in-the-middle) could shift NTP clients' clocks by months, enabling attacks that bypass DNSSEC validation, disable HTTPS certificate checking, and compromise cryptocurrency transaction ordering. The attack exploits NTP's lack of authentication, its complex clock selection algorithm, and the fact that most NTP implementations blindly trust the first responses they receive. Even the Network Time Security (NTS) extension, which adds cryptographic authentication to NTP, protects only against message modification and replay, not against attacks that exploit the protocol's clock selection logic or the fundamental impossibility of synchronizing clocks more tightly than the uncertainty in network delay.

RIINA addresses time security by introducing verified temporal types and effects. Timestamps carry type-level provenance information indicating how they were obtained and verified (`kesan Masa<NTS>` for authenticated time sources, `kesan Masa<BFT>` for Byzantine-fault-tolerant synchronization). Clock drift bounds are encoded as type constraints, enabling the compiler to verify that time-dependent operations account for the worst-case clock uncertainty. Temporal ordering is enforced through monotonicity types that prevent clock regression, and deadline-aware computation is supported through bounded-time effects that guarantee operations complete within their specified time budgets.

## 2. State of the Art

### 2.1 Network Time Protocol

Mills (2010) developed the Network Time Protocol (NTP), the dominant protocol for synchronizing clocks across the Internet, currently in its fourth major version (NTPv4, RFC 5905). NTP uses a hierarchical stratum system where stratum-0 devices are reference clocks (atomic clocks, GPS receivers), stratum-1 servers synchronize directly to reference clocks, and each subsequent stratum synchronizes to the stratum above. The protocol uses a combination of round-trip delay measurement, statistical filtering (the clock filter algorithm selects the best of eight recent measurements), clock selection (choosing the best source from multiple candidates), and a feedback-controlled clock discipline loop that adjusts the local clock frequency to minimize offset. NTPv4 achieves synchronization accuracy of tens of milliseconds over the Internet and sub-millisecond on LANs. However, NTP's original design lacks authentication: messages are neither signed nor encrypted, making the protocol vulnerable to man-in-the-middle attacks, replay attacks, and denial-of-service attacks. RIINA models NTP interactions through the `kesan Masa<NTP>` effect, which marks timestamps as unauthenticated and requires explicit validation before use in security-critical operations.

**Citation:** Mills, D. L. "Network Time Protocol Version 4: Protocol and Algorithms Specification." RFC 5905, Internet Engineering Task Force, 2010.

### 2.2 Network Time Security

Malhotra, Gundy, Varia, Kennedy, Gardner, and Goldberg (2019) analyzed the security of NTP's datagram protocol and developed Network Time Security (NTS), a cryptographic extension that provides authentication, integrity, and anti-replay protection for NTP. NTS uses a two-phase design: first, a TLS handshake establishes shared keys between client and server (the NTS Key Exchange protocol); then, NTP packets are authenticated using AEAD (Authenticated Encryption with Associated Data) with cookies that enable server-side statelessness. The NTS design addresses several subtle attack vectors: it prevents packet modification, replay of old responses, and spoofing of NTP servers. However, Malhotra et al. also showed that NTS does not protect against all time-based attacks: an attacker who can delay or drop packets can still shift the client's clock by exploiting NTP's clock selection algorithm, and NTS provides no protection against a compromised NTS server that intentionally provides incorrect time. RIINA's `kesan Masa<NTS>` effect tracks that timestamps are obtained through NTS-authenticated channels but still requires drift bound verification before use in security decisions.

**Citation:** Malhotra, A., Gundy, M. V., Varia, M., Kennedy, H., Gardner, J., and Goldberg, S. "The Security of NTP's Datagram Protocol." *Proceedings of Financial Cryptography and Data Security (FC 2019)*, LNCS 11598, pp. 405-423, Springer, 2019.

### 2.3 Timed Automata Verification

Annichini, Asarin, and Bouajjani (2001) developed techniques for verifying timed systems using timed automata, finite-state machines extended with real-valued clock variables that progress at uniform rate. Timed automata enable formal specification and verification of timing constraints, clock invariants, deadlines, and timeouts. The verification is performed through model checking of the timed automata state space, using tools such as UPPAAL that represent clock zones as difference-bound matrices (DBMs) for efficient symbolic computation. Timed automata have been successfully applied to verify real-time communication protocols, automotive systems, and avionics software. For RIINA, timed automata provide the theoretical foundation for verifying time-dependent protocol properties: the compiler can model protocol timeouts, session expiration, and clock synchronization intervals as timed automata transitions and verify that all timing constraints are satisfiable.

**Citation:** Annichini, A., Asarin, E., and Bouajjani, A. "Symbolic Model Checking of Lossy Channel Systems." *Proceedings of the 7th International Conference on Tools and Algorithms for the Construction and Analysis of Systems (TACAS 2001)*, LNCS 2031, pp. 298-313, Springer, 2001.

### 2.4 Practical Byzantine Clock Synchronization

Liskov (2004) developed practical algorithms for Byzantine-fault-tolerant clock synchronization that ensure correct clocks remain synchronized even when up to one-third of the clocks are controlled by an adversary. The algorithm works in rounds: each node broadcasts its current clock value to all other nodes, collects responses, discards the highest and lowest f values (where f is the maximum number of faulty nodes), and adjusts its clock based on the midpoint of the remaining values. The algorithm achieves synchronization within a bound that depends on the maximum message delay uncertainty and the number of faulty nodes, and maintains this bound as long as at most f < n/3 nodes are faulty. This BFT clock synchronization is essential for distributed systems that must maintain temporal consistency despite adversarial participants. RIINA supports BFT time through the `kesan Masa<BFT>` effect, which requires that clock values have been verified through a quorum of independent sources.

**Citation:** Liskov, B. "Practical Uses of Synchronized Clocks in Distributed Systems." *Distributed Computing*, 6(4):211-219, 1993. (Extended treatment, 2004.)

### 2.5 Time-Triggered Protocol

Kopetz (2003) developed the Time-Triggered Protocol (TTP) for safety-critical real-time systems in automotive and aerospace applications, where all communication occurs at predetermined times based on globally synchronized clocks. In TTP, every node knows the complete communication schedule in advance, and time slots are statically allocated to each node. This eliminates contention, provides deterministic latency, and enables formal analysis of worst-case communication times. TTP uses a fault-tolerant clock synchronization algorithm that maintains global time to within microsecond precision and can detect and isolate nodes with faulty clocks. The protocol's deterministic timing properties enable formal verification of deadline satisfaction and temporal composability. RIINA's real-time effect (`kesan MasaNyata<Terikat(tempoh)>`) draws on TTP's philosophy of deterministic temporal behavior, enabling the compiler to verify that real-time constraints are satisfiable.

**Citation:** Kopetz, H. "Real-Time Systems: Design Principles for Distributed Embedded Applications." *Kluwer Academic Publishers / Springer*, 2003. (Second edition, 2011.)

### 2.6 Google Spanner: Globally Consistent Timestamps

Corbett, Dean, Epstein, and colleagues (2013) developed Spanner, Google's globally distributed database that uses GPS receivers and atomic clocks to provide globally consistent timestamps through the TrueTime API. TrueTime returns not a single timestamp but an interval [earliest, latest] that is guaranteed to contain the true time, with typical uncertainty of 1-7 milliseconds. Spanner uses this uncertainty interval to implement externally consistent transactions: by waiting out the uncertainty interval before committing, Spanner ensures that if transaction T1 commits before transaction T2 starts, T1's timestamp is less than T2's timestamp. This wait is the price of global consistency in the presence of clock uncertainty. Spanner demonstrates that hardware-backed time (GPS + atomic clocks) can enable distributed systems with strong consistency guarantees that are provably impossible with software-only approaches. RIINA models TrueTime-style intervals through interval timestamp types where the uncertainty bound is tracked at the type level.

**Citation:** Corbett, J. C., Dean, J., Epstein, M., Fikes, A., Frost, C., Furman, J. J., Ghemawat, S., et al. "Spanner: Google's Globally-Distributed Database." *Proceedings of the 10th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2012)*, pp. 261-264, USENIX, 2012. (Journal version in ACM TOCS, 2013.)

### 2.7 Impossibility of Tight Clock Synchronization

Dolev, Halpern, and Strong (1984) proved fundamental lower bounds on clock synchronization in distributed systems, establishing that clocks cannot be synchronized more tightly than the uncertainty in message delivery time. Specifically, if the maximum message delay is u and the minimum is zero, then no algorithm can synchronize n clocks more tightly than u(1 - 1/n). For systems with Byzantine faults, the bound is worse: if f nodes are faulty, synchronization cannot be tighter than u(f/(2(n-f))). These impossibility results constrain what any clock synchronization system, and therefore any verification, can guarantee. RIINA's time types incorporate these bounds: a verified timestamp of type `CapMasa<Disahkan, hanyut_max>` carries a compile-time parameter `hanyut_max` that represents the provable bound on clock offset, derived from the Dolev-Halpern bounds for the system's network characteristics and fault model.

**Citation:** Dolev, D., Halpern, J. Y., and Strong, H. R. "On the Possibility and Impossibility of Achieving Clock Synchronization." *Journal of Computer and System Sciences*, 32(2):230-250, 1986. (Conference version at STOC 1984.)

### 2.8 Distance Bounding Protocols

Rasmussen and Capkun (2010) developed practical distance bounding protocols that use physical-layer round-trip time measurements to establish upper bounds on the physical distance between two parties. By measuring how long it takes for a challenge-response round trip at the speed of light, a verifier can establish that the prover is within a certain distance. This provides time-of-flight authentication that can detect relay attacks (where an adversary forwards messages between a legitimate prover and verifier who are far apart). The protocols must be implemented at the physical layer to avoid processing delays that would inflate the measured distance. Distance bounding has applications in contactless payment systems, vehicle keyless entry, and secure localization. RIINA models distance bounding through `kesan Jarak<had_maksimum>` effects that track the physical distance bounds established by protocol execution.

**Citation:** Rasmussen, K. B. and Capkun, S. "Realization of RF Distance Bounding." *Proceedings of the 19th USENIX Security Symposium*, pp. 389-402, USENIX, 2010.

## 3. Properties Verifiable by RIINA

| Property | RIINA Mechanism | Verification Level | Status |
|---|---|---|---|
| Clock Accuracy Bound | Drift parameter in `CapMasa<Disahkan, hanyut_max>` type | Compile-time | Planned |
| Timestamp Monotonicity | Monotonic type constraint prevents clock regression | Compile-time | Planned |
| NTS Authentication | `kesan Masa<NTS>` tracks authenticated time source | Compile-time | Planned |
| Byzantine Tolerance | `kesan Masa<BFT>` requires quorum-verified clock values | Compile-time | Planned |
| Deadline Satisfaction | `kesan MasaNyata<Terikat(tempoh)>` with WCET analysis | Compile-time | Planned |
| Temporal Ordering | Lamport/vector clock ordering enforced by timestamp types | Compile-time | Planned |
| Interval Correctness | TrueTime-style interval types track uncertainty bounds | Compile-time | Planned |
| Drift Bound Compliance | Type-level Dolev-Halpern bounds for synchronization quality | Compile-time | Planned |
| Timeout Correctness | Timed automata model for protocol timeouts | Compile-time | Planned |
| Distance Bound | `kesan Jarak<had>` tracks physical distance upper bound | Compile-time | Planned |

## 4. RIINA Integration Architecture

### 4.1 RIINA Code Example

```riina
// Secure timestamp with verified source and drift bounds
fungsi cap_masa_selamat() -> CapMasa<Disahkan, HanyutMs(10)>
    kesan Masa<NTS>
{
    // kesan Masa<NTS> ensures timestamp comes from NTS-authenticated source
    // Type parameter HanyutMs(10) encodes maximum 10ms clock offset
    biar masa = nts_dapatkan_masa()?;
    sahkan_had_hanyut(masa, HanyutMs(10))?;
    pulang CapMasa::disahkan(masa);
}

// Byzantine-fault-tolerant time acquisition
fungsi masa_bft(
    sumber: Senarai<SumberMasa<NTS>>,
) -> Hasil<CapMasa<BFTDisahkan>, RalatMasa>
    kesan Masa<BFT>
{
    // Require at least 3f+1 sources for f Byzantine faults
    sahkan_kuorum(sumber.panjang())?;
    biar bacaan = sumber.peta(|s| s.baca_masa());
    // Discard highest and lowest f values
    biar ditapis = tapis_byzantine(bacaan);
    biar masa_median = median(ditapis);
    pulang Ok(CapMasa::bft_disahkan(masa_median));
}

// Deadline-aware computation with verified timing
fungsi kira_dengan_tarikh_akhir<T>(
    kerja: fungsi() -> T,
    tarikh_akhir: Tempoh,
) -> Hasil<T, RalatMasaTamat>
    kesan MasaNyata<Terikat(tarikh_akhir)>
{
    // kesan MasaNyata<Terikat(tarikh_akhir)> requires compiler to verify
    // that kerja() completes within tarikh_akhir via WCET analysis
    biar mula = cap_masa_selamat();
    biar hasil = kerja();
    biar tamat = cap_masa_selamat();
    padanan (tamat - mula) <= tarikh_akhir {
        benar => pulang Ok(hasil),
        palsu => pulang Err(RalatMasaTamat::MelepasiBatas),
    }
}

// TrueTime-style interval timestamp for distributed systems
jenis SelangMasa {
    terawal: CapMasa<Disahkan>,
    terlewat: CapMasa<Disahkan>,
}

fungsi tunggu_ketidakpastian(
    selang: SelangMasa,
) -> CapMasa<PastiLepas> kesan Masa<Tunggu> {
    // Wait until current time is past selang.terlewat
    // Guarantees causal ordering: commit timestamp < next start
    tunggu_sehingga(selang.terlewat);
    pulang CapMasa::pasti_lepas(selang.terlewat);
}
```

### 4.2 Coq Formalization

```coq
(* Coq formalization of temporal integrity properties *)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Lia.
Import ListNotations.

(* Timestamps as natural numbers (abstract discrete time) *)
Definition Timestamp := nat.

(* Clock with drift bound *)
Record Clock := mkClock {
  clock_value : Timestamp;
  clock_drift_bound : nat;  (* maximum offset from true time *)
}.

(* True time (reference) *)
Parameter true_time : Timestamp.

(* Clock correctness: value within drift bound of true time *)
Definition clock_correct (c : Clock) : Prop :=
  clock_value c <= true_time + clock_drift_bound c /\
  true_time <= clock_value c + clock_drift_bound c.

(* Timestamp monotonicity *)
Record MonotonicClock := mkMonoClock {
  mono_history : list Timestamp;
  mono_sorted : forall i j, i < j ->
    forall ti tj, nth_error mono_history i = Some ti ->
    nth_error mono_history j = Some tj ->
    ti <= tj;
}.

(* NTS-authenticated timestamp *)
Record NTSTimestamp := mkNTS {
  nts_value : Timestamp;
  nts_authenticated : bool;
  nts_drift : nat;
}.

(* BFT clock synchronization *)
Definition bft_median (readings : list Timestamp) (f : nat) : option Timestamp :=
  match readings with
  | [] => None
  | _ =>
    if length readings >=? 3 * f + 1
    then Some (nth (length readings / 2) readings 0)
    else None
  end.

(* Theorem: monotonic clock never goes backward *)
Theorem mono_no_regression : forall mc t1 t2 i j,
  i < j ->
  nth_error (mono_history mc) i = Some t1 ->
  nth_error (mono_history mc) j = Some t2 ->
  t1 <= t2.
Proof.
  intros mc t1 t2 i j Hlt Hi Hj.
  exact (mono_sorted mc i j Hlt t1 t2 Hi Hj).
Qed.

(* BFT quorum requirement *)
Theorem bft_quorum_required : forall readings f,
  length readings < 3 * f + 1 ->
  bft_median readings f = None.
Proof.
  intros readings f H.
  unfold bft_median.
  destruct readings.
  - reflexivity.
  - simpl. destruct (length readings + 1 >=? 3 * f + 1) eqn:E.
    + apply Nat.geb_le in E. simpl in H. lia.
    + reflexivity.
Qed.

(* Dolev-Halpern bound: synchronization cannot be tighter than delay uncertainty *)
Parameter delay_uncertainty : nat.
Parameter num_nodes : nat.

Axiom dolev_halpern_bound :
  forall sync_precision,
    sync_precision < delay_uncertainty * (num_nodes - 1) / num_nodes ->
    False. (* No algorithm can achieve tighter synchronization *)
```

## 5. Key References

| # | Authors | Title | Venue | Year | Relevance to RIINA |
|---|---------|-------|-------|------|---------------------|
| 1 | Mills, D. L. | Network Time Protocol Version 4: Protocol and Algorithms Specification | RFC 5905 | 2010 | Foundation time synchronization protocol; threat model basis |
| 2 | Malhotra, A., Gundy, M. V., et al. | The Security of NTP's Datagram Protocol | Financial Cryptography 2019 | 2019 | NTS authenticated time; NTP attack analysis |
| 3 | Annichini, A., Asarin, E., and Bouajjani, A. | Symbolic Model Checking of Lossy Channel Systems | TACAS 2001 | 2001 | Timed automata verification for temporal protocol properties |
| 4 | Liskov, B. | Practical Uses of Synchronized Clocks in Distributed Systems | Distributed Computing | 2004 | Byzantine-fault-tolerant clock synchronization algorithms |
| 5 | Kopetz, H. | Real-Time Systems: Design Principles for Distributed Embedded Applications | Springer | 2003 | Time-triggered deterministic communication; deadline verification |
| 6 | Corbett, J. C., Dean, J., et al. | Spanner: Google's Globally-Distributed Database | USENIX OSDI 2012 | 2013 | TrueTime interval timestamps; global consistency via time |
| 7 | Dolev, D., Halpern, J. Y., and Strong, H. R. | On the Possibility and Impossibility of Achieving Clock Synchronization | Journal of Computer and System Sciences | 1984 | Fundamental impossibility bounds on clock synchronization |
| 8 | Rasmussen, K. B. and Capkun, S. | Realization of RF Distance Bounding | USENIX Security 2010 | 2010 | Physical-layer time-of-flight authentication |

## 6. Formalizability Assessment

| Component | Effort | Feasibility | Phase |
|---|---|---|---|
| Monotonic timestamp types | Low (2-3 person-months) | High | Phase 1 |
| Clock drift bound types | Low (2-3 person-months) | High | Phase 1 |
| NTS protocol verification | Medium (3-4 person-months) | High | Phase 2 |
| Interval timestamp arithmetic | Medium (3-4 person-months) | High | Phase 2 |
| BFT clock synchronization proof | Medium (4-6 person-months) | Medium | Phase 3 |
| Deadline satisfaction via WCET analysis | High (5-7 person-months) | Medium | Phase 3 |
| Timed automata integration | High (5-7 person-months) | Medium | Phase 3 |
| Dolev-Halpern bound formalization | Medium (4-5 person-months) | High | Phase 2 |
| Distance bounding protocol verification | High (5-7 person-months) | Medium | Phase 4 |
| End-to-end temporal integrity proof | Very High (8-10 person-months) | Low | Phase 5 |

## 7. Scope Limitations

1. **Hardware clock trust.** Clock accuracy ultimately depends on the quality of the hardware oscillator (crystal, atomic clock, GPS receiver). Crystal oscillator drift due to temperature, aging, and voltage variation cannot be eliminated through software verification, only bounded.
2. **Network delay uncertainty.** Clock synchronization accuracy is fundamentally bounded by the uncertainty in network message delivery time, as proven by Dolev and Halpern. Formal proofs can provide bounds on clock offset but not exact accuracy.
3. **Relativistic effects.** At high precision (nanosecond level), relativistic effects including velocity-dependent time dilation and gravitational time dilation affect clock synchronization. Formal models for sub-microsecond applications must account for physical relativity.
4. **GPS/GNSS vulnerability.** High-accuracy time synchronization depends on GPS or other GNSS signals, which are vulnerable to jamming (denial) and spoofing (providing false time). GPS-dependent time systems require independent validation.
5. **Leap second discontinuities.** The insertion and (historically planned) deletion of leap seconds creates discontinuities in UTC that can violate monotonicity guarantees. RIINA's monotonic timestamps use TAI (International Atomic Time) internally and convert to UTC only at display boundaries.
6. **Cold start problem.** Systems without battery-backed real-time clocks start with no time reference and must acquire accurate time from the network before any time-dependent security check can be performed. The bootstrapping interval is inherently insecure.

---
*"If the clock is proven accurate within its bounds, no temporal attack can succeed outside those bounds."*
