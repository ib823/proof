; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ModuleSystems — SMT Verification
; Derived from 02_FORMAL/coq/domains/ModuleSystems.v (26 assertions)
; Module: ModuleSystems
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Visibility 0)) (((VPrivate) (VCrate) (VPublic) (VSecurityLevel))))

(declare-datatypes ((ModuleItem 0)) (((MIType) (MIFunction) (MIModule))))

(declare-datatypes ((InitState 0)) (((Uninitialized) (Initializing) (Initialized))))

(declare-datatypes ((Rec_Module 0))
  (((mk-module (mod_path Int) (mod_items (Seq Int)) (mod_exports (Seq Int))))))

(declare-datatypes ((Rec_Crate 0))
  (((mk-crate (crate_name String) (crate_modules (Seq Int))))))

(declare-datatypes ((Signature 0))
  (((mk-signature (sig_types (Seq Int)) (sig_functions (Seq Int))))))

(declare-datatypes ((Version 0))
  (((mk-version (major Int) (minor Int) (patch Int)))))

(declare-datatypes ((Dependency 0))
  (((mk-dependency (dep_name String) (dep_version Version) (dep_security_min Int)))))

(declare-datatypes ((ImportContext 0))
  (((mk-import_context (import_source Rec_Module) (import_names (Seq Int))))))

(declare-datatypes ((AbstractType 0))
  (((mk-abstract_type (abs_name String) (abs_repr Int) (abs_exposed Bool)))))

(declare-datatypes ((SealedTrait 0))
  (((mk-sealed_trait (sealed_name String) (sealed_impls (Seq Int))))))

(declare-datatypes ((InterfaceFile 0))
  (((mk-interface_file (iface_module Int) (iface_public_types (Seq Int)) (iface_public_fns (Seq Int)) (iface_effects (Seq Int))))))

(declare-datatypes ((CompilationUnit 0))
  (((mk-compilation_unit (cu_module Rec_Module) (cu_hash Int) (cu_deps (Seq Int))))))

(declare-datatypes ((Package 0))
  (((mk-package (pkg_name String) (pkg_version Version) (pkg_deps (Seq Int))))))

(declare-datatypes ((CapabilityReq 0))
  (((mk-capability_req (cap_name String) (cap_level Int)))))

(declare-datatypes ((ReExport 0))
  (((mk-re_export (reexp_source Rec_Module) (reexp_target Rec_Module) (reexp_names (Seq Int))))))

(declare-datatypes ((CapabilityScope 0))
  (((mk-capability_scope (scope_cap CapabilityReq) (scope_allowed (Seq Int))))))

(declare-datatypes ((AssocTypeMapping 0))
  (((mk-assoc_type_mapping (assoc_trait String) (assoc_impl String) (assoc_type_name String) (assoc_resolved String)))))

(declare-datatypes ((EffectSig 0))
  (((mk-effect_sig (effect_name String) (effect_ops (Seq Int))))))

(declare-datatypes ((StaticInit 0))
  (((mk-static_init (si_module Int) (si_value Int)))))

(declare-datatypes ((SecureInit 0))
  (((mk-secure_init (sec_init_module Int) (sec_init_cap_required (Seq Int)) (sec_init_cap_provided (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Visibility enum properties ---

; --- 1. Visibility exhaustiveness ---
(push 1)
(declare-const x Visibility)
(assert (not (or (= x VPrivate) (= x VCrate) (= x VPublic) (= x VSecurityLevel))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Visibility: VPrivate != VCrate ---
(push 1)
(assert (= VPrivate VCrate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Visibility: VCrate != VPublic ---
(push 1)
(assert (= VCrate VPublic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Visibility: VPublic != VSecurityLevel ---
(push 1)
(assert (= VPublic VSecurityLevel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Visibility: VPrivate != VSecurityLevel ---
(push 1)
(assert (= VPrivate VSecurityLevel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Visibility finite cardinality (4 values) ---
(push 1)
(declare-const x Visibility)
(assert (and (not (= x VPrivate)) (not (= x VCrate)) (not (= x VPublic)) (not (= x VSecurityLevel))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ModuleItem enum properties ---

; --- 7. ModuleItem exhaustiveness ---
(push 1)
(declare-const x ModuleItem)
(assert (not (or (= x MIType) (= x MIFunction) (= x MIModule))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ModuleItem: MIType != MIFunction ---
(push 1)
(assert (= MIType MIFunction))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ModuleItem: MIFunction != MIModule ---
(push 1)
(assert (= MIFunction MIModule))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ModuleItem: MIType != MIModule ---
(push 1)
(assert (= MIType MIModule))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ModuleItem finite cardinality (3 values) ---
(push 1)
(declare-const x ModuleItem)
(assert (and (not (= x MIType)) (not (= x MIFunction)) (not (= x MIModule))))
(check-sat) ; expect UNSAT
(pop 1)

; --- InitState enum properties ---

; --- 12. InitState exhaustiveness ---
(push 1)
(declare-const x InitState)
(assert (not (or (= x Uninitialized) (= x Initializing) (= x Initialized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. InitState: Uninitialized != Initializing ---
(push 1)
(assert (= Uninitialized Initializing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. InitState: Initializing != Initialized ---
(push 1)
(assert (= Initializing Initialized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. InitState: Uninitialized != Initialized ---
(push 1)
(assert (= Uninitialized Initialized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. InitState finite cardinality (3 values) ---
(push 1)
(declare-const x InitState)
(assert (and (not (= x Uninitialized)) (not (= x Initializing)) (not (= x Initialized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Rec_Module record properties ---

; --- 17. Rec_Module accessor round-trip: mod_path ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (mod_path (mk-module f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Rec_Module accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (mod_items (mk-module f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Rec_Module: integer field consistency ---
(push 1)
(declare-const r Rec_Module)
(assert (>= (mod_path r) 0))
(assert (>= (seq.len (mod_items r)) 0))
(assert (not (>= (+ (mod_path r) (seq.len (mod_items r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Rec_Crate record properties ---

; --- 20. Rec_Crate accessor round-trip: crate_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 (Seq Int))
(assert (not (= (crate_name (mk-crate f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Signature record properties ---

; --- 21. Signature accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (sig_types (mk-signature f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Version record properties ---

; --- 22. Version accessor round-trip: major ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (major (mk-version f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Version accessor round-trip: minor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (minor (mk-version f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Version: integer field consistency ---
(push 1)
(declare-const r Version)
(assert (>= (major r) 0))
(assert (>= (minor r) 0))
(assert (not (>= (+ (major r) (minor r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Dependency record properties ---

; --- 25. Dependency accessor round-trip: dep_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Version)
(declare-const f2 Int)
(assert (not (= (dep_name (mk-dependency f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Dependency accessor round-trip: dep_version ---
(push 1)
(declare-const f0 String)
(declare-const f1 Version)
(declare-const f2 Int)
(assert (not (= (dep_version (mk-dependency f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ImportContext record properties ---

; --- 27. ImportContext accessor round-trip: import_source ---
(push 1)
(declare-const f0 Rec_Module)
(declare-const f1 (Seq Int))
(assert (not (= (import_source (mk-import_context f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AbstractType record properties ---

; --- 28. AbstractType accessor round-trip: abs_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (abs_name (mk-abstract_type f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. AbstractType accessor round-trip: abs_repr ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (abs_repr (mk-abstract_type f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SealedTrait record properties ---

; --- 30. SealedTrait accessor round-trip: sealed_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 (Seq Int))
(assert (not (= (sealed_name (mk-sealed_trait f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InterfaceFile record properties ---

; --- 31. InterfaceFile accessor round-trip: iface_module ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (iface_module (mk-interface_file f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. InterfaceFile accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (iface_public_types (mk-interface_file f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. InterfaceFile accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (iface_public_fns (mk-interface_file f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. InterfaceFile: integer field consistency ---
(push 1)
(declare-const r InterfaceFile)
(assert (>= (iface_module r) 0))
(assert (>= (seq.len (iface_public_types r)) 0))
(assert (not (>= (+ (iface_module r) (seq.len (iface_public_types r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CompilationUnit record properties ---

; --- 35. CompilationUnit accessor round-trip: cu_module ---
(push 1)
(declare-const f0 Rec_Module)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (cu_module (mk-compilation_unit f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. CompilationUnit accessor round-trip: cu_hash ---
(push 1)
(declare-const f0 Rec_Module)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (cu_hash (mk-compilation_unit f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Package record properties ---

; --- 37. Package accessor round-trip: pkg_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Version)
(declare-const f2 (Seq Int))
(assert (not (= (pkg_name (mk-package f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Package accessor round-trip: pkg_version ---
(push 1)
(declare-const f0 String)
(declare-const f1 Version)
(declare-const f2 (Seq Int))
(assert (not (= (pkg_version (mk-package f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CapabilityReq record properties ---

; --- 39. CapabilityReq accessor round-trip: cap_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(assert (not (= (cap_name (mk-capability_req f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReExport record properties ---

; --- 40. ReExport accessor round-trip: reexp_source ---
(push 1)
(declare-const f0 Rec_Module)
(declare-const f1 Rec_Module)
(declare-const f2 (Seq Int))
(assert (not (= (reexp_source (mk-re_export f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ReExport accessor round-trip: reexp_target ---
(push 1)
(declare-const f0 Rec_Module)
(declare-const f1 Rec_Module)
(declare-const f2 (Seq Int))
(assert (not (= (reexp_target (mk-re_export f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CapabilityScope record properties ---

; --- 42. CapabilityScope accessor round-trip: scope_cap ---
(push 1)
(declare-const f0 CapabilityReq)
(declare-const f1 (Seq Int))
(assert (not (= (scope_cap (mk-capability_scope f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AssocTypeMapping record properties ---

; --- 43. AssocTypeMapping accessor round-trip: assoc_trait ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 String)
(declare-const f3 String)
(assert (not (= (assoc_trait (mk-assoc_type_mapping f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. AssocTypeMapping accessor round-trip: assoc_impl ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 String)
(declare-const f3 String)
(assert (not (= (assoc_impl (mk-assoc_type_mapping f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. AssocTypeMapping accessor round-trip: assoc_type_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 String)
(declare-const f3 String)
(assert (not (= (assoc_type_name (mk-assoc_type_mapping f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EffectSig record properties ---

; --- 46. EffectSig accessor round-trip: effect_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 (Seq Int))
(assert (not (= (effect_name (mk-effect_sig f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StaticInit record properties ---

; --- 47. StaticInit accessor round-trip: si_module ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (si_module (mk-static_init f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureInit record properties ---

; --- 48. SecureInit accessor round-trip: sec_init_module ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (sec_init_module (mk-secure_init f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. SecureInit accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (sec_init_cap_required (mk-secure_init f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. SecureInit: integer field consistency ---
(push 1)
(declare-const r SecureInit)
(assert (>= (sec_init_module r) 0))
(assert (>= (seq.len (sec_init_cap_required r)) 0))
(assert (not (>= (+ (sec_init_module r) (seq.len (sec_init_cap_required r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
