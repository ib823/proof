// Lean compiler output
// Module: RIINA.Termination.ReducibilityFull
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
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter___rarg___boxed(lean_object**);
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter___rarg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_string_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_extend__rho(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_id__rho(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_extend__rho___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_subst__env(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter(lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_id__rho(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_extend__rho(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
uint8_t x_5; 
x_5 = lean_string_dec_eq(x_4, x_2);
if (x_5 == 0)
{
lean_object* x_6; 
x_6 = lean_apply_1(x_1, x_4);
return x_6;
}
else
{
lean_dec(x_4);
lean_dec(x_1);
lean_inc(x_3);
return x_3;
}
}
}
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_extend__rho___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l_RIINA_ReducibilityFull_extend__rho(x_1, x_2, x_3, x_4);
lean_dec(x_3);
lean_dec(x_2);
return x_5;
}
}
LEAN_EXPORT lean_object* l_RIINA_ReducibilityFull_subst__env(lean_object* x_1, lean_object* x_2) {
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
lean_object* x_16; lean_object* x_17; 
x_16 = lean_ctor_get(x_2, 0);
lean_inc(x_16);
lean_dec(x_2);
x_17 = lean_apply_1(x_1, x_16);
return x_17;
}
case 6:
{
uint8_t x_18; 
x_18 = !lean_is_exclusive(x_2);
if (x_18 == 0)
{
lean_object* x_19; lean_object* x_20; lean_object* x_21; lean_object* x_22; lean_object* x_23; 
x_19 = lean_ctor_get(x_2, 0);
x_20 = lean_ctor_get(x_2, 2);
lean_inc(x_19);
x_21 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_21, 0, x_19);
lean_inc(x_19);
x_22 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_22, 0, x_1);
lean_closure_set(x_22, 1, x_19);
lean_closure_set(x_22, 2, x_21);
x_23 = l_RIINA_ReducibilityFull_subst__env(x_22, x_20);
lean_ctor_set(x_2, 2, x_23);
return x_2;
}
else
{
lean_object* x_24; lean_object* x_25; lean_object* x_26; lean_object* x_27; lean_object* x_28; lean_object* x_29; lean_object* x_30; 
x_24 = lean_ctor_get(x_2, 0);
x_25 = lean_ctor_get(x_2, 1);
x_26 = lean_ctor_get(x_2, 2);
lean_inc(x_26);
lean_inc(x_25);
lean_inc(x_24);
lean_dec(x_2);
lean_inc(x_24);
x_27 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_27, 0, x_24);
lean_inc(x_24);
x_28 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_28, 0, x_1);
lean_closure_set(x_28, 1, x_24);
lean_closure_set(x_28, 2, x_27);
x_29 = l_RIINA_ReducibilityFull_subst__env(x_28, x_26);
x_30 = lean_alloc_ctor(6, 3, 0);
lean_ctor_set(x_30, 0, x_24);
lean_ctor_set(x_30, 1, x_25);
lean_ctor_set(x_30, 2, x_29);
return x_30;
}
}
case 7:
{
uint8_t x_31; 
x_31 = !lean_is_exclusive(x_2);
if (x_31 == 0)
{
lean_object* x_32; lean_object* x_33; lean_object* x_34; lean_object* x_35; 
x_32 = lean_ctor_get(x_2, 0);
x_33 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_34 = l_RIINA_ReducibilityFull_subst__env(x_1, x_32);
x_35 = l_RIINA_ReducibilityFull_subst__env(x_1, x_33);
lean_ctor_set(x_2, 1, x_35);
lean_ctor_set(x_2, 0, x_34);
return x_2;
}
else
{
lean_object* x_36; lean_object* x_37; lean_object* x_38; lean_object* x_39; lean_object* x_40; 
x_36 = lean_ctor_get(x_2, 0);
x_37 = lean_ctor_get(x_2, 1);
lean_inc(x_37);
lean_inc(x_36);
lean_dec(x_2);
lean_inc(x_1);
x_38 = l_RIINA_ReducibilityFull_subst__env(x_1, x_36);
x_39 = l_RIINA_ReducibilityFull_subst__env(x_1, x_37);
x_40 = lean_alloc_ctor(7, 2, 0);
lean_ctor_set(x_40, 0, x_38);
lean_ctor_set(x_40, 1, x_39);
return x_40;
}
}
case 8:
{
uint8_t x_41; 
x_41 = !lean_is_exclusive(x_2);
if (x_41 == 0)
{
lean_object* x_42; lean_object* x_43; lean_object* x_44; lean_object* x_45; 
x_42 = lean_ctor_get(x_2, 0);
x_43 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_44 = l_RIINA_ReducibilityFull_subst__env(x_1, x_42);
x_45 = l_RIINA_ReducibilityFull_subst__env(x_1, x_43);
lean_ctor_set(x_2, 1, x_45);
lean_ctor_set(x_2, 0, x_44);
return x_2;
}
else
{
lean_object* x_46; lean_object* x_47; lean_object* x_48; lean_object* x_49; lean_object* x_50; 
x_46 = lean_ctor_get(x_2, 0);
x_47 = lean_ctor_get(x_2, 1);
lean_inc(x_47);
lean_inc(x_46);
lean_dec(x_2);
lean_inc(x_1);
x_48 = l_RIINA_ReducibilityFull_subst__env(x_1, x_46);
x_49 = l_RIINA_ReducibilityFull_subst__env(x_1, x_47);
x_50 = lean_alloc_ctor(8, 2, 0);
lean_ctor_set(x_50, 0, x_48);
lean_ctor_set(x_50, 1, x_49);
return x_50;
}
}
case 9:
{
uint8_t x_51; 
x_51 = !lean_is_exclusive(x_2);
if (x_51 == 0)
{
lean_object* x_52; lean_object* x_53; 
x_52 = lean_ctor_get(x_2, 0);
x_53 = l_RIINA_ReducibilityFull_subst__env(x_1, x_52);
lean_ctor_set(x_2, 0, x_53);
return x_2;
}
else
{
lean_object* x_54; lean_object* x_55; lean_object* x_56; 
x_54 = lean_ctor_get(x_2, 0);
lean_inc(x_54);
lean_dec(x_2);
x_55 = l_RIINA_ReducibilityFull_subst__env(x_1, x_54);
x_56 = lean_alloc_ctor(9, 1, 0);
lean_ctor_set(x_56, 0, x_55);
return x_56;
}
}
case 10:
{
uint8_t x_57; 
x_57 = !lean_is_exclusive(x_2);
if (x_57 == 0)
{
lean_object* x_58; lean_object* x_59; 
x_58 = lean_ctor_get(x_2, 0);
x_59 = l_RIINA_ReducibilityFull_subst__env(x_1, x_58);
lean_ctor_set(x_2, 0, x_59);
return x_2;
}
else
{
lean_object* x_60; lean_object* x_61; lean_object* x_62; 
x_60 = lean_ctor_get(x_2, 0);
lean_inc(x_60);
lean_dec(x_2);
x_61 = l_RIINA_ReducibilityFull_subst__env(x_1, x_60);
x_62 = lean_alloc_ctor(10, 1, 0);
lean_ctor_set(x_62, 0, x_61);
return x_62;
}
}
case 11:
{
uint8_t x_63; 
x_63 = !lean_is_exclusive(x_2);
if (x_63 == 0)
{
lean_object* x_64; lean_object* x_65; 
x_64 = lean_ctor_get(x_2, 0);
x_65 = l_RIINA_ReducibilityFull_subst__env(x_1, x_64);
lean_ctor_set(x_2, 0, x_65);
return x_2;
}
else
{
lean_object* x_66; lean_object* x_67; lean_object* x_68; lean_object* x_69; 
x_66 = lean_ctor_get(x_2, 0);
x_67 = lean_ctor_get(x_2, 1);
lean_inc(x_67);
lean_inc(x_66);
lean_dec(x_2);
x_68 = l_RIINA_ReducibilityFull_subst__env(x_1, x_66);
x_69 = lean_alloc_ctor(11, 2, 0);
lean_ctor_set(x_69, 0, x_68);
lean_ctor_set(x_69, 1, x_67);
return x_69;
}
}
case 12:
{
uint8_t x_70; 
x_70 = !lean_is_exclusive(x_2);
if (x_70 == 0)
{
lean_object* x_71; lean_object* x_72; 
x_71 = lean_ctor_get(x_2, 0);
x_72 = l_RIINA_ReducibilityFull_subst__env(x_1, x_71);
lean_ctor_set(x_2, 0, x_72);
return x_2;
}
else
{
lean_object* x_73; lean_object* x_74; lean_object* x_75; lean_object* x_76; 
x_73 = lean_ctor_get(x_2, 0);
x_74 = lean_ctor_get(x_2, 1);
lean_inc(x_74);
lean_inc(x_73);
lean_dec(x_2);
x_75 = l_RIINA_ReducibilityFull_subst__env(x_1, x_73);
x_76 = lean_alloc_ctor(12, 2, 0);
lean_ctor_set(x_76, 0, x_75);
lean_ctor_set(x_76, 1, x_74);
return x_76;
}
}
case 13:
{
uint8_t x_77; 
x_77 = !lean_is_exclusive(x_2);
if (x_77 == 0)
{
lean_object* x_78; lean_object* x_79; lean_object* x_80; lean_object* x_81; lean_object* x_82; lean_object* x_83; lean_object* x_84; lean_object* x_85; lean_object* x_86; lean_object* x_87; lean_object* x_88; lean_object* x_89; 
x_78 = lean_ctor_get(x_2, 0);
x_79 = lean_ctor_get(x_2, 1);
x_80 = lean_ctor_get(x_2, 2);
x_81 = lean_ctor_get(x_2, 3);
x_82 = lean_ctor_get(x_2, 4);
lean_inc(x_1);
x_83 = l_RIINA_ReducibilityFull_subst__env(x_1, x_78);
lean_inc(x_79);
x_84 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_84, 0, x_79);
lean_inc(x_79);
lean_inc(x_1);
x_85 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_85, 0, x_1);
lean_closure_set(x_85, 1, x_79);
lean_closure_set(x_85, 2, x_84);
x_86 = l_RIINA_ReducibilityFull_subst__env(x_85, x_80);
lean_inc(x_81);
x_87 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_87, 0, x_81);
lean_inc(x_81);
x_88 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_88, 0, x_1);
lean_closure_set(x_88, 1, x_81);
lean_closure_set(x_88, 2, x_87);
x_89 = l_RIINA_ReducibilityFull_subst__env(x_88, x_82);
lean_ctor_set(x_2, 4, x_89);
lean_ctor_set(x_2, 2, x_86);
lean_ctor_set(x_2, 0, x_83);
return x_2;
}
else
{
lean_object* x_90; lean_object* x_91; lean_object* x_92; lean_object* x_93; lean_object* x_94; lean_object* x_95; lean_object* x_96; lean_object* x_97; lean_object* x_98; lean_object* x_99; lean_object* x_100; lean_object* x_101; lean_object* x_102; 
x_90 = lean_ctor_get(x_2, 0);
x_91 = lean_ctor_get(x_2, 1);
x_92 = lean_ctor_get(x_2, 2);
x_93 = lean_ctor_get(x_2, 3);
x_94 = lean_ctor_get(x_2, 4);
lean_inc(x_94);
lean_inc(x_93);
lean_inc(x_92);
lean_inc(x_91);
lean_inc(x_90);
lean_dec(x_2);
lean_inc(x_1);
x_95 = l_RIINA_ReducibilityFull_subst__env(x_1, x_90);
lean_inc(x_91);
x_96 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_96, 0, x_91);
lean_inc(x_91);
lean_inc(x_1);
x_97 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_97, 0, x_1);
lean_closure_set(x_97, 1, x_91);
lean_closure_set(x_97, 2, x_96);
x_98 = l_RIINA_ReducibilityFull_subst__env(x_97, x_92);
lean_inc(x_93);
x_99 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_99, 0, x_93);
lean_inc(x_93);
x_100 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_100, 0, x_1);
lean_closure_set(x_100, 1, x_93);
lean_closure_set(x_100, 2, x_99);
x_101 = l_RIINA_ReducibilityFull_subst__env(x_100, x_94);
x_102 = lean_alloc_ctor(13, 5, 0);
lean_ctor_set(x_102, 0, x_95);
lean_ctor_set(x_102, 1, x_91);
lean_ctor_set(x_102, 2, x_98);
lean_ctor_set(x_102, 3, x_93);
lean_ctor_set(x_102, 4, x_101);
return x_102;
}
}
case 14:
{
uint8_t x_103; 
x_103 = !lean_is_exclusive(x_2);
if (x_103 == 0)
{
lean_object* x_104; lean_object* x_105; lean_object* x_106; lean_object* x_107; lean_object* x_108; lean_object* x_109; 
x_104 = lean_ctor_get(x_2, 0);
x_105 = lean_ctor_get(x_2, 1);
x_106 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
x_107 = l_RIINA_ReducibilityFull_subst__env(x_1, x_104);
lean_inc(x_1);
x_108 = l_RIINA_ReducibilityFull_subst__env(x_1, x_105);
x_109 = l_RIINA_ReducibilityFull_subst__env(x_1, x_106);
lean_ctor_set(x_2, 2, x_109);
lean_ctor_set(x_2, 1, x_108);
lean_ctor_set(x_2, 0, x_107);
return x_2;
}
else
{
lean_object* x_110; lean_object* x_111; lean_object* x_112; lean_object* x_113; lean_object* x_114; lean_object* x_115; lean_object* x_116; 
x_110 = lean_ctor_get(x_2, 0);
x_111 = lean_ctor_get(x_2, 1);
x_112 = lean_ctor_get(x_2, 2);
lean_inc(x_112);
lean_inc(x_111);
lean_inc(x_110);
lean_dec(x_2);
lean_inc(x_1);
x_113 = l_RIINA_ReducibilityFull_subst__env(x_1, x_110);
lean_inc(x_1);
x_114 = l_RIINA_ReducibilityFull_subst__env(x_1, x_111);
x_115 = l_RIINA_ReducibilityFull_subst__env(x_1, x_112);
x_116 = lean_alloc_ctor(14, 3, 0);
lean_ctor_set(x_116, 0, x_113);
lean_ctor_set(x_116, 1, x_114);
lean_ctor_set(x_116, 2, x_115);
return x_116;
}
}
case 15:
{
uint8_t x_117; 
x_117 = !lean_is_exclusive(x_2);
if (x_117 == 0)
{
lean_object* x_118; lean_object* x_119; lean_object* x_120; lean_object* x_121; lean_object* x_122; lean_object* x_123; lean_object* x_124; 
x_118 = lean_ctor_get(x_2, 0);
x_119 = lean_ctor_get(x_2, 1);
x_120 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
x_121 = l_RIINA_ReducibilityFull_subst__env(x_1, x_119);
lean_inc(x_118);
x_122 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_122, 0, x_118);
lean_inc(x_118);
x_123 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_123, 0, x_1);
lean_closure_set(x_123, 1, x_118);
lean_closure_set(x_123, 2, x_122);
x_124 = l_RIINA_ReducibilityFull_subst__env(x_123, x_120);
lean_ctor_set(x_2, 2, x_124);
lean_ctor_set(x_2, 1, x_121);
return x_2;
}
else
{
lean_object* x_125; lean_object* x_126; lean_object* x_127; lean_object* x_128; lean_object* x_129; lean_object* x_130; lean_object* x_131; lean_object* x_132; 
x_125 = lean_ctor_get(x_2, 0);
x_126 = lean_ctor_get(x_2, 1);
x_127 = lean_ctor_get(x_2, 2);
lean_inc(x_127);
lean_inc(x_126);
lean_inc(x_125);
lean_dec(x_2);
lean_inc(x_1);
x_128 = l_RIINA_ReducibilityFull_subst__env(x_1, x_126);
lean_inc(x_125);
x_129 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_129, 0, x_125);
lean_inc(x_125);
x_130 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_130, 0, x_1);
lean_closure_set(x_130, 1, x_125);
lean_closure_set(x_130, 2, x_129);
x_131 = l_RIINA_ReducibilityFull_subst__env(x_130, x_127);
x_132 = lean_alloc_ctor(15, 3, 0);
lean_ctor_set(x_132, 0, x_125);
lean_ctor_set(x_132, 1, x_128);
lean_ctor_set(x_132, 2, x_131);
return x_132;
}
}
case 16:
{
uint8_t x_133; 
x_133 = !lean_is_exclusive(x_2);
if (x_133 == 0)
{
lean_object* x_134; lean_object* x_135; 
x_134 = lean_ctor_get(x_2, 0);
x_135 = l_RIINA_ReducibilityFull_subst__env(x_1, x_134);
lean_ctor_set(x_2, 0, x_135);
return x_2;
}
else
{
uint8_t x_136; lean_object* x_137; lean_object* x_138; lean_object* x_139; 
x_136 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
x_137 = lean_ctor_get(x_2, 0);
lean_inc(x_137);
lean_dec(x_2);
x_138 = l_RIINA_ReducibilityFull_subst__env(x_1, x_137);
x_139 = lean_alloc_ctor(16, 1, 1);
lean_ctor_set(x_139, 0, x_138);
lean_ctor_set_uint8(x_139, sizeof(void*)*1, x_136);
return x_139;
}
}
case 17:
{
uint8_t x_140; 
x_140 = !lean_is_exclusive(x_2);
if (x_140 == 0)
{
lean_object* x_141; lean_object* x_142; lean_object* x_143; lean_object* x_144; lean_object* x_145; lean_object* x_146; lean_object* x_147; 
x_141 = lean_ctor_get(x_2, 0);
x_142 = lean_ctor_get(x_2, 1);
x_143 = lean_ctor_get(x_2, 2);
lean_inc(x_1);
x_144 = l_RIINA_ReducibilityFull_subst__env(x_1, x_141);
lean_inc(x_142);
x_145 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_145, 0, x_142);
lean_inc(x_142);
x_146 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_146, 0, x_1);
lean_closure_set(x_146, 1, x_142);
lean_closure_set(x_146, 2, x_145);
x_147 = l_RIINA_ReducibilityFull_subst__env(x_146, x_143);
lean_ctor_set(x_2, 2, x_147);
lean_ctor_set(x_2, 0, x_144);
return x_2;
}
else
{
lean_object* x_148; lean_object* x_149; lean_object* x_150; lean_object* x_151; lean_object* x_152; lean_object* x_153; lean_object* x_154; lean_object* x_155; 
x_148 = lean_ctor_get(x_2, 0);
x_149 = lean_ctor_get(x_2, 1);
x_150 = lean_ctor_get(x_2, 2);
lean_inc(x_150);
lean_inc(x_149);
lean_inc(x_148);
lean_dec(x_2);
lean_inc(x_1);
x_151 = l_RIINA_ReducibilityFull_subst__env(x_1, x_148);
lean_inc(x_149);
x_152 = lean_alloc_ctor(5, 1, 0);
lean_ctor_set(x_152, 0, x_149);
lean_inc(x_149);
x_153 = lean_alloc_closure((void*)(l_RIINA_ReducibilityFull_extend__rho___boxed), 4, 3);
lean_closure_set(x_153, 0, x_1);
lean_closure_set(x_153, 1, x_149);
lean_closure_set(x_153, 2, x_152);
x_154 = l_RIINA_ReducibilityFull_subst__env(x_153, x_150);
x_155 = lean_alloc_ctor(17, 3, 0);
lean_ctor_set(x_155, 0, x_151);
lean_ctor_set(x_155, 1, x_149);
lean_ctor_set(x_155, 2, x_154);
return x_155;
}
}
case 18:
{
uint8_t x_156; 
x_156 = !lean_is_exclusive(x_2);
if (x_156 == 0)
{
lean_object* x_157; lean_object* x_158; 
x_157 = lean_ctor_get(x_2, 0);
x_158 = l_RIINA_ReducibilityFull_subst__env(x_1, x_157);
lean_ctor_set(x_2, 0, x_158);
return x_2;
}
else
{
lean_object* x_159; uint8_t x_160; lean_object* x_161; lean_object* x_162; 
x_159 = lean_ctor_get(x_2, 0);
x_160 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
lean_inc(x_159);
lean_dec(x_2);
x_161 = l_RIINA_ReducibilityFull_subst__env(x_1, x_159);
x_162 = lean_alloc_ctor(18, 1, 1);
lean_ctor_set(x_162, 0, x_161);
lean_ctor_set_uint8(x_162, sizeof(void*)*1, x_160);
return x_162;
}
}
case 19:
{
uint8_t x_163; 
x_163 = !lean_is_exclusive(x_2);
if (x_163 == 0)
{
lean_object* x_164; lean_object* x_165; 
x_164 = lean_ctor_get(x_2, 0);
x_165 = l_RIINA_ReducibilityFull_subst__env(x_1, x_164);
lean_ctor_set(x_2, 0, x_165);
return x_2;
}
else
{
lean_object* x_166; lean_object* x_167; lean_object* x_168; 
x_166 = lean_ctor_get(x_2, 0);
lean_inc(x_166);
lean_dec(x_2);
x_167 = l_RIINA_ReducibilityFull_subst__env(x_1, x_166);
x_168 = lean_alloc_ctor(19, 1, 0);
lean_ctor_set(x_168, 0, x_167);
return x_168;
}
}
case 20:
{
uint8_t x_169; 
x_169 = !lean_is_exclusive(x_2);
if (x_169 == 0)
{
lean_object* x_170; lean_object* x_171; lean_object* x_172; lean_object* x_173; 
x_170 = lean_ctor_get(x_2, 0);
x_171 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_172 = l_RIINA_ReducibilityFull_subst__env(x_1, x_170);
x_173 = l_RIINA_ReducibilityFull_subst__env(x_1, x_171);
lean_ctor_set(x_2, 1, x_173);
lean_ctor_set(x_2, 0, x_172);
return x_2;
}
else
{
lean_object* x_174; lean_object* x_175; lean_object* x_176; lean_object* x_177; lean_object* x_178; 
x_174 = lean_ctor_get(x_2, 0);
x_175 = lean_ctor_get(x_2, 1);
lean_inc(x_175);
lean_inc(x_174);
lean_dec(x_2);
lean_inc(x_1);
x_176 = l_RIINA_ReducibilityFull_subst__env(x_1, x_174);
x_177 = l_RIINA_ReducibilityFull_subst__env(x_1, x_175);
x_178 = lean_alloc_ctor(20, 2, 0);
lean_ctor_set(x_178, 0, x_176);
lean_ctor_set(x_178, 1, x_177);
return x_178;
}
}
case 21:
{
uint8_t x_179; 
x_179 = !lean_is_exclusive(x_2);
if (x_179 == 0)
{
lean_object* x_180; lean_object* x_181; 
x_180 = lean_ctor_get(x_2, 0);
x_181 = l_RIINA_ReducibilityFull_subst__env(x_1, x_180);
lean_ctor_set(x_2, 0, x_181);
return x_2;
}
else
{
lean_object* x_182; lean_object* x_183; lean_object* x_184; 
x_182 = lean_ctor_get(x_2, 0);
lean_inc(x_182);
lean_dec(x_2);
x_183 = l_RIINA_ReducibilityFull_subst__env(x_1, x_182);
x_184 = lean_alloc_ctor(21, 1, 0);
lean_ctor_set(x_184, 0, x_183);
return x_184;
}
}
case 22:
{
uint8_t x_185; 
x_185 = !lean_is_exclusive(x_2);
if (x_185 == 0)
{
lean_object* x_186; lean_object* x_187; lean_object* x_188; lean_object* x_189; 
x_186 = lean_ctor_get(x_2, 0);
x_187 = lean_ctor_get(x_2, 1);
lean_inc(x_1);
x_188 = l_RIINA_ReducibilityFull_subst__env(x_1, x_186);
x_189 = l_RIINA_ReducibilityFull_subst__env(x_1, x_187);
lean_ctor_set(x_2, 1, x_189);
lean_ctor_set(x_2, 0, x_188);
return x_2;
}
else
{
lean_object* x_190; lean_object* x_191; lean_object* x_192; lean_object* x_193; lean_object* x_194; 
x_190 = lean_ctor_get(x_2, 0);
x_191 = lean_ctor_get(x_2, 1);
lean_inc(x_191);
lean_inc(x_190);
lean_dec(x_2);
lean_inc(x_1);
x_192 = l_RIINA_ReducibilityFull_subst__env(x_1, x_190);
x_193 = l_RIINA_ReducibilityFull_subst__env(x_1, x_191);
x_194 = lean_alloc_ctor(22, 2, 0);
lean_ctor_set(x_194, 0, x_192);
lean_ctor_set(x_194, 1, x_193);
return x_194;
}
}
case 23:
{
uint8_t x_195; 
x_195 = !lean_is_exclusive(x_2);
if (x_195 == 0)
{
lean_object* x_196; lean_object* x_197; 
x_196 = lean_ctor_get(x_2, 0);
x_197 = l_RIINA_ReducibilityFull_subst__env(x_1, x_196);
lean_ctor_set(x_2, 0, x_197);
return x_2;
}
else
{
lean_object* x_198; lean_object* x_199; lean_object* x_200; 
x_198 = lean_ctor_get(x_2, 0);
lean_inc(x_198);
lean_dec(x_2);
x_199 = l_RIINA_ReducibilityFull_subst__env(x_1, x_198);
x_200 = lean_alloc_ctor(23, 1, 0);
lean_ctor_set(x_200, 0, x_199);
return x_200;
}
}
case 24:
{
uint8_t x_201; 
x_201 = !lean_is_exclusive(x_2);
if (x_201 == 0)
{
lean_object* x_202; lean_object* x_203; 
x_202 = lean_ctor_get(x_2, 0);
x_203 = l_RIINA_ReducibilityFull_subst__env(x_1, x_202);
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
x_206 = l_RIINA_ReducibilityFull_subst__env(x_1, x_205);
x_207 = lean_alloc_ctor(24, 1, 1);
lean_ctor_set(x_207, 0, x_206);
lean_ctor_set_uint8(x_207, sizeof(void*)*1, x_204);
return x_207;
}
}
default: 
{
uint8_t x_208; 
x_208 = !lean_is_exclusive(x_2);
if (x_208 == 0)
{
lean_object* x_209; lean_object* x_210; 
x_209 = lean_ctor_get(x_2, 0);
x_210 = l_RIINA_ReducibilityFull_subst__env(x_1, x_209);
lean_ctor_set(x_2, 0, x_210);
return x_2;
}
else
{
uint8_t x_211; lean_object* x_212; lean_object* x_213; lean_object* x_214; 
x_211 = lean_ctor_get_uint8(x_2, sizeof(void*)*1);
x_212 = lean_ctor_get(x_2, 0);
lean_inc(x_212);
lean_dec(x_2);
x_213 = l_RIINA_ReducibilityFull_subst__env(x_1, x_212);
x_214 = lean_alloc_ctor(25, 1, 1);
lean_ctor_set(x_214, 0, x_213);
lean_ctor_set_uint8(x_214, sizeof(void*)*1, x_211);
return x_214;
}
}
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
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
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter___rarg___boxed), 3, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l___private_RIINA_Termination_ReducibilityFull_0__RIINA_type__env__lookup_match__1_splitter___rarg(x_1, x_2, x_3);
lean_dec(x_2);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7, lean_object* x_8, lean_object* x_9, lean_object* x_10, lean_object* x_11, lean_object* x_12, lean_object* x_13, lean_object* x_14, lean_object* x_15, lean_object* x_16, lean_object* x_17, lean_object* x_18, lean_object* x_19, lean_object* x_20, lean_object* x_21, lean_object* x_22, lean_object* x_23, lean_object* x_24, lean_object* x_25, lean_object* x_26, lean_object* x_27) {
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
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter___rarg___boxed), 27, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter___rarg___boxed(lean_object** _args) {
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
x_28 = l___private_RIINA_Termination_ReducibilityFull_0__RIINA_substExpr_match__1_splitter___rarg(x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15, x_16, x_17, x_18, x_19, x_20, x_21, x_22, x_23, x_24, x_25, x_26, x_27);
lean_dec(x_2);
return x_28;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Syntax(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Semantics(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_TypeSystem_Typing(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Termination_ReducibilityFull(uint8_t builtin, lean_object* w) {
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
