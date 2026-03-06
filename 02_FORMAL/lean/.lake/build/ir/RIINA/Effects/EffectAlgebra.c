// Lean compiler output
// Module: RIINA.Effects.EffectAlgebra
// Imports: Init RIINA.Foundations.Syntax
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
uint8_t l_Nat_blt(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249_(lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249____rarg(uint8_t, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_effect__meet___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249____rarg___boxed(lean_object**);
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter(lean_object*);
lean_object* l_RIINA_effect__level(uint8_t);
LEAN_EXPORT lean_object* l_RIINA_effect__leq__dec___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_effect__meet(uint8_t, uint8_t);
lean_object* lean_nat_sub(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_effect__leq__dec(uint8_t, uint8_t);
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter___rarg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_nat_dec_le(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_effect__meet(uint8_t x_1, uint8_t x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; uint8_t x_5; 
x_3 = l_RIINA_effect__level(x_1);
x_4 = l_RIINA_effect__level(x_2);
x_5 = l_Nat_blt(x_3, x_4);
lean_dec(x_4);
lean_dec(x_3);
if (x_5 == 0)
{
return x_2;
}
else
{
return x_1;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_effect__meet___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; uint8_t x_4; uint8_t x_5; lean_object* x_6; 
x_3 = lean_unbox(x_1);
lean_dec(x_1);
x_4 = lean_unbox(x_2);
lean_dec(x_2);
x_5 = l_RIINA_effect__meet(x_3, x_4);
x_6 = lean_box(x_5);
return x_6;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249____rarg(uint8_t x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7, lean_object* x_8, lean_object* x_9, lean_object* x_10, lean_object* x_11, lean_object* x_12, lean_object* x_13, lean_object* x_14, lean_object* x_15, lean_object* x_16, lean_object* x_17, lean_object* x_18) {
_start:
{
switch (x_1) {
case 0:
{
lean_inc(x_2);
return x_2;
}
case 1:
{
lean_inc(x_3);
return x_3;
}
case 2:
{
lean_inc(x_4);
return x_4;
}
case 3:
{
lean_inc(x_5);
return x_5;
}
case 4:
{
lean_inc(x_6);
return x_6;
}
case 5:
{
lean_inc(x_7);
return x_7;
}
case 6:
{
lean_inc(x_8);
return x_8;
}
case 7:
{
lean_inc(x_9);
return x_9;
}
case 8:
{
lean_inc(x_10);
return x_10;
}
case 9:
{
lean_inc(x_11);
return x_11;
}
case 10:
{
lean_inc(x_12);
return x_12;
}
case 11:
{
lean_inc(x_13);
return x_13;
}
case 12:
{
lean_inc(x_14);
return x_14;
}
case 13:
{
lean_inc(x_15);
return x_15;
}
case 14:
{
lean_inc(x_16);
return x_16;
}
case 15:
{
lean_inc(x_17);
return x_17;
}
default: 
{
lean_inc(x_18);
return x_18;
}
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249_(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249____rarg___boxed), 18, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249____rarg___boxed(lean_object** _args) {
lean_object* x_1 = _args[0];
lean_object* x_2 = _args[1];
lean_object* x_3 = _args[2];
lean_object* x_4 = _args[3];
lean_object* x_5 = _args[4];
lean_object* x_6 = _args[5];
lean_object* x_7 = _args[6];
lean_object* x_8 = _args[7];
lean_object* x_9 = _args[8];
lean_object* x_10 = _args[9];
lean_object* x_11 = _args[10];
lean_object* x_12 = _args[11];
lean_object* x_13 = _args[12];
lean_object* x_14 = _args[13];
lean_object* x_15 = _args[14];
lean_object* x_16 = _args[15];
lean_object* x_17 = _args[16];
lean_object* x_18 = _args[17];
_start:
{
uint8_t x_19; lean_object* x_20; 
x_19 = lean_unbox(x_1);
lean_dec(x_1);
x_20 = l___private_RIINA_Effects_EffectAlgebra_0____private_RIINA_Foundations_Syntax_0__RIINA_repreffect_match__1_splitter____x40_RIINA_Foundations_Syntax___hyg_2249____rarg(x_19, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15, x_16, x_17, x_18);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
lean_dec(x_14);
lean_dec(x_13);
lean_dec(x_12);
lean_dec(x_11);
lean_dec(x_10);
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
lean_dec(x_2);
return x_20;
}
}
LEAN_EXPORT uint8_t l_RIINA_effect__leq__dec(uint8_t x_1, uint8_t x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; uint8_t x_5; 
x_3 = l_RIINA_effect__level(x_1);
x_4 = l_RIINA_effect__level(x_2);
x_5 = lean_nat_dec_le(x_3, x_4);
lean_dec(x_4);
lean_dec(x_3);
return x_5;
}
}
LEAN_EXPORT lean_object* l_RIINA_effect__leq__dec___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; uint8_t x_4; uint8_t x_5; lean_object* x_6; 
x_3 = lean_unbox(x_1);
lean_dec(x_1);
x_4 = lean_unbox(x_2);
lean_dec(x_2);
x_5 = l_RIINA_effect__leq__dec(x_3, x_4);
x_6 = lean_box(x_5);
return x_6;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6) {
_start:
{
lean_object* x_7; uint8_t x_8; 
x_7 = lean_unsigned_to_nat(0u);
x_8 = lean_nat_dec_eq(x_1, x_7);
if (x_8 == 0)
{
lean_object* x_9; lean_object* x_10; uint8_t x_11; 
lean_dec(x_4);
x_9 = lean_unsigned_to_nat(1u);
x_10 = lean_nat_sub(x_1, x_9);
x_11 = lean_nat_dec_eq(x_2, x_7);
if (x_11 == 0)
{
lean_object* x_12; lean_object* x_13; 
lean_dec(x_5);
x_12 = lean_nat_sub(x_2, x_9);
x_13 = lean_apply_2(x_6, x_10, x_12);
return x_13;
}
else
{
lean_object* x_14; 
lean_dec(x_6);
x_14 = lean_apply_1(x_5, x_10);
return x_14;
}
}
else
{
uint8_t x_15; 
lean_dec(x_6);
lean_dec(x_5);
x_15 = lean_nat_dec_eq(x_2, x_7);
if (x_15 == 0)
{
lean_object* x_16; lean_object* x_17; lean_object* x_18; 
x_16 = lean_unsigned_to_nat(1u);
x_17 = lean_nat_sub(x_2, x_16);
x_18 = lean_apply_1(x_4, x_17);
return x_18;
}
else
{
lean_dec(x_4);
lean_inc(x_3);
return x_3;
}
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter___rarg___boxed), 6, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6) {
_start:
{
lean_object* x_7; 
x_7 = l___private_RIINA_Effects_EffectAlgebra_0__Nat_beq_match__1_splitter___rarg(x_1, x_2, x_3, x_4, x_5, x_6);
lean_dec(x_3);
lean_dec(x_2);
lean_dec(x_1);
return x_7;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Syntax(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Effects_EffectAlgebra(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Foundations_Syntax(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
