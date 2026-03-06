// Lean compiler output
// Module: RIINA.Compliance
// Imports: Init RIINA.Compliance.DO178CCompliance RIINA.Compliance.HIPAACompliance RIINA.Compliance.PCIDSSCompliance RIINA.Compliance.VerifiedCompliance
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Compliance_DO178CCompliance(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Compliance_HIPAACompliance(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Compliance_PCIDSSCompliance(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Compliance_VerifiedCompliance(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Compliance(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Compliance_DO178CCompliance(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Compliance_HIPAACompliance(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Compliance_PCIDSSCompliance(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Compliance_VerifiedCompliance(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
