# Y_VERIFIED_STDLIB Remediation Worklist

## Immediate (audit cleanup)
- [ ] Correct implementation mapping: riina-codegen builtins + riina-typechecker
- [ ] Add StandardLibrary.v and PlatformStdlibVerification.v to evidence
- [ ] Write Y vs P domain boundary statement
- [ ] Add generated-lane disclaimers for non-Coq files
- [ ] Commit audit artifact to snapshot

## Phase 2 (formal model)
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:546
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:584
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:610
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:619
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:628
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:664
- [ ] Fix vacuous theorem at Y001_VerifiedStdlib.v:679
- [ ] Create per-builtin claim-to-artifact mapping table

## Phase 3 (toolchain enforcement)
- [ ] Replace `Ty::Fn(Any, Any, Pure)` for teks (string) builtins
- [ ] Replace `Ty::Fn(Any, Any, Pure)` for senarai (list) builtins
- [ ] Replace `Ty::Fn(Any, Any, Pure)` for remaining 3 builtin families
- [ ] Add negative test: `teks_belah(42)` rejected at check time
- [ ] Add negative test: `senarai_dapat((1,5))` rejected at check time
- [ ] Add negative test: `json_urai(1)` rejected at check time
- [ ] Document one complete theorem-to-implementation trace
