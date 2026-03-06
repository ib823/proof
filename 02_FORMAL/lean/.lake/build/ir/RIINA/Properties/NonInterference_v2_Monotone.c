// Lean compiler output
// Module: RIINA.Properties.NonInterference_v2_Monotone
// Imports: Init RIINA.Foundations.Syntax RIINA.Foundations.Semantics RIINA.TypeSystem.Typing
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
LEAN_EXPORT uint8_t l_RIINA_first__order__decidable__local(lean_object*);
uint8_t l_RIINA_first__order__type(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_first__order__decidable__local___boxed(lean_object*);
LEAN_EXPORT uint8_t l_RIINA_first__order__decidable__local(lean_object* x_1) {
_start:
{
uint8_t x_2; 
x_2 = l_RIINA_first__order__type(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_first__order__decidable__local___boxed(lean_object* x_1) {
_start:
{
uint8_t x_2; lean_object* x_3; 
x_2 = l_RIINA_first__order__decidable__local(x_1);
lean_dec(x_1);
x_3 = lean_box(x_2);
return x_3;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Syntax(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Semantics(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_TypeSystem_Typing(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Properties_NonInterference__v2__Monotone(uint8_t builtin, lean_object* w) {
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
res = initialize_RIINA_TypeSystem_Typing(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
