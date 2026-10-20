# Syariah and RIINA

**RIINA does not check Syariah compliance today.** There is no Syariah effect,
no type that rules out riba, gharar or maysir, and no compile-time check of a
financial contract against AAOIFI or IFSB standards. A Syariah-compliant
financial type library is planned as REQ-20; the project's choice of fintech
with PCI-DSS and Syariah as its first target is recorded as REQ-33.

Withdrawn on 2026-10-20: earlier versions of this page described a `kesan SyariahPatuh` effect
that enforced those rules, and keywords with proven semantics. Neither existed.

Every `riina` block below is checked by the test suite
(`03_PROTO/crates/riinac/tests/doc_snippets.rs`).

## What exists

**`zakat`** is a builtin: `zakat(x)` is 2.5% of `x`, rounded down to a whole
number. The nisab threshold is yours to apply:

```riina
fungsi kira_zakat(harta: Nombor, nisab: Nombor) -> Nombor kesan Bersih {
    kalau harta >= nisab { zakat(harta) } lain { 0 }
}
```

`kira_zakat(10000, 5000)` is `250`; `kira_zakat(4000, 5000)` is `0`.

**Exact money.** `wang` (fixed-scale decimal with banker's rounding) and
`perpuluhan` (arbitrary-precision decimal) keep amounts exact, which any
profit-sharing or cost-plus calculation needs. See
[GETTING_STARTED.md](guide/GETTING_STARTED.md#5-money-that-does-not-lose-sen-1-minute).

## Reserved keywords

| Keyword | Meaning | Status |
|---------|---------|--------|
| `zakat` | Obligatory charity | Builtin, as above |
| `sukuk` | Islamic bond | Reserved: no semantics yet |
| `mudarabah` | Profit-sharing partnership | Reserved: no semantics yet |
| `musharakah` | Joint venture | Reserved: no semantics yet |
| `wakaf` | Endowment | Reserved: no semantics yet |

A reserved keyword cannot be used as a name, and the compiler gives it no
meaning. The language surface is frozen (REQ-108), so giving these meaning is
part of REQ-20 and needs an owner decision.

## The Coq model

`02_FORMAL/coq/domains/SyariahCompliance.v` models Syariah rules as boolean
properties of contract records and proves facts about those definitions. It is
a model: no RIINA program is checked against it, and the project counts its
results as model Qed, not as guarantees.

## Disclaimer

> **This is not a fatwa.** Nothing RIINA produces is religious guidance or a
> Syariah certification. Financial software intended to be Syariah-compliant
> must be reviewed by a qualified Syariah Advisory Board.
