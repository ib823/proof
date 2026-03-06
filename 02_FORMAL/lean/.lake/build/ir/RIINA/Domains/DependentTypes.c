// Lean compiler output
// Module: RIINA.Domains.DependentTypes
// Imports: Init
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
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_ctx__lookup(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__prod___rarg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14___rarg___boxed(lean_object*);
lean_object* l___private_Init_Data_Nat_Basic_0__Nat_recCompiled___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport___rarg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__option___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd(lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd___rarg(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__nat___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_rect___rarg___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_ctx__lookup___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__nat(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_rect___rarg(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__bool(uint8_t, uint8_t);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__dep__ind___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__option(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__dep__ind___rarg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport___rarg(lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_rect(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__dep__ind(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__rect__dep(lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14___rarg(uint8_t);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd___rarg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__prod(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__bool___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_ctx__lookup(lean_object* x_1, lean_object* x_2) {
_start:
{
if (lean_obj_tag(x_1) == 0)
{
lean_object* x_3; 
lean_dec(x_2);
x_3 = lean_box(0);
return x_3;
}
else
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; uint8_t x_7; 
x_4 = lean_ctor_get(x_1, 0);
x_5 = lean_ctor_get(x_1, 1);
x_6 = lean_unsigned_to_nat(0u);
x_7 = lean_nat_dec_eq(x_2, x_6);
if (x_7 == 0)
{
lean_object* x_8; lean_object* x_9; 
x_8 = lean_unsigned_to_nat(1u);
x_9 = lean_nat_sub(x_2, x_8);
lean_dec(x_2);
x_1 = x_5;
x_2 = x_9;
goto _start;
}
else
{
lean_object* x_11; 
lean_dec(x_2);
lean_inc(x_4);
x_11 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_11, 0, x_4);
return x_11;
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_ctx__lookup___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_RIINA_Domains_DependentTypes_ctx__lookup(x_1, x_2);
lean_dec(x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd___rarg(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_ctor_get(x_1, 1);
lean_inc(x_2);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_Vec_hd___rarg___boxed), 1, 0);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd___rarg___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_RIINA_Domains_DependentTypes_Vec_hd___rarg(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_hd___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_RIINA_Domains_DependentTypes_Vec_hd(x_1, x_2);
lean_dec(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; uint8_t x_5; 
x_4 = lean_unsigned_to_nat(0u);
x_5 = lean_nat_dec_eq(x_3, x_4);
if (x_5 == 0)
{
lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; 
x_6 = lean_unsigned_to_nat(1u);
x_7 = lean_nat_sub(x_3, x_6);
lean_inc(x_2);
x_8 = l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg(x_1, x_2, x_7);
x_9 = lean_apply_2(x_2, x_7, x_8);
return x_9;
}
else
{
lean_dec(x_2);
lean_inc(x_1);
return x_1;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__rect__dep(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg___boxed), 3, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l_RIINA_Domains_DependentTypes_nat__rect__dep___rarg(x_1, x_2, x_3);
lean_dec(x_3);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_rect___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; uint8_t x_6; 
x_5 = lean_unsigned_to_nat(0u);
x_6 = lean_nat_dec_eq(x_3, x_5);
if (x_6 == 0)
{
lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; 
x_7 = lean_ctor_get(x_4, 1);
lean_inc(x_7);
x_8 = lean_ctor_get(x_4, 2);
lean_inc(x_8);
lean_dec(x_4);
x_9 = lean_unsigned_to_nat(1u);
x_10 = lean_nat_sub(x_3, x_9);
lean_inc(x_8);
lean_inc(x_2);
x_11 = l_RIINA_Domains_DependentTypes_Vec_rect___rarg(x_1, x_2, x_10, x_8);
x_12 = lean_apply_4(x_2, x_7, x_10, x_8, x_11);
return x_12;
}
else
{
lean_dec(x_4);
lean_dec(x_2);
lean_inc(x_1);
return x_1;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_rect(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_Vec_rect___rarg___boxed), 4, 0);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_Vec_rect___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l_RIINA_Domains_DependentTypes_Vec_rect___rarg(x_1, x_2, x_3, x_4);
lean_dec(x_3);
lean_dec(x_1);
return x_5;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport___rarg(lean_object* x_1) {
_start:
{
lean_inc(x_1);
return x_1;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; 
x_6 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_transport___rarg___boxed), 1, 0);
return x_6;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport___rarg___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_RIINA_Domains_DependentTypes_transport___rarg(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_transport___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; 
x_6 = l_RIINA_Domains_DependentTypes_transport(x_1, x_2, x_3, x_4, x_5);
lean_dec(x_4);
lean_dec(x_3);
return x_6;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__dep__ind___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l___private_Init_Data_Nat_Basic_0__Nat_recCompiled___rarg(x_1, x_2, x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__dep__ind(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_nat__dep__ind___rarg___boxed), 3, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_nat__dep__ind___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l_RIINA_Domains_DependentTypes_nat__dep__ind___rarg(x_1, x_2, x_3);
lean_dec(x_3);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14___rarg(uint8_t x_1) {
_start:
{
if (x_1 == 0)
{
lean_object* x_2; 
x_2 = lean_box(1);
return x_2;
}
else
{
lean_object* x_3; 
x_3 = lean_box(0);
return x_3;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_TYPE__005__14___rarg___boxed), 1, 0);
return x_5;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14___rarg___boxed(lean_object* x_1) {
_start:
{
uint8_t x_2; lean_object* x_3; 
x_2 = lean_unbox(x_1);
lean_dec(x_1);
x_3 = l_RIINA_Domains_DependentTypes_TYPE__005__14___rarg(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_TYPE__005__14___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l_RIINA_Domains_DependentTypes_TYPE__005__14(x_1, x_2, x_3, x_4);
lean_dec(x_4);
lean_dec(x_3);
return x_5;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__nat(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; 
x_3 = lean_nat_dec_eq(x_1, x_2);
if (x_3 == 0)
{
lean_object* x_4; 
x_4 = lean_box(1);
return x_4;
}
else
{
lean_object* x_5; 
x_5 = lean_box(0);
return x_5;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__nat___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_RIINA_Domains_DependentTypes_dec__eq__nat(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__bool(uint8_t x_1, uint8_t x_2) {
_start:
{
if (x_1 == 0)
{
if (x_2 == 0)
{
lean_object* x_3; 
x_3 = lean_box(0);
return x_3;
}
else
{
lean_object* x_4; 
x_4 = lean_box(1);
return x_4;
}
}
else
{
if (x_2 == 0)
{
lean_object* x_5; 
x_5 = lean_box(1);
return x_5;
}
else
{
lean_object* x_6; 
x_6 = lean_box(0);
return x_6;
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__bool___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; uint8_t x_4; lean_object* x_5; 
x_3 = lean_unbox(x_1);
lean_dec(x_1);
x_4 = lean_unbox(x_2);
lean_dec(x_2);
x_5 = l_RIINA_Domains_DependentTypes_dec__eq__bool(x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__prod___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; uint8_t x_8; 
x_5 = lean_ctor_get(x_3, 0);
lean_inc(x_5);
x_6 = lean_ctor_get(x_4, 0);
lean_inc(x_6);
x_7 = lean_apply_2(x_1, x_5, x_6);
x_8 = lean_unbox(x_7);
lean_dec(x_7);
if (x_8 == 0)
{
lean_object* x_9; lean_object* x_10; lean_object* x_11; uint8_t x_12; 
x_9 = lean_ctor_get(x_3, 1);
lean_inc(x_9);
lean_dec(x_3);
x_10 = lean_ctor_get(x_4, 1);
lean_inc(x_10);
lean_dec(x_4);
x_11 = lean_apply_2(x_2, x_9, x_10);
x_12 = lean_unbox(x_11);
lean_dec(x_11);
if (x_12 == 0)
{
lean_object* x_13; 
x_13 = lean_box(0);
return x_13;
}
else
{
lean_object* x_14; 
x_14 = lean_box(1);
return x_14;
}
}
else
{
lean_object* x_15; 
lean_dec(x_4);
lean_dec(x_3);
lean_dec(x_2);
x_15 = lean_box(1);
return x_15;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__prod(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_dec__eq__prod___rarg), 4, 0);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__option___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
lean_dec(x_1);
if (lean_obj_tag(x_3) == 0)
{
lean_object* x_4; 
x_4 = lean_box(0);
return x_4;
}
else
{
lean_object* x_5; 
lean_dec(x_3);
x_5 = lean_box(1);
return x_5;
}
}
else
{
if (lean_obj_tag(x_3) == 0)
{
lean_object* x_6; 
lean_dec(x_2);
lean_dec(x_1);
x_6 = lean_box(1);
return x_6;
}
else
{
lean_object* x_7; lean_object* x_8; lean_object* x_9; uint8_t x_10; 
x_7 = lean_ctor_get(x_2, 0);
lean_inc(x_7);
lean_dec(x_2);
x_8 = lean_ctor_get(x_3, 0);
lean_inc(x_8);
lean_dec(x_3);
x_9 = lean_apply_2(x_1, x_7, x_8);
x_10 = lean_unbox(x_9);
lean_dec(x_9);
if (x_10 == 0)
{
lean_object* x_11; 
x_11 = lean_box(0);
return x_11;
}
else
{
lean_object* x_12; 
x_12 = lean_box(1);
return x_12;
}
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_Domains_DependentTypes_dec__eq__option(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_Domains_DependentTypes_dec__eq__option___rarg), 3, 0);
return x_2;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Domains_DependentTypes(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
