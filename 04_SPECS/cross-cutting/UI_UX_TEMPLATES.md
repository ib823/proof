# RIINA UI/UX DESIGN TEMPLATES

## Version 1.0.0 — Comprehensive Compliance | 1,000,000× Better Interface

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                      ║
║  ██╗   ██╗██╗    ██╗██╗   ██╗██╗  ██╗                                                               ║
║  ██║   ██║██║   ██╔╝██║   ██║╚██╗██╔╝                                                               ║
║  ██║   ██║██║  ██╔╝ ██║   ██║ ╚███╔╝                                                                ║
║  ██║   ██║██║ ██╔╝  ██║   ██║ ██╔██╗                                                                ║
║  ╚██████╔╝██║██╔╝   ╚██████╔╝██╔╝ ██╗                                                               ║
║   ╚═════╝ ╚═╝╚═╝     ╚═════╝ ╚═╝  ╚═╝                                                               ║
║                                                                                                      ║
║  RIINA USER INTERFACE AND USER EXPERIENCE TEMPLATES                                                 ║
║  "1,000,000× Better Than Second Best"                                                               ║
║                                                                                                      ║
║  Core Principle: Security should be invisible when not needed,                                      ║
║                  crystal clear when it is                                                           ║
║                                                                                                      ║
║  Date: 2026-01-19                                                                                    ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

## IMPLEMENTATION STATUS (Audit: 2026-02-06)

| Component | Status | Evidence |
|-----------|--------|----------|
| Design Templates | COMPLETE | Component library, design system, interaction patterns specified |
| Coq Formal Proofs | 8 FILES, ~71 Qed | domains/VerifiedUI.v + domains/uiux/*.v |
| Compiler UI Types | NOT STARTED | No UI type system in riina-typechecker |
| UI Runtime Library | NOT STARTED | No UI builtins or rendering engine |
| Example Programs | NOT STARTED | No UI-focused .rii examples |

**This document specifies UI/UX design templates for a future RIINA UI framework. No UI framework implementation exists. The templates are design specifications, not shipped features.**

---

# PART I: DESIGN PHILOSOPHY

## 1.1 The RIINA UX Manifesto

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  RIINA UX MANIFESTO — "1,000,000× Better Than Second Best"                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  PRINCIPLE 1: INVISIBLE SECURITY                                                                    ║
║  ═══════════════════════════════                                                                    ║
║  "The best security is security you don't notice—until you need it."                                ║
║                                                                                                      ║
║  • Security should never impede legitimate workflows                                                ║
║  • Authentication should be seamless (biometrics, passkeys)                                         ║
║  • Encryption happens automatically, transparently                                                  ║
║  • Audit logging is silent but comprehensive                                                        ║
║                                                                                                      ║
║  PRINCIPLE 2: PROACTIVE GUIDANCE                                                                    ║
║  ══════════════════════════════                                                                     ║
║  "Guide users toward secure choices before they make insecure ones."                                ║
║                                                                                                      ║
║  • Default to most secure option                                                                    ║
║  • Warn before risky actions, not after                                                             ║
║  • Explain WHY something is blocked, not just THAT it's blocked                                     ║
║  • Offer secure alternatives, never dead ends                                                       ║
║                                                                                                      ║
║  PRINCIPLE 3: CONTEXTUAL INTELLIGENCE                                                               ║
║  ════════════════════════════════                                                                   ║
║  "Show the right information at the right time in the right way."                                   ║
║                                                                                                      ║
║  • Adapt UI to user's role and clearance level                                                      ║
║  • Surface relevant security info based on current task                                             ║
║  • Progressive disclosure: simple first, details on demand                                          ║
║  • Context-aware help and recommendations                                                           ║
║                                                                                                      ║
║  PRINCIPLE 4: BEAUTIFUL SIMPLICITY                                                                  ║
║  ══════════════════════════════                                                                     ║
║  "Complex security, simple interface."                                                              ║
║                                                                                                      ║
║  • Clean, uncluttered design                                                                        ║
║  • Consistent visual language across all products                                                   ║
║  • Information hierarchy that guides the eye                                                        ║
║  • Micro-interactions that delight                                                                  ║
║                                                                                                      ║
║  PRINCIPLE 5: TRUST THROUGH TRANSPARENCY                                                            ║
║  ════════════════════════════════════                                                               ║
║  "Users trust what they understand."                                                                ║
║                                                                                                      ║
║  • Show security status clearly                                                                     ║
║  • Explain data handling in plain language                                                          ║
║  • Provide audit trails users can actually read                                                     ║
║  • Never hide important security information                                                        ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 1.2 Design System Foundation

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  RIINA DESIGN SYSTEM FOUNDATION                                                                     ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  COLOR PALETTE:                                                                                     ║
║  ══════════════                                                                                     ║
║                                                                                                      ║
║  Primary (Trust Blue)                                                                               ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────┐       ║
║  │  #0A1628  │  #1A365D  │  #2B6CB0  │  #4299E1  │  #63B3ED  │  #BEE3F8  │  #EBF8FF        │       ║
║  │  900      │  800      │  600      │  500      │  400      │  200      │  50             │       ║
║  └──────────────────────────────────────────────────────────────────────────────────────────┘       ║
║                                                                                                      ║
║  Security Status Colors                                                                             ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────┐       ║
║  │  SECURE     #22C55E (Green 500)    - All systems nominal                                │       ║
║  │  CAUTION    #EAB308 (Yellow 500)   - Attention needed                                   │       ║
║  │  WARNING    #F97316 (Orange 500)   - Action required                                    │       ║
║  │  CRITICAL   #EF4444 (Red 500)      - Immediate action                                   │       ║
║  │  UNKNOWN    #6B7280 (Gray 500)     - Status unavailable                                 │       ║
║  └──────────────────────────────────────────────────────────────────────────────────────────┘       ║
║                                                                                                      ║
║  Classification Level Colors (Military/Government)                                                  ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────┐       ║
║  │  UNCLASSIFIED     #22C55E (Green)     - Open/public                                     │       ║
║  │  CUI              #3B82F6 (Blue)      - Controlled unclassified                         │       ║
║  │  CONFIDENTIAL     #EAB308 (Yellow)    - Confidential                                    │       ║
║  │  SECRET           #F97316 (Orange)    - Secret                                          │       ║
║  │  TOP SECRET       #EF4444 (Red)       - Top Secret                                      │       ║
║  │  TS/SCI           #7C3AED (Purple)    - TS with compartments                            │       ║
║  └──────────────────────────────────────────────────────────────────────────────────────────┘       ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  TYPOGRAPHY:                                                                                        ║
║  ═══════════                                                                                        ║
║                                                                                                      ║
║  Primary Font: Inter (Sans-serif)                                                                   ║
║  • Clean, highly legible at all sizes                                                               ║
║  • Excellent for interfaces and data display                                                        ║
║  • Variable font for optimal rendering                                                              ║
║                                                                                                      ║
║  Monospace Font: JetBrains Mono                                                                     ║
║  • Code, logs, technical data                                                                       ║
║  • Clear distinction between similar characters                                                     ║
║  • Ligatures for common programming patterns                                                        ║
║                                                                                                      ║
║  Type Scale:                                                                                        ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────┐       ║
║  │  Display    48px / 3rem    - Page titles, hero text                                     │       ║
║  │  H1         36px / 2.25rem - Section headers                                            │       ║
║  │  H2         24px / 1.5rem  - Subsection headers                                         │       ║
║  │  H3         20px / 1.25rem - Card titles                                                │       ║
║  │  Body       16px / 1rem    - Main content                                               │       ║
║  │  Small      14px / 0.875rem - Secondary text, labels                                    │       ║
║  │  Caption    12px / 0.75rem - Captions, timestamps                                       │       ║
║  └──────────────────────────────────────────────────────────────────────────────────────────┘       ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  SPACING SYSTEM:                                                                                    ║
║  ═══════════════                                                                                    ║
║                                                                                                      ║
║  Base unit: 4px                                                                                     ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────┐       ║
║  │  xs    4px     - Micro spacing (icon padding)                                           │       ║
║  │  sm    8px     - Tight spacing (related items)                                          │       ║
║  │  md    16px    - Standard spacing (content)                                             │       ║
║  │  lg    24px    - Comfortable spacing (sections)                                         │       ║
║  │  xl    32px    - Generous spacing (major sections)                                      │       ║
║  │  2xl   48px    - Large spacing (page sections)                                          │       ║
║  │  3xl   64px    - Extra large (hero sections)                                            │       ║
║  └──────────────────────────────────────────────────────────────────────────────────────────┘       ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART II: COMPONENT LIBRARY

## 2.1 Security Status Components

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  SECURITY STATUS COMPONENTS                                                                         ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  SECURITY STATUS INDICATOR (Global)                                                                 ║
║  ═══════════════════════════════════                                                                ║
║                                                                                                      ║
║  ┌─────────────────────────────────────┐                                                            ║
║  │ ● SECURE                       ▾    │ ← Always visible in header                                ║
║  └─────────────────────────────────────┘                                                            ║
║                                                                                                      ║
║  Expanded state (on click):                                                                         ║
║  ┌─────────────────────────────────────────────────────────────────┐                                ║
║  │ ● SECURE                                                        │                                ║
║  │ ──────────────────────────────────────────────────────────────  │                                ║
║  │                                                                 │                                ║
║  │ ✓ Connection encrypted (TLS 1.3, AES-256-GCM)                  │                                ║
║  │ ✓ Identity verified (2 factors)                                │                                ║
║  │ ✓ Session secured (expires in 14:32)                           │                                ║
║  │ ✓ Data protection active                                       │                                ║
║  │                                                                 │                                ║
║  │ [View Security Details]              [Security Settings]       │                                ║
║  └─────────────────────────────────────────────────────────────────┘                                ║
║                                                                                                      ║
║  Warning state:                                                                                     ║
║  ┌─────────────────────────────────────────────────────────────────┐                                ║
║  │ ⚠ ATTENTION NEEDED                                              │                                ║
║  │ ──────────────────────────────────────────────────────────────  │                                ║
║  │                                                                 │                                ║
║  │ ⚠ Certificate expires in 7 days                                │                                ║
║  │ ✓ Connection encrypted                                         │                                ║
║  │ ✓ Identity verified                                            │                                ║
║  │                                                                 │                                ║
║  │ [Renew Certificate Now]              [Remind Me Later]         │                                ║
║  └─────────────────────────────────────────────────────────────────┘                                ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  CLASSIFICATION BANNER (Government/Military)                                                        ║
║  ═══════════════════════════════════════════                                                        ║
║                                                                                                      ║
║  TOP SECRET // SCI // NOFORN                                                                        ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────┐       ║
║  │                                                                                          │       ║
║  │                    ████  TOP SECRET // SCI // NOFORN  ████                               │       ║
║  │                                                                                          │       ║
║  └──────────────────────────────────────────────────────────────────────────────────────────┘       ║
║  • Always visible at top AND bottom of classified content                                           ║
║  • Cannot be scrolled off screen                                                                    ║
║  • Color-coded per classification level                                                             ║
║  • Includes handling caveats                                                                        ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  DATA SENSITIVITY INDICATOR                                                                         ║
║  ══════════════════════════                                                                         ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────┐                                 ║
║  │  📋 Patient Record: John Smith                                 │                                 ║
║  │  ──────────────────────────────────────────────────────────    │                                 ║
║  │  🔒 HIPAA Protected (PHI)                                      │                                 ║
║  │  📍 Stored: US-East (AWS GovCloud)                             │                                 ║
║  │  🕐 Accessed: Today 2:34 PM by Dr. Sarah Chen                  │                                 ║
║  │  📊 Access log: 12 views this month                            │                                 ║
║  └────────────────────────────────────────────────────────────────┘                                 ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 2.2 Authentication Components

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  AUTHENTICATION COMPONENTS                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  PASSKEY LOGIN (Preferred)                                                                          ║
║  ═════════════════════════                                                                          ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────┐                                 ║
║  │                                                                │                                 ║
║  │               🔐  Welcome back, Sarah                          │                                 ║
║  │                                                                │                                 ║
║  │        ┌──────────────────────────────────────┐               │                                 ║
║  │        │                                      │               │                                 ║
║  │        │     👆  Tap to sign in with          │               │                                 ║
║  │        │         your passkey                 │               │                                 ║
║  │        │                                      │               │                                 ║
║  │        └──────────────────────────────────────┘               │                                 ║
║  │                                                                │                                 ║
║  │        ─────────── or ───────────                             │                                 ║
║  │                                                                │                                 ║
║  │        [Use hardware key]    [Other options]                  │                                 ║
║  │                                                                │                                 ║
║  └────────────────────────────────────────────────────────────────┘                                 ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  MFA VERIFICATION                                                                                   ║
║  ════════════════                                                                                   ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────┐                                 ║
║  │                                                                │                                 ║
║  │               🔐  Verify your identity                         │                                 ║
║  │                                                                │                                 ║
║  │    Additional verification is required for this action.       │                                 ║
║  │                                                                │                                 ║
║  │    Choose verification method:                                │                                 ║
║  │                                                                │                                 ║
║  │    ┌──────────────────────────────────────────────┐           │                                 ║
║  │    │  👆  Biometric (Face ID / Fingerprint)       │           │                                 ║
║  │    │      Fastest, most secure                    │           │                                 ║
║  │    └──────────────────────────────────────────────┘           │                                 ║
║  │                                                                │                                 ║
║  │    ┌──────────────────────────────────────────────┐           │                                 ║
║  │    │  🔑  Hardware security key                   │           │                                 ║
║  │    │      Insert your FIDO2 key                   │           │                                 ║
║  │    └──────────────────────────────────────────────┘           │                                 ║
║  │                                                                │                                 ║
║  │    ┌──────────────────────────────────────────────┐           │                                 ║
║  │    │  📱  Authenticator app                       │           │                                 ║
║  │    │      Enter code from your app                │           │                                 ║
║  │    └──────────────────────────────────────────────┘           │                                 ║
║  │                                                                │                                 ║
║  └────────────────────────────────────────────────────────────────┘                                 ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  STEP-UP AUTHENTICATION (Contextual)                                                                ║
║  ════════════════════════════════════                                                               ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────┐                                 ║
║  │  ⚠️  Additional verification required                          │                                 ║
║  │  ──────────────────────────────────────────────────────────    │                                 ║
║  │                                                                │                                 ║
║  │  You're about to:                                             │                                 ║
║  │  • Transfer $50,000 to new recipient                          │                                 ║
║  │  • Add new wire instructions                                   │                                 ║
║  │                                                                │                                 ║
║  │  This action requires verification because:                   │                                 ║
║  │  ✓ Large transaction amount                                   │                                 ║
║  │  ✓ New recipient                                              │                                 ║
║  │                                                                │                                 ║
║  │  [Verify with biometrics]              [Cancel]               │                                 ║
║  │                                                                │                                 ║
║  └────────────────────────────────────────────────────────────────┘                                 ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 2.3 Audit and Logging Components

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  AUDIT AND LOGGING COMPONENTS                                                                       ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  ACTIVITY TIMELINE                                                                                  ║
║  ═════════════════                                                                                  ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────────────────────────────┐         ║
║  │  📋 Activity Log: Patient Record #12345                                                │         ║
║  │  ──────────────────────────────────────────────────────────────────────────────────    │         ║
║  │                                                                                        │         ║
║  │  Today                                                                                │         ║
║  │  ────                                                                                 │         ║
║  │  ○ 2:34 PM  Dr. Sarah Chen viewed record                                             │         ║
║  │  │          Purpose: Treatment                                                        │         ║
║  │  │          📍 Hospital Main, Workstation 42                                          │         ║
║  │  │                                                                                    │         ║
║  │  ○ 11:15 AM Lab results updated                                                       │         ║
║  │  │          By: Quest Diagnostics (automated)                                         │         ║
║  │  │          📋 Added: Blood panel results                                             │         ║
║  │  │                                                                                    │         ║
║  │  ○ 9:00 AM  Insurance verification                                                   │         ║
║  │             By: Billing Dept (Maria Rodriguez)                                        │         ║
║  │             Purpose: Claims processing                                                │         ║
║  │                                                                                        │         ║
║  │  Yesterday                                                                            │         ║
║  │  ─────────                                                                            │         ║
║  │  ○ 4:22 PM  Dr. Sarah Chen updated diagnosis                                         │         ║
║  │  ○ 2:00 PM  Nurse John Smith recorded vitals                                         │         ║
║  │  ○ 10:30 AM Patient portal access (patient)                                          │         ║
║  │                                                                                        │         ║
║  │  [Load more]                                                     [Export log]         │         ║
║  └────────────────────────────────────────────────────────────────────────────────────────┘         ║
║                                                                                                      ║
║  ─────────────────────────────────────────────────────────────────────────────────────────────────  ║
║                                                                                                      ║
║  SECURITY EVENT NOTIFICATION                                                                        ║
║  ═══════════════════════════                                                                        ║
║                                                                                                      ║
║  Toast notification (non-critical):                                                                 ║
║  ┌────────────────────────────────────────────────────────────┐                                     ║
║  │  ℹ️  New login from new device                              │                                     ║
║  │  Chrome on Windows • New York, NY                          │                                     ║
║  │  [That was me]                    [Secure my account]      │                                     ║
║  └────────────────────────────────────────────────────────────┘                                     ║
║                                                                                                      ║
║  Modal notification (critical):                                                                     ║
║  ┌────────────────────────────────────────────────────────────────────────────────────────┐         ║
║  │                                                                                        │         ║
║  │                    ⚠️  SECURITY ALERT                                                  │         ║
║  │                                                                                        │         ║
║  │     Unusual activity detected on your account                                         │         ║
║  │                                                                                        │         ║
║  │     ┌────────────────────────────────────────────────────────────────────────────┐    │         ║
║  │     │  • 3 failed login attempts from unknown IP                                 │    │         ║
║  │     │  • Location: Moscow, Russia (unusual for your account)                     │    │         ║
║  │     │  • Time: 3:42 AM your local time                                          │    │         ║
║  │     └────────────────────────────────────────────────────────────────────────────┘    │         ║
║  │                                                                                        │         ║
║  │     Your account is currently secure. We blocked these attempts.                      │         ║
║  │                                                                                        │         ║
║  │     [Review activity]    [Change password]    [Dismiss]                               │         ║
║  │                                                                                        │         ║
║  └────────────────────────────────────────────────────────────────────────────────────────┘         ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART III: INDUSTRY-SPECIFIC UI PATTERNS

## 3.1 Healthcare (IND-B)

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  IND-B: HEALTHCARE UI PATTERNS                                                                      ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  BREAK-THE-GLASS OVERRIDE                                                                           ║
║  ════════════════════════                                                                           ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────────────────────────────┐         ║
║  │                                                                                        │         ║
║  │          🚨  EMERGENCY ACCESS REQUEST                                                  │         ║
║  │                                                                                        │         ║
║  │    You do not have routine access to this patient record.                             │         ║
║  │                                                                                        │         ║
║  │    ┌──────────────────────────────────────────────────────────────────────────────┐   │         ║
║  │    │  Patient: Jane Doe (MRN: 789456)                                             │   │         ║
║  │    │  Your role: Emergency Department Physician                                   │   │         ║
║  │    │  Current access level: None                                                  │   │         ║
║  │    └──────────────────────────────────────────────────────────────────────────────┘   │         ║
║  │                                                                                        │         ║
║  │    Emergency access is audited and reviewed. Please provide:                          │         ║
║  │                                                                                        │         ║
║  │    Reason for access: *                                                               │         ║
║  │    ┌──────────────────────────────────────────────────────────────────────────────┐   │         ║
║  │    │  [▾ Select reason]                                                           │   │         ║
║  │    │    • Life-threatening emergency                                              │   │         ║
║  │    │    • Urgent care required                                                    │   │         ║
║  │    │    • Consulting physician request                                            │   │         ║
║  │    │    • Other (explain below)                                                   │   │         ║
║  │    └──────────────────────────────────────────────────────────────────────────────┘   │         ║
║  │                                                                                        │         ║
║  │    Additional details:                                                                │         ║
║  │    ┌──────────────────────────────────────────────────────────────────────────────┐   │         ║
║  │    │                                                                              │   │         ║
║  │    │                                                                              │   │         ║
║  │    └──────────────────────────────────────────────────────────────────────────────┘   │         ║
║  │                                                                                        │         ║
║  │    ☑️ I understand this access will be audited and reviewed                           │         ║
║  │                                                                                        │         ║
║  │    [Request Emergency Access]                           [Cancel]                      │         ║
║  │                                                                                        │         ║
║  └────────────────────────────────────────────────────────────────────────────────────────┘         ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 3.2 Financial Services (IND-C)

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  IND-C: FINANCIAL SERVICES UI PATTERNS                                                              ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  WIRE TRANSFER VERIFICATION                                                                         ║
║  ══════════════════════════                                                                         ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────────────────────────────┐         ║
║  │  💸 Wire Transfer Confirmation                                                         │         ║
║  │  ──────────────────────────────────────────────────────────────────────────────────    │         ║
║  │                                                                                        │         ║
║  │  IMPORTANT: Review all details carefully before confirming.                           │         ║
║  │                                                                                        │         ║
║  │  ┌──────────────────────────────────────────────────────────────────────────────┐     │         ║
║  │  │  FROM                                                                        │     │         ║
║  │  │  Account: ****4521 (Business Checking)                                       │     │         ║
║  │  │  Available: $125,432.56                                                      │     │         ║
║  │  └──────────────────────────────────────────────────────────────────────────────┘     │         ║
║  │                           ↓                                                           │         ║
║  │  ┌──────────────────────────────────────────────────────────────────────────────┐     │         ║
║  │  │  TO                                                                          │     │         ║
║  │  │  Recipient: ABC Title Company                                                │     │         ║
║  │  │  Bank: First National Bank                                                   │     │         ║
║  │  │  Routing: 021000089                                                          │     │         ║
║  │  │  Account: ****7890                                                           │     │         ║
║  │  │                                                                              │     │         ║
║  │  │  ⚠️ NEW RECIPIENT - First time sending to this account                       │     │         ║
║  │  └──────────────────────────────────────────────────────────────────────────────┘     │         ║
║  │                                                                                        │         ║
║  │  Amount: $245,000.00                                                                  │         ║
║  │  Reference: Closing - 123 Main St                                                     │         ║
║  │                                                                                        │         ║
║  │  ┌──────────────────────────────────────────────────────────────────────────────┐     │         ║
║  │  │  🔒 VERIFICATION REQUIRED                                                     │     │         ║
║  │  │                                                                              │     │         ║
║  │  │  Before this wire can be processed:                                          │     │         ║
║  │  │                                                                              │     │         ║
║  │  │  ☐ Call recipient to verify account details                                  │     │         ║
║  │  │    📞 Call: (555) 123-4567 (ABC Title Company)                               │     │         ║
║  │  │                                                                              │     │         ║
║  │  │  ☑️ I have verified these wire instructions by phone                          │     │         ║
║  │  │    with a known contact at the recipient                                     │     │         ║
║  │  └──────────────────────────────────────────────────────────────────────────────┘     │         ║
║  │                                                                                        │         ║
║  │  [Verify and Send]                                              [Cancel]              │         ║
║  │                                                                                        │         ║
║  └────────────────────────────────────────────────────────────────────────────────────────┘         ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## 3.3 Military/Defense (IND-A)

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  IND-A: MILITARY/DEFENSE UI PATTERNS                                                                ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  NEED-TO-KNOW ACCESS REQUEST                                                                        ║
║  ═══════════════════════════                                                                        ║
║                                                                                                      ║
║  ████████████████████████████████████████████████████████████████████████████████████████           ║
║  ██                           TOP SECRET // SCI // NOFORN                              ██           ║
║  ████████████████████████████████████████████████████████████████████████████████████████           ║
║                                                                                                      ║
║  ┌────────────────────────────────────────────────────────────────────────────────────────┐         ║
║  │                                                                                        │         ║
║  │          🔐  COMPARTMENTED ACCESS REQUEST                                              │         ║
║  │                                                                                        │         ║
║  │    You are requesting access to:                                                      │         ║
║  │    ┌──────────────────────────────────────────────────────────────────────────────┐   │         ║
║  │    │  Program: [REDACTED]                                                         │   │         ║
║  │    │  Classification: TS/SCI                                                      │   │         ║
║  │    │  Compartments: [REDACTED], [REDACTED]                                        │   │         ║
║  │    └──────────────────────────────────────────────────────────────────────────────┘   │         ║
║  │                                                                                        │         ║
║  │    Your current access:                                                               │         ║
║  │    ┌──────────────────────────────────────────────────────────────────────────────┐   │         ║
║  │    │  Clearance: TOP SECRET                        ✓                              │   │         ║
║  │    │  SCI Access: [REDACTED]                       ✓                              │   │         ║
║  │    │  Required Compartments: [REDACTED]            ✗ Not indoctrinated           │   │         ║
║  │    └──────────────────────────────────────────────────────────────────────────────┘   │         ║
║  │                                                                                        │         ║
║  │    Mission justification required:                                                    │         ║
║  │    ┌──────────────────────────────────────────────────────────────────────────────┐   │         ║
║  │    │                                                                              │   │         ║
║  │    │                                                                              │   │         ║
║  │    └──────────────────────────────────────────────────────────────────────────────┘   │         ║
║  │                                                                                        │         ║
║  │    Supervisor approval: _________________________ (required)                          │         ║
║  │                                                                                        │         ║
║  │    [Submit Request]                                    [Cancel]                       │         ║
║  │                                                                                        │         ║
║  └────────────────────────────────────────────────────────────────────────────────────────┘         ║
║                                                                                                      ║
║  ████████████████████████████████████████████████████████████████████████████████████████           ║
║  ██                           TOP SECRET // SCI // NOFORN                              ██           ║
║  ████████████████████████████████████████████████████████████████████████████████████████           ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# PART IV: ACCESSIBILITY AND INTERNATIONALIZATION

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  ACCESSIBILITY AND INTERNATIONALIZATION                                                             ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                      ║
║  WCAG 2.1 AA COMPLIANCE (Minimum):                                                                  ║
║  ═════════════════════════════════                                                                  ║
║                                                                                                      ║
║  • Color contrast: 4.5:1 for normal text, 3:1 for large text                                        ║
║  • Never rely on color alone for information                                                        ║
║  • Full keyboard navigation support                                                                 ║
║  • Screen reader compatible (ARIA labels)                                                           ║
║  • Focus indicators clearly visible                                                                 ║
║  • Text resizable to 200% without loss of functionality                                             ║
║  • Touch targets minimum 44×44 pixels                                                               ║
║                                                                                                      ║
║  SECURITY-SPECIFIC ACCESSIBILITY:                                                                   ║
║  ═════════════════════════════════                                                                  ║
║                                                                                                      ║
║  • Classification banners: Pattern + color + text                                                   ║
║  • Security status: Icon + color + text                                                             ║
║  • Alerts: Audio + visual (user configurable)                                                       ║
║  • MFA prompts: Multiple modalities available                                                       ║
║                                                                                                      ║
║  INTERNATIONALIZATION:                                                                              ║
║  ═════════════════════                                                                              ║
║                                                                                                      ║
║  • RTL language support (Arabic, Hebrew)                                                            ║
║  • Unicode throughout                                                                               ║
║  • Date/time/number localization                                                                    ║
║  • Translatable strings externalized                                                                ║
║  • Security terms reviewed by native speakers                                                       ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# DOCUMENT SIGNATURE

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                      ║
║  Document: RIINA_UI_UX_TEMPLATES_v1_0_0.md                                                          ║
║  Version: 1.0.0                                                                                      ║
║  Date: 2026-01-19                                                                                    ║
║  Status: COMPLETE - COMPLIANT                                                           ║
║                                                                                                      ║
║  Summary:                                                                                           ║
║  • UX philosophy ("1,000,000× better than second best")                                             ║
║  • Complete design system (colors, typography, spacing)                                             ║
║  • Security-specific component library                                                              ║
║  • Industry-specific UI patterns (Healthcare, Financial, Military)                                  ║
║  • Authentication and authorization flows                                                           ║
║  • Audit and logging interfaces                                                                     ║
║  • Accessibility and internationalization guidelines                                                ║
║                                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

## PLATFORM BACKEND TARGETS (Phase 7)

The UI/UX design system defined in this document applies to **all platform backends**:

| Backend | Implementation Target | UI/UX Applicability |
|---------|-----------------------|---------------------|
| **M7.2 WASM** | Web applications via `--target=wasm32` | Full web design system: DOM components, CSS variables, WCAG AAA compliance, responsive layouts |
| **M7.4 Android** | Android apps via `--target=android-arm64` | Material Design integration, Android accessibility services, JNI bridge for native UI |
| **M7.4 iOS** | iOS apps via `--target=ios-arm64` | UIKit/SwiftUI bridge, iOS accessibility, Swift binding for native UI components |
| **M7.5 Playground** | In-browser compiler (Playground page) | Split-pane editor, 5 examples, debounced compile, Web Worker WASM execution |

The 200 UI verification theorems from Track UX-01 ensure that:
- Accessibility properties (WCAG AAA) are preserved across all platforms
- Security-relevant UI states (secret data display, authentication flows) are formally verified
- Platform-conditional stdlib (M7.3) ensures correct UI behavior per platform

---

**END OF RIINA UI/UX DESIGN TEMPLATES**
