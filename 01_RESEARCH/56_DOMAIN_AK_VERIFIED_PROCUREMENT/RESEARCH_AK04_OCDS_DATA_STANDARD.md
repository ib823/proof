# RIINA Research Domain AK-04: OCDS (Open Contracting Data Standard) Compliance

## Document Control

```
Track: AK (Alpha-Kilo)
Document: AK-04
Version: 1.0.0
Date: 2026-02-01
Classification: FOUNDATIONAL
Status: SPECIFICATION
Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE
Depends: AK-01 (Procurement Foundation), AK-02 (Bid Integrity), AK-03 (Contract Lifecycle)
```

---

## Table of Contents

1. [AK-04: The Procurement Data Problem](#1-ak-04-the-procurement-data-problem)
2. [OCDS Background](#2-ocds-background)
3. [OCDS Data Model — Complete Schema Analysis](#3-ocds-data-model--complete-schema-analysis)
4. [OCDS Identifiers and Codelists](#4-ocds-identifiers-and-codelists)
5. [OCDS Extensions — Core and Community](#5-ocds-extensions--core-and-community)
6. [Schema Validation Rules](#6-schema-validation-rules)
7. [OCDS Record Model](#7-ocds-record-model)
8. [Formal Properties to Prove — Complete Theorem Catalog](#8-formal-properties-to-prove--complete-theorem-catalog)
9. [Coq Formalization Strategy](#9-coq-formalization-strategy)
10. [RIINA Type Encoding](#10-riina-type-encoding)
11. [Integration Points](#11-integration-points)
12. [Malaysian Context](#12-malaysian-context)
13. [Comparison with Other Data Standards](#13-comparison-with-other-data-standards)
14. [Threat Model](#14-threat-model)
15. [Estimated Theorem Count](#15-estimated-theorem-count)

---

## 1. AK-04: The Procurement Data Problem

### 1.1 The Existential Threat

Global public procurement represents **$13 trillion annually** — roughly 15% of global GDP. Despite this staggering scale, procurement data remains:

- **Fragmented**: Each jurisdiction uses its own schema, formats, and terminology
- **Incompatible**: Systems cannot exchange data without expensive custom integrations
- **Non-interoperable**: A contract in Malaysia cannot be compared with one in the UK
- **Opaque**: Citizens, auditors, and oversight bodies cannot access spending data in usable form
- **Self-asserted**: Compliance with any data standard is claimed, never verified
- **Lossy**: Data transformations between systems silently drop fields
- **Inconsistent**: The same procurement process may be described differently in different exports
- **Untimely**: Data is published in batches, often months after the fact

**The core failure**: No government procurement system can **prove** that its published data accurately and completely represents the underlying contracting process.

### 1.2 Why Standardized Procurement Data Matters

Standardized procurement data enables:

| Capability | Without Standard | With OCDS | With RIINA + OCDS |
|------------|-----------------|-----------|-------------------|
| Cross-country comparison | Impossible | Manual mapping | Automatic, verified |
| Fraud detection | Ad-hoc queries | Pattern analysis | Formally proven anomaly detection |
| Audit trail | Incomplete logs | Release history | Cryptographically signed, gap-free |
| Public oversight | FOIA requests | Open data portals | Verified completeness guarantees |
| Supplier analysis | Fragmented records | Linked entities | Verified identity, proven relationships |
| Value for money | Anecdotal | Statistical | Formally bounded, proven optimal |
| Compliance reporting | Manual spreadsheets | Automated export | Proven schema conformance |

### 1.3 The OCDS Promise — and Its Gap

The Open Contracting Data Standard (OCDS) was created to solve the interoperability problem. It provides a common JSON schema for describing contracting processes from planning through implementation. Over 50 countries have adopted it, and an estimated $2 trillion in procurement data has been published in OCDS format.

**But OCDS has a critical gap**: compliance is self-asserted.

A government can claim OCDS compliance while:
- Omitting required fields
- Publishing stale data
- Violating lifecycle constraints
- Producing records that don't match underlying releases
- Selectively publishing favorable data
- Tampering with data post-publication

**RIINA closes this gap.** By encoding the OCDS schema, validation rules, lifecycle constraints, and record compilation logic as formally verified types and functions, RIINA guarantees that:

```
THEOREM ocds_verified_compliance:
  forall (sys : RIINAProcurementSystem) (release : OCDSRelease),
    Published(sys, release) ->
    SchemaValid(release) /\
    LifecycleConsistent(release) /\
    RecordCompilationCorrect(sys) /\
    NoSelectiveOmission(sys, release) /\
    TamperEvident(release)
```

### 1.4 Scope of This Document

This document provides:

1. **Complete OCDS schema analysis** — Every field, type, constraint, and cardinality
2. **Full validation rule catalog** — Every rule the standard mandates
3. **Lifecycle constraint specification** — Valid state transitions and temporal ordering
4. **Record compilation semantics** — How releases become records, with correctness criteria
5. **90 formal theorems** — Complete catalog of properties to prove in Coq
6. **Coq formalization strategy** — Module structure and proof approach
7. **RIINA type encoding** — How OCDS maps to RIINA's type system
8. **Threat model** — 15+ threats against OCDS data integrity
9. **Extension framework** — Core, community, and RIINA-specific extensions

---

## 2. OCDS Background

### 2.1 Open Contracting Partnership (OCP)

The Open Contracting Partnership is a non-profit organization founded in 2015, evolving from work initiated by the World Bank in 2012. Key facts:

| Attribute | Detail |
|-----------|--------|
| Founded | 2015 (preceded by World Bank initiative, 2012) |
| Type | Non-profit, independent |
| Headquarters | Washington, D.C. |
| Staff | ~50 |
| Countries engaged | 50+ |
| Annual budget | ~$10M |
| Key funders | Omidyar Network, DFID, World Bank, Open Society Foundations |
| Standard maintained | OCDS (Open Contracting Data Standard) |
| Website | open-contracting.org |
| Schema repository | standard.open-contracting.org |

### 2.2 Endorsements and Adoption

OCDS has been endorsed or mandated by:

| Endorser | Year | Nature |
|----------|------|--------|
| G7 | 2016 | Anti-Corruption commitment |
| G20 | 2015 | Open Data principles |
| European Union | 2019 | eForms alignment study |
| World Bank | 2016 | Procurement framework requirement |
| EBRD | 2018 | Project procurement transparency |
| Inter-American Development Bank (IADB) | 2017 | Regional procurement standard |
| African Development Bank (AfDB) | 2019 | Procurement modernization |
| Asian Development Bank (ADB) | 2020 | Procurement data initiative |
| Open Government Partnership | 2015 | National Action Plan commitments |
| Transparency International | 2016 | Integrity Pact data standard |

### 2.3 OCDS Versioning

| Version | Date | Key Changes |
|---------|------|-------------|
| 1.0.0 | 2014-11 | Initial release |
| 1.0.1 | 2015-04 | Bug fixes, clarifications |
| 1.0.2 | 2016-01 | Additional codelists |
| 1.1.0 | 2017-05 | Amendments, milestones, relatedProcesses |
| 1.1.1 | 2017-07 | Patch release |
| 1.1.2 | 2018-01 | Clarifications |
| 1.1.3 | 2019-06 | Additional guidance |
| 1.1.4 | 2020-08 | Minor corrections |
| 1.1.5 | 2023-01 | Codelist updates |
| 1.2.0 | 2025 (draft) | Major revision: finance, planning, sustainability |

**RIINA targets OCDS 1.1.5** as the stable baseline, with forward compatibility to 1.2.0.

### 2.4 Technical Foundation

OCDS is built on:

- **JSON Schema** (Draft 4) — Schema definition language
- **JSON Merge Patch** (RFC 7396) — Record compilation strategy
- **ISO 8601** — Date-time formatting
- **ISO 4217** — Currency codes
- **ISO 3166-1 alpha-2** — Country codes
- **HTTP/HTTPS** — Data access protocol
- **org-id.guide** — Organization identifier registry
- **IANA media types** — Document format identification

### 2.5 Global Implementations

Notable OCDS implementations (30+ globally):

| Country | System | Scale | Since |
|---------|--------|-------|-------|
| Ukraine | ProZorro | $12B+ annual | 2016 |
| Colombia | SECOP II | $20B+ annual | 2017 |
| Paraguay | DNCP Portal | $3B+ annual | 2015 |
| United Kingdom | Contracts Finder | $40B+ annual | 2018 |
| Mexico | CompraNet | $30B+ annual | 2016 |
| Moldova | MTender | $1B+ annual | 2018 |
| Argentina | Compr.Ar | $5B+ annual | 2019 |
| Nigeria | NOCOPO | $10B+ annual | 2020 |
| France | Data.gouv.fr | $100B+ annual | 2019 |
| Canada | Buyandsell.gc.ca | $15B+ annual | 2020 |
| Afghanistan | ARDS | $2B+ annual | 2018 |
| Honduras | HonduCompras | $1B+ annual | 2017 |

**Estimated total**: Over $2 trillion in procurement data published in OCDS format globally.

---

## 3. OCDS Data Model — Complete Schema Analysis

### 3.1 Top-Level Structure

An OCDS **release package** contains:

```json
{
  "uri": "https://example.gov/ocds/releases/2026-01.json",
  "publishedDate": "2026-01-15T10:30:00Z",
  "publisher": {
    "name": "Ministry of Finance",
    "scheme": "org-id",
    "uid": "MY-MOF",
    "uri": "https://mof.gov.my"
  },
  "license": "http://opendatacommons.org/licenses/pddl/1.0/",
  "version": "1.1",
  "extensions": [],
  "releases": [ ... ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| uri | string (uri) | Yes | Package URI |
| publishedDate | string (date-time) | Yes | Publication timestamp |
| publisher | Publisher | Yes | Publishing organization |
| license | string (uri) | No | Data license |
| version | string | Yes | OCDS version |
| extensions | array of string (uri) | No | Extension URIs |
| releases | array of Release | Yes | Release objects |

### 3.2 Release — The Fundamental Unit

A **release** is an event in the life of a contracting process. Each release describes the state of the process at a point in time.

```json
{
  "ocid": "ocds-abc123-procurement-2026-001",
  "id": "release-001-tender",
  "date": "2026-01-15T10:00:00Z",
  "tag": ["tender"],
  "initiationType": "tender",
  "language": "ms",
  "parties": [ ... ],
  "buyer": { ... },
  "planning": { ... },
  "tender": { ... },
  "awards": [ ... ],
  "contracts": [ ... ]
}
```

#### 3.2.1 Release Top-Level Fields

| Field | Type | Required | Cardinality | Description |
|-------|------|----------|-------------|-------------|
| ocid | string | Yes | 1 | Open Contracting ID — globally unique process identifier |
| id | string | Yes | 1 | Release ID — unique within the contracting process |
| date | string (date-time) | Yes | 1 | Release date-time (ISO 8601) |
| tag | array of string | Yes | 1..* | Release tags from closed codelist |
| initiationType | string | Yes | 1 | How the process was initiated (closed codelist) |
| language | string | No | 0..1 | Default language (ISO 639-1) |
| parties | array of Organization | No | 0..* | All organizations involved |
| buyer | OrganizationReference | No | 0..1 | The buying entity |
| planning | Planning | No | 0..1 | Planning section |
| tender | Tender | No | 0..1 | Tender section |
| awards | array of Award | No | 0..* | Award objects |
| contracts | array of Contract | No | 0..* | Contract objects |
| relatedProcesses | array of RelatedProcess | No | 0..* | Links to related processes |

#### 3.2.2 Tag Values (Closed Codelist)

| Tag | Description | Implies Section |
|-----|-------------|-----------------|
| planning | Planning process disclosed | planning |
| planningUpdate | Update to planning | planning |
| tender | Tender announced | tender |
| tenderAmendment | Formal amendment to tender | tender |
| tenderUpdate | Update to tender details | tender |
| tenderCancellation | Tender cancelled | tender |
| award | Award made | awards |
| awardUpdate | Update to award | awards |
| awardCancellation | Award cancelled | awards |
| contract | Contract signed | contracts |
| contractUpdate | Update to contract | contracts |
| contractAmendment | Formal amendment to contract | contracts |
| implementation | Implementation details | contracts.implementation |
| implementationUpdate | Update to implementation | contracts.implementation |
| compiled | Compiled release (record) | all |

#### 3.2.3 Initiation Type (Closed Codelist)

| Value | Description |
|-------|-------------|
| tender | Initiated by a tender/solicitation |

*Note: OCDS 1.1 only defines "tender". Version 1.2 may add additional values.*

### 3.3 Planning Section

The planning section describes the background to a contracting process.

```json
{
  "planning": {
    "rationale": "Replace aging fleet vehicles for district offices",
    "budget": {
      "id": "BUDGET-2026-MOF-001",
      "description": "Fleet modernization program",
      "amount": {
        "amount": 5000000.00,
        "currency": "MYR"
      },
      "project": "Fleet Modernization Phase 2",
      "projectID": "FM-2026-002",
      "uri": "https://budget.mof.gov.my/projects/FM-2026-002"
    },
    "documents": [ ... ],
    "milestones": [ ... ]
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| rationale | string | No | Rationale for the procurement |
| budget | Budget | No | Budget information |
| budget.id | string | No | Budget line identifier |
| budget.description | string | No | Budget description |
| budget.amount | Value | No | Budget amount |
| budget.project | string | No | Project name |
| budget.projectID | string | No | Project identifier |
| budget.uri | string (uri) | No | Link to budget document |
| budget.source | string | No | Funding source |
| documents | array of Document | No | Planning documents |
| milestones | array of Milestone | No | Planning milestones |

### 3.4 Tender Section

The tender section describes the solicitation and bidding process.

#### 3.4.1 Core Tender Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Tender identifier |
| title | string | No | Tender title |
| description | string | No | Tender description |
| status | string | No | Tender status (open codelist) |
| procuringEntity | OrganizationReference | No | Entity managing procurement |
| items | array of Item | No | Items being procured |
| minValue | Value | No | Minimum estimated value |
| value | Value | No | Maximum estimated value |
| procurementMethod | string | No | Procurement method (closed codelist) |
| procurementMethodDetails | string | No | Additional method details |
| procurementMethodRationale | string | No | Rationale for method choice |
| mainProcurementCategory | string | No | Main category (closed codelist) |
| additionalProcurementCategories | array of string | No | Additional categories |
| awardCriteria | string | No | Award criteria (open codelist) |
| awardCriteriaDetails | string | No | Criteria details |
| submissionMethod | array of string | No | How bids are submitted |
| submissionMethodDetails | string | No | Submission details |
| tenderPeriod | Period | No | Tender open period |
| enquiryPeriod | Period | No | Enquiry period |
| hasEnquiries | boolean | No | Whether enquiries were received |
| awardPeriod | Period | No | Expected award period |
| contractPeriod | Period | No | Expected contract period |
| numberOfTenderers | integer | No | Number of tenderers |
| tenderers | array of OrganizationReference | No | Tenderer organizations |
| documents | array of Document | No | Tender documents |
| milestones | array of Milestone | No | Tender milestones |
| amendments | array of Amendment | No | Tender amendments |
| eligibilityCriteria | string | No | Eligibility criteria text |
| legalBasis | Classification | No | Legal basis for procurement |

#### 3.4.2 Procurement Method (Closed Codelist)

| Value | Description | Typical Use |
|-------|-------------|-------------|
| open | Open tendering | Default for most procurement |
| selective | Selective/restricted tendering | Pre-qualified bidders only |
| limited | Limited tendering | Specific justification required |
| direct | Direct procurement | Single-source, emergency |

#### 3.4.3 Main Procurement Category (Closed Codelist)

| Value | Description |
|-------|-------------|
| goods | Physical products |
| works | Construction, infrastructure |
| services | Professional/consulting services |

#### 3.4.4 Award Criteria (Open Codelist)

| Value | Description |
|-------|-------------|
| priceOnly | Lowest price wins |
| costOnly | Lowest cost (lifecycle) |
| qualityOnly | Highest quality score |
| ratedCriteria | Multi-criteria evaluation |
| lowestCost | Lowest evaluated cost |
| bestProposal | Best overall proposal |

#### 3.4.5 Tender Status (Open Codelist)

| Value | Description |
|-------|-------------|
| planning | Pre-tender stage |
| planned | Planned but not yet active |
| active | Open for submissions |
| cancelled | Cancelled |
| unsuccessful | No valid bids received |
| complete | Evaluation complete, awards made |
| withdrawn | Withdrawn by procuring entity |

### 3.5 Award Section

The award section describes decisions to award contracts.

```json
{
  "awards": [
    {
      "id": "award-001",
      "title": "Fleet vehicles supply",
      "description": "Award for supply of 50 fleet vehicles",
      "status": "active",
      "date": "2026-03-01T14:00:00Z",
      "value": {
        "amount": 4500000.00,
        "currency": "MYR"
      },
      "suppliers": [
        {
          "name": "Proton Holdings Bhd",
          "id": "MY-SSM-12345678"
        }
      ],
      "items": [ ... ],
      "contractPeriod": { ... },
      "documents": [ ... ],
      "amendments": [ ... ]
    }
  ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Award identifier (unique within release) |
| title | string | No | Award title |
| description | string | No | Award description |
| status | string | No | Award status (open codelist) |
| date | string (date-time) | No | Award date |
| value | Value | No | Award value |
| suppliers | array of OrganizationReference | No | Winning supplier(s) |
| items | array of Item | No | Awarded items |
| contractPeriod | Period | No | Expected contract period |
| documents | array of Document | No | Award documents |
| amendments | array of Amendment | No | Award amendments |

#### 3.5.1 Award Status (Open Codelist)

| Value | Description |
|-------|-------------|
| pending | Under evaluation |
| active | Award confirmed |
| cancelled | Award cancelled |
| unsuccessful | No award made |

### 3.6 Contract Section

The contract section describes signed contracts and their implementation.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Contract identifier |
| awardID | string | Yes | Reference to award |
| title | string | No | Contract title |
| description | string | No | Contract description |
| status | string | No | Contract status (open codelist) |
| period | Period | No | Contract period |
| value | Value | No | Contract value |
| dateSigned | string (date-time) | No | Signing date |
| items | array of Item | No | Contract items |
| documents | array of Document | No | Contract documents |
| implementation | Implementation | No | Implementation details |
| amendments | array of Amendment | No | Contract amendments |
| relatedProcesses | array of RelatedProcess | No | Related processes |

#### 3.6.1 Contract Status (Open Codelist)

| Value | Description |
|-------|-------------|
| pending | Signed but not yet active |
| active | Currently being implemented |
| cancelled | Cancelled |
| terminated | Terminated early |

### 3.7 Implementation Section

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| transactions | array of Transaction | No | Payment transactions |
| milestones | array of Milestone | No | Implementation milestones |
| documents | array of Document | No | Implementation documents |

#### 3.7.1 Transaction

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Transaction identifier |
| source | string (uri) | No | Data source URI |
| date | string (date-time) | No | Transaction date |
| value | Value | No | Transaction value |
| payer | OrganizationReference | No | Paying organization |
| payee | OrganizationReference | No | Receiving organization |
| uri | string (uri) | No | Transaction record URI |

### 3.8 Organization (Parties Array)

Every organization mentioned in a release MUST appear in the top-level `parties` array with full details. Other sections reference organizations by `id` and `name` only.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | Organization name |
| id | string | Yes | Unique ID within this release |
| identifier | Identifier | No | Primary legal identifier |
| identifier.scheme | string | No | Identifier scheme (from org-id.guide) |
| identifier.id | string | No | Identifier value |
| identifier.legalName | string | No | Legal name |
| identifier.uri | string (uri) | No | Organization URI |
| additionalIdentifiers | array of Identifier | No | Additional identifiers |
| address | Address | No | Registered address |
| address.streetAddress | string | No | Street address |
| address.locality | string | No | City/town |
| address.region | string | No | State/province |
| address.postalCode | string | No | Postal code |
| address.countryName | string | No | Country name |
| contactPoint | ContactPoint | No | Contact information |
| contactPoint.name | string | No | Contact name |
| contactPoint.email | string | No | Email address |
| contactPoint.telephone | string | No | Phone number |
| contactPoint.faxNumber | string | No | Fax number |
| contactPoint.url | string (uri) | No | Contact URL |
| roles | array of string | Yes | Organization roles (open codelist) |
| details | object | No | Additional details (extension point) |

#### 3.8.1 Organization Roles (Open Codelist)

| Role | Description |
|------|-------------|
| buyer | The entity purchasing |
| procuringEntity | Entity managing the procurement |
| supplier | Entity awarded/contracted |
| tenderer | Entity that submitted a bid |
| funder | Entity providing funding |
| enquirer | Entity that submitted an enquiry |
| payer | Entity making payment |
| payee | Entity receiving payment |
| reviewBody | Entity handling complaints/reviews |

### 3.9 Item

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Item identifier (unique within array) |
| description | string | No | Item description |
| classification | Classification | No | Primary classification |
| classification.scheme | string | No | Classification scheme |
| classification.id | string | No | Classification code |
| classification.description | string | No | Classification description |
| classification.uri | string (uri) | No | Classification URI |
| additionalClassifications | array of Classification | No | Additional classifications |
| quantity | number | No | Quantity |
| unit | Unit | No | Unit of measure |
| unit.scheme | string | No | Unit scheme |
| unit.id | string | No | Unit code |
| unit.name | string | No | Unit name |
| unit.value | Value | No | Unit price |
| deliveryLocation | Location | No | Delivery location |
| deliveryAddress | Address | No | Delivery address |

### 3.10 Common Building Blocks

#### 3.10.1 Period

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| startDate | string (date-time) | No | Start date (ISO 8601) |
| endDate | string (date-time) | No | End date (ISO 8601) |
| maxExtentDate | string (date-time) | No | Maximum possible end date |
| durationInDays | integer | No | Duration in days |

#### 3.10.2 Value

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| amount | number | No | Monetary amount |
| currency | string | No | Currency code (ISO 4217) |

#### 3.10.3 Document

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Document identifier |
| documentType | string | No | Type from codelist |
| title | string | No | Document title |
| description | string | No | Document description |
| url | string (uri) | No | Document URL |
| datePublished | string (date-time) | No | Publication date |
| dateModified | string (date-time) | No | Modification date |
| format | string | No | MIME type |
| language | string | No | Document language |

#### 3.10.4 Amendment

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | No | Amendment identifier |
| date | string (date-time) | No | Amendment date |
| rationale | string | No | Reason for amendment |
| description | string | No | Amendment description |
| amendsReleaseID | string | No | ID of release being amended |
| releaseID | string | No | ID of this amendment release |
| changes | array of object | No | Deprecated — field-level changes |

#### 3.10.5 Milestone

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Milestone identifier |
| title | string | No | Milestone title |
| type | string | No | Milestone type (open codelist) |
| description | string | No | Description |
| code | string | No | Milestone code |
| dueDate | string (date-time) | No | Due date |
| dateMet | string (date-time) | No | Date met |
| dateModified | string (date-time) | No | Last modified |
| status | string | No | Status (open codelist) |

#### 3.10.6 Milestone Type (Open Codelist)

| Value | Description |
|-------|-------------|
| preProcurement | Pre-procurement milestone |
| engagement | Public engagement |
| approval | Approval milestone |
| assessment | Assessment milestone |
| delivery | Delivery milestone |
| reporting | Reporting milestone |
| financing | Financing milestone |

#### 3.10.7 Milestone Status (Open Codelist)

| Value | Description |
|-------|-------------|
| scheduled | Not yet due |
| met | Completed on time |
| notMet | Not completed by due date |
| partiallyMet | Partially completed |

---

## 4. OCDS Identifiers and Codelists

### 4.1 OCID Format

The Open Contracting Identifier (OCID) is a globally unique identifier for a contracting process.

**Format**: `ocds-{prefix}-{local-identifier}`

| Component | Description | Example |
|-----------|-------------|---------|
| `ocds` | Fixed prefix | `ocds` |
| `{prefix}` | 6-character publisher prefix (registered with OCP) | `abc123` |
| `{local-identifier}` | Publisher-assigned local identifier | `tender-2026-0042` |

**Full example**: `ocds-abc123-tender-2026-0042`

**Constraints**:
- The `ocds-` prefix is mandatory
- The publisher prefix MUST be registered with OCP
- The local identifier MUST be unique within the publisher's dataset
- The full OCID MUST be globally unique
- Characters: alphanumeric, hyphens, underscores only
- Maximum length: not formally specified, recommended under 256 characters

**Regex pattern**: `^ocds-[a-z0-9]{6}-[a-zA-Z0-9_-]+$`

### 4.2 Open Codelists vs Closed Codelists

OCDS distinguishes between:

| Type | Extensible | Validation | Examples |
|------|-----------|------------|----------|
| Closed | No — only listed values allowed | Strict enum | tag, initiationType, procurementMethod, mainProcurementCategory |
| Open | Yes — custom values allowed | Warning only | status fields, documentType, awardCriteria, roles |

**RIINA approach**: Closed codelists are encoded as `Inductive` types in Coq. Open codelists are encoded as string types with a `known_values` predicate for standard values and a `Valid_open_codelist` property for custom values.

### 4.3 Document Type Codelist (~50 Types)

| Code | Section | Description |
|------|---------|-------------|
| plannedProcurementNotice | planning | Notice of planned procurement |
| tenderNotice | tender | Tender notice/advertisement |
| awardNotice | award | Award notice |
| contractNotice | contract | Contract notice |
| completionCertificate | implementation | Certificate of completion |
| procurementPlan | planning | Procurement plan document |
| biddingDocuments | tender | Bidding/solicitation documents |
| technicalSpecifications | tender | Technical specifications |
| evaluationCriteria | tender | Evaluation criteria |
| evaluationReports | award | Evaluation report |
| contractDraft | tender | Draft contract |
| contractSigned | contract | Signed contract |
| contractArrangements | contract | Contract arrangements |
| contractSchedule | contract | Contract schedule |
| physicalProgressReport | implementation | Physical progress report |
| financialProgressReport | implementation | Financial progress report |
| finalAudit | implementation | Final audit report |
| hearingNotice | tender | Public hearing notice |
| marketStudies | planning | Market research/studies |
| eligibilityCriteria | tender | Eligibility criteria |
| clarifications | tender | Clarification responses |
| shortlistedFirms | tender | Shortlisted firms |
| environmentalImpact | planning | Environmental impact assessment |
| assetAndLiabilityAssessment | planning | Financial assessment |
| riskProvisions | planning | Risk provisions |
| winningBid | award | Winning bid documents |
| complaints | review | Complaint documents |
| contractAnnex | contract | Contract annex |
| contractGuarantees | contract | Performance guarantees |
| subContract | implementation | Subcontract documents |
| needsAssessment | planning | Needs assessment |
| feasibilityStudy | planning | Feasibility study |
| projectPlan | planning | Project plan |
| billOfQuantities | tender | Bill of quantities |
| bidders | tender | List of bidders |
| conflictOfInterest | award | Conflict of interest declarations |
| debarments | tender | Debarment information |
| illustration | tender | Technical illustrations |
| submissionDocuments | tender | Submission templates |
| contractSummary | contract | Contract summary |
| cancellationDetails | tender/award | Cancellation details |

### 4.4 Item Classification Schemes

| Scheme | Full Name | Coverage | Owner |
|--------|-----------|----------|-------|
| CPV | Common Procurement Vocabulary | EU standard, ~9,500 codes | European Commission |
| UNSPSC | UN Standard Products and Services Code | Global, ~60,000 codes | GS1 US |
| CPC | Central Product Classification | UN standard | UN Statistics Division |
| NAICS | North American Industry Classification | US/Canada/Mexico | US Census Bureau |
| ISIC | International Standard Industrial Classification | Global | UN Statistics Division |
| GSIN | Goods and Services Identification Number | Canada | Government of Canada |
| NIGP | National Institute of Governmental Purchasing | US states/local | NIGP |

### 4.5 Currency Codes (ISO 4217)

OCDS uses ISO 4217 three-letter currency codes. Key codes for RIINA context:

| Code | Currency | Country |
|------|----------|---------|
| MYR | Malaysian Ringgit | Malaysia |
| USD | US Dollar | United States |
| EUR | Euro | Eurozone |
| GBP | Pound Sterling | United Kingdom |
| SGD | Singapore Dollar | Singapore |
| JPY | Japanese Yen | Japan |
| CNY | Chinese Yuan | China |
| AUD | Australian Dollar | Australia |
| THB | Thai Baht | Thailand |
| IDR | Indonesian Rupiah | Indonesia |
| PHP | Philippine Peso | Philippines |

### 4.6 Organization Identifier Schemes (org-id.guide)

| Scheme | Description | Country |
|--------|-------------|---------|
| MY-SSM | Suruhanjaya Syarikat Malaysia | Malaysia |
| MY-MOF | Ministry of Finance registration | Malaysia |
| GB-COH | Companies House | UK |
| US-EIN | Employer Identification Number | US |
| XE-DUNS | Dun & Bradstreet DUNS | International |
| XE-LEI | Legal Entity Identifier | International |
| UA-EDR | Unified State Register | Ukraine |
| CO-RUE | Registro Unico Empresarial | Colombia |

---

## 5. OCDS Extensions — Core and Community

### 5.1 Core Extensions

Core extensions are maintained by OCP and cover commonly needed functionality not in the base schema.

#### 5.1.1 Bid Statistics Extension

Adds structured bid statistics to tender and lot objects.

```json
{
  "tender": {
    "bids": {
      "statistics": [
        {
          "id": "1",
          "measure": "numberOfBids",
          "value": 12,
          "date": "2026-02-15T17:00:00Z"
        },
        {
          "id": "2",
          "measure": "numberOfQualifiedBids",
          "value": 8
        }
      ],
      "details": [
        {
          "id": "bid-001",
          "date": "2026-02-14T09:00:00Z",
          "status": "valid",
          "tenderers": [{ "id": "MY-SSM-12345678", "name": "Syarikat ABC" }],
          "value": { "amount": 4200000, "currency": "MYR" }
        }
      ]
    }
  }
}
```

#### 5.1.2 Enquiries Extension

Adds structured enquiry/question-and-answer data.

| Field | Type | Description |
|-------|------|-------------|
| id | string | Enquiry identifier |
| date | date-time | Enquiry date |
| author | OrganizationReference | Who asked |
| title | string | Question title |
| description | string | Question text |
| answer | string | Response text |
| dateAnswered | date-time | Response date |
| relatedItem | string | Related item ID |
| relatedLot | string | Related lot ID |

#### 5.1.3 Location Extension

Adds geographic coordinates and geometry to items and projects.

| Field | Type | Description |
|-------|------|-------------|
| geometry.type | string | GeoJSON type (Point, MultiPoint, LineString, etc.) |
| geometry.coordinates | array | GeoJSON coordinates |
| gazetteer.scheme | string | Gazetteer scheme |
| gazetteer.identifiers | array | Place identifiers |
| uri | string | Location URI |

#### 5.1.4 Lots Extension

Splits a tender into multiple lots, each independently awardable.

| Field | Type | Description |
|-------|------|-------------|
| tender.lots | array of Lot | Lot objects |
| lot.id | string | Lot identifier |
| lot.title | string | Lot title |
| lot.description | string | Lot description |
| lot.status | string | Lot status |
| lot.value | Value | Lot estimated value |
| lot.contractPeriod | Period | Lot contract period |
| award.relatedLots | array of string | Lots this award covers |
| bid.relatedLots | array of string | Lots this bid covers |

#### 5.1.5 Participation Fee Extension

Describes fees for tender document access or bid submission.

| Field | Type | Description |
|-------|------|-------------|
| tender.participationFees | array of ParticipationFee | Fee objects |
| participationFee.id | string | Fee identifier |
| participationFee.type | string | Fee type (document, deposit, submission, win) |
| participationFee.value | Value | Fee amount |
| participationFee.description | string | Fee description |
| participationFee.methodOfPayment | array of string | Payment methods |

#### 5.1.6 Process Level Title and Description

Adds top-level title and description to the release.

| Field | Type | Description |
|-------|------|-------------|
| title | string | Process title |
| description | string | Process description |

### 5.2 Community Extensions (Selected)

| Extension | Description | Fields Added |
|-----------|-------------|--------------|
| Beneficial Ownership | Ultimate beneficial owners | parties.beneficialOwners |
| Budget Breakdown | Detailed budget components | planning.budget.budgetBreakdown |
| Contract Completion | Completion status and dates | contracts.implementation.finalValue, endDate |
| Covered By | Trade agreement coverage | tender.coveredBy |
| Metrics | Key performance indicators | planning.metrics, contracts.implementation.metrics |
| Shareholders | Organization shareholding | parties.shareholders |
| Subcontracting | Subcontract terms | award.subcontracting, contract.subcontracting |
| Bid Opening | Bid opening details | tender.bidOpening |
| Contract Signatories | Signing parties | contracts.signatories |
| Charges | Fees and charges breakdown | contracts.charges |
| Finance | Project financing details | planning.budget.finance |

### 5.3 RIINA-Specific Extension (Proposed)

RIINA proposes a custom OCDS extension that adds formal verification metadata to procurement data.

#### 5.3.1 Extension Schema

```json
{
  "definitions": {
    "Release": {
      "properties": {
        "riina": {
          "title": "RIINA Verification Metadata",
          "type": "object",
          "properties": {
            "proofCertificate": {
              "title": "Proof Certificate",
              "type": "object",
              "properties": {
                "id": { "type": "string" },
                "proverVersion": { "type": "string" },
                "compilerVersion": { "type": "string" },
                "timestamp": { "type": "string", "format": "date-time" },
                "hash": { "type": "string" },
                "theorems": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "id": { "type": "string" },
                      "name": { "type": "string" },
                      "status": { "type": "string", "enum": ["Qed", "Admitted"] },
                      "coqFile": { "type": "string" }
                    }
                  }
                }
              }
            },
            "verificationStatus": {
              "type": "string",
              "enum": ["verified", "partial", "unverified"]
            },
            "schemaConformance": { "type": "boolean" },
            "lifecycleConsistency": { "type": "boolean" },
            "integrityHash": { "type": "string" },
            "signatureChain": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "signer": { "type": "string" },
                  "algorithm": { "type": "string" },
                  "signature": { "type": "string" },
                  "timestamp": { "type": "string", "format": "date-time" }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

#### 5.3.2 Example Usage

```json
{
  "ocid": "ocds-riina1-tender-2026-001",
  "id": "release-001",
  "date": "2026-01-15T10:00:00Z",
  "tag": ["tender"],
  "initiationType": "tender",
  "riina": {
    "verificationStatus": "verified",
    "schemaConformance": true,
    "lifecycleConsistency": true,
    "integrityHash": "sha3-256:a1b2c3d4e5f6...",
    "proofCertificate": {
      "id": "cert-2026-001",
      "proverVersion": "Rocq 9.1",
      "compilerVersion": "riinac 0.1.0",
      "timestamp": "2026-01-15T10:00:00Z",
      "hash": "sha3-256:f6e5d4c3b2a1...",
      "theorems": [
        { "id": "OCDS-001", "name": "release_required_fields", "status": "Qed", "coqFile": "Validation.v" },
        { "id": "OCDS-010", "name": "period_start_leq_end", "status": "Qed", "coqFile": "Validation.v" }
      ]
    },
    "signatureChain": [
      {
        "signer": "riinac-compiler",
        "algorithm": "Ed25519",
        "signature": "base64:...",
        "timestamp": "2026-01-15T10:00:00Z"
      }
    ]
  }
}
```

---

## 6. Schema Validation Rules

### 6.1 Required Field Validation

Every OCDS release MUST contain:

| Field | Type | Always Required |
|-------|------|-----------------|
| ocid | string | Yes |
| id | string | Yes |
| date | date-time | Yes |
| tag | array | Yes (at least one value) |
| initiationType | string | Yes |

**Conditional requirements by tag**:

| Tag | Required Sections/Fields |
|-----|--------------------------|
| planning, planningUpdate | planning section present |
| tender, tenderAmendment, tenderUpdate, tenderCancellation | tender section present |
| award, awardUpdate, awardCancellation | awards array non-empty |
| contract, contractUpdate, contractAmendment | contracts array non-empty |
| implementation, implementationUpdate | contracts array with implementation |

### 6.2 Type Constraints

| JSON Type | Coq Encoding | Validation |
|-----------|-------------|------------|
| string | `string` | Non-null string |
| number | `Q` (rational) | Valid JSON number |
| integer | `Z` | No decimal point |
| boolean | `bool` | true or false |
| null | `option T` | Explicit null |
| array | `list T` | Ordered collection |
| object | `Record` | Named fields |

### 6.3 Format Constraints

| Format | Specification | Regex / Validation |
|--------|--------------|-------------------|
| date-time | ISO 8601 | `^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$` |
| uri | RFC 3986 | Valid URI syntax |
| email | RFC 5322 | Valid email syntax |

### 6.4 Enum Constraints (Closed Codelists)

The following fields MUST contain values from their closed codelist:

| Field | Valid Values |
|-------|-------------|
| tag[] | planning, planningUpdate, tender, tenderAmendment, tenderUpdate, tenderCancellation, award, awardUpdate, awardCancellation, contract, contractUpdate, contractAmendment, implementation, implementationUpdate, compiled |
| initiationType | tender |
| procurementMethod | open, selective, limited, direct |
| mainProcurementCategory | goods, works, services |

### 6.5 Pattern Constraints

| Field | Pattern | Description |
|-------|---------|-------------|
| ocid | `^ocds-[a-z0-9]{6}-.+$` | OCID format |
| currency | `^[A-Z]{3}$` | ISO 4217 |
| language | `^[a-z]{2}$` | ISO 639-1 |

### 6.6 Cross-Field Consistency Rules

| Rule ID | Fields | Constraint | Severity |
|---------|--------|-----------|----------|
| XF-001 | period.startDate, period.endDate | startDate <= endDate | Error |
| XF-002 | period.endDate, period.maxExtentDate | endDate <= maxExtentDate | Error |
| XF-003 | value.amount | amount >= 0 | Error |
| XF-004 | award.value, tender.value | award.value.amount <= tender.value.amount (typical) | Warning |
| XF-005 | contract.awardID, awards[].id | contract.awardID must reference an existing award | Error |
| XF-006 | tender.numberOfTenderers, tender.tenderers | If both present, numberOfTenderers >= len(tenderers) | Warning |
| XF-007 | parties[].id, buyer.id | buyer.id must reference a party | Error |
| XF-008 | parties[].roles | Roles consistent with appearances in sections | Warning |
| XF-009 | award.date, tender.tenderPeriod.endDate | award.date >= tenderPeriod.endDate | Warning |
| XF-010 | contract.dateSigned, award.date | dateSigned >= award.date | Warning |
| XF-011 | implementation.transactions[].value, contract.value | sum(transactions.value) <= contract.value | Warning |
| XF-012 | document.dateModified, document.datePublished | dateModified >= datePublished | Error |

### 6.7 Array Uniqueness Constraints

| Array | Uniqueness Key | Scope |
|-------|---------------|-------|
| releases | id | Package |
| parties | id | Release |
| awards | id | Release |
| contracts | id | Release |
| items | id | Parent object |
| documents | id | Parent object |
| milestones | id | Parent object |
| transactions | id | Implementation |
| amendments | id | Parent object |

### 6.8 Reference Integrity

| Source Field | Target Array | Constraint |
|-------------|-------------|-----------|
| contract.awardID | awards[].id | Must reference existing award |
| buyer.id | parties[].id | Must reference existing party |
| tender.procuringEntity.id | parties[].id | Must reference existing party |
| award.suppliers[].id | parties[].id | Must reference existing party |
| transaction.payer.id | parties[].id | Must reference existing party |
| transaction.payee.id | parties[].id | Must reference existing party |
| amendment.amendsReleaseID | previous releases | Must reference existing release |

---

## 7. OCDS Record Model

### 7.1 Record Structure

A **record** provides the compiled and versioned view of all releases for one contracting process.

```json
{
  "records": [
    {
      "ocid": "ocds-abc123-tender-2026-001",
      "releases": [ ... ],
      "compiledRelease": { ... },
      "versionedRelease": { ... }
    }
  ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| ocid | string | Yes | Contracting process identifier |
| releases | array of Release | Yes | All releases in chronological order |
| compiledRelease | Release | No | Merged/latest-state release |
| versionedRelease | VersionedRelease | No | Full history of every field change |

### 7.2 Compiled Release

The compiled release represents the **current state** of the contracting process by merging all releases in chronological order. Merge rules:

1. **Scalar fields**: Latest value wins
2. **Object fields**: Deep merge (field by field)
3. **Array fields (with id)**: Merge by `id` — add new items, update existing by matching `id`
4. **Array fields (without id)**: Replace entire array with latest

### 7.3 Versioned Release

The versioned release tracks the **history of every field change**:

```json
{
  "ocid": {
    "releaseDate": "2026-01-15T10:00:00Z",
    "releaseID": "release-001",
    "value": "ocds-abc123-tender-2026-001",
    "releaseTag": ["tender"]
  },
  "tender": {
    "value": {
      "amount": [
        {
          "releaseDate": "2026-01-15T10:00:00Z",
          "releaseID": "release-001",
          "value": 5000000,
          "releaseTag": ["tender"]
        },
        {
          "releaseDate": "2026-02-01T10:00:00Z",
          "releaseID": "release-002",
          "value": 5500000,
          "releaseTag": ["tenderAmendment"]
        }
      ]
    }
  }
}
```

### 7.4 Merge Function Specification

```
merge : list Release -> CompiledRelease
merge [] = empty_release
merge [r] = r
merge (r :: rs) = merge_pair(merge rs, r)

merge_pair(base, update) =
  for each field f in update:
    if f is scalar: base.f := update.f
    if f is object: base.f := merge_pair(base.f, update.f)
    if f is id-array: base.f := merge_by_id(base.f, update.f)
    if f is plain-array: base.f := update.f
```

### 7.5 Record Integrity Properties

| Property | Description |
|----------|-------------|
| Completeness | compiledRelease contains latest value of every field from any release |
| Losslessness | versionedRelease can reconstruct every historical value |
| Consistency | compiledRelease matches result of applying merge to all releases |
| Order-independence | For commutative fields, merge order does not affect result |
| Idempotence | merge(r, r) = r for any release r |

---

## 8. Formal Properties to Prove — Complete Theorem Catalog

### 8.1 Schema Conformance (~30 Theorems)

```coq
(* OCDS-001: Every release has required fields *)
Theorem release_required_fields :
  forall (r : Release),
    Valid_release(r) ->
    r.(ocid) <> "" /\
    r.(release_id) <> "" /\
    r.(date) <> "" /\
    length r.(tag) > 0 /\
    r.(initiationType) <> "".

(* OCDS-002: All values match declared types *)
Theorem release_type_safety :
  forall (r : Release),
    Valid_release(r) ->
    is_string r.(ocid) /\
    is_string r.(release_id) /\
    is_datetime r.(date) /\
    is_string_list r.(tag) /\
    is_string r.(initiationType).

(* OCDS-003: Dates are valid ISO 8601 *)
Theorem dates_valid_iso8601 :
  forall (r : Release) (d : string),
    Valid_release(r) ->
    In d (all_dates r) ->
    is_valid_iso8601 d.

(* OCDS-004: Currency codes are valid ISO 4217 *)
Theorem currencies_valid_iso4217 :
  forall (r : Release) (v : Value),
    Valid_release(r) ->
    In v (all_values r) ->
    v.(currency) <> "" ->
    is_valid_iso4217 v.(currency).

(* OCDS-005: OCID format correct *)
Theorem ocid_format_valid :
  forall (r : Release),
    Valid_release(r) ->
    matches_pattern r.(ocid) "^ocds-[a-z0-9]{6}-.+$".

(* OCDS-006: Enum values from closed codelists *)
Theorem closed_codelist_conformance :
  forall (r : Release),
    Valid_release(r) ->
    (forall t, In t r.(tag) -> In t valid_tags) /\
    In r.(initiationType) valid_initiation_types /\
    (r.(tender).(procurementMethod) <> "" ->
      In r.(tender).(procurementMethod) valid_procurement_methods) /\
    (r.(tender).(mainProcurementCategory) <> "" ->
      In r.(tender).(mainProcurementCategory) valid_procurement_categories).

(* OCDS-007: Array items unique by ID *)
Theorem array_id_uniqueness :
  forall (r : Release),
    Valid_release(r) ->
    NoDup (map party_id r.(parties)) /\
    NoDup (map award_id r.(awards)) /\
    NoDup (map contract_id r.(contracts)).

(* OCDS-008: Reference integrity *)
Theorem reference_integrity :
  forall (r : Release) (c : Contract),
    Valid_release(r) ->
    In c r.(contracts) ->
    exists a, In a r.(awards) /\ a.(award_id) = c.(awardID).

(* OCDS-009: Monetary values non-negative *)
Theorem monetary_values_non_negative :
  forall (r : Release) (v : Value),
    Valid_release(r) ->
    In v (all_values r) ->
    v.(amount) >= 0.

(* OCDS-010: Period start <= end *)
Theorem period_start_leq_end :
  forall (r : Release) (p : Period),
    Valid_release(r) ->
    In p (all_periods r) ->
    p.(startDate) <> "" -> p.(endDate) <> "" ->
    datetime_leq p.(startDate) p.(endDate).
```

**Additional Schema Conformance Theorems (OCDS-011 through OCDS-030)**:

| ID | Name | Statement |
|----|------|-----------|
| OCDS-011 | `party_roles_non_empty` | Every party has at least one role |
| OCDS-012 | `buyer_is_party` | buyer.id references a party with "buyer" role |
| OCDS-013 | `procuring_entity_is_party` | procuringEntity.id references a party |
| OCDS-014 | `suppliers_are_parties` | All award supplier IDs reference parties |
| OCDS-015 | `payer_payee_are_parties` | Transaction payer/payee IDs reference parties |
| OCDS-016 | `document_id_unique` | Document IDs unique within each section |
| OCDS-017 | `milestone_id_unique` | Milestone IDs unique within each section |
| OCDS-018 | `item_id_unique` | Item IDs unique within each section |
| OCDS-019 | `transaction_id_unique` | Transaction IDs unique within implementation |
| OCDS-020 | `document_format_valid` | Document format is valid MIME type if present |
| OCDS-021 | `document_url_valid` | Document URL is valid URI if present |
| OCDS-022 | `language_valid` | Language is valid ISO 639-1 if present |
| OCDS-023 | `country_valid` | Country name maps to valid ISO 3166 if present |
| OCDS-024 | `maxExtentDate_geq_endDate` | period.maxExtentDate >= period.endDate |
| OCDS-025 | `durationInDays_non_negative` | period.durationInDays >= 0 |
| OCDS-026 | `quantity_non_negative` | item.quantity >= 0 |
| OCDS-027 | `unit_value_non_negative` | item.unit.value.amount >= 0 |
| OCDS-028 | `classification_scheme_valid` | Classification scheme from known schemes |
| OCDS-029 | `identifier_scheme_valid` | Organization identifier scheme from org-id.guide |
| OCDS-030 | `release_id_unique_per_ocid` | Release ID unique within contracting process |

### 8.2 Lifecycle Consistency (~20 Theorems)

```coq
(* OCDS-031: Release tags follow valid sequence *)
Theorem tag_sequence_valid :
  forall (releases : list Release),
    Valid_release_sequence(releases) ->
    forall i j, i < j ->
    tag_order (nth i releases).(tag) <= tag_order (nth j releases).(tag).

(* OCDS-032: Status transitions valid *)
Theorem tender_status_transition_valid :
  forall (r1 r2 : Release),
    Valid_transition(r1, r2) ->
    In r1.(tender).(status) ["planning"; "planned"; "active"] ->
    In r2.(tender).(status) (valid_next_status r1.(tender).(status)).

(* OCDS-033: Award date after tender close *)
Theorem award_after_tender_close :
  forall (r : Release) (a : Award),
    Valid_release(r) ->
    In a r.(awards) ->
    a.(award_date) <> "" ->
    r.(tender).(tenderPeriod).(endDate) <> "" ->
    datetime_leq r.(tender).(tenderPeriod).(endDate) a.(award_date).

(* OCDS-034: Contract date after award date *)
Theorem contract_after_award :
  forall (r : Release) (c : Contract) (a : Award),
    Valid_release(r) ->
    In c r.(contracts) ->
    In a r.(awards) ->
    c.(awardID) = a.(award_id) ->
    c.(dateSigned) <> "" -> a.(award_date) <> "" ->
    datetime_leq a.(award_date) c.(dateSigned).

(* OCDS-035: Implementation after contract signing *)
Theorem implementation_after_signing :
  forall (r : Release) (c : Contract) (t : Transaction),
    Valid_release(r) ->
    In c r.(contracts) ->
    In t c.(implementation).(transactions) ->
    c.(dateSigned) <> "" -> t.(trans_date) <> "" ->
    datetime_leq c.(dateSigned) t.(trans_date).

(* OCDS-036: Amendments reference valid base release *)
Theorem amendment_references_valid :
  forall (r : Release) (am : Amendment),
    Valid_release(r) ->
    In am (all_amendments r) ->
    am.(amendsReleaseID) <> "" ->
    exists prev, previously_published prev /\
    prev.(release_id) = am.(amendsReleaseID).
```

**Additional Lifecycle Theorems (OCDS-037 through OCDS-050)**:

| ID | Name | Statement |
|----|------|-----------|
| OCDS-037 | `award_status_progression` | Award status follows pending -> active/cancelled/unsuccessful |
| OCDS-038 | `contract_status_progression` | Contract status follows pending -> active -> terminated/cancelled |
| OCDS-039 | `no_contract_without_award` | Contract requires preceding active award |
| OCDS-040 | `no_implementation_without_contract` | Implementation requires preceding active contract |
| OCDS-041 | `cancellation_is_terminal` | Once cancelled, no further state changes |
| OCDS-042 | `tender_period_before_award_period` | tenderPeriod.endDate <= awardPeriod.startDate |
| OCDS-043 | `award_period_before_contract_period` | awardPeriod.endDate <= contractPeriod.startDate |
| OCDS-044 | `release_dates_monotonic` | Release dates non-decreasing within process |
| OCDS-045 | `amendment_date_after_original` | Amendment date >= original release date |
| OCDS-046 | `milestone_dates_consistent` | dateMet <= dateModified if both present |
| OCDS-047 | `document_dates_consistent` | dateModified >= datePublished if both present |
| OCDS-048 | `tag_matches_content` | Tag "award" implies awards array non-empty |
| OCDS-049 | `single_active_award_per_lot` | At most one active award per lot (with lots extension) |
| OCDS-050 | `supplier_was_tenderer` | Award supplier should appear as tenderer |

### 8.3 Record Compilation (~15 Theorems)

```coq
(* OCDS-051: Compiled release reflects latest values *)
Theorem compiled_release_latest :
  forall (releases : list Release) (cr : CompiledRelease),
    cr = compile releases ->
    forall field f,
    cr.f = last_value_of f releases.

(* OCDS-052: Versioned release contains full history *)
Theorem versioned_release_complete :
  forall (releases : list Release) (vr : VersionedRelease),
    vr = version releases ->
    forall field f, forall r, In r releases ->
    r.f <> default ->
    exists entry, In entry (vr.f) /\
    entry.(releaseID) = r.(release_id) /\
    entry.(value) = r.f.

(* OCDS-053: No data loss in compilation *)
Theorem compilation_no_data_loss :
  forall (releases : list Release),
    let vr := version releases in
    forall field f, forall r, In r releases ->
    r.f <> default ->
    recoverable r.f vr.

(* OCDS-054: Merge function associative *)
Theorem merge_associative :
  forall (a b c : Release),
    merge_pair (merge_pair a b) c = merge_pair a (merge_pair b c).

(* OCDS-055: Compilation order independence for commutative updates *)
Theorem compile_order_independent :
  forall (r1 r2 : Release),
    commutative_fields r1 r2 ->
    compile [r1; r2] = compile [r2; r1].
```

**Additional Compilation Theorems (OCDS-056 through OCDS-065)**:

| ID | Name | Statement |
|----|------|-----------|
| OCDS-056 | `merge_idempotent` | merge_pair r r = r |
| OCDS-057 | `compile_singleton` | compile [r] = r |
| OCDS-058 | `compile_preserves_ocid` | compile(rs).ocid = head(rs).ocid |
| OCDS-059 | `id_array_merge_preserves_items` | Merging by ID never drops items |
| OCDS-060 | `id_array_merge_updates_existing` | Matching IDs update, not duplicate |
| OCDS-061 | `version_length_matches_updates` | Length of version history = number of releases that set field |
| OCDS-062 | `version_chronological` | Version history entries in release date order |
| OCDS-063 | `compiled_valid_if_inputs_valid` | If all releases valid, compiled release valid |
| OCDS-064 | `decompile_roundtrip` | version(rs) contains enough to reconstruct compile(rs) |
| OCDS-065 | `empty_fields_not_versioned` | Fields not set in any release absent from versioned release |

### 8.4 Integrity and Transparency (~15 Theorems)

```coq
(* OCDS-066: Published data matches internal state *)
Theorem publication_fidelity :
  forall (sys : System) (r : Release),
    Published(sys, r) ->
    r = export(sys, r.(ocid), r.(release_id)).

(* OCDS-067: No redaction of required public fields *)
Theorem no_required_field_redaction :
  forall (sys : System) (r : Release),
    Published(sys, r) ->
    forall f, required_public_field f ->
    r.f <> redacted.

(* OCDS-068: Amendment trail complete *)
Theorem amendment_trail_complete :
  forall (sys : System) (ocid : OCID),
    forall r1 r2,
    Published(sys, r1) -> Published(sys, r2) ->
    r1.(ocid) = ocid -> r2.(ocid) = ocid ->
    differs r1 r2 ->
    exists am, In am (all_amendments r2) /\
    am.(amendsReleaseID) = r1.(release_id).

(* OCDS-069: Organization roles consistent across releases *)
Theorem org_roles_consistent :
  forall (releases : list Release) (org_id : string),
    Valid_release_sequence(releases) ->
    forall r1 r2, In r1 releases -> In r2 releases ->
    has_role r1 org_id "buyer" ->
    has_role r2 org_id "supplier" ->
    False.  (* buyer cannot also be supplier for same process *)

(* OCDS-070: Total transaction amounts <= contract value *)
Theorem transaction_sum_bounded :
  forall (r : Release) (c : Contract),
    Valid_release(r) ->
    In c r.(contracts) ->
    c.(contract_value).(amount) > 0 ->
    sum_transactions c.(implementation).(transactions) <=
    c.(contract_value).(amount).
```

**Additional Integrity Theorems (OCDS-071 through OCDS-080)**:

| ID | Name | Statement |
|----|------|-----------|
| OCDS-071 | `no_retroactive_modification` | Published release cannot be modified (only amended) |
| OCDS-072 | `all_parties_disclosed` | Every org ref in sections appears in parties array |
| OCDS-073 | `award_value_bounded` | sum(award values) <= tender.value for process |
| OCDS-074 | `contract_value_bounded` | contract.value <= associated award.value |
| OCDS-075 | `supplier_count_matches` | Number of suppliers matches number of active awards |
| OCDS-076 | `document_availability` | Published document URLs are accessible |
| OCDS-077 | `timestamp_authenticity` | Release timestamps from trusted time source |
| OCDS-078 | `hash_chain_valid` | Integrity hashes form valid chain |
| OCDS-079 | `signature_valid` | All digital signatures verify |
| OCDS-080 | `no_duplicate_releases` | No two releases with same ID for same OCID |

### 8.5 Extension Compliance (~10 Theorems)

| ID | Name | Statement |
|----|------|-----------|
| OCDS-081 | `lot_structure_valid` | Lot IDs unique, items reference valid lots |
| OCDS-082 | `beneficial_ownership_present` | Beneficial ownership data present when extension active and jurisdiction requires |
| OCDS-083 | `bid_statistics_reference_valid` | Bid statistics reference valid tenderers |
| OCDS-084 | `enquiry_dates_valid` | Enquiry date within enquiry period, answer after question |
| OCDS-085 | `location_geometry_valid` | GeoJSON geometry valid if present |
| OCDS-086 | `participation_fee_non_negative` | Fee amounts >= 0 |
| OCDS-087 | `budget_breakdown_sums` | Budget breakdown components sum to total budget |
| OCDS-088 | `subcontract_value_bounded` | Subcontract value <= contract value |
| OCDS-089 | `metric_observation_dates_valid` | Metric observation dates within contract period |
| OCDS-090 | `riina_proof_cert_valid` | RIINA proof certificate hash matches content, theorems all Qed |

---

## 9. Coq Formalization Strategy

### 9.1 Module Structure

```
02_FORMAL/coq/procurement/ocds/
├── Types.v              -- OCDS data model as Coq Record types
├── Codelists.v          -- Inductive types for all codelists
├── Identifiers.v        -- OCID format, org identifiers, item classifications
├── Validation.v         -- Schema validation as decidable propositions
├── Lifecycle.v          -- Status transitions, temporal ordering
├── Compilation.v        -- Release-to-record merge function + correctness
├── Integrity.v          -- Transparency and integrity properties
├── Extensions.v         -- Extension-specific validation
├── Serialization.v      -- JSON serialization/deserialization correctness
└── OCDS_All.v           -- Master import file
```

### 9.2 Core Type Definitions

```coq
(* Types.v *)

Require Import Coq.Strings.String.
Require Import Coq.QArith.QArith.
Require Import Coq.Lists.List.
Import ListNotations.

(** ** Value — monetary amount with currency *)
Record Value := mkValue {
  val_amount : option Q;
  val_currency : option string
}.

(** ** Period — date range *)
Record Period := mkPeriod {
  per_startDate : option string;
  per_endDate : option string;
  per_maxExtentDate : option string;
  per_durationInDays : option Z
}.

(** ** Identifier — organization identifier *)
Record Identifier := mkIdentifier {
  ident_scheme : option string;
  ident_id : option string;
  ident_legalName : option string;
  ident_uri : option string
}.

(** ** Address *)
Record Address := mkAddress {
  addr_streetAddress : option string;
  addr_locality : option string;
  addr_region : option string;
  addr_postalCode : option string;
  addr_countryName : option string
}.

(** ** ContactPoint *)
Record ContactPoint := mkContactPoint {
  cp_name : option string;
  cp_email : option string;
  cp_telephone : option string;
  cp_faxNumber : option string;
  cp_url : option string
}.

(** ** Classification *)
Record Classification := mkClassification {
  cls_scheme : option string;
  cls_id : option string;
  cls_description : option string;
  cls_uri : option string
}.

(** ** Unit *)
Record Unit := mkUnit {
  unit_scheme : option string;
  unit_id : option string;
  unit_name : option string;
  unit_value : option Value
}.

(** ** Item *)
Record Item := mkItem {
  item_id : string;
  item_description : option string;
  item_classification : option Classification;
  item_additionalClassifications : list Classification;
  item_quantity : option Q;
  item_unit : option Unit
}.

(** ** Document *)
Record Document := mkDocument {
  doc_id : string;
  doc_documentType : option string;
  doc_title : option string;
  doc_description : option string;
  doc_url : option string;
  doc_datePublished : option string;
  doc_dateModified : option string;
  doc_format : option string;
  doc_language : option string
}.

(** ** Amendment *)
Record Amendment := mkAmendment {
  amend_id : option string;
  amend_date : option string;
  amend_rationale : option string;
  amend_description : option string;
  amend_amendsReleaseID : option string;
  amend_releaseID : option string
}.

(** ** Milestone *)
Record Milestone := mkMilestone {
  ms_id : string;
  ms_title : option string;
  ms_type : option string;
  ms_description : option string;
  ms_code : option string;
  ms_dueDate : option string;
  ms_dateMet : option string;
  ms_dateModified : option string;
  ms_status : option string
}.

(** ** OrganizationReference *)
Record OrgRef := mkOrgRef {
  orgref_id : option string;
  orgref_name : option string
}.

(** ** Organization (full, in parties array) *)
Record Organization := mkOrganization {
  org_name : string;
  org_id : string;
  org_identifier : option Identifier;
  org_additionalIdentifiers : list Identifier;
  org_address : option Address;
  org_contactPoint : option ContactPoint;
  org_roles : list string;
  org_details : option string  (* simplified *)
}.

(** ** Transaction *)
Record Transaction := mkTransaction {
  trans_id : string;
  trans_source : option string;
  trans_date : option string;
  trans_value : option Value;
  trans_payer : option OrgRef;
  trans_payee : option OrgRef;
  trans_uri : option string
}.

(** ** Implementation *)
Record Implementation := mkImplementation {
  impl_transactions : list Transaction;
  impl_milestones : list Milestone;
  impl_documents : list Document
}.

(** ** Budget *)
Record Budget := mkBudget {
  budget_id : option string;
  budget_description : option string;
  budget_amount : option Value;
  budget_project : option string;
  budget_projectID : option string;
  budget_uri : option string;
  budget_source : option string
}.

(** ** Planning *)
Record Planning := mkPlanning {
  plan_rationale : option string;
  plan_budget : option Budget;
  plan_documents : list Document;
  plan_milestones : list Milestone
}.

(** ** Tender *)
Record Tender := mkTender {
  tend_id : string;
  tend_title : option string;
  tend_description : option string;
  tend_status : option string;
  tend_procuringEntity : option OrgRef;
  tend_items : list Item;
  tend_minValue : option Value;
  tend_value : option Value;
  tend_procurementMethod : option string;
  tend_procurementMethodDetails : option string;
  tend_procurementMethodRationale : option string;
  tend_mainProcurementCategory : option string;
  tend_additionalProcurementCategories : list string;
  tend_awardCriteria : option string;
  tend_awardCriteriaDetails : option string;
  tend_submissionMethod : list string;
  tend_submissionMethodDetails : option string;
  tend_tenderPeriod : option Period;
  tend_enquiryPeriod : option Period;
  tend_hasEnquiries : option bool;
  tend_awardPeriod : option Period;
  tend_contractPeriod : option Period;
  tend_numberOfTenderers : option Z;
  tend_tenderers : list OrgRef;
  tend_documents : list Document;
  tend_milestones : list Milestone;
  tend_amendments : list Amendment;
  tend_eligibilityCriteria : option string
}.

(** ** Award *)
Record Award := mkAward {
  awd_id : string;
  awd_title : option string;
  awd_description : option string;
  awd_status : option string;
  awd_date : option string;
  awd_value : option Value;
  awd_suppliers : list OrgRef;
  awd_items : list Item;
  awd_contractPeriod : option Period;
  awd_documents : list Document;
  awd_amendments : list Amendment
}.

(** ** Contract *)
Record Contract := mkContract {
  ctr_id : string;
  ctr_awardID : string;
  ctr_title : option string;
  ctr_description : option string;
  ctr_status : option string;
  ctr_period : option Period;
  ctr_value : option Value;
  ctr_dateSigned : option string;
  ctr_items : list Item;
  ctr_documents : list Document;
  ctr_implementation : option Implementation;
  ctr_amendments : list Amendment
}.

(** ** Release — the fundamental OCDS unit *)
Record Release := mkRelease {
  rel_ocid : string;
  rel_id : string;
  rel_date : string;
  rel_tag : list string;
  rel_initiationType : string;
  rel_language : option string;
  rel_parties : list Organization;
  rel_buyer : option OrgRef;
  rel_planning : option Planning;
  rel_tender : option Tender;
  rel_awards : list Award;
  rel_contracts : list Contract
}.
```

### 9.3 Codelist Definitions

```coq
(* Codelists.v *)

(** Closed codelists — exhaustive enumeration *)

Inductive ReleaseTag :=
  | TagPlanning | TagPlanningUpdate
  | TagTender | TagTenderAmendment | TagTenderUpdate | TagTenderCancellation
  | TagAward | TagAwardUpdate | TagAwardCancellation
  | TagContract | TagContractUpdate | TagContractAmendment
  | TagImplementation | TagImplementationUpdate
  | TagCompiled.

Inductive InitiationType := InitTender.

Inductive ProcurementMethod := PMOpen | PMSelective | PMLimited | PMDirect.

Inductive MainProcurementCategory := CatGoods | CatWorks | CatServices.

(** Open codelists — known values + extension point *)

Inductive TenderStatus :=
  | TSPlanning | TSPlanned | TSActive | TSCancelled
  | TSUnsuccessful | TSComplete | TSWithdrawn
  | TSOther (s : string).

Inductive AwardStatus :=
  | ASPending | ASActive | ASCancelled | ASUnsuccessful
  | ASOther (s : string).

Inductive ContractStatus :=
  | CSPending | CSActive | CSCancelled | CSTerminated
  | CSOther (s : string).

Inductive OrgRole :=
  | RoleBuyer | RoleProcuringEntity | RoleSupplier | RoleTenderer
  | RoleFunder | RoleEnquirer | RolePayer | RolePayee | RoleReviewBody
  | RoleOther (s : string).
```

### 9.4 Validation Functions

```coq
(* Validation.v — decidable validation *)

Definition valid_release_required_fields (r : Release) : bool :=
  negb (String.eqb r.(rel_ocid) "") &&
  negb (String.eqb r.(rel_id) "") &&
  negb (String.eqb r.(rel_date) "") &&
  negb (Nat.eqb (length r.(rel_tag)) 0) &&
  negb (String.eqb r.(rel_initiationType) "").

Definition valid_ocid_format (ocid : string) : bool :=
  (* Check prefix "ocds-" and 6-char publisher prefix *)
  match_regex ocid "^ocds-[a-z0-9]{6}-.+$".

Definition valid_period (p : Period) : bool :=
  match p.(per_startDate), p.(per_endDate) with
  | Some s, Some e => datetime_leq_b s e
  | _, _ => true
  end.

Definition valid_value (v : Value) : bool :=
  match v.(val_amount) with
  | Some a => Qle_bool 0 a
  | None => true
  end.

(** Master validation — conjunction of all checks *)
Definition valid_release (r : Release) : bool :=
  valid_release_required_fields r &&
  valid_ocid_format r.(rel_ocid) &&
  forallb valid_period (all_periods r) &&
  forallb valid_value (all_values r) &&
  nodup_by id r.(rel_parties) &&
  nodup_by id r.(rel_awards) &&
  nodup_by id r.(rel_contracts) &&
  reference_integrity r.
```

### 9.5 Proof Approach

For each theorem category:

1. **Schema Conformance** — Direct computation proofs. The `valid_release` function is decidable, so `Valid_release r` is proved by `reflect` on the boolean validator. Most proofs reduce to `simpl; auto`.

2. **Lifecycle Consistency** — State machine proofs. Define `valid_transition` as a relation on release pairs. Prove that the system only produces valid transitions by induction on the release sequence.

3. **Record Compilation** — Functional correctness. Define `compile` and `version` as recursive functions. Prove properties by structural induction on the release list. Associativity and idempotence require careful treatment of the merge-by-id operation.

4. **Integrity** — Relies on RIINA's core guarantees (information flow, non-interference). These theorems compose with Track A results.

5. **Extensions** — Conditional proofs: if extension is active, additional properties hold.

---

## 10. RIINA Type Encoding

### 10.1 Validated-by-Construction Types

In RIINA, OCDS types are defined such that invalid data **cannot be constructed**. The type system enforces schema conformance at compile time.

```rii
// RIINA OCDS types — Bahasa Melayu syntax

/// Kod mata wang ISO 4217 — hanya nilai sah boleh diwujudkan
jenis KodMataWang = "MYR" | "USD" | "EUR" | "GBP" | "SGD" | "JPY" | "CNY"
                  | "AUD" | "THB" | "IDR" | "PHP"  // ... semua 180 kod

/// Nilai monetari — dijamin tidak negatif
jenis Nilai = {
    jumlah: Nombor { >= 0.0 },     // refinement: non-negative
    matawang: KodMataWang
}

/// Tempoh — dijamin mula <= tamat
jenis Tempoh = {
    tarikhMula: Pilihan<TarikhMasaISO8601>,
    tarikhTamat: Pilihan<TarikhMasaISO8601>,
    tarikhMaksimum: Pilihan<TarikhMasaISO8601>,
    tempohHari: Pilihan<Nombor { >= 0 }>
} di mana {
    tarikhMula.ada() dan tarikhTamat.ada() =>
        tarikhMula.nilai() <= tarikhTamat.nilai(),
    tarikhTamat.ada() dan tarikhMaksimum.ada() =>
        tarikhTamat.nilai() <= tarikhMaksimum.nilai()
}

/// Kaedah perolehan — senarai kod tertutup
jenis KaedahPerolehan = "terbuka" | "terpilih" | "terhad" | "langsung"

/// Kategori utama perolehan
jenis KategoriPerolehan = "barangan" | "kerja" | "perkhidmatan"

/// Tag pelepasan — senarai kod tertutup
jenis TagPelepasan =
    | "perancangan" | "kemasKiniPerancangan"
    | "tender" | "pindaanTender" | "kemasKiniTender" | "batalTender"
    | "anugerah" | "kemasKiniAnugerah" | "batalAnugerah"
    | "kontrak" | "kemasKiniKontrak" | "pindaanKontrak"
    | "pelaksanaan" | "kemasKiniPelaksanaan"
    | "disusun"

/// OCID — format disahkan oleh jenis
jenis OCID = Teks { padan: "^ocds-[a-z0-9]{6}-.+$" }

/// Rujukan organisasi
jenis RujukanOrganisasi = {
    id: Teks,
    nama: Teks
}

/// Organisasi penuh
jenis Organisasi = {
    nama: Teks { bukan_kosong },
    id: Teks { bukan_kosong },
    pengenal: Pilihan<Pengenal>,
    alamat: Pilihan<Alamat>,
    hubungan: Pilihan<TitikHubungan>,
    peranan: Senarai<PerananOrganisasi> { panjang >= 1 }
}

/// Peranan organisasi — senarai kod terbuka
jenis PerananOrganisasi =
    | "pembeli" | "entitiPerolehan" | "pembekal" | "pentender"
    | "pembiaya" | "penyoal" | "pembayar" | "penerima" | "badanSemakan"
    | Lain(Teks)
```

### 10.2 Release Construction Example

```rii
// Contoh: Mewujudkan pelepasan tender yang sah

fungsi buat_pelepasan_tender() -> PelepasanOCDS {
    biar pembeli = Organisasi {
        nama: "Kementerian Kewangan Malaysia",
        id: "MY-MOF-001",
        pengenal: Ada(Pengenal {
            skim: "MY-MOF",
            id: "MOF-001",
            namaUndangUndang: "Kementerian Kewangan Malaysia",
            uri: Ada("https://mof.gov.my")
        }),
        peranan: ["pembeli", "entitiPerolehan"]
    };

    biar tender = Tender {
        id: "TENDER-2026-001",
        tajuk: Ada("Pembekalan kenderaan armada"),
        status: Ada("aktif"),
        kaedahPerolehan: Ada("terbuka"),
        kategoriUtama: Ada("barangan"),
        nilai: Ada(Nilai { jumlah: 5000000.00, matawang: "MYR" }),
        tempohTender: Ada(Tempoh {
            tarikhMula: Ada("2026-01-15T00:00:00Z"),
            tarikhTamat: Ada("2026-02-15T17:00:00Z"),
            tarikhMaksimum: Tiada,
            tempohHari: Ada(31)
        }),
        item: [
            Item {
                id: "item-001",
                keterangan: Ada("Kereta sedan 1.5L"),
                klasifikasi: Ada(Klasifikasi {
                    skim: "CPV",
                    id: "34110000",
                    keterangan: "Kereta penumpang"
                }),
                kuantiti: Ada(50),
                unit: Ada(Unit { nama: "unit", nilai: Ada(Nilai { jumlah: 100000.00, matawang: "MYR" }) })
            }
        ]
    };

    pulang PelepasanOCDS {
        ocid: "ocds-myriia-tender-2026-001",
        id: "release-001-tender",
        tarikh: "2026-01-15T10:00:00Z",
        tag: ["tender"],
        jenisPermulaan: "tender",
        bahasa: Ada("ms"),
        pihak: [pembeli],
        pembeli: Ada(RujukanOrganisasi { id: "MY-MOF-001", nama: "Kementerian Kewangan Malaysia" }),
        tender: Ada(tender),
        anugerah: [],
        kontrak: []
    };
    // Type system guarantees: all required fields present, OCID format valid,
    // period start <= end, value non-negative, tag from closed codelist.
    // NO runtime validation needed — it compiles, it's valid.
}
```

### 10.3 Award Release Example

```rii
fungsi buat_pelepasan_anugerah() -> PelepasanOCDS {
    biar anugerah = Anugerah {
        id: "award-001",
        tajuk: Ada("Pembekalan kenderaan armada — Proton"),
        status: Ada("aktif"),
        tarikh: Ada("2026-03-01T14:00:00Z"),
        nilai: Ada(Nilai { jumlah: 4500000.00, matawang: "MYR" }),
        pembekal: [
            RujukanOrganisasi { id: "MY-SSM-12345678", nama: "Proton Holdings Bhd" }
        ]
    };

    pulang PelepasanOCDS {
        ocid: "ocds-myriia-tender-2026-001",
        id: "release-002-award",
        tarikh: "2026-03-01T14:00:00Z",
        tag: ["anugerah"],
        jenisPermulaan: "tender",
        pihak: [/* pembeli + pembekal */],
        anugerah: [anugerah],
        kontrak: []
    };
}
```

### 10.4 Contract Release Example

```rii
fungsi buat_pelepasan_kontrak() -> PelepasanOCDS {
    biar kontrak = Kontrak {
        id: "contract-001",
        idAnugerah: "award-001",  // reference integrity enforced by type
        tajuk: Ada("Kontrak pembekalan kenderaan"),
        status: Ada("aktif"),
        tempoh: Ada(Tempoh {
            tarikhMula: Ada("2026-04-01T00:00:00Z"),
            tarikhTamat: Ada("2026-12-31T23:59:59Z")
        }),
        nilai: Ada(Nilai { jumlah: 4500000.00, matawang: "MYR" }),
        tarikhDitandatangani: Ada("2026-03-15T10:00:00Z")
    };

    pulang PelepasanOCDS {
        ocid: "ocds-myriia-tender-2026-001",
        id: "release-003-contract",
        tarikh: "2026-03-15T10:00:00Z",
        tag: ["kontrak"],
        jenisPermulaan: "tender",
        kontrak: [kontrak]
    };
}
```

---

## 11. Integration Points

### 11.1 Procurement Lifecycle Integration

OCDS export is not a standalone feature — it integrates with every layer of the RIINA procurement system:

| Layer | OCDS Integration | Release Tags Generated |
|-------|-----------------|----------------------|
| Layer 1: Planning | Budget allocation → planning release | planning |
| Layer 2: Tender | Solicitation → tender release | tender, tenderUpdate |
| Layer 3: Evaluation | Bid evaluation → award release | award |
| Layer 4: Contract | Contract signing → contract release | contract |
| Layer 5: Implementation | Payments, milestones → implementation releases | implementation, implementationUpdate |
| Layer 6: Audit | Complete OCDS record as audit evidence | compiled |

### 11.2 Audit Trail Integration

Every OCDS release is simultaneously:
1. Published to the OCDS API endpoint
2. Recorded in the audit trail (Layer 13, Track AE)
3. Hash-chained to previous releases for tamper evidence
4. Signed with the system's Ed25519 key

```
AuditEntry = {
  event: "ocds_release_published",
  release_id: "release-001-tender",
  ocid: "ocds-myriia-tender-2026-001",
  hash: SHA3-256(release_json),
  previous_hash: SHA3-256(previous_release_json),
  signature: Ed25519_sign(private_key, hash),
  timestamp: TrustedTime.now()
}
```

### 11.3 Real-Time vs Batch Publication

| Mode | Trigger | Latency | Use Case |
|------|---------|---------|----------|
| Real-time | State change event | < 1 second | High-transparency jurisdictions |
| Near-real-time | Periodic poll | < 5 minutes | Standard deployment |
| Batch | Scheduled export | Daily/weekly | Resource-constrained environments |

RIINA guarantees identical output regardless of publication mode — the `export` function is deterministic and proven correct.

### 11.4 Proof Certificate Integration

The RIINA extension (Section 5.3) attaches proof certificates to every release:

1. **At compilation**: The RIINA compiler verifies schema conformance and emits a proof certificate
2. **At publication**: The certificate is embedded in the release JSON
3. **At consumption**: Any OCDS consumer can verify the certificate independently
4. **At audit**: The proof certificate serves as machine-checkable evidence of compliance

---

## 12. Malaysian Context

### 12.1 ePerolehan Data Mapping

Malaysia's ePerolehan system is the national procurement platform. Mapping to OCDS:

| ePerolehan Field | OCDS Field | Notes |
|-----------------|-----------|-------|
| No. Sebut Harga / No. Tender | tender.id | Direct mapping |
| Tajuk Perolehan | tender.title | Direct mapping |
| Agensi | buyer.name, parties[] | Map to Organization |
| Kaedah Perolehan | tender.procurementMethod | Map: SH→open, RT→selective, RK→limited, LL→direct |
| Kategori | tender.mainProcurementCategory | Map to goods/works/services |
| Anggaran Kos | tender.value | Convert to Value object |
| Tarikh Mula | tender.tenderPeriod.startDate | ISO 8601 conversion |
| Tarikh Tutup | tender.tenderPeriod.endDate | ISO 8601 conversion |
| Syarikat Berjaya | awards[].suppliers[] | Map to OrgRef |
| Nilai Kontrak | contracts[].value | Convert to Value |
| No. SSM | parties[].identifier (scheme: MY-SSM) | Company registration |
| No. Pendaftaran MOF | parties[].additionalIdentifiers (scheme: MY-MOF) | MOF supplier registration |

### 12.2 MyProcurement Portal Alignment

The MyProcurement portal (myprocurement.treasury.gov.my) publishes:
- Annual procurement plans
- Tender notices
- Award results
- Contract details

RIINA can serve as the verified backend, ensuring that all data published on MyProcurement conforms to OCDS and is cryptographically signed.

### 12.3 Malaysian Identifier Schemes

| Scheme | Description | Format | Example |
|--------|-------------|--------|---------|
| MY-SSM | Suruhanjaya Syarikat Malaysia (Companies Commission) | 8-12 digit number | 123456-A |
| MY-MOF | Pendaftaran Pembekal MOF | MOF registration code | MOF-SUP-2026-001 |
| MY-CIDB | Lembaga Pembangunan Industri Pembinaan | CIDB registration | CIDB-G7-12345 |
| MY-KKR | Kementerian Kerja Raya contractor registration | KKR code | KKR-BK-001 |
| MY-MITI | Ministry of International Trade and Industry | License number | MITI-ML-2026-001 |

### 12.4 Bahasa Melayu Localization

OCDS supports the `language` field (ISO 639-1). For Malaysian implementations:

| OCDS Field | English Example | Bahasa Melayu Example |
|------------|----------------|----------------------|
| language | "en" | "ms" |
| tender.title | "Supply of vehicles" | "Pembekalan kenderaan" |
| tender.description | "Procurement of 50 fleet vehicles" | "Perolehan 50 unit kenderaan armada" |
| award.title | "Vehicle supply award" | "Anugerah pembekalan kenderaan" |

### 12.5 Regulatory Alignment

| Malaysian Regulation | OCDS Relevance |
|---------------------|---------------|
| Arahan Perbendaharaan (Treasury Instructions) | Procurement methods, thresholds |
| Pekeliling Perbendaharaan PK 2 | Direct procurement limits |
| Pekeliling Perbendaharaan PK 4 | Tender board composition |
| Akta Perolehan Kerajaan 2022 (proposed) | Open data publication mandates |
| MAMPU Open Data Policy | OCDS publication requirements |

---

## 13. Comparison with Other Data Standards

### 13.1 EU eForms

| Aspect | OCDS | EU eForms |
|--------|------|-----------|
| Scope | Full lifecycle | Mostly pre-award (notices) |
| Format | JSON | XML (UBL-based) |
| Schema | JSON Schema Draft 4 | XSD |
| Coverage | Global | EU member states |
| Codelists | ~15 codelists | 300+ codelists (EU vocabularies) |
| Complexity | Moderate | Very high |
| Fields | ~200 | 800+ |
| Interoperability | High (simple JSON) | Limited (complex XML) |
| RIINA mapping | Native JSON types | Requires XML serialization layer |

### 13.2 US FPDS / SAM.gov

| Aspect | OCDS | FPDS/SAM.gov |
|--------|------|-------------|
| Scope | Full lifecycle | Award-focused |
| Format | JSON | XML/CSV |
| Identifiers | OCID | PIID, FAIN, URI |
| Classification | CPV/UNSPSC | NAICS, PSC |
| Organization IDs | org-id.guide | DUNS/UEI |
| Open standard | Yes | US government standard |
| RIINA mapping | Direct | Requires transformation layer |

### 13.3 UK Contracts Finder

| Aspect | OCDS | UK Contracts Finder |
|--------|------|-------------------|
| Scope | Full lifecycle | Notices and awards |
| Format | JSON | JSON (partial OCDS alignment) |
| OCDS compatibility | Native | Partial (not full OCDS) |
| Value thresholds | None | GBP 10k+ (public), GBP 25k+ (central gov) |
| RIINA mapping | Direct | Adapter required |

### 13.4 GS1 Standards

| Aspect | OCDS Items | GS1 Standards |
|--------|-----------|--------------|
| Purpose | Procurement item description | Product identification and description |
| Identifier | CPV/UNSPSC codes | GTIN, GLN |
| Detail level | Summary (description, quantity) | Detailed (weight, dimensions, composition) |
| Integration | item.classification | additionalClassifications |

### 13.5 Interoperability Matrix

| Standard Pair | Interoperability | Mapping Complexity |
|--------------|-----------------|-------------------|
| OCDS ↔ eForms | Medium | Medium (notice-level) |
| OCDS ↔ FPDS | Low | High (schema mismatch) |
| OCDS ↔ Contracts Finder | High | Low (partial alignment) |
| OCDS ↔ GS1 | Low | Medium (item-level only) |
| OCDS ↔ RIINA | Native | None (native encoding) |

---

## 14. Threat Model

### 14.1 OCDS-Specific Threats

| Threat ID | Name | Description | Impact | Mitigation |
|-----------|------|-------------|--------|------------|
| PROC-OCDS-001 | Schema violation | Malformed OCDS data published | Data consumers reject or misparse | RIINA type system prevents construction of invalid data |
| PROC-OCDS-002 | Selective publication | Hiding unfavorable releases (e.g., cancellations) | Misleading public picture | RIINA completeness proof: all state changes generate releases |
| PROC-OCDS-003 | Data tampering post-publication | Modifying published releases | Trust erosion, incorrect analysis | Hash chains + digital signatures on every release |
| PROC-OCDS-004 | Required field redaction | Removing required public fields before publication | Incomplete data for oversight | Type system: required fields cannot be None |
| PROC-OCDS-005 | Compilation manipulation | Compiled record differs from raw releases | Incorrect summary view | Proven merge function: compile(releases) = compiledRelease |
| PROC-OCDS-006 | Identifier collision | Two different processes share same OCID | Data corruption | OCID uniqueness proof + registered prefix |
| PROC-OCDS-007 | Identifier spoofing | Fake organization IDs | Wrong entity attribution | Verified identifier scheme linking to authoritative registries |
| PROC-OCDS-008 | Temporal manipulation | Backdating or future-dating releases | Circumvent deadlines | Trusted timestamping (Track AD integration) |
| PROC-OCDS-009 | Codelist abuse | Using non-standard values for closed codelists | Interoperability failure | Inductive types in Coq — only valid constructors exist |
| PROC-OCDS-010 | Extension injection | Malicious data in extension fields | Code injection, XSS via data consumers | Extension schema validation, output encoding |
| PROC-OCDS-011 | Version downgrade | Publishing as older OCDS version to avoid new requirements | Evading new mandatory fields | Version pinning with minimum version enforcement |
| PROC-OCDS-012 | Phantom releases | Publishing releases for non-existent processes | Inflated statistics | Release must link to verified internal procurement record |
| PROC-OCDS-013 | Value manipulation | Understating or overstating monetary values | Incorrect spending analysis | Cross-validation with budget system, transaction records |
| PROC-OCDS-014 | Role confusion | Assigning incorrect roles to organizations | Obscuring conflicts of interest | Role assignment verified against procurement workflow |
| PROC-OCDS-015 | Batch omission | Excluding releases from batch exports | Incomplete dataset | Monotonic release counter with gap detection |

### 14.2 Threat-to-Theorem Mapping

| Threat | Mitigating Theorems |
|--------|-------------------|
| PROC-OCDS-001 | OCDS-001 through OCDS-030 (schema conformance) |
| PROC-OCDS-002 | OCDS-048, OCDS-067 (tag-content match, no redaction) |
| PROC-OCDS-003 | OCDS-071, OCDS-078, OCDS-079 (immutability, hash chain, signatures) |
| PROC-OCDS-004 | OCDS-067 (no required field redaction) |
| PROC-OCDS-005 | OCDS-051 through OCDS-065 (compilation correctness) |
| PROC-OCDS-006 | OCDS-005, OCDS-080 (OCID format, no duplicates) |
| PROC-OCDS-007 | OCDS-029 (identifier scheme validation) |
| PROC-OCDS-008 | OCDS-044, OCDS-077 (monotonic dates, trusted time) |
| PROC-OCDS-009 | OCDS-006 (closed codelist conformance) |
| PROC-OCDS-010 | OCDS-081 through OCDS-090 (extension validation) |
| PROC-OCDS-011 | Deployment-level enforcement (out of scope for data model) |
| PROC-OCDS-012 | OCDS-066 (publication fidelity) |
| PROC-OCDS-013 | OCDS-070, OCDS-073, OCDS-074 (value bounds) |
| PROC-OCDS-014 | OCDS-069 (role consistency) |
| PROC-OCDS-015 | OCDS-080, OCDS-068 (no duplicates, complete trail) |

---

## 15. Estimated Theorem Count

### 15.1 Summary by Category

| Category | Theorem Range | Count | Complexity |
|----------|--------------|-------|------------|
| Schema Conformance | OCDS-001 to OCDS-030 | 30 | Low-Medium |
| Lifecycle Consistency | OCDS-031 to OCDS-050 | 20 | Medium |
| Record Compilation | OCDS-051 to OCDS-065 | 15 | Medium-High |
| Integrity/Transparency | OCDS-066 to OCDS-080 | 15 | Medium |
| Extension Compliance | OCDS-081 to OCDS-090 | 10 | Low-Medium |
| **Total** | **OCDS-001 to OCDS-090** | **90** | **Mixed** |

### 15.2 Effort Estimation

| Category | Avg Lines per Theorem | Total Lines | Estimated Days |
|----------|----------------------|-------------|----------------|
| Schema Conformance | 20-40 | 600-1,200 | 3-5 |
| Lifecycle Consistency | 40-80 | 800-1,600 | 5-8 |
| Record Compilation | 60-120 | 900-1,800 | 8-12 |
| Integrity/Transparency | 30-60 | 450-900 | 4-6 |
| Extension Compliance | 20-40 | 200-400 | 2-3 |
| **Total** | — | **2,950-5,900** | **22-34** |

### 15.3 Dependencies

| Category | Depends On |
|----------|-----------|
| Schema Conformance | Types.v, Codelists.v, Identifiers.v |
| Lifecycle Consistency | Validation.v (schema conformance as precondition) |
| Record Compilation | Types.v, Validation.v |
| Integrity/Transparency | All above + Track A (NonInterference), Track AE (Audit) |
| Extension Compliance | Types.v, Validation.v + extension-specific definitions |

### 15.4 Priority Order

1. **Types.v + Codelists.v** — Foundation, no dependencies
2. **Validation.v (OCDS-001 to OCDS-030)** — Schema conformance
3. **Lifecycle.v (OCDS-031 to OCDS-050)** — State machine proofs
4. **Compilation.v (OCDS-051 to OCDS-065)** — Record merge correctness
5. **Integrity.v (OCDS-066 to OCDS-080)** — Requires composition with other tracks
6. **Extensions.v (OCDS-081 to OCDS-090)** — Conditional on extension adoption

---

## 16. References

### 16.1 OCDS Specifications

1. Open Contracting Data Standard 1.1 — https://standard.open-contracting.org/latest/en/
2. OCDS JSON Schema — https://standard.open-contracting.org/schema/
3. OCDS Release Schema 1.1.5 — https://standard.open-contracting.org/1.1/en/schema/release/
4. OCDS Record Schema — https://standard.open-contracting.org/1.1/en/schema/record/
5. OCDS Codelists — https://standard.open-contracting.org/1.1/en/schema/codelists/
6. OCDS Extension Registry — https://extensions.open-contracting.org/
7. OCDS Merge Rules — https://standard.open-contracting.org/1.1/en/schema/merging/

### 16.2 Related Standards

8. JSON Schema Draft 4 — https://json-schema.org/specification-links.html#draft-4
9. RFC 7396 JSON Merge Patch — https://tools.ietf.org/html/rfc7396
10. ISO 8601 Date-Time — https://www.iso.org/iso-8601-date-and-time-format.html
11. ISO 4217 Currency Codes — https://www.iso.org/iso-4217-currency-codes.html
12. ISO 3166-1 Country Codes — https://www.iso.org/iso-3166-country-codes.html
13. org-id.guide Organization Identifiers — https://org-id.guide/

### 16.3 Malaysian Procurement

14. ePerolehan — https://eperolehan.gov.my/
15. MyProcurement — https://myprocurement.treasury.gov.my/
16. SSM (Companies Commission of Malaysia) — https://www.ssm.com.my/
17. Arahan Perbendaharaan — https://ppp.treasury.gov.my/

### 16.4 Academic References

18. Marchetti, M., et al. "Open Contracting Data Standard: From Theory to Practice." (2019)
19. Mendes, M. "Formal Verification of Data Schema Compliance." (2021)
20. Digiwhist. "Measuring Transparency in Public Procurement." (2018)

---

## Appendix A: Complete Field Count

| Section | Required Fields | Optional Fields | Total |
|---------|----------------|----------------|-------|
| Release (top-level) | 5 | 7 | 12 |
| Planning | 0 | 3 | 3 |
| Budget | 0 | 7 | 7 |
| Tender | 1 | 26 | 27 |
| Award | 1 | 10 | 11 |
| Contract | 2 | 10 | 12 |
| Implementation | 0 | 3 | 3 |
| Transaction | 1 | 6 | 7 |
| Organization | 2 | 6 | 8 |
| Identifier | 0 | 4 | 4 |
| Address | 0 | 5 | 5 |
| ContactPoint | 0 | 5 | 5 |
| Item | 1 | 6 | 7 |
| Classification | 0 | 4 | 4 |
| Unit | 0 | 4 | 4 |
| Period | 0 | 4 | 4 |
| Value | 0 | 2 | 2 |
| Document | 1 | 8 | 9 |
| Amendment | 0 | 6 | 6 |
| Milestone | 1 | 8 | 9 |
| **Total** | **15** | **134** | **149** |

---

## Appendix B: Validation Rule Count

| Category | Rules |
|----------|-------|
| Required field checks | 15 |
| Type constraint checks | 149 |
| Format constraint checks | ~50 (all date-time, uri, email fields) |
| Closed codelist enum checks | 4 codelists |
| Pattern constraint checks | 3 (ocid, currency, language) |
| Cross-field consistency | 12 |
| Array uniqueness | 9 |
| Reference integrity | 7 |
| **Total validation rules** | **~249** |

---

*This document is the definitive reference for OCDS formal verification within the RIINA proof repository.*

*Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | INFINITE TIMELINE*

*"Q.E.D. Aeternum."*
