// Lean compiler output
// Module: RIINA.Properties.NonInterference
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
LEAN_EXPORT lean_object* l_RIINA_firstOrderType___boxed(lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter___rarg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_isLowDec___boxed(lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter___rarg___boxed(lean_object**);
uint8_t lean_string_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter___rarg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter(lean_object*);
LEAN_EXPORT uint8_t l_RIINA_firstOrderType(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_applySubst(lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_singleSubst(lean_object*, lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_singleSubst___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_isLowDec(uint8_t);
LEAN_EXPORT uint8_t l_RIINA_observer__level;
uint8_t l_RIINA_sec__leq__dec(uint8_t, uint8_t);
static uint8_t _init_l_RIINA_observer__level() {
_start:
{
uint8_t x_1; 
x_1 = 0;
return x_1;
}
}
LEAN_EXPORT uint8_t l_RIINA_isLowDec(uint8_t x_1) {
_start:
{
uint8_t x_2; uint8_t x_3; 
x_2 = l_RIINA_observer__level;
x_3 = l_RIINA_sec__leq__dec(x_1, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_isLowDec___boxed(lean_object* x_1) {
_start:
{
uint8_t x_2; uint8_t x_3; lean_object* x_4; 
x_2 = lean_unbox(x_1);
lean_dec(x_1);
x_3 = l_RIINA_isLowDec(x_2);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT uint8_t l_RIINA_firstOrderType(lean_object* x_1) {
_start:
{
switch (lean_obj_tag(x_1)) {
case 0:
{
uint8_t x_2; 
x_2 = 1;
return x_2;
}
case 1:
{
uint8_t x_3; 
x_3 = 1;
return x_3;
}
case 2:
{
uint8_t x_4; 
x_4 = 1;
return x_4;
}
case 3:
{
uint8_t x_5; 
x_5 = 1;
return x_5;
}
case 4:
{
uint8_t x_6; 
x_6 = 1;
return x_6;
}
case 5:
{
uint8_t x_7; 
x_7 = 0;
return x_7;
}
case 6:
{
lean_object* x_8; lean_object* x_9; uint8_t x_10; 
x_8 = lean_ctor_get(x_1, 0);
x_9 = lean_ctor_get(x_1, 1);
x_10 = l_RIINA_firstOrderType(x_8);
if (x_10 == 0)
{
uint8_t x_11; 
x_11 = 0;
return x_11;
}
else
{
x_1 = x_9;
goto _start;
}
}
case 7:
{
lean_object* x_13; lean_object* x_14; uint8_t x_15; 
x_13 = lean_ctor_get(x_1, 0);
x_14 = lean_ctor_get(x_1, 1);
x_15 = l_RIINA_firstOrderType(x_13);
if (x_15 == 0)
{
uint8_t x_16; 
x_16 = 0;
return x_16;
}
else
{
x_1 = x_14;
goto _start;
}
}
case 16:
{
uint8_t x_18; 
x_18 = 1;
return x_18;
}
case 17:
{
uint8_t x_19; 
x_19 = 1;
return x_19;
}
case 18:
{
uint8_t x_20; 
x_20 = 0;
return x_20;
}
case 19:
{
uint8_t x_21; 
x_21 = 0;
return x_21;
}
default: 
{
lean_object* x_22; 
x_22 = lean_ctor_get(x_1, 0);
x_1 = x_22;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_firstOrderType___boxed(lean_object* x_1) {
_start:
{
uint8_t x_2; lean_object* x_3; 
x_2 = l_RIINA_firstOrderType(x_1);
lean_dec(x_1);
x_3 = lean_box(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_RIINA_applySubst(lean_object* x_1, lean_object* x_2) {
_start:
{
switch (lean_obj_tag(x_2)) {
case 0:
{
lean_object* x_3; 
lean_dec(x_1);
x_3 = lean_box(0);
return x_3;
}
case 1:
{
uint8_t x_4; 
lean_dec(x_1);
x_4 = !lean_is_exclusive(x_2);
if (x_4 == 0)
{
return x_2;
}
else
{
uint8_t x_5; lean_object* x_6; 
x_5 = lean_ctor_get_uint8(x_2, 0);
lean_dec(x_2);
x_6 = lean_alloc_ctor(1, 0, 1);
lean_ctor_set_uint8(x_6, 0, x_5);
return x_6;
}
}
case 2:
{
uint8_t x_7; 
lean_dec(x_1);
x_7 = !lean_is_exclusive(x_2);
if (x_7 == 0)
{
return x_2;
}
else
{
lean_object* x_8; lean_object* x_9; 
x_8 = lean_ctor_get(x_2, 0);
lean_inc(x_8);
lean_dec(x_2);
x_9 = lean_alloc_ctor(2, 1, 0);
lean_ctor_set(x_9, 0, x_8);
return x_9;
}
}
case 3:
{
uint8_t x_10; 
lean_dec(x_1);
x_10 = !lean_is_exclusive(x_2);
if (x_10 == 0)
{
return x_2;
}
else
{
lean_object* x_11; lean_object* x_12; 
x_11 = lean_ctor_get(x_2, 0);
lean_inc(x_11);
lean_dec(x_2);
x_12 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_12, 0, x_11);
return x_12;
}
}
case 4:
{
uint8_t x_13; 
lean_dec(x_1);
x_13 = !lean_is_exclusive(x_2);
if (x_13 == 0)
{
return x_2;
}
else
{
lean_object* x_14; lean_object* x_15; 
x_14 = lean_ctor_get(x_2, 0);
lean_inc(x_14);
lean_dec(x_2);
x_15 = lean_alloc_ctor(4, 1, 0);
lean_ctor_set(x_15, 0, x_14);
return x_15;
}
}
case 5:
{
uint8_t x_16; 
x_16 = !lean_is_exclusive(x_2);
if (x_16 == 0)
{
lean_object* x_17; lean_object* x_18; 
x_17 = lean_ctor_get(x_2, 0);
lean_inc(x_17);
x_18 = lean_apply_1(x_1, x_17);
if (lean_obj_tag(x_18) == 0)
{
return x_2;
}
else
{
lean_object* x_19; 
lean_free_object(x_2);
lean_dec(x_17);
x_19 = lean_ctor_get(x_18, 0);
lean_inc(x_19);
lean_dec(x_18);
return x_19;
}
}
else
{
lean_object* x_20; lean_object* x_21; 
x_20 = lean_ctor_get(x_2, 0);
lean_inc(x_20);
lean_dec(x_2);
lean_inc(x_20);
x_21 = lean_apply_1(x_1, x_20);
if (lean_obj_tag(x_21) == 0)
{
lean_object* x_22; 
x_22 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_22, 0, x_20);
return x_22;
}
else
{
lean_object* x_23; 
lean_dec(x_20);
x_23 = lean_ctor_get(x_21, 0);
lean_inc(x_23);
lean_dec(x_21);
return x_23;
}
}
}
case 6:
{
uint8_t x_24; 
x_24 = !lean_is_exclusive(x_2);
if (x_24 == 0)
{
lean_object* x_25; lean_object* x_26; lean_object* x_27; 
x_25 = lean_ctor_get(x_2, 0);
x_26 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
lean_inc(x_25);
x_27 = lean_apply_1(x_1, x_25);
if (lean_obj_tag(x_27) == 0)
{
lean_object* x_28; 
x_28 = l_RIINA_applySubst(x_1, x_26);
lean_ctor_set(x_2, 2, x_28);
return x_2;
}
else
{
lean_dec(x_27);
lean_dec(x_1);
return x_2;
}
}
else
{
lean_object* x_29; lean_object* x_30; lean_object* x_31; lean_object* x_32; 
x_29 = lean_ctor_get(x_2, 0);
x_30 = lean_ctor_get(x_2, 1);
x_31 = lean_ctor_get(x_2, 2);
lean_inc(x_31);
lean_inc(x_30);
lean_inc(x_29);
lean_dec(x_2);
lean_inc(x_1);
lean_inc(x_29);
x_32 = lean_apply_1(x_1, x_29);
if (lean_obj_tag(x_32) == 0)
{
lean_object* x_33; lean_object* x_34; 
x_33 = l_RIINA_applySubst(x_1, x_31);
x_34 = lean_alloc_ctor(6, 3, 0);
lean_ctor_set(x_34, 0, x_29);
lean_ctor_set(x_34, 1, x_30);
lean_ctor_set(x_34, 2, x_33);
return x_34;
}
else
{
lean_object* x_35; 
lean_dec(x_32);
lean_dec(x_1);
x_35 = lean_alloc_ctor(6, 3, 0);
lean_ctor_set(x_35, 0, x_29);
lean_ctor_set(x_35, 1, x_30);
lean_ctor_set(x_35, 2, x_31);
return x_35;
}
}
}
case 7:
{
uint8_t x_36; 
x_36 = !lean_is_exclusive(x_2);
if (x_36 == 0)
{
lean_object* x_37; lean_object* x_38; lean_object* x_39; lean_object* x_40; 
x_37 = lean_ctor_get(x_2, 0);
x_38 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_39 = l_RIINA_applySubst(x_1, x_37);
x_40 = l_RIINA_applySubst(x_1, x_38);
lean_ctor_set(x_2, 1, x_40);
lean_ctor_set(x_2, 0, x_39);
return x_2;
}
else
{
lean_object* x_41; lean_object* x_42; lean_object* x_43; lean_object* x_44; lean_object* x_45; 
x_41 = lean_ctor_get(x_2, 0);
x_42 = lean_ctor_get(x_2, 1);
lean_inc(x_42);
lean_inc(x_41);
lean_dec(x_2);
lean_inc(x_1);
x_43 = l_RIINA_applySubst(x_1, x_41);
x_44 = l_RIINA_applySubst(x_1, x_42);
x_45 = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(x_45, 0, x_43);
lean_ctor_set(x_45, 1, x_44);
return x_45;
}
}
case 8:
{
uint8_t x_46; 
x_46 = !lean_is_exclusive(x_2);
if (x_46 == 0)
{
lean_object* x_47; lean_object* x_48; lean_object* x_49; lean_object* x_50; 
x_47 = lean_ctor_get(x_2, 0);
x_48 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_49 = l_RIINA_applySubst(x_1, x_47);
x_50 = l_RIINA_applySubst(x_1, x_48);
lean_ctor_set(x_2, 1, x_50);
lean_ctor_set(x_2, 0, x_49);
return x_2;
}
else
{
lean_object* x_51; lean_object* x_52; lean_object* x_53; lean_object* x_54; lean_object* x_55; 
x_51 = lean_ctor_get(x_2, 0);
x_52 = lean_ctor_get(x_2, 1);
lean_inc(x_52);
lean_inc(x_51);
lean_dec(x_2);
lean_inc(x_1);
x_53 = l_RIINA_applySubst(x_1, x_51);
x_54 = l_RIINA_applySubst(x_1, x_52);
x_55 = lean_alloc_ctor(8, 2, 0);
lean_ctor_set(x_55, 0, x_53);
lean_ctor_set(x_55, 1, x_54);
return x_55;
}
}
case 9:
{
uint8_t x_56; 
x_56 = !lean_is_exclusive(x_2);
if (x_56 == 0)
{
lean_object* x_57; lean_object* x_58; 
x_57 = lean_ctor_get(x_2, 0);
x_58 = l_RIINA_applySubst(x_1, x_57);
lean_ctor_set(x_2, 0, x_58);
return x_2;
}
else
{
lean_object* x_59; lean_object* x_60; lean_object* x_61; 
x_59 = lean_ctor_get(x_2, 0);
lean_inc(x_59);
lean_dec(x_2);
x_60 = l_RIINA_applySubst(x_1, x_59);
x_61 = lean_alloc_ctor(9, 1, 0);
lean_ctor_set(x_61, 0, x_60);
return x_61;
}
}
case 10:
{
uint8_t x_62; 
x_62 = !lean_is_exclusive(x_2);
if (x_62 == 0)
{
lean_object* x_63; lean_object* x_64; 
x_63 = lean_ctor_get(x_2, 0);
x_64 = l_RIINA_applySubst(x_1, x_63);
lean_ctor_set(x_2, 0, x_64);
return x_2;
}
else
{
lean_object* x_65; lean_object* x_66; lean_object* x_67; 
x_65 = lean_ctor_get(x_2, 0);
lean_inc(x_65);
lean_dec(x_2);
x_66 = l_RIINA_applySubst(x_1, x_65);
x_67 = lean_alloc_ctor(10, 1, 0);
lean_ctor_set(x_67, 0, x_66);
return x_67;
}
}
case 11:
{
uint8_t x_68; 
x_68 = !lean_is_exclusive(x_2);
if (x_68 == 0)
{
lean_object* x_69; lean_object* x_70; 
x_69 = lean_ctor_get(x_2, 0);
x_70 = l_RIINA_applySubst(x_1, x_69);
lean_ctor_set(x_2, 0, x_70);
return x_2;
}
else
{
lean_object* x_71; lean_object* x_72; lean_object* x_73; lean_object* x_74; 
x_71 = lean_ctor_get(x_2, 0);
x_72 = lean_ctor_get(x_2, 1);
lean_inc(x_72);
lean_inc(x_71);
lean_dec(x_2);
x_73 = l_RIINA_applySubst(x_1, x_71);
x_74 = lean_alloc_ctor(11, 2, 0);
lean_ctor_set(x_74, 0, x_73);
lean_ctor_set(x_74, 1, x_72);
return x_74;
}
}
case 12:
{
uint8_t x_75; 
x_75 = !lean_is_exclusive(x_2);
if (x_75 == 0)
{
lean_object* x_76; lean_object* x_77; 
x_76 = lean_ctor_get(x_2, 0);
x_77 = l_RIINA_applySubst(x_1, x_76);
lean_ctor_set(x_2, 0, x_77);
return x_2;
}
else
{
lean_object* x_78; lean_object* x_79; lean_object* x_80; lean_object* x_81; 
x_78 = lean_ctor_get(x_2, 0);
x_79 = lean_ctor_get(x_2, 1);
lean_inc(x_79);
lean_inc(x_78);
lean_dec(x_2);
x_80 = l_RIINA_applySubst(x_1, x_78);
x_81 = lean_alloc_ctor(12, 2, 0);
lean_ctor_set(x_81, 0, x_80);
lean_ctor_set(x_81, 1, x_79);
return x_81;
}
}
case 13:
{
uint8_t x_82; 
x_82 = !lean_is_exclusive(x_2);
if (x_82 == 0)
{
lean_object* x_83; lean_object* x_84; lean_object* x_85; lean_object* x_86; lean_object* x_87; lean_object* x_88; 
x_83 = lean_ctor_get(x_2, 0);
x_84 = lean_ctor_get(x_2, 2);
x_85 = lean_ctor_get(x_2, 4);
lean_inc(x_1);
x_86 = l_RIINA_applySubst(x_1, x_83);
lean_inc(x_1);
x_87 = l_RIINA_applySubst(x_1, x_84);
x_88 = l_RIINA_applySubst(x_1, x_85);
lean_ctor_set(x_2, 4, x_88);
lean_ctor_set(x_2, 2, x_87);
lean_ctor_set(x_2, 0, x_86);
return x_2;
}
else
{
lean_object* x_89; lean_object* x_90; lean_object* x_91; lean_object* x_92; lean_object* x_93; lean_object* x_94; lean_object* x_95; lean_object* x_96; lean_object* x_97; 
x_89 = lean_ctor_get(x_2, 0);
x_90 = lean_ctor_get(x_2, 1);
x_91 = lean_ctor_get(x_2, 2);
x_92 = lean_ctor_get(x_2, 3);
x_93 = lean_ctor_get(x_2, 4);
lean_inc(x_93);
lean_inc(x_92);
lean_inc(x_91);
lean_inc(x_90);
lean_inc(x_89);
lean_dec(x_2);
lean_inc(x_1);
x_94 = l_RIINA_applySubst(x_1, x_89);
lean_inc(x_1);
x_95 = l_RIINA_applySubst(x_1, x_91);
x_96 = l_RIINA_applySubst(x_1, x_93);
x_97 = lean_alloc_ctor(13, 5, 0);
lean_ctor_set(x_97, 0, x_94);
lean_ctor_set(x_97, 1, x_90);
lean_ctor_set(x_97, 2, x_95);
lean_ctor_set(x_97, 3, x_92);
lean_ctor_set(x_97, 4, x_96);
return x_97;
}
}
case 14:
{
uint8_t x_98; 
x_98 = !lean_is_exclusive(x_2);
if (x_98 == 0)
{
lean_object* x_99; lean_object* x_100; lean_object* x_101; lean_object* x_102; lean_object* x_103; lean_object* x_104; 
x_99 = lean_ctor_get(x_2, 0);
x_100 = lean_ctor_get(x_2, 1);
x_101 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
x_102 = l_RIINA_applySubst(x_1, x_99);
lean_inc(x_1);
x_103 = l_RIINA_applySubst(x_1, x_100);
x_104 = l_RIINA_applySubst(x_1, x_101);
lean_ctor_set(x_2, 2, x_104);
lean_ctor_set(x_2, 1, x_103);
lean_ctor_set(x_2, 0, x_102);
return x_2;
}
else
{
lean_object* x_105; lean_object* x_106; lean_object* x_107; lean_object* x_108; lean_object* x_109; lean_object* x_110; lean_object* x_111; 
x_105 = lean_ctor_get(x_2, 0);
x_106 = lean_ctor_get(x_2, 1);
x_107 = lean_ctor_get(x_2, 2);
lean_inc(x_107);
lean_inc(x_106);
lean_inc(x_105);
lean_dec(x_2);
lean_inc(x_1);
x_108 = l_RIINA_applySubst(x_1, x_105);
lean_inc(x_1);
x_109 = l_RIINA_applySubst(x_1, x_106);
x_110 = l_RIINA_applySubst(x_1, x_107);
x_111 = lean_alloc_ctor(14, 3, 0);
lean_ctor_set(x_111, 0, x_108);
lean_ctor_set(x_111, 1, x_109);
lean_ctor_set(x_111, 2, x_110);
return x_111;
}
}
case 15:
{
uint8_t x_112; 
x_112 = !lean_is_exclusive(x_2);
if (x_112 == 0)
{
lean_object* x_113; lean_object* x_114; lean_object* x_115; lean_object* x_116; lean_object* x_117; 
x_113 = lean_ctor_get(x_2, 0);
x_114 = lean_ctor_get(x_2, 1);
x_115 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
x_116 = l_RIINA_applySubst(x_1, x_114);
lean_inc(x_1);
lean_inc(x_113);
x_117 = lean_apply_1(x_1, x_113);
if (lean_obj_tag(x_117) == 0)
{
lean_object* x_118; 
x_118 = l_RIINA_applySubst(x_1, x_115);
lean_ctor_set(x_2, 2, x_118);
lean_ctor_set(x_2, 1, x_116);
return x_2;
}
else
{
lean_dec(x_117);
lean_dec(x_1);
lean_ctor_set(x_2, 1, x_116);
return x_2;
}
}
else
{
lean_object* x_119; lean_object* x_120; lean_object* x_121; lean_object* x_122; lean_object* x_123; 
x_119 = lean_ctor_get(x_2, 0);
x_120 = lean_ctor_get(x_2, 1);
x_121 = lean_ctor_get(x_2, 2);
lean_inc(x_121);
lean_inc(x_120);
lean_inc(x_119);
lean_dec(x_2);
lean_inc(x_1);
x_122 = l_RIINA_applySubst(x_1, x_120);
lean_inc(x_1);
lean_inc(x_119);
x_123 = lean_apply_1(x_1, x_119);
if (lean_obj_tag(x_123) == 0)
{
lean_object* x_124; lean_object* x_125; 
x_124 = l_RIINA_applySubst(x_1, x_121);
x_125 = lean_alloc_ctor(15, 3, 0);
lean_ctor_set(x_125, 0, x_119);
lean_ctor_set(x_125, 1, x_122);
lean_ctor_set(x_125, 2, x_124);
return x_125;
}
else
{
lean_object* x_126; 
lean_dec(x_123);
lean_dec(x_1);
x_126 = lean_alloc_ctor(15, 3, 0);
lean_ctor_set(x_126, 0, x_119);
lean_ctor_set(x_126, 1, x_122);
lean_ctor_set(x_126, 2, x_121);
return x_126;
}
}
}
case 16:
{
uint8_t x_127; 
x_127 = !lean_is_exclusive(x_2);
if (x_127 == 0)
{
lean_object* x_128; lean_object* x_129; 
x_128 = lean_ctor_get(x_2, 0);
x_129 = l_RIINA_applySubst(x_1, x_128);
lean_ctor_set(x_2, 0, x_129);
return x_2;
}
else
{
uint8_t x_130; lean_object* x_131; lean_object* x_132; lean_object* x_133; 
x_130 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
x_131 = lean_ctor_get(x_2, 0);
lean_inc(x_131);
lean_dec(x_2);
x_132 = l_RIINA_applySubst(x_1, x_131);
x_133 = lean_alloc_ctor(16, 1, 1);
lean_ctor_set(x_133, 0, x_132);
lean_ctor_set_uint8(x_133, sizeof(void*)*1, x_130);
return x_133;
}
}
case 17:
{
uint8_t x_134; 
x_134 = !lean_is_exclusive(x_2);
if (x_134 == 0)
{
lean_object* x_135; lean_object* x_136; lean_object* x_137; lean_object* x_138; lean_object* x_139; 
x_135 = lean_ctor_get(x_2, 0);
x_136 = lean_ctor_get(x_2, 1);
x_137 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
x_138 = l_RIINA_applySubst(x_1, x_135);
lean_inc(x_1);
lean_inc(x_136);
x_139 = lean_apply_1(x_1, x_136);
if (lean_obj_tag(x_139) == 0)
{
lean_object* x_140; 
x_140 = l_RIINA_applySubst(x_1, x_137);
lean_ctor_set(x_2, 2, x_140);
lean_ctor_set(x_2, 0, x_138);
return x_2;
}
else
{
lean_dec(x_139);
lean_dec(x_1);
lean_ctor_set(x_2, 0, x_138);
return x_2;
}
}
else
{
lean_object* x_141; lean_object* x_142; lean_object* x_143; lean_object* x_144; lean_object* x_145; 
x_141 = lean_ctor_get(x_2, 0);
x_142 = lean_ctor_get(x_2, 1);
x_143 = lean_ctor_get(x_2, 2);
lean_inc(x_143);
lean_inc(x_142);
lean_inc(x_141);
lean_dec(x_2);
lean_inc(x_1);
x_144 = l_RIINA_applySubst(x_1, x_141);
lean_inc(x_1);
lean_inc(x_142);
x_145 = lean_apply_1(x_1, x_142);
if (lean_obj_tag(x_145) == 0)
{
lean_object* x_146; lean_object* x_147; 
x_146 = l_RIINA_applySubst(x_1, x_143);
x_147 = lean_alloc_ctor(17, 3, 0);
lean_ctor_set(x_147, 0, x_144);
lean_ctor_set(x_147, 1, x_142);
lean_ctor_set(x_147, 2, x_146);
return x_147;
}
else
{
lean_object* x_148; 
lean_dec(x_145);
lean_dec(x_1);
x_148 = lean_alloc_ctor(17, 3, 0);
lean_ctor_set(x_148, 0, x_144);
lean_ctor_set(x_148, 1, x_142);
lean_ctor_set(x_148, 2, x_143);
return x_148;
}
}
}
case 18:
{
uint8_t x_149; 
x_149 = !lean_is_exclusive(x_2);
if (x_149 == 0)
{
lean_object* x_150; lean_object* x_151; 
x_150 = lean_ctor_get(x_2, 0);
x_151 = l_RIINA_applySubst(x_1, x_150);
lean_ctor_set(x_2, 0, x_151);
return x_2;
}
else
{
lean_object* x_152; uint8_t x_153; lean_object* x_154; lean_object* x_155; 
x_152 = lean_ctor_get(x_2, 0);
x_153 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
lean_inc(x_152);
lean_dec(x_2);
x_154 = l_RIINA_applySubst(x_1, x_152);
x_155 = lean_alloc_ctor(18, 1, 1);
lean_ctor_set(x_155, 0, x_154);
lean_ctor_set_uint8(x_155, sizeof(void*)*1, x_153);
return x_155;
}
}
case 19:
{
uint8_t x_156; 
x_156 = !lean_is_exclusive(x_2);
if (x_156 == 0)
{
lean_object* x_157; lean_object* x_158; 
x_157 = lean_ctor_get(x_2, 0);
x_158 = l_RIINA_applySubst(x_1, x_157);
lean_ctor_set(x_2, 0, x_158);
return x_2;
}
else
{
lean_object* x_159; lean_object* x_160; lean_object* x_161; 
x_159 = lean_ctor_get(x_2, 0);
lean_inc(x_159);
lean_dec(x_2);
x_160 = l_RIINA_applySubst(x_1, x_159);
x_161 = lean_alloc_ctor(19, 1, 0);
lean_ctor_set(x_161, 0, x_160);
return x_161;
}
}
case 20:
{
uint8_t x_162; 
x_162 = !lean_is_exclusive(x_2);
if (x_162 == 0)
{
lean_object* x_163; lean_object* x_164; lean_object* x_165; lean_object* x_166; 
x_163 = lean_ctor_get(x_2, 0);
x_164 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_165 = l_RIINA_applySubst(x_1, x_163);
x_166 = l_RIINA_applySubst(x_1, x_164);
lean_ctor_set(x_2, 1, x_166);
lean_ctor_set(x_2, 0, x_165);
return x_2;
}
else
{
lean_object* x_167; lean_object* x_168; lean_object* x_169; lean_object* x_170; lean_object* x_171; 
x_167 = lean_ctor_get(x_2, 0);
x_168 = lean_ctor_get(x_2, 1);
lean_inc(x_168);
lean_inc(x_167);
lean_dec(x_2);
lean_inc(x_1);
x_169 = l_RIINA_applySubst(x_1, x_167);
x_170 = l_RIINA_applySubst(x_1, x_168);
x_171 = lean_alloc_ctor(20, 2, 0);
lean_ctor_set(x_171, 0, x_169);
lean_ctor_set(x_171, 1, x_170);
return x_171;
}
}
case 21:
{
uint8_t x_172; 
x_172 = !lean_is_exclusive(x_2);
if (x_172 == 0)
{
lean_object* x_173; lean_object* x_174; 
x_173 = lean_ctor_get(x_2, 0);
x_174 = l_RIINA_applySubst(x_1, x_173);
lean_ctor_set(x_2, 0, x_174);
return x_2;
}
else
{
lean_object* x_175; lean_object* x_176; lean_object* x_177; 
x_175 = lean_ctor_get(x_2, 0);
lean_inc(x_175);
lean_dec(x_2);
x_176 = l_RIINA_applySubst(x_1, x_175);
x_177 = lean_alloc_ctor(21, 1, 0);
lean_ctor_set(x_177, 0, x_176);
return x_177;
}
}
case 22:
{
uint8_t x_178; 
x_178 = !lean_is_exclusive(x_2);
if (x_178 == 0)
{
lean_object* x_179; lean_object* x_180; lean_object* x_181; lean_object* x_182; 
x_179 = lean_ctor_get(x_2, 0);
x_180 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_181 = l_RIINA_applySubst(x_1, x_179);
x_182 = l_RIINA_applySubst(x_1, x_180);
lean_ctor_set(x_2, 1, x_182);
lean_ctor_set(x_2, 0, x_181);
return x_2;
}
else
{
lean_object* x_183; lean_object* x_184; lean_object* x_185; lean_object* x_186; lean_object* x_187; 
x_183 = lean_ctor_get(x_2, 0);
x_184 = lean_ctor_get(x_2, 1);
lean_inc(x_184);
lean_inc(x_183);
lean_dec(x_2);
lean_inc(x_1);
x_185 = l_RIINA_applySubst(x_1, x_183);
x_186 = l_RIINA_applySubst(x_1, x_184);
x_187 = lean_alloc_ctor(22, 2, 0);
lean_ctor_set(x_187, 0, x_185);
lean_ctor_set(x_187, 1, x_186);
return x_187;
}
}
case 23:
{
uint8_t x_188; 
x_188 = !lean_is_exclusive(x_2);
if (x_188 == 0)
{
lean_object* x_189; lean_object* x_190; 
x_189 = lean_ctor_get(x_2, 0);
x_190 = l_RIINA_applySubst(x_1, x_189);
lean_ctor_set(x_2, 0, x_190);
return x_2;
}
else
{
lean_object* x_191; lean_object* x_192; lean_object* x_193; 
x_191 = lean_ctor_get(x_2, 0);
lean_inc(x_191);
lean_dec(x_2);
x_192 = l_RIINA_applySubst(x_1, x_191);
x_193 = lean_alloc_ctor(23, 1, 0);
lean_ctor_set(x_193, 0, x_192);
return x_193;
}
}
case 24:
{
uint8_t x_194; 
x_194 = !lean_is_exclusive(x_2);
if (x_194 == 0)
{
lean_object* x_195; lean_object* x_196; 
x_195 = lean_ctor_get(x_2, 0);
x_196 = l_RIINA_applySubst(x_1, x_195);
lean_ctor_set(x_2, 0, x_196);
return x_2;
}
else
{
uint8_t x_197; lean_object* x_198; lean_object* x_199; lean_object* x_200; 
x_197 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
x_198 = lean_ctor_get(x_2, 0);
lean_inc(x_198);
lean_dec(x_2);
x_199 = l_RIINA_applySubst(x_1, x_198);
x_200 = lean_alloc_ctor(24, 1, 1);
lean_ctor_set(x_200, 0, x_199);
lean_ctor_set_uint8(x_200, sizeof(void*)*1, x_197);
return x_200;
}
}
default: 
{
uint8_t x_201; 
x_201 = !lean_is_exclusive(x_2);
if (x_201 == 0)
{
lean_object* x_202; lean_object* x_203; 
x_202 = lean_ctor_get(x_2, 0);
x_203 = l_RIINA_applySubst(x_1, x_202);
lean_ctor_set(x_2, 0, x_203);
return x_2;
}
else
{
uint8_t x_204; lean_object* x_205; lean_object* x_206; lean_object* x_207; 
x_204 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
x_205 = lean_ctor_get(x_2, 0);
lean_inc(x_205);
lean_dec(x_2);
x_206 = l_RIINA_applySubst(x_1, x_205);
x_207 = lean_alloc_ctor(25, 1, 1);
lean_ctor_set(x_207, 0, x_206);
lean_ctor_set_uint8(x_207, sizeof(void*)*1, x_204);
return x_207;
}
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_singleSubst(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
uint8_t x_4; 
x_4 = lean_string_dec_eq(x_3, x_1);
if (x_4 == 0)
{
lean_object* x_5; 
lean_dec(x_2);
x_5 = lean_box(0);
return x_5;
}
else
{
lean_object* x_6; 
x_6 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_6, 0, x_2);
return x_6;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_singleSubst___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l_RIINA_singleSubst(x_1, x_2, x_3);
lean_dec(x_3);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7) {
_start:
{
lean_object* x_8; uint8_t x_9; 
x_8 = lean_unsigned_to_nat(0u);
x_9 = lean_nat_dec_eq(x_1, x_8);
if (x_9 == 0)
{
lean_object* x_10; lean_object* x_11; lean_object* x_12; 
lean_dec(x_6);
x_10 = lean_unsigned_to_nat(1u);
x_11 = lean_nat_sub(x_1, x_10);
x_12 = lean_apply_5(x_7, x_11, x_2, x_3, x_4, x_5);
return x_12;
}
else
{
lean_object* x_13; 
lean_dec(x_7);
x_13 = lean_apply_4(x_6, x_2, x_3, x_4, x_5);
return x_13;
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter___rarg___boxed), 7, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7) {
_start:
{
lean_object* x_8; 
x_8 = l___private_RIINA_Properties_NonInterference_0__RIINA_valRelN_match__1_splitter___rarg(x_1, x_2, x_3, x_4, x_5, x_6, x_7);
lean_dec(x_1);
return x_8;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_1) == 0)
{
lean_dec(x_3);
lean_inc(x_2);
return x_2;
}
else
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; 
x_4 = lean_ctor_get(x_1, 0);
lean_inc(x_4);
x_5 = lean_ctor_get(x_1, 1);
lean_inc(x_5);
lean_dec(x_1);
x_6 = lean_ctor_get(x_4, 0);
lean_inc(x_6);
x_7 = lean_ctor_get(x_4, 1);
lean_inc(x_7);
lean_dec(x_4);
x_8 = lean_apply_3(x_3, x_6, x_7, x_5);
return x_8;
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter___rarg___boxed), 3, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l___private_RIINA_Properties_NonInterference_0__RIINA_type__env__lookup_match__1_splitter___rarg(x_1, x_2, x_3);
lean_dec(x_2);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7, lean_object* x_8, lean_object* x_9, lean_object* x_10, lean_object* x_11, lean_object* x_12, lean_object* x_13, lean_object* x_14, lean_object* x_15, lean_object* x_16, lean_object* x_17, lean_object* x_18, lean_object* x_19, lean_object* x_20, lean_object* x_21, lean_object* x_22, lean_object* x_23, lean_object* x_24, lean_object* x_25, lean_object* x_26, lean_object* x_27) {
_start:
{
switch (lean_obj_tag(x_1)) {
case 0:
{
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
lean_inc(x_2);
return x_2;
}
case 1:
{
uint8_t x_28; lean_object* x_29; lean_object* x_30; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_28 = lean_ctor_get_uint8(x_1, 0);
lean_dec(x_1);
x_29 = lean_box(x_28);
x_30 = lean_apply_1(x_3, x_29);
return x_30;
}
case 2:
{
lean_object* x_31; lean_object* x_32; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
lean_dec(x_3);
x_31 = lean_ctor_get(x_1, 0);
lean_inc(x_31);
lean_dec(x_1);
x_32 = lean_apply_1(x_4, x_31);
return x_32;
}
case 3:
{
lean_object* x_33; lean_object* x_34; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
lean_dec(x_4);
lean_dec(x_3);
x_33 = lean_ctor_get(x_1, 0);
lean_inc(x_33);
lean_dec(x_1);
x_34 = lean_apply_1(x_5, x_33);
return x_34;
}
case 4:
{
lean_object* x_35; lean_object* x_36; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_35 = lean_ctor_get(x_1, 0);
lean_inc(x_35);
lean_dec(x_1);
x_36 = lean_apply_1(x_6, x_35);
return x_36;
}
case 5:
{
lean_object* x_37; lean_object* x_38; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_37 = lean_ctor_get(x_1, 0);
lean_inc(x_37);
lean_dec(x_1);
x_38 = lean_apply_1(x_7, x_37);
return x_38;
}
case 6:
{
lean_object* x_39; lean_object* x_40; lean_object* x_41; lean_object* x_42; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
lean_dec(x_7);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_39 = lean_ctor_get(x_1, 0);
lean_inc(x_39);
x_40 = lean_ctor_get(x_1, 1);
lean_inc(x_40);
x_41 = lean_ctor_get(x_1, 2);
lean_inc(x_41);
lean_dec(x_1);
x_42 = lean_apply_3(x_8, x_39, x_40, x_41);
return x_42;
}
case 7:
{
lean_object* x_43; lean_object* x_44; lean_object* x_45; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
lean_dec(x_14);
lean_dec(x_13);
lean_dec(x_12);
lean_dec(x_11);
lean_dec(x_10);
lean_dec(x_8);
lean_dec(x_7);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_43 = lean_ctor_get(x_1, 0);
lean_inc(x_43);
x_44 = lean_ctor_get(x_1, 1);
lean_inc(x_44);
lean_dec(x_1);
x_45 = lean_apply_2(x_9, x_43, x_44);
return x_45;
}
case 8:
{
lean_object* x_46; lean_object* x_47; lean_object* x_48; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
lean_dec(x_14);
lean_dec(x_13);
lean_dec(x_12);
lean_dec(x_11);
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_46 = lean_ctor_get(x_1, 0);
lean_inc(x_46);
x_47 = lean_ctor_get(x_1, 1);
lean_inc(x_47);
lean_dec(x_1);
x_48 = lean_apply_2(x_10, x_46, x_47);
return x_48;
}
case 9:
{
lean_object* x_49; lean_object* x_50; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
lean_dec(x_14);
lean_dec(x_13);
lean_dec(x_12);
lean_dec(x_10);
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_49 = lean_ctor_get(x_1, 0);
lean_inc(x_49);
lean_dec(x_1);
x_50 = lean_apply_1(x_11, x_49);
return x_50;
}
case 10:
{
lean_object* x_51; lean_object* x_52; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
lean_dec(x_14);
lean_dec(x_13);
lean_dec(x_11);
lean_dec(x_10);
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
x_51 = lean_ctor_get(x_1, 0);
lean_inc(x_51);
lean_dec(x_1);
x_52 = lean_apply_1(x_12, x_51);
return x_52;
}
case 11:
{
lean_object* x_53; lean_object* x_54; lean_object* x_55; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
lean_dec(x_14);
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
x_53 = lean_ctor_get(x_1, 0);
lean_inc(x_53);
x_54 = lean_ctor_get(x_1, 1);
lean_inc(x_54);
lean_dec(x_1);
x_55 = lean_apply_2(x_13, x_53, x_54);
return x_55;
}
case 12:
{
lean_object* x_56; lean_object* x_57; lean_object* x_58; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
lean_dec(x_15);
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
x_56 = lean_ctor_get(x_1, 0);
lean_inc(x_56);
x_57 = lean_ctor_get(x_1, 1);
lean_inc(x_57);
lean_dec(x_1);
x_58 = lean_apply_2(x_14, x_56, x_57);
return x_58;
}
case 13:
{
lean_object* x_59; lean_object* x_60; lean_object* x_61; lean_object* x_62; lean_object* x_63; lean_object* x_64; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
lean_dec(x_16);
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
x_59 = lean_ctor_get(x_1, 0);
lean_inc(x_59);
x_60 = lean_ctor_get(x_1, 1);
lean_inc(x_60);
x_61 = lean_ctor_get(x_1, 2);
lean_inc(x_61);
x_62 = lean_ctor_get(x_1, 3);
lean_inc(x_62);
x_63 = lean_ctor_get(x_1, 4);
lean_inc(x_63);
lean_dec(x_1);
x_64 = lean_apply_5(x_15, x_59, x_60, x_61, x_62, x_63);
return x_64;
}
case 14:
{
lean_object* x_65; lean_object* x_66; lean_object* x_67; lean_object* x_68; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
lean_dec(x_17);
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
x_65 = lean_ctor_get(x_1, 0);
lean_inc(x_65);
x_66 = lean_ctor_get(x_1, 1);
lean_inc(x_66);
x_67 = lean_ctor_get(x_1, 2);
lean_inc(x_67);
lean_dec(x_1);
x_68 = lean_apply_3(x_16, x_65, x_66, x_67);
return x_68;
}
case 15:
{
lean_object* x_69; lean_object* x_70; lean_object* x_71; lean_object* x_72; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
lean_dec(x_18);
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
x_69 = lean_ctor_get(x_1, 0);
lean_inc(x_69);
x_70 = lean_ctor_get(x_1, 1);
lean_inc(x_70);
x_71 = lean_ctor_get(x_1, 2);
lean_inc(x_71);
lean_dec(x_1);
x_72 = lean_apply_3(x_17, x_69, x_70, x_71);
return x_72;
}
case 16:
{
uint8_t x_73; lean_object* x_74; lean_object* x_75; lean_object* x_76; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_73 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
x_74 = lean_ctor_get(x_1, 0);
lean_inc(x_74);
lean_dec(x_1);
x_75 = lean_box(x_73);
x_76 = lean_apply_2(x_18, x_75, x_74);
return x_76;
}
case 17:
{
lean_object* x_77; lean_object* x_78; lean_object* x_79; lean_object* x_80; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
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
x_77 = lean_ctor_get(x_1, 0);
lean_inc(x_77);
x_78 = lean_ctor_get(x_1, 1);
lean_inc(x_78);
x_79 = lean_ctor_get(x_1, 2);
lean_inc(x_79);
lean_dec(x_1);
x_80 = lean_apply_3(x_19, x_77, x_78, x_79);
return x_80;
}
case 18:
{
lean_object* x_81; uint8_t x_82; lean_object* x_83; lean_object* x_84; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_19);
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
x_81 = lean_ctor_get(x_1, 0);
lean_inc(x_81);
x_82 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
lean_dec(x_1);
x_83 = lean_box(x_82);
x_84 = lean_apply_2(x_20, x_81, x_83);
return x_84;
}
case 19:
{
lean_object* x_85; lean_object* x_86; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_20);
lean_dec(x_19);
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
x_85 = lean_ctor_get(x_1, 0);
lean_inc(x_85);
lean_dec(x_1);
x_86 = lean_apply_1(x_21, x_85);
return x_86;
}
case 20:
{
lean_object* x_87; lean_object* x_88; lean_object* x_89; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_87 = lean_ctor_get(x_1, 0);
lean_inc(x_87);
x_88 = lean_ctor_get(x_1, 1);
lean_inc(x_88);
lean_dec(x_1);
x_89 = lean_apply_2(x_22, x_87, x_88);
return x_89;
}
case 21:
{
lean_object* x_90; lean_object* x_91; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_90 = lean_ctor_get(x_1, 0);
lean_inc(x_90);
lean_dec(x_1);
x_91 = lean_apply_1(x_23, x_90);
return x_91;
}
case 22:
{
lean_object* x_92; lean_object* x_93; lean_object* x_94; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_92 = lean_ctor_get(x_1, 0);
lean_inc(x_92);
x_93 = lean_ctor_get(x_1, 1);
lean_inc(x_93);
lean_dec(x_1);
x_94 = lean_apply_2(x_24, x_92, x_93);
return x_94;
}
case 23:
{
lean_object* x_95; lean_object* x_96; 
lean_dec(x_27);
lean_dec(x_26);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_95 = lean_ctor_get(x_1, 0);
lean_inc(x_95);
lean_dec(x_1);
x_96 = lean_apply_1(x_25, x_95);
return x_96;
}
case 24:
{
uint8_t x_97; lean_object* x_98; lean_object* x_99; lean_object* x_100; 
lean_dec(x_27);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_97 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
x_98 = lean_ctor_get(x_1, 0);
lean_inc(x_98);
lean_dec(x_1);
x_99 = lean_box(x_97);
x_100 = lean_apply_2(x_26, x_99, x_98);
return x_100;
}
default: 
{
uint8_t x_101; lean_object* x_102; lean_object* x_103; lean_object* x_104; 
lean_dec(x_26);
lean_dec(x_25);
lean_dec(x_24);
lean_dec(x_23);
lean_dec(x_22);
lean_dec(x_21);
lean_dec(x_20);
lean_dec(x_19);
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
x_101 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
x_102 = lean_ctor_get(x_1, 0);
lean_inc(x_102);
lean_dec(x_1);
x_103 = lean_box(x_101);
x_104 = lean_apply_2(x_27, x_103, x_102);
return x_104;
}
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter___rarg___boxed), 27, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter___rarg___boxed(lean_object** _args) {
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
lean_object* x_19 = _args[18];
lean_object* x_20 = _args[19];
lean_object* x_21 = _args[20];
lean_object* x_22 = _args[21];
lean_object* x_23 = _args[22];
lean_object* x_24 = _args[23];
lean_object* x_25 = _args[24];
lean_object* x_26 = _args[25];
lean_object* x_27 = _args[26];
_start:
{
lean_object* x_28; 
x_28 = l___private_RIINA_Properties_NonInterference_0__RIINA_substExpr_match__1_splitter___rarg(x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15, x_16, x_17, x_18, x_19, x_20, x_21, x_22, x_23, x_24, x_25, x_26, x_27);
lean_dec(x_2);
return x_28;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Syntax(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Semantics(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_TypeSystem_Typing(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Properties_NonInterference(uint8_t builtin, lean_object* w) {
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
l_RIINA_observer__level = _init_l_RIINA_observer__level();
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
