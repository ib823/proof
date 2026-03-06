// Lean compiler output
// Module: RIINA.Industries
// Imports: Init RIINA.Foundations.Syntax RIINA.Foundations.Semantics RIINA.Industries.IndustryAerospace RIINA.Industries.IndustryAgriculture RIINA.Industries.IndustryEducation RIINA.Industries.IndustryEnergy RIINA.Industries.IndustryFinancial RIINA.Industries.IndustryGovernment RIINA.Industries.IndustryHealthcare RIINA.Industries.IndustryLegal RIINA.Industries.IndustryManufacturing RIINA.Industries.IndustryMedia RIINA.Industries.IndustryMilitary RIINA.Industries.IndustryRealEstate RIINA.Industries.IndustryRetail RIINA.Industries.IndustryTelecom RIINA.Industries.IndustryTransportation
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
lean_object* initialize_RIINA_Foundations_Syntax(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Semantics(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryAerospace(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryAgriculture(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryEducation(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryEnergy(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryFinancial(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryGovernment(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryHealthcare(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryLegal(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryManufacturing(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryMedia(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryMilitary(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryRealEstate(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryRetail(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryTelecom(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Industries_IndustryTransportation(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Industries(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Foundations_Syntax(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Foundations_Semantics(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryAerospace(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryAgriculture(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryEducation(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryEnergy(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryFinancial(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryGovernment(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryHealthcare(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryLegal(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryManufacturing(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryMedia(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryMilitary(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryRealEstate(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryRetail(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryTelecom(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Industries_IndustryTransportation(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
