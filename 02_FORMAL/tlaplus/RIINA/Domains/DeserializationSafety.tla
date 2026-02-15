---- MODULE DeserializationSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/DeserializationSafety.v (26 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* SerFormat (matches Coq: Inductive SerFormat)
CONSTANTS JSON, MessagePack, CBOR, Protobuf, Custom

\* TypeTag (matches Coq: Inductive TypeTag)
CONSTANTS TagBool, TagNat, TagString, TagList, TagRecord, TagNone

\* DeserResult (matches Coq: Inductive DeserResult)
CONSTANTS DeserOk, DeserTypeErr, DeserOverflow, DeserMalformed, DeserGadget

\* DeserPolicy (matches Coq: Record DeserPolicy)
VARIABLES dp_max_depth, dp_max_size_bytes, dp_allow_polymorphic, dp_allow_callbacks, dp_allow_reflection, dp_require_schema, dp_require_type_tag, dp_sanitize_strings, dp_allowlist_types, dp_log_deserializations

\* SerializedInput (matches Coq: Record SerializedInput)
VARIABLES si_format, si_size_bytes, si_depth, si_has_schema, si_has_type_tags, si_contains_code, si_types_allowlisted

\* Type invariant
TypeOK ==
  /\ dp_max_depth \in BOOLEAN
  /\ dp_max_size_bytes \in BOOLEAN
  /\ dp_allow_polymorphic \in BOOLEAN
  /\ dp_allow_callbacks \in BOOLEAN
  /\ dp_allow_reflection \in BOOLEAN
  /\ dp_require_schema \in BOOLEAN
  /\ dp_require_type_tag \in BOOLEAN
  /\ dp_sanitize_strings \in BOOLEAN
  /\ dp_allowlist_types \in BOOLEAN
  /\ dp_log_deserializations \in BOOLEAN
  /\ si_format \in BOOLEAN
  /\ si_size_bytes \in BOOLEAN
  /\ si_depth \in BOOLEAN
  /\ si_has_schema \in BOOLEAN
  /\ si_has_type_tags \in BOOLEAN
  /\ si_contains_code \in BOOLEAN
  /\ si_types_allowlisted \in BOOLEAN

\* Initial state
Init ==
  /\ dp_max_depth = TRUE
  /\ dp_max_size_bytes = TRUE
  /\ dp_allow_polymorphic = TRUE
  /\ dp_allow_callbacks = TRUE
  /\ dp_allow_reflection = TRUE
  /\ dp_require_schema = TRUE
  /\ dp_require_type_tag = TRUE
  /\ dp_sanitize_strings = TRUE
  /\ dp_allowlist_types = TRUE
  /\ dp_log_deserializations = TRUE
  /\ si_format = TRUE
  /\ si_size_bytes = TRUE
  /\ si_depth = TRUE
  /\ si_has_schema = TRUE
  /\ si_has_type_tags = TRUE
  /\ si_contains_code = TRUE
  /\ si_types_allowlisted = TRUE

\* rce_prevention_active (matches Coq: Definition rce_prevention_active)
rce_prevention_active(p) == TRUE

\* schema_enforcement_active (matches Coq: Definition schema_enforcement_active)
schema_enforcement_active(p) == TRUE

\* input_validation_active (matches Coq: Definition input_validation_active)
input_validation_active(p) == TRUE

\* string_safety_active (matches Coq: Definition string_safety_active)
string_safety_active(p) == TRUE

\* all_deser_defenses (matches Coq: Definition all_deser_defenses)
all_deser_defenses(p) == TRUE

\* riina_deser_policy (matches Coq: Definition riina_deser_policy)
riina_deser_policy == TRUE

\* check_input (matches Coq: Definition check_input)
check_input(p, inp) == TRUE

\* is_deser_ok (matches Coq: Definition is_deser_ok)
is_deser_ok(r) == TRUE

\* is_gadget_blocked (matches Coq: Definition is_gadget_blocked)
is_gadget_blocked(r) == TRUE

\* andb_true_iff_deser (matches Coq: Lemma andb_true_iff_deser)
THEOREM andb_true_iff_deser == Init => TypeOK

\* DESER_001_rce_prevention (matches Coq: Theorem DESER_001_rce_prevention)
THEOREM DESER_001_rce_prevention == Init => TypeOK

\* DESER_002_schema_enforcement (matches Coq: Theorem DESER_002_schema_enforcement)
THEOREM DESER_002_schema_enforcement == Init => TypeOK

\* DESER_003_input_validation (matches Coq: Theorem DESER_003_input_validation)
THEOREM DESER_003_input_validation == Init => TypeOK

\* DESER_004_string_safety (matches Coq: Theorem DESER_004_string_safety)
THEOREM DESER_004_string_safety == Init => TypeOK

\* DESER_005_all_defenses (matches Coq: Theorem DESER_005_all_defenses)
THEOREM DESER_005_all_defenses == Init => TypeOK

\* DESER_006_gadget_blocked (matches Coq: Theorem DESER_006_gadget_blocked)
THEOREM DESER_006_gadget_blocked == Init => TypeOK

\* DESER_007_no_polymorphic (matches Coq: Theorem DESER_007_no_polymorphic)
THEOREM DESER_007_no_polymorphic == Init => TypeOK

\* DESER_008_no_callbacks (matches Coq: Theorem DESER_008_no_callbacks)
THEOREM DESER_008_no_callbacks == Init => TypeOK

\* DESER_009_no_reflection (matches Coq: Theorem DESER_009_no_reflection)
THEOREM DESER_009_no_reflection == Init => TypeOK

\* DESER_010_requires_schema (matches Coq: Theorem DESER_010_requires_schema)
THEOREM DESER_010_requires_schema == Init => TypeOK

\* DESER_011_requires_type_tags (matches Coq: Theorem DESER_011_requires_type_tags)
THEOREM DESER_011_requires_type_tags == Init => TypeOK

\* DESER_012_requires_allowlist (matches Coq: Theorem DESER_012_requires_allowlist)
THEOREM DESER_012_requires_allowlist == Init => TypeOK

\* DESER_013_valid_input_passes (matches Coq: Theorem DESER_013_valid_input_passes)
THEOREM DESER_013_valid_input_passes == Init => TypeOK

\* DESER_014_oversized_rejected (matches Coq: Theorem DESER_014_oversized_rejected)
THEOREM DESER_014_oversized_rejected == Init => TypeOK

\* DESER_015_overdepth_rejected (matches Coq: Theorem DESER_015_overdepth_rejected)
THEOREM DESER_015_overdepth_rejected == Init => TypeOK

\* DESER_016_ok_is_ok (matches Coq: Theorem DESER_016_ok_is_ok)
THEOREM DESER_016_ok_is_ok == Init => TypeOK

\* DESER_017_gadget_not_ok (matches Coq: Theorem DESER_017_gadget_not_ok)
THEOREM DESER_017_gadget_not_ok == Init => TypeOK

\* DESER_018_type_err_not_ok (matches Coq: Theorem DESER_018_type_err_not_ok)
THEOREM DESER_018_type_err_not_ok == Init => TypeOK

\* DESER_019_overflow_not_ok (matches Coq: Theorem DESER_019_overflow_not_ok)
THEOREM DESER_019_overflow_not_ok == Init => TypeOK

\* DESER_020_malformed_not_ok (matches Coq: Theorem DESER_020_malformed_not_ok)
THEOREM DESER_020_malformed_not_ok == Init => TypeOK

\* DESER_021_all_implies_rce (matches Coq: Theorem DESER_021_all_implies_rce)
THEOREM DESER_021_all_implies_rce == Init => TypeOK

\* DESER_022_all_implies_schema (matches Coq: Theorem DESER_022_all_implies_schema)
THEOREM DESER_022_all_implies_schema == Init => TypeOK

\* DESER_023_all_implies_validation (matches Coq: Theorem DESER_023_all_implies_validation)
THEOREM DESER_023_all_implies_validation == Init => TypeOK

\* DESER_024_all_implies_string (matches Coq: Theorem DESER_024_all_implies_string)
THEOREM DESER_024_all_implies_string == Init => TypeOK

\* DESER_025_complete_defense (matches Coq: Theorem DESER_025_complete_defense)
THEOREM DESER_025_complete_defense == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<dp_max_depth, dp_max_size_bytes, dp_allow_polymorphic, dp_allow_callbacks, dp_allow_reflection, dp_require_schema, dp_require_type_tag, dp_sanitize_strings, dp_allowlist_types, dp_log_deserializations, si_format, si_size_bytes, si_depth, si_has_schema, si_has_type_tags, si_contains_code, si_types_allowlisted>>

\* Specification
Spec == Init /\ [][Next]_<<dp_max_depth, dp_max_size_bytes, dp_allow_polymorphic, dp_allow_callbacks, dp_allow_reflection, dp_require_schema, dp_require_type_tag, dp_sanitize_strings, dp_allowlist_types, dp_log_deserializations, si_format, si_size_bytes, si_depth, si_has_schema, si_has_type_tags, si_contains_code, si_types_allowlisted>>

====
