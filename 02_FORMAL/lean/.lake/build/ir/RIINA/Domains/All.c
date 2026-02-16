// Lean compiler output
// Module: RIINA.Domains.All
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
LEAN_EXPORT lean_object* l_RIINA_snd___rarg___boxed(lean_object*);
uint8_t l_List_all___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_hd__error(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_existsb(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_length___rarg(lean_object*);
lean_object* l_List_head_x3f___rarg(lean_object*);
lean_object* l_List_find_x3f___rarg(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_forallb___rarg(lean_object*, lean_object*);
uint8_t l_List_any___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_forallb___rarg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_orb___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_snd(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_snd___rarg(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_andb___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_negb___boxed(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_fst(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_existsb___rarg___boxed(lean_object*, lean_object*);
lean_object* l_List_lengthTRAux___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_hd__error___rarg___boxed(lean_object*);
LEAN_EXPORT uint8_t l_RIINA_orb(uint8_t, uint8_t);
LEAN_EXPORT lean_object* l_RIINA_find(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_fst___rarg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_length(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_forallb(lean_object*);
LEAN_EXPORT uint8_t l_RIINA_negb(uint8_t);
LEAN_EXPORT lean_object* l_RIINA_length___rarg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_find___rarg(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_existsb___rarg(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_andb(uint8_t, uint8_t);
LEAN_EXPORT lean_object* l_RIINA_fst___rarg(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_hd__error___rarg(lean_object*);
LEAN_EXPORT uint8_t l_RIINA_negb(uint8_t x_1) {
_start:
{
if (x_1 == 0)
{
uint8_t x_2; 
x_2 = 1;
return x_2;
}
else
{
uint8_t x_3; 
x_3 = 0;
return x_3;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_negb___boxed(lean_object* x_1) {
_start:
{
uint8_t x_2; uint8_t x_3; lean_object* x_4; 
x_2 = lean_unbox(x_1);
lean_dec(x_1);
x_3 = l_RIINA_negb(x_2);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT uint8_t l_RIINA_andb(uint8_t x_1, uint8_t x_2) {
_start:
{
if (x_1 == 0)
{
uint8_t x_3; 
x_3 = 0;
return x_3;
}
else
{
return x_2;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_andb___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; uint8_t x_4; uint8_t x_5; lean_object* x_6; 
x_3 = lean_unbox(x_1);
lean_dec(x_1);
x_4 = lean_unbox(x_2);
lean_dec(x_2);
x_5 = l_RIINA_andb(x_3, x_4);
x_6 = lean_box(x_5);
return x_6;
}
}
LEAN_EXPORT uint8_t l_RIINA_orb(uint8_t x_1, uint8_t x_2) {
_start:
{
if (x_1 == 0)
{
return x_2;
}
else
{
uint8_t x_3; 
x_3 = 1;
return x_3;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_orb___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; uint8_t x_4; uint8_t x_5; lean_object* x_6; 
x_3 = lean_unbox(x_1);
lean_dec(x_1);
x_4 = lean_unbox(x_2);
lean_dec(x_2);
x_5 = l_RIINA_orb(x_3, x_4);
x_6 = lean_box(x_5);
return x_6;
}
}
LEAN_EXPORT uint8_t l_RIINA_forallb___rarg(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; 
x_3 = l_List_all___rarg(x_2, x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_forallb(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_forallb___rarg___boxed), 2, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_forallb___rarg___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_RIINA_forallb___rarg(x_1, x_2);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT uint8_t l_RIINA_existsb___rarg(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; 
x_3 = l_List_any___rarg(x_2, x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_existsb(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_existsb___rarg___boxed), 2, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_existsb___rarg___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_RIINA_existsb___rarg(x_1, x_2);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_RIINA_length___rarg(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; 
x_2 = lean_unsigned_to_nat(0u);
x_3 = l_List_lengthTRAux___rarg(x_1, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_length(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_length___rarg___boxed), 1, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_length___rarg___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_RIINA_length___rarg(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_hd__error___rarg(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_List_head_x3f___rarg(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_hd__error(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_hd__error___rarg___boxed), 1, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_hd__error___rarg___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_RIINA_hd__error___rarg(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_find___rarg(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_List_find_x3f___rarg(x_1, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_find(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_RIINA_find___rarg), 2, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_fst___rarg(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_ctor_get(x_1, 0);
lean_inc(x_2);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_fst(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_closure((void*)(l_RIINA_fst___rarg___boxed), 1, 0);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_fst___rarg___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_RIINA_fst___rarg(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_snd___rarg(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_ctor_get(x_1, 1);
lean_inc(x_2);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_snd(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_closure((void*)(l_RIINA_snd___rarg___boxed), 1, 0);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_snd___rarg___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_RIINA_snd___rarg(x_1);
lean_dec(x_1);
return x_2;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Domains_All(uint8_t builtin, lean_object* w) {
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
