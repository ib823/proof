# Syariah Compliance Guide

RIINA provides type-level Islamic finance regulation, enabling Syariah compliance to be verified at compile time.

## What is Syariah Compliance in RIINA?

RIINA encodes Islamic finance principles as type constraints and effect restrictions. The compiler proves that financial code adheres to Syariah rules — no riba (interest), no gharar (excessive uncertainty), no maysir (gambling).

**Grounded in standards:** AAOIFI SS 1-62, IFSB guidelines, BNM RMiT (Risk Management in Technology). Approximately 80% of Syariah rules are formalizable as type constraints.

## Keywords

| Keyword | Meaning | Usage |
|---------|---------|-------|
| `sukuk` | Islamic bond | Asset-backed securities with proven ownership transfer |
| `mudarabah` | Profit-sharing | Investment partnership with type-checked profit/loss distribution |
| `musharakah` | Joint venture | Shared ownership with proven proportional returns |
| `murabahah` | Cost-plus sale | Transparent markup with compile-time disclosure proof |
| `zakat` | Obligatory charity | Automatic calculation with proven thresholds (nisab) |
| `wakaf` | Endowment | Irrevocable dedication with type-enforced permanence |

## Effect Constraints

Syariah-compliant code operates under the `SyariahPatuh` effect constraint:

```riina
fungsi pindah_dana(dari: Akaun, ke: Akaun, jumlah: Nombor) -> Hasil<(), Ralat> kesan SyariahPatuh {
    // Compiler enforces:
    // - No interest accumulation (riba)
    // - No excessive uncertainty (gharar)
    // - No gambling mechanics (maysir)
    // - Transparent pricing (murabahah disclosure)
    pulang Ok(());
}
```

The `kesan SyariahPatuh` annotation tells the compiler to:
1. Reject any interest calculation on principal
2. Require transparent pricing in all transactions
3. Enforce asset-backing for all financial instruments
4. Verify profit/loss sharing ratios match contract terms

## Escrow Example

```riina
// Wakaf-style escrow: irrevocable deposit until conditions met
// No riba — funds held, not lent

biar deposit = 1000;
biar released = kalau deposit > 0 { deposit } lain { 0 };
released
```

## Zakat Calculation

```riina
// Automatic zakat at 2.5% when wealth exceeds nisab
fungsi kira_zakat(harta: Nombor, nisab: Nombor) -> Nombor kesan SyariahPatuh {
    kalau harta >= nisab {
        harta * 25 / 1000
    } lain {
        0
    }
}
```

## Disclaimer

> **This is not a fatwa.** RIINA's Syariah type system is a technical tool for enforcing formalizable rules. It does not constitute religious guidance. All Syariah-compliant software should be reviewed and certified by a qualified Syariah Advisory Board before deployment in production financial systems.

## Examples

See `07_EXAMPLES/08_jalinan/syariah_escrow.rii` for a conceptual escrow example.
