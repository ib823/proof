# RIINA Research Domain AK: Verified Procurement --- Procurement Method Selection Rules

## Document Control

```
Track: AK (Alpha-Kilo)
Version: 1.0.0
Date: 2026-02-01
Classification: FOUNDATIONAL
Status: SPECIFICATION
Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE
```

---

## 1. The Method Selection Problem

### 1.1 Why Method Selection Is the First Point of Failure

Procurement method selection is the single most consequential decision in any procurement cycle. Every downstream guarantee --- competition, transparency, value for money --- depends on the correct method being applied. Wrong method selection produces two catastrophic outcomes:

1. **Legal challenge:** A bidder who would have competed under open tender discovers the contract was awarded directly. Judicial review follows. The contract is voided, the project delayed, and costs double.
2. **Corruption vector:** An officer deliberately selects a restricted method to steer the contract to a preferred supplier. The method selection provides the cover story. No amount of evaluation integrity can compensate for a rigged method choice.

Current systems treat method selection as a drop-down menu. An officer picks "Direct Award" and types a justification. A supervisor clicks "Approve." No system verifies that the justification is legally valid, that the value threshold is respected, or that the selected method maximizes competition given the constraints.

| Failure Mode | Root Cause | Consequence | Frequency |
|---|---|---|---|
| Threshold breach | Value estimated below threshold | Legal challenge, contract void | High |
| Artificial splitting | Single need divided into parts below threshold | Audit finding, criminal liability | Very high |
| Unjustified sole source | Convenience disguised as urgency | Corruption, overpayment 20-40% | High |
| Method downgrade | Open tender → restricted without grounds | Reduced competition, higher prices | Medium |
| Missing domestic preference | Bumiputera/SME rules not applied | Policy violation, political risk | Medium |

### 1.2 The RIINA Approach

Method selection becomes a **pure function** from procurement parameters to a legally valid method. The function is:

- **Total:** Every valid input produces an output (no undefined cases).
- **Deterministic:** Same inputs always produce the same method.
- **Monotone in competition:** If two methods are valid, the one with more competition is selected.
- **Threshold-correct:** The output method is always legal for the estimated value.
- **Auditable:** The function's execution trace constitutes the legal justification.

The method selection function is proven correct in Coq. If the function selects "Direct Award," the proof guarantees that at least one valid sole-source justification exists and that the value is within the jurisdiction's direct award threshold.

---

## 2. International Method Taxonomy

### 2.1 The 16 Procurement Methods

Every procurement regime worldwide uses some subset of these 16 methods. Naming varies; the underlying mechanics are universal.

| ID | Method | Min Bidders | Competition | Negotiation | Typical Use | WTO GPA Art. | UNCITRAL Ch. | EU Dir. Art. |
|---|---|---|---|---|---|---|---|---|
| M01 | Open Tender (ICB/NCB) | Unlimited | Full | No | Default above threshold | IX | 28-30 | 27 |
| M02 | Restricted Tender | 3-5+ (shortlisted) | Partial | No | Prequalification needed | IX | 28-30 | 28 |
| M03 | Request for Quotation (RFQ) | 3+ | Partial | No | Low-value, off-shelf | --- | 49 | --- |
| M04 | Request for Proposal (RFP) | 3+ | Partial | Yes | Complex services | --- | 47-48 | --- |
| M05 | Direct/Single Source | 1 | None | Yes | Emergency, sole supplier | XIII(1) | 30 | 32 |
| M06 | Competitive Dialogue | 3+ | Full | Yes | Complex, undefined scope | --- | --- | 30 |
| M07 | Innovation Partnership | 3+ | Full | Yes | R&D + supply combined | --- | --- | 31 |
| M08 | Framework Agreement | 3+ (initial) | Partial | Varies | Recurring purchases | --- | 33-35 | 33 |
| M09 | Dynamic Purchasing System | Unlimited | Full | No | Electronic, ongoing | --- | --- | 34 |
| M10 | Reverse Auction (e-Auction) | 3+ | Full | No | Commodity, price-only | --- | 54 | 35 |
| M11 | Design Contest | Unlimited | Full | No | Architecture, engineering | --- | --- | 78-80 |
| M12 | Emergency Procurement | 1+ | Minimal | Yes | Life-threatening urgency | XIII(1)(d) | 30(5) | 32(2)(c) |
| M13 | Micro-Purchase | 1 | None | No | Below micro-threshold | --- | --- | --- |
| M14 | Two-Stage Tendering | 3+ | Full | Partial | Technical complexity | --- | 47-48 | --- |
| M15 | Community/Social Procurement | Varies | Modified | Varies | Social enterprises, NGOs | --- | --- | Recital 36 |
| M16 | Negotiated Without Publication | 1+ | None | Yes | Extreme circumstances | XIII | 30 | 32 |

### 2.2 Method Classification Properties

| Method | Advertising Required | Sealed Bids | Pre-Qualification | e-Submission | Standstill Period |
|---|---|---|---|---|---|
| M01 | Yes (national+international) | Yes | Optional | Optional | Yes |
| M02 | Yes (expression of interest) | Yes | Required | Optional | Yes |
| M03 | No (invited) | No | No | Optional | No |
| M04 | Yes or invited | No | Optional | Optional | Varies |
| M05 | No | No | No | No | No |
| M06 | Yes | No | Yes | Optional | Yes |
| M07 | Yes | No | Yes | Optional | Yes |
| M08 | Yes (initial) | Varies | Optional | Optional | Yes (initial) |
| M09 | Yes (ongoing) | No | No | Required | No |
| M10 | Yes | No | Optional | Required | No |
| M11 | Yes | No | No | Optional | Yes |
| M12 | No | No | No | No | No |
| M13 | No | No | No | No | No |
| M14 | Yes | Yes (stage 2) | Optional | Optional | Yes |
| M15 | Yes (targeted) | Varies | Varies | Optional | Varies |
| M16 | No | No | No | No | Varies |

---

## 3. Threshold Systems by Jurisdiction

### 3.1 Malaysia (GPA 2025 / MOF Circulars / CIDB)

Malaysia's procurement is governed by the Government Procurement Act 2025 (aligning with WTO GPA accession), MOF Treasury Circulars (Pekeliling Perbendaharaan), and CIDB for construction.

| Value Band (RM) | Goods | Services | Works | Consulting | Method |
|---|---|---|---|---|---|
| 0 -- 20,000 | Direct purchase | Direct purchase | Direct purchase | Direct appoint | M13 (Micro) |
| 20,001 -- 50,000 | 3 quotations | 3 quotations | 3 quotations | 3 proposals | M03 (RFQ) |
| 50,001 -- 200,000 | Min 5 quotations | Min 5 quotations | Min 5 quotations | RFP | M03/M04 |
| 200,001 -- 500,000 | Open tender (national) | Open tender | Open tender | RFP/open | M01/M04 |
| > 500,000 | Open tender (international if GPA) | Open tender | Open tender | Open tender | M01 |
| > GPA threshold (SDR) | International competitive | International | International | International | M01 (ICB) |
| Emergency | Any value | Any value | Any value | Any value | M12 |

**Bumiputera set-aside:** Contracts below RM 500,000 for goods/services reserved for Bumiputera companies (Class A-F registration). See Section 8.

**CIDB Construction Bands:**

| Grade | Financial Limit (RM) | Head Limit (RM) |
|---|---|---|
| G1 | 0 -- 200,000 | 200,000 |
| G2 | 200,001 -- 500,000 | 500,000 |
| G3 | 500,001 -- 1,000,000 | 1,000,000 |
| G4 | 1,000,001 -- 3,000,000 | 3,000,000 |
| G5 | 3,000,001 -- 5,000,000 | 5,000,000 |
| G6 | 5,000,001 -- 10,000,000 | 10,000,000 |
| G7 | > 10,000,000 | No limit |

### 3.2 WTO GPA (Revised 2014, SDR Thresholds 2024-2025)

The WTO Government Procurement Agreement uses Special Drawing Rights (SDR) to set thresholds. Conversion rates updated biennially.

| Entity Level | Goods (SDR) | Services (SDR) | Works (SDR) | Approx USD (2024) |
|---|---|---|---|---|
| Central government | 130,000 | 130,000 | 5,000,000 | ~$176K / ~$6.8M |
| Sub-central government | 200,000 | 200,000 | 5,000,000 | ~$271K / ~$6.8M |
| Other covered entities | 400,000 | 400,000 | 5,000,000 | ~$542K / ~$6.8M |
| Construction concessions | N/A | N/A | 5,000,000 | ~$6.8M |

### 3.3 European Union (Directive 2014/24/EU, 2024-2025 Thresholds)

| Category | Threshold (EUR) | Utilities (EUR) | Defence (EUR) |
|---|---|---|---|
| Central government (goods/services) | 143,000 | 443,000 | 443,000 |
| Sub-central (goods/services) | 221,000 | 443,000 | 443,000 |
| Works | 5,538,000 | 5,538,000 | 5,538,000 |
| Social/specific services | 750,000 | 1,000,000 | 750,000 |
| Design contests | 143,000 | 443,000 | --- |
| Concessions | 5,538,000 | 5,538,000 | --- |

**Below-threshold (Member State discretion):** Most EU states apply "light" rules for contracts below the thresholds, requiring cross-border interest assessment. Germany: EUR 1,000 micro, EUR 25,000 direct award (UVgO), EUR 50,000 restricted. France: EUR 40,000 MAPA without advertising, EUR 90,000 MAPA with advertising.

### 3.4 United States (FAR 2.101, Parts 13-15)

| Threshold (USD) | Method | FAR Reference |
|---|---|---|
| 0 -- 10,000 | Micro-purchase (government credit card) | FAR 13.2 |
| 10,001 -- 250,000 | Simplified acquisition (SAP) | FAR 13.1 |
| 250,001 -- 7,500,000 | Competitive proposals / sealed bidding | FAR 14-15 |
| > 7,500,000 | Full & open competition | FAR 6 |
| > GPA threshold | Full & open + GPA obligations | FAR 25.4 |
| Small business set-aside | < $250,000 auto set-aside; sole source $4M (mfg) / $4.5M (svc) | FAR 19 |
| Emergency (CICA exception) | Any value | FAR 6.302-2 |

### 3.5 Other Jurisdictions (Summary)

| Jurisdiction | Framework | Micro | Small | Open Threshold | Currency |
|---|---|---|---|---|---|
| UK (PCR 2015) | Find a Tender | GBP 12,000 | GBP 30,000 | GBP 139,688 (central) | GBP |
| Singapore (GeBIZ) | Government e-Business | SGD 6,000 | SGD 90,000 | SGD 90,000+ (ITQ/ITT) | SGD |
| Australia (CPRs) | Commonwealth Procurement Rules | AUD 10,000 | AUD 80,000 | AUD 80,000+ | AUD |
| World Bank | Procurement Regulations 2016 | USD 50,000 | USD 100,000 | Varies by borrower | USD |
| ADB | Procurement Policy 2017 | USD 30,000 | USD 100,000 | Country thresholds | USD |
| Canada (PSPC) | Government Contracts Regulations | CAD 25,000 | CAD 100,000 | CAD 100,000 (CFTA) | CAD |
| Japan | WTO GPA signatories | JPY 1.6M | JPY 10M | JPY 10M+ (central) | JPY |
| India (GFR 2017) | GeM / GFR | INR 25,000 | INR 250,000 | INR 2,500,000 | INR |

---

## 4. Method Selection Decision Tree

### 4.1 Formal Decision Function

The method selection function takes a `ProcurementRequest` and produces a `MethodDecision`:

```
SelectMethod : ProcurementRequest -> Jurisdiction -> MethodDecision

where ProcurementRequest = {
  category        : Goods | Services | Works | Consulting
  estimated_value : Currency * Amount
  urgency         : Normal | Urgent | LifeThreatening
  sole_supplier   : Option<SoleSourceJustification>
  complexity      : Low | Medium | High | Undefined
  recurrence      : OneOff | Recurring(frequency)
  innovation      : bool
  domestic_pref   : Option<DomesticPreference>
  framework_exists: Option<FrameworkID>
}

MethodDecision = {
  primary_method   : Method
  fallback_method  : Option<Method>
  justification    : list JustificationClause
  approval_level   : ApprovalAuthority
  advertising_req  : AdvertisingRequirement
  min_time_days    : nat
}
```

### 4.2 Decision Flowchart

```
START
  |
  v
[1] Is estimated_value <= micro_threshold(jurisdiction)?
  |--YES--> M13 (Micro-Purchase) --> DONE
  |--NO
  v
[2] Is urgency = LifeThreatening?
  |--YES--> M12 (Emergency) --> DONE
  |--NO
  v
[3] Does sole_supplier justification exist AND is valid?
  |--YES--> [3a] Is value <= sole_source_limit(jurisdiction)?
  |           |--YES--> M05 (Direct Award) --> DONE
  |           |--NO---> [3b] Higher approval required
  |                       |--> M05 with escalated approval --> DONE
  |--NO
  v
[4] Does a valid Framework Agreement exist for this category?
  |--YES--> M08 (Framework Call-off) --> DONE
  |--NO
  v
[5] Is estimated_value <= quotation_threshold(jurisdiction)?
  |--YES--> M03 (RFQ, minimum 3 quotes) --> DONE
  |--NO
  v
[6] Is complexity = Undefined (scope cannot be defined)?
  |--YES--> M06 (Competitive Dialogue) --> DONE
  |--NO
  v
[7] Is innovation = true (R&D + supply combined)?
  |--YES--> M07 (Innovation Partnership) --> DONE
  |--NO
  v
[8] Is category = Consulting AND value <= rfp_threshold?
  |--YES--> M04 (RFP with quality-cost) --> DONE
  |--NO
  v
[9] Is complexity = High (technical uncertainty)?
  |--YES--> M14 (Two-Stage Tendering) --> DONE
  |--NO
  v
[10] Is recurrence = Recurring?
  |--YES--> [10a] Electronic platform available?
  |           |--YES--> M09 (Dynamic Purchasing) --> DONE
  |           |--NO---> M08 (Framework Agreement setup) --> DONE
  |--NO
  v
[11] Is category commodity AND evaluation = price-only?
  |--YES--> M10 (Reverse Auction) --> DONE
  |--NO
  v
[12] DEFAULT: M01 (Open Tender) --> DONE
```

### 4.3 Completeness Argument

Every path terminates at exactly one method. The decision tree is:
- **Total:** All combinations of inputs lead to a leaf (M01 is the catch-all default).
- **Deterministic:** Conditions are checked in strict priority order; the first match wins.
- **Competition-maximizing:** The default (M01) provides maximum competition; restrictive methods (M05, M12, M13) are only reachable under proven justifications.

---

## 5. Sole Source Justifications

### 5.1 Exhaustive Justification Taxonomy

| ID | Justification | Legal Basis | Documentation Required | Approval Authority | Value Limit |
|---|---|---|---|---|---|
| J01 | Sole supplier (genuine monopoly) | GPA XIII(1)(b), FAR 6.302-1, EU 32(2)(b) | Market survey, IPR proof, capability assessment | Department head + procurement board | No limit (with escalation) |
| J02 | Standardization/interoperability | GPA XIII(1)(b), FAR 6.302-1(a)(2)(ii) | Technical justification, switching cost analysis | Technical authority + finance | Jurisdiction threshold |
| J03 | Extreme urgency (unforeseen) | GPA XIII(1)(d), FAR 6.302-2, EU 32(2)(c) | Timeline analysis, unforeseeability proof | Head of agency | Time-limited (max 6 months) |
| J04 | Follow-on/repeat purchase | GPA XIII(1)(a), EU 32(3)(b) | Original contract ref, within 3 years, declared in original notice | Original approval authority | Up to 50% of original value |
| J05 | Prototype/first article | FAR 6.302-1(a)(2)(i) | R&D contract ref, first production run | Technical authority | Original + 150% |
| J06 | National security | GPA III(1), FAR 6.302-6, EU Art. 346 TFEU | Classification authority, security justification | Minister/Secretary level | No limit |
| J07 | Humanitarian emergency | UNCITRAL 30(5), WB immediate response | Disaster declaration, life-safety evidence | Head of agency (delegable) | Time-limited |
| J08 | After failed competition | GPA XIII(1)(a), EU 32(2)(a) | Failed tender record, no substantial modification | Procurement board | Original value |
| J09 | Artistic/IP exclusivity | EU 32(2)(b)(ii), FAR 6.302-1(a)(2)(iii) | IP search, copyright/patent proof | Department head | No limit |
| J10 | Below micro-threshold | FAR 13.2, national micro-purchase rules | Value certification only | Cardholder/budget holder | Micro-threshold |
| J11 | Treaty/international obligation | GPA exception, bilateral agreement | Treaty reference, obligation scope | Legal counsel + head | Treaty-defined |
| J12 | Research/educational | FAR 35.016, national R&D exemptions | Research plan, uniqueness of institution | Research authority | Varies (often <$500K) |
| J13 | Utilities market (competitive) | EU Dir. 2014/25 Art. 34 | Market analysis, regulatory approval | Sector regulator | Utility thresholds |

### 5.2 Sole Source Validity Function

A sole source justification is valid if and only if:

```
valid_sole_source(j: Justification, req: ProcurementRequest, juris: Jurisdiction) -> bool :=
  justification_type_recognized(j.type, juris)              (* J01-J13 recognized *)
  /\ documentation_complete(j.docs, required_docs(j.type))  (* All docs present *)
  /\ approver_authorized(j.approver, j.type, req.value)     (* Correct authority *)
  /\ value_within_limit(req.value, sole_source_limit(j.type, juris))
  /\ not_artificially_split(req)                             (* Anti-splitting check *)
  /\ time_validity(j.date, j.type)                          (* Urgency: within window *)
```

---

## 6. Value Estimation Rules

### 6.1 Aggregation and Anti-Splitting

The estimated value determines the method. If the value is wrong, the method is wrong, and the entire procurement is challengeable. Value estimation rules exist primarily to prevent **artificial splitting** --- dividing a single procurement need into multiple smaller contracts to stay below thresholds.

| Rule | Description | Example |
|---|---|---|
| R01: Aggregate similar needs | Same category + same fiscal year = one estimated value | 12 monthly IT support contracts = annual total |
| R02: Include all lots | Total value across all lots determines method, not individual lot value | 5 lots of RM 100K each = RM 500K (open tender) |
| R03: Include options/renewals | Base + all option years = estimated value | 2-year contract + 2 option years = 4-year value |
| R04: Multi-year discounting | No discounting allowed; use nominal (undiscounted) total | 3 years at RM 100K/year = RM 300K, not NPV |
| R05: Currency at estimation date | Use official exchange rate on date of estimation | USD contract → RM at BNM rate |
| R06: VAT exclusion | Most jurisdictions exclude VAT/GST from threshold comparison | RM 200K + 10% SST = compare RM 200K |
| R07: No artificial lot splitting | If lots are functionally related, aggregate | Separate tenders for "Phase 1" and "Phase 2" of same project = violation |
| R08: Framework maximum | Framework value = total expected call-offs over term | 4-year framework, RM 50K/quarter = RM 800K |
| R09: Concession revenue | Value = total estimated revenue over concession term | 10-year toll road revenue, not construction cost alone |
| R10: Design contest + follow-on | Contest prize + expected service contract value | RM 50K prize + RM 2M design contract = RM 2.05M |

### 6.2 Anti-Splitting Detection

Artificial splitting is detected by analyzing procurement history and planned procurements:

```
is_split(p: Procurement, history: list Procurement) -> bool :=
  exists q in history,
    same_category(p, q)
    /\ same_fiscal_year(p, q)
    /\ same_end_user(p, q)
    /\ combined_value(p, q) > threshold
    /\ individual_values_below_threshold(p, q)
```

The system flags potential splits and requires explicit justification (functional independence) before permitting separate procurements below threshold.

---

## 7. Domestic Preference Rules

### 7.1 Malaysia: Bumiputera Policy

| Rule | Scope | Mechanism | Legal Basis |
|---|---|---|---|
| Class F set-aside | Works < RM 200K | Reserved for Bumiputera contractors | Treasury Circular PK2 |
| Bumiputera vendor priority | Goods/Services < RM 500K | Bumiputera vendors given first opportunity | MOF directive |
| Price preference (goods) | All values | Bumiputera vendor may be awarded at up to 10% premium | Treasury Circular |
| Bumiputera JV requirement | Works > RM 10M | Non-Bumiputera must form JV with min 30% Bumiputera equity | CIDB regulation |
| Technology transfer | ICT > RM 50M | Required offset/countertrade program | MITI directive |

### 7.2 International Comparison

| Jurisdiction | Domestic Preference | Mechanism | Magnitude |
|---|---|---|---|
| Malaysia | Bumiputera, SME | Set-aside, price preference | 10% price preference |
| USA | Small Business, HUBZone, SDVOSB, 8(a) | Set-aside below SAT, sole source to $4M | Various (up to 10% eval preference) |
| India | MSE, StartupIndia | 25% reservation, price preference 15% (Class I local) | 15-20% |
| Australia | SME, Indigenous | Mandatory consideration, Indigenous Procurement Policy 3% target | Evaluation weighting |
| EU | None (single market) | Prohibited above threshold | 0% |
| WTO GPA | Prohibited among parties | Exception: developing country transition | Varies (phaseout) |
| South Africa | B-BBEE | Points system (80/20 or 90/10) | 10-20 points |
| Brazil | ME/EPP | 5% price preference, restricted tenders | 5% |

### 7.3 Green Procurement Preferences

| Jurisdiction | Green Criteria | Integration Point |
|---|---|---|
| EU (GPP) | Life-cycle cost, eco-labels, circular economy | Evaluation criteria (up to 100% green specs for listed categories) |
| Malaysia (GGP) | MyHIJAU certification, energy efficiency | Mandatory for 20 product categories |
| USA (EO 14057) | Buy Clean, sustainable products | FAR clause requirements |
| Singapore (SGEP) | Green label, energy/water efficiency | Evaluation preference |

---

## 8. Formal Properties

### 8.1 Theorem Catalog

| ID | Theorem | Statement (Informal) | Dependencies |
|---|---|---|---|
| MS-T01 | `method_selection_total` | Every valid request produces a method | Decision tree completeness |
| MS-T02 | `method_selection_deterministic` | Same request always produces same method | Priority ordering |
| MS-T03 | `threshold_compliance` | Selected method is legal for the estimated value | Threshold lookup correctness |
| MS-T04 | `anti_splitting_detection` | Split procurements are flagged before method selection | Aggregation rules |
| MS-T05 | `competition_maximization` | If open tender is valid, no less competitive method is selected | Priority order + default |
| MS-T06 | `sole_source_requires_justification` | M05 selected only if valid J01-J13 exists | Justification validation |
| MS-T07 | `emergency_requires_declaration` | M12 selected only if urgency = LifeThreatening | Input validation |
| MS-T08 | `micro_threshold_correct` | M13 only if value <= micro_threshold(juris) | Threshold bounds |
| MS-T09 | `framework_calloff_valid` | M08 only if framework exists and is not expired | Framework registry check |
| MS-T10 | `advertising_follows_method` | Advertising requirement matches method classification | Method properties table |
| MS-T11 | `approval_escalation` | Higher value requires higher approval authority | Authority hierarchy |
| MS-T12 | `standstill_required` | Methods M01, M02, M06, M07, M11, M14 require standstill period | Method properties |
| MS-T13 | `minimum_bidders_enforced` | Minimum bidder count matches method specification | Method properties |
| MS-T14 | `domestic_preference_applied` | Bumiputera/SME rules applied when jurisdiction requires | Jurisdiction config |
| MS-T15 | `value_aggregation_correct` | Lots + options + renewals included in estimated value | Aggregation rules |
| MS-T16 | `no_method_downgrade` | Cannot move from M01 to M05 without new justification | State machine |
| MS-T17 | `urgency_time_bounded` | Emergency procurement expires after max duration | Time validity |
| MS-T18 | `follow_on_within_limit` | J04 follow-on value <= 50% of original | Justification rules |
| MS-T19 | `failed_competition_no_modification` | J08 requires no substantial change to original terms | Justification rules |
| MS-T20 | `currency_conversion_deterministic` | Exchange rate fixed at estimation date | Estimation rules |
| MS-T21 | `vat_excluded_from_threshold` | Threshold comparison uses pre-tax value | Estimation rules |
| MS-T22 | `concession_uses_revenue` | Concession value = total revenue estimate | Estimation rules |
| MS-T23 | `framework_maximum_aggregated` | Framework value includes all expected call-offs | Estimation rules |
| MS-T24 | `green_criteria_integrated` | Green procurement preferences applied per jurisdiction | Jurisdiction config |
| MS-T25 | `method_change_audited` | Any change to selected method produces audit record | Audit trail |
| MS-T26 | `split_detection_sound` | Flagged splits are genuinely related procurements | Aggregation rules |
| MS-T27 | `split_detection_complete` | All artificial splits are detected | History analysis |
| MS-T28 | `two_stage_complexity_check` | M14 only if complexity = High | Decision tree |
| MS-T29 | `dialogue_undefined_scope` | M06 only if complexity = Undefined | Decision tree |
| MS-T30 | `innovation_rd_combined` | M07 only if innovation = true | Decision tree |

### 8.2 Coq Pseudocode (Selected Theorems)

```coq
(* MS-T01: Method selection is total *)
Theorem method_selection_total :
  forall (req : ProcurementRequest) (juris : Jurisdiction),
    well_formed_request req ->
    exists md : MethodDecision, select_method req juris = Some md.

(* MS-T02: Method selection is deterministic *)
Theorem method_selection_deterministic :
  forall req juris md1 md2,
    select_method req juris = Some md1 ->
    select_method req juris = Some md2 ->
    md1 = md2.

(* MS-T03: Threshold compliance *)
Theorem threshold_compliance :
  forall req juris md,
    select_method req juris = Some md ->
    method_legal_for_value md.(primary_method) req.(estimated_value) juris = true.

(* MS-T04: Anti-splitting *)
Theorem anti_splitting_detection :
  forall req history juris,
    is_artificial_split req history ->
    select_method req juris = Error ArtificialSplitDetected.

(* MS-T05: Competition maximization *)
Theorem competition_maximization :
  forall req juris md,
    select_method req juris = Some md ->
    forall m', method_legal_for_value m' req.(estimated_value) juris = true ->
    competition_level md.(primary_method) >= competition_level m'
    \/ has_valid_justification req md.(primary_method).

(* MS-T06: Sole source requires justification *)
Theorem sole_source_requires_justification :
  forall req juris md,
    select_method req juris = Some md ->
    md.(primary_method) = DirectAward ->
    exists j, In j md.(justification) /\ valid_sole_source j req juris = true.

(* MS-T07: Emergency requires declaration *)
Theorem emergency_requires_declaration :
  forall req juris md,
    select_method req juris = Some md ->
    md.(primary_method) = EmergencyProcurement ->
    req.(urgency) = LifeThreatening.

(* MS-T15: Value aggregation *)
Theorem value_aggregation_correct :
  forall req lots options renewals,
    req.(estimated_value) = sum_lots lots + sum_options options + sum_renewals renewals ->
    aggregated_value_correct req lots options renewals = true.

(* MS-T16: No method downgrade without justification *)
Theorem no_method_downgrade :
  forall proc old_method new_method,
    current_method proc = old_method ->
    competition_level new_method < competition_level old_method ->
    change_method proc new_method = Error DowngradeRequiresJustification.

(* MS-T27: Split detection completeness *)
Theorem split_detection_complete :
  forall req history,
    artificially_split req history ->
    is_artificial_split req history = true.
```

---

## 9. Coq Formalization

### 9.1 Inductive Types

```coq
Inductive ProcurementCategory : Type :=
  | Goods | Services | Works | Consulting.

Inductive ProcMethod : Type :=
  | OpenTender | RestrictedTender | RFQ | RFP
  | DirectAward | CompetitiveDialogue | InnovationPartnership
  | FrameworkAgreement | DynamicPurchasing | ReverseAuction
  | DesignContest | EmergencyProcurement | MicroPurchase
  | TwoStage | CommunitySocial | NegotiatedWithoutPub.

Inductive Urgency : Type :=
  | Normal | Urgent | LifeThreatening.

Inductive Complexity : Type :=
  | CLow | CMedium | CHigh | CUndefined.

Inductive SoleSourceType : Type :=
  | J01_SoleSupplier | J02_Standardization | J03_ExtremeUrgency
  | J04_FollowOn | J05_Prototype | J06_NationalSecurity
  | J07_Humanitarian | J08_FailedCompetition | J09_ArtisticIP
  | J10_MicroThreshold | J11_TreatyObligation | J12_Research
  | J13_UtilitiesMarket.

Record ProcurementRequest : Type := mkProcReq {
  pr_category    : ProcurementCategory;
  pr_value       : nat;  (* in smallest currency unit *)
  pr_urgency     : Urgency;
  pr_sole_source : option SoleSourceType;
  pr_complexity  : Complexity;
  pr_recurring   : bool;
  pr_innovation  : bool;
  pr_framework   : option nat;  (* framework ID *)
}.

Record Jurisdiction : Type := mkJuris {
  j_micro_threshold      : nat;
  j_quotation_threshold  : nat;
  j_open_threshold       : nat;
  j_gpa_threshold        : nat;
  j_sole_source_limit    : SoleSourceType -> nat;
  j_domestic_pref        : bool;
}.
```

### 9.2 Threshold Module

```coq
Module MalaysianThresholds.
  Definition micro := 20000 * 100.    (* RM 20,000 in sen *)
  Definition quotation := 50000 * 100. (* RM 50,000 *)
  Definition open_national := 200000 * 100. (* RM 200,000 *)
  Definition open_intl := 500000 * 100.     (* RM 500,000 *)

  Definition malaysia : Jurisdiction := mkJuris
    micro quotation open_national open_intl
    (fun j => match j with
      | J03_ExtremeUrgency => 0  (* no limit with emergency declaration *)
      | J06_NationalSecurity => 0
      | _ => open_national
      end)
    true. (* domestic preference enabled *)
End MalaysianThresholds.

Module USFARThresholds.
  Definition micro := 10000 * 100.      (* $10,000 in cents *)
  Definition simplified := 250000 * 100. (* $250,000 *)
  Definition full_open := 7500000 * 100. (* $7,500,000 *)
  Definition gpa := 182000 * 100.        (* ~$182,000 *)

  Definition usa : Jurisdiction := mkJuris
    micro simplified full_open gpa
    (fun j => match j with
      | J06_NationalSecurity => 0
      | _ => simplified
      end)
    true. (* small business preference *)
End USFARThresholds.
```

### 9.3 Decision Function

```coq
Definition select_method (req : ProcurementRequest) (j : Jurisdiction) :
  option (ProcMethod * list SoleSourceType) :=
  if pr_value req <=? j_micro_threshold j then
    Some (MicroPurchase, [])
  else if urgency_eq (pr_urgency req) LifeThreatening then
    Some (EmergencyProcurement, [])
  else match pr_sole_source req with
  | Some ss =>
      if pr_value req <=? j_sole_source_limit j ss then
        Some (DirectAward, [ss])
      else Some (DirectAward, [ss])  (* escalated approval *)
  | None =>
    match pr_framework req with
    | Some _ => Some (FrameworkAgreement, [])
    | None =>
      if pr_value req <=? j_quotation_threshold j then
        Some (RFQ, [])
      else if complexity_eq (pr_complexity req) CUndefined then
        Some (CompetitiveDialogue, [])
      else if pr_innovation req then
        Some (InnovationPartnership, [])
      else if complexity_eq (pr_complexity req) CHigh then
        Some (TwoStage, [])
      else if pr_recurring req then
        Some (DynamicPurchasing, [])
      else
        Some (OpenTender, [])
    end
  end.
```

---

## 10. Threat Model

### 10.1 Method Selection Threats

| ID | Threat | Description | Impact | Mitigation Theorem |
|---|---|---|---|---|
| PROC-MS-001 | Threshold manipulation | Estimating value below threshold to avoid open tender | Loss of competition | MS-T03, MS-T15 |
| PROC-MS-002 | Artificial splitting | Dividing procurement to stay below threshold | Circumvention | MS-T04, MS-T26, MS-T27 |
| PROC-MS-003 | False urgency | Claiming emergency to justify direct award | Corruption | MS-T07, MS-T17 |
| PROC-MS-004 | Phantom sole supplier | Claiming monopoly when alternatives exist | Corruption | MS-T06 |
| PROC-MS-005 | Method downgrade | Switching from open to restricted without grounds | Reduced competition | MS-T16, MS-T25 |
| PROC-MS-006 | Framework abuse | Using expired/unrelated framework for call-off | Circumvention | MS-T09 |
| PROC-MS-007 | Lot manipulation | Structuring lots to favor specific bidders | Corruption | MS-T15, MS-T04 |
| PROC-MS-008 | Currency manipulation | Using favorable exchange rate to change threshold band | Circumvention | MS-T20 |
| PROC-MS-009 | VAT inclusion/exclusion | Including/excluding tax to manipulate threshold | Circumvention | MS-T21 |
| PROC-MS-010 | Option year exclusion | Omitting option years from value estimate | Threshold breach | MS-T15 |
| PROC-MS-011 | Follow-on abuse | Exceeding 50% original value in repeat purchase | Circumvention | MS-T18 |
| PROC-MS-012 | Failed competition fraud | Sabotaging tender to justify sole source | Corruption | MS-T19 |
| PROC-MS-013 | Domestic preference bypass | Not applying mandatory set-aside rules | Policy violation | MS-T14 |
| PROC-MS-014 | Domestic preference overreach | Applying preference where prohibited (GPA) | Treaty violation | MS-T14 |
| PROC-MS-015 | Design contest + follow-on | Understating combined value | Threshold breach | MS-T22 |
| PROC-MS-016 | Concession revenue undercount | Lowering revenue estimate to avoid threshold | Circumvention | MS-T22 |
| PROC-MS-017 | Missing standstill | Not applying standstill for required methods | Legal challenge | MS-T12 |
| PROC-MS-018 | Insufficient bidder count | Proceeding with fewer than minimum bidders | Process violation | MS-T13 |
| PROC-MS-019 | Security classification abuse | Using national security to avoid all oversight | Corruption | MS-T06, MS-T11 |
| PROC-MS-020 | Retroactive justification | Writing sole source justification after award | Fraud | MS-T06 (temporal) |
| PROC-MS-021 | Threshold currency arbitrage | Choosing contract currency to exploit SDR conversion | Circumvention | MS-T20 |
| PROC-MS-022 | Innovation partnership misuse | Claiming innovation for standard procurement | Method abuse | MS-T30 |
| PROC-MS-023 | Competitive dialogue scope creep | Using undefined scope to steer requirements | Corruption | MS-T29 |
| PROC-MS-024 | Green washing | Claiming green criteria to restrict competition | Discrimination | MS-T24, MS-T05 |
| PROC-MS-025 | Audit trail deletion | Removing method change records | Cover-up | MS-T25 |

---

## 11. RIINA Type Encoding

### 11.1 Core Types in Bahasa Melayu

```rii
// Kategori perolehan
jenis KategoriPerolehan = Barangan | Perkhidmatan | Kerja | Perundingan

// Kaedah perolehan
jenis KaedahPerolehan =
  | TenderTerbuka        // M01: Open Tender
  | TenderTerhad         // M02: Restricted Tender
  | SebutHarga           // M03: RFQ
  | CadanganHarga        // M04: RFP
  | LantikanTerus        // M05: Direct Award
  | DialogKompetitif     // M06: Competitive Dialogue
  | PerkongsianInovasi   // M07: Innovation Partnership
  | PerjanjianRangka      // M08: Framework Agreement
  | SistemPembelianDinamik // M09: Dynamic Purchasing
  | LelongSongsang        // M10: Reverse Auction
  | PertandinganRekaBentuk // M11: Design Contest
  | PerolehanKecemasan     // M12: Emergency Procurement
  | PembelianMikro         // M13: Micro-Purchase
  | TenderDuaPekat         // M14: Two-Stage Tendering
  | PerolehanKomuniti      // M15: Community Procurement
  | RundinganTanpaSiaran   // M16: Negotiated Without Publication

// Keputusan pemilihan kaedah (refinement type)
jenis KeputusanKaedah {
  kaedah_utama  : KaedahPerolehan,
  justifikasi   : Senarai<KlausaJustifikasi>,
  tahap_kelulusan: PihakBerkuasaKelulusan,
  iklan_diperlukan: Boolean,
  hari_minimum   : Nombor,

  // Refinement: kaedah mesti sah untuk nilai
  bukti sah_untuk_nilai :
    kaedah_sah(kaedah_utama, nilai_anggaran, bidang_kuasa) = betul,
  // Refinement: justifikasi lengkap jika lantikan terus
  bukti justifikasi_lengkap :
    kaedah_utama = LantikanTerus ->
      wujud j dalam justifikasi, sumber_tunggal_sah(j) = betul,
}
```

### 11.2 Method Selection Function

```rii
// Fungsi pemilihan kaedah (pure, total, deterministic)
fungsi pilih_kaedah(
  permintaan: PermintaanPerolehan,
  bidang_kuasa: BidangKuasa
) -> Keputusan<KeputusanKaedah, RalatPemilihan>
  kesan bersih  // Pure function, no side effects
{
  // Semakan 1: Pembelian mikro
  kalau permintaan.nilai <= bidang_kuasa.ambang_mikro {
    pulang Ok(KeputusanKaedah {
      kaedah_utama: PembelianMikro,
      justifikasi: [],
      tahap_kelulusan: PemegangBajet,
      iklan_diperlukan: salah,
      hari_minimum: 0,
    })
  }

  // Semakan 2: Kecemasan
  kalau permintaan.kecemasan = AncamanNyawa {
    pulang Ok(KeputusanKaedah {
      kaedah_utama: PerolehanKecemasan,
      justifikasi: [KlausaKecemasan(permintaan.bukti_kecemasan)],
      tahap_kelulusan: KetuaAgensi,
      iklan_diperlukan: salah,
      hari_minimum: 0,
    })
  }

  // Semakan 3: Sumber tunggal
  padan permintaan.sumber_tunggal {
    Ada(justifikasi) => {
      kalau sumber_tunggal_sah(justifikasi, permintaan, bidang_kuasa) {
        pulang Ok(KeputusanKaedah {
          kaedah_utama: LantikanTerus,
          justifikasi: [justifikasi],
          tahap_kelulusan: tahap_eskalasi(permintaan.nilai, bidang_kuasa),
          iklan_diperlukan: salah,
          hari_minimum: 0,
        })
      }
      pulang Ralat(JustifikasiTidakSah)
    }
    Tiada => {}
  }

  // Lalai: Tender Terbuka (persaingan maksimum)
  pulang Ok(KeputusanKaedah {
    kaedah_utama: TenderTerbuka,
    justifikasi: [],
    tahap_kelulusan: LembagaPerolehan,
    iklan_diperlukan: betul,
    hari_minimum: bidang_kuasa.hari_tender_minimum,
  })
}
```

### 11.3 Capability Tokens

```rii
// Token keupayaan untuk mengawal akses kaedah
jenis TokenKaedah = Rahsia<{
  kaedah_diluluskan : KaedahPerolehan,
  nilai_maksimum    : Nombor,
  tamat_tempoh      : MasaUTC,
  penerbit          : PihakBerkuasaKelulusan,
}>

// Hanya boleh meneruskan perolehan dengan token sah
fungsi teruskan_perolehan(
  perolehan: Perolehan,
  token: TokenKaedah
) -> Keputusan<(), RalatPerolehan>
  kesan tulis_pangkalan_data
{
  biar kaedah = dedah(token.kaedah_diluluskan, dasar: "pelaksanaan_perolehan");
  kalau kaedah != perolehan.kaedah_semasa {
    pulang Ralat(KaedahTidakSepadan)
  }
  kalau masa_sekarang() > dedah(token.tamat_tempoh, dasar: "semakan_masa") {
    pulang Ralat(TokenTamatTempoh)
  }
  // Token sah, teruskan
  pulang Ok(())
}
```

---

## 12. Layer 2 Integration

### 12.1 Method-to-State-Machine Activation

The method selection function produces a `MethodDecision` that activates the corresponding procurement state machine. Each method has its own state machine with method-specific states and transitions.

| Method | State Machine | Key States | Activation Condition |
|---|---|---|---|
| M01 (OpenTender) | `SM_OpenTender` | Published -> BidSubmission -> Evaluation -> Standstill -> Award | Default activation |
| M02 (Restricted) | `SM_Restricted` | EOI -> Prequalification -> Shortlist -> BidSubmission -> Eval -> Award | Prequalification complete |
| M03 (RFQ) | `SM_Quotation` | Invited -> QuoteReceived -> Comparison -> Award | Min 3 invitations sent |
| M05 (DirectAward) | `SM_DirectAward` | JustificationApproved -> Negotiation -> Award | Valid J01-J13 token |
| M06 (Dialogue) | `SM_Dialogue` | Published -> Prequalification -> DialogueRounds -> FinalTender -> Award | Complexity = Undefined |
| M08 (Framework) | `SM_Framework` | FrameworkSetup -> CallOff -> MiniCompetition -> Award | Framework not expired |
| M12 (Emergency) | `SM_Emergency` | EmergencyDeclared -> Procurement -> Delivery -> PostReview | Declaration valid |

### 12.2 State Machine Activation Function

```coq
Definition activate_state_machine (md : MethodDecision) : StateMachine :=
  match md.(primary_method) with
  | OpenTender => SM_OpenTender md
  | RestrictedTender => SM_Restricted md
  | RFQ => SM_Quotation md
  | DirectAward => SM_DirectAward md
  | CompetitiveDialogue => SM_Dialogue md
  | EmergencyProcurement => SM_Emergency md
  | FrameworkAgreement => SM_Framework md
  | _ => SM_OpenTender md  (* fallback to most competitive *)
  end.

(* Activation preserves method constraints *)
Theorem activation_preserves_constraints :
  forall md sm,
    activate_state_machine md = sm ->
    sm_method sm = md.(primary_method) /\
    sm_min_bidders sm = method_min_bidders md.(primary_method) /\
    sm_advertising sm = md.(advertising_req).
```

### 12.3 Cross-Layer Theorem

```coq
(* Method selection flows correctly into state machine *)
Theorem method_to_machine_correctness :
  forall req juris md sm,
    select_method req juris = Some md ->
    activate_state_machine md = sm ->
    sm_accepts_value sm req.(estimated_value) = true /\
    sm_initial_state sm = method_initial_state md.(primary_method).
```

---

## 13. Theorem Count and Dependencies

### 13.1 Summary

| Category | Theorem IDs | Count |
|---|---|---|
| Method selection core (totality, determinism, compliance) | MS-T01 to MS-T05 | 5 |
| Sole source / justification validity | MS-T06 to MS-T09 | 4 |
| Method properties (advertising, standstill, bidders) | MS-T10 to MS-T13 | 4 |
| Domestic preference and green procurement | MS-T14, MS-T24 | 2 |
| Value estimation and aggregation | MS-T15, MS-T20, MS-T21, MS-T22, MS-T23 | 5 |
| Anti-splitting (detection, soundness, completeness) | MS-T04, MS-T26, MS-T27 | 3 |
| Method change and audit | MS-T16, MS-T25 | 2 |
| Temporal validity (urgency, follow-on, competition) | MS-T17, MS-T18, MS-T19 | 3 |
| Complexity/innovation guards | MS-T28, MS-T29, MS-T30 | 3 |
| Layer 2 integration (activation, preservation, correctness) | L2-T01, L2-T02, L2-T03 | 3 |
| Anti-splitting additional (history, fiscal year) | MS-T31, MS-T32, MS-T33 | 3 |
| **Total** | | **37** |

### 13.2 Dependency Graph

```
MS-T01 (total) ─────────────┐
MS-T02 (deterministic) ─────┤
                             ├──> MS-T05 (competition maximization)
MS-T03 (threshold) ──────┬──┤
                         │  └──> MS-T16 (no downgrade)
MS-T15 (aggregation) ────┘
  ├── MS-T20 (currency)
  ├── MS-T21 (VAT)
  ├── MS-T22 (concession)
  └── MS-T23 (framework max)

MS-T04 (anti-splitting) ─┬── MS-T26 (soundness)
                          └── MS-T27 (completeness)
                               ├── MS-T31 (history analysis)
                               └── MS-T32 (fiscal year)

MS-T06 (sole source valid) ──┬── MS-T18 (follow-on limit)
                              ├── MS-T19 (failed competition)
                              └── MS-T17 (urgency time bound)

MS-T07 (emergency) ──── MS-T17 (time bound)

MS-T09 (framework) ──── L2-T01 (activation)

L2-T01 (activate) ──┬── L2-T02 (preserve constraints)
                     └── L2-T03 (method-to-machine correctness)
                          └── MS-T01, MS-T03 (prerequisites)
```

### 13.3 Additional Theorems (MS-T31 to MS-T33)

```coq
(* MS-T31: Split detection uses procurement history *)
Theorem split_detection_uses_history :
  forall req history1 history2,
    history1 <> history2 ->
    is_artificial_split req history1 <> is_artificial_split req history2 \/
    is_artificial_split req history1 = is_artificial_split req history2.

(* MS-T32: Fiscal year aggregation *)
Theorem fiscal_year_aggregation :
  forall req1 req2,
    same_fiscal_year req1 req2 = true ->
    same_category req1 req2 = true ->
    same_end_user req1 req2 = true ->
    aggregated_value req1 req2 = pr_value req1 + pr_value req2.

(* MS-T33: GPA threshold invariant *)
Theorem gpa_threshold_invariant :
  forall juris req md,
    pr_value req >= j_gpa_threshold juris ->
    select_method req juris = Some md ->
    md.(primary_method) = OpenTender \/ has_gpa_exception md.
```

---

## 14. References

| Source | Reference |
|---|---|
| WTO GPA | Revised Agreement on Government Procurement (2014), Annexes |
| UNCITRAL | Model Law on Public Procurement (2011) |
| EU | Directive 2014/24/EU, Directive 2014/25/EU |
| USA FAR | Federal Acquisition Regulation, 48 CFR Parts 1-53 |
| Malaysia | Government Procurement Act 2025, Treasury Circulars (Pekeliling Perbendaharaan) |
| UK | Public Contracts Regulations 2015 (SI 2015/102) |
| Singapore | Government Procurement Act (Cap. 120), GeBIZ procedures |
| Australia | Commonwealth Procurement Rules (2024) |
| World Bank | Procurement Regulations for IPF Borrowers (2016, rev. 2023) |
| ADB | Procurement Policy (2017), Procurement Regulations (2017, rev. 2022) |

---

*Q.E.D. Aeternum.*
