// Lean compiler output
// Module: RIINA.Properties.FirstOrderComplete
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
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_string_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_expr__eqb(lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_is__base__type___boxed(lean_object*);
LEAN_EXPORT lean_object* l_RIINA_expr__eqb___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_RIINA_ty__eqb___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter___rarg___boxed(lean_object**);
LEAN_EXPORT uint8_t l_RIINA_is__base__type(lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter(lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter___rarg(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter___rarg___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter(lean_object*);
LEAN_EXPORT uint8_t l_RIINA_ty__eqb(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_RIINA_is__base__type(lean_object* x_1) {
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
case 16:
{
uint8_t x_7; 
x_7 = 1;
return x_7;
}
case 17:
{
uint8_t x_8; 
x_8 = 1;
return x_8;
}
default: 
{
uint8_t x_9; 
x_9 = 0;
return x_9;
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_is__base__type___boxed(lean_object* x_1) {
_start:
{
uint8_t x_2; lean_object* x_3; 
x_2 = l_RIINA_is__base__type(x_1);
lean_dec(x_1);
x_3 = lean_box(x_2);
return x_3;
}
}
LEAN_EXPORT uint8_t l_RIINA_expr__eqb(lean_object* x_1, lean_object* x_2) {
_start:
{
switch (lean_obj_tag(x_1)) {
case 0:
{
if (lean_obj_tag(x_2) == 0)
{
uint8_t x_3; 
x_3 = 1;
return x_3;
}
else
{
uint8_t x_4; 
x_4 = 0;
return x_4;
}
}
case 1:
{
if (lean_obj_tag(x_2) == 1)
{
uint8_t x_5; 
x_5 = lean_ctor_get_uint8(x_1, 0);
if (x_5 == 0)
{
uint8_t x_6; 
x_6 = lean_ctor_get_uint8(x_2, 0);
if (x_6 == 0)
{
uint8_t x_7; 
x_7 = 1;
return x_7;
}
else
{
uint8_t x_8; 
x_8 = 0;
return x_8;
}
}
else
{
uint8_t x_9; 
x_9 = lean_ctor_get_uint8(x_2, 0);
return x_9;
}
}
else
{
uint8_t x_10; 
x_10 = 0;
return x_10;
}
}
case 2:
{
if (lean_obj_tag(x_2) == 2)
{
lean_object* x_11; lean_object* x_12; uint8_t x_13; 
x_11 = lean_ctor_get(x_1, 0);
x_12 = lean_ctor_get(x_2, 0);
x_13 = lean_nat_dec_eq(x_11, x_12);
return x_13;
}
else
{
uint8_t x_14; 
x_14 = 0;
return x_14;
}
}
case 3:
{
if (lean_obj_tag(x_2) == 3)
{
lean_object* x_15; lean_object* x_16; uint8_t x_17; 
x_15 = lean_ctor_get(x_1, 0);
x_16 = lean_ctor_get(x_2, 0);
x_17 = lean_string_dec_eq(x_15, x_16);
return x_17;
}
else
{
uint8_t x_18; 
x_18 = 0;
return x_18;
}
}
case 4:
{
if (lean_obj_tag(x_2) == 4)
{
lean_object* x_19; lean_object* x_20; uint8_t x_21; 
x_19 = lean_ctor_get(x_1, 0);
x_20 = lean_ctor_get(x_2, 0);
x_21 = lean_nat_dec_eq(x_19, x_20);
return x_21;
}
else
{
uint8_t x_22; 
x_22 = 0;
return x_22;
}
}
case 5:
{
if (lean_obj_tag(x_2) == 5)
{
lean_object* x_23; lean_object* x_24; uint8_t x_25; 
x_23 = lean_ctor_get(x_1, 0);
x_24 = lean_ctor_get(x_2, 0);
x_25 = lean_string_dec_eq(x_23, x_24);
return x_25;
}
else
{
uint8_t x_26; 
x_26 = 0;
return x_26;
}
}
case 6:
{
if (lean_obj_tag(x_2) == 6)
{
lean_object* x_27; lean_object* x_28; lean_object* x_29; lean_object* x_30; uint8_t x_31; 
x_27 = lean_ctor_get(x_1, 0);
x_28 = lean_ctor_get(x_1, 2);
x_29 = lean_ctor_get(x_2, 0);
x_30 = lean_ctor_get(x_2, 2);
x_31 = lean_string_dec_eq(x_27, x_29);
if (x_31 == 0)
{
uint8_t x_32; 
x_32 = 0;
return x_32;
}
else
{
x_1 = x_28;
x_2 = x_30;
goto _start;
}
}
else
{
uint8_t x_34; 
x_34 = 0;
return x_34;
}
}
case 8:
{
if (lean_obj_tag(x_2) == 8)
{
lean_object* x_35; lean_object* x_36; lean_object* x_37; lean_object* x_38; uint8_t x_39; 
x_35 = lean_ctor_get(x_1, 0);
x_36 = lean_ctor_get(x_1, 1);
x_37 = lean_ctor_get(x_2, 0);
x_38 = lean_ctor_get(x_2, 1);
x_39 = l_RIINA_expr__eqb(x_35, x_37);
if (x_39 == 0)
{
uint8_t x_40; 
x_40 = 0;
return x_40;
}
else
{
x_1 = x_36;
x_2 = x_38;
goto _start;
}
}
else
{
uint8_t x_42; 
x_42 = 0;
return x_42;
}
}
case 11:
{
if (lean_obj_tag(x_2) == 11)
{
lean_object* x_43; lean_object* x_44; 
x_43 = lean_ctor_get(x_1, 0);
x_44 = lean_ctor_get(x_2, 0);
x_1 = x_43;
x_2 = x_44;
goto _start;
}
else
{
uint8_t x_46; 
x_46 = 0;
return x_46;
}
}
case 12:
{
if (lean_obj_tag(x_2) == 12)
{
lean_object* x_47; lean_object* x_48; 
x_47 = lean_ctor_get(x_1, 0);
x_48 = lean_ctor_get(x_2, 0);
x_1 = x_47;
x_2 = x_48;
goto _start;
}
else
{
uint8_t x_50; 
x_50 = 0;
return x_50;
}
}
case 21:
{
if (lean_obj_tag(x_2) == 21)
{
lean_object* x_51; lean_object* x_52; 
x_51 = lean_ctor_get(x_1, 0);
x_52 = lean_ctor_get(x_2, 0);
x_1 = x_51;
x_2 = x_52;
goto _start;
}
else
{
uint8_t x_54; 
x_54 = 0;
return x_54;
}
}
case 23:
{
if (lean_obj_tag(x_2) == 23)
{
lean_object* x_55; lean_object* x_56; 
x_55 = lean_ctor_get(x_1, 0);
x_56 = lean_ctor_get(x_2, 0);
x_1 = x_55;
x_2 = x_56;
goto _start;
}
else
{
uint8_t x_58; 
x_58 = 0;
return x_58;
}
}
default: 
{
uint8_t x_59; 
x_59 = 0;
return x_59;
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_expr__eqb___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_RIINA_expr__eqb(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT uint8_t l_RIINA_ty__eqb(lean_object* x_1, lean_object* x_2) {
_start:
{
switch (lean_obj_tag(x_1)) {
case 0:
{
if (lean_obj_tag(x_2) == 0)
{
uint8_t x_3; 
x_3 = 1;
return x_3;
}
else
{
uint8_t x_4; 
x_4 = 0;
return x_4;
}
}
case 1:
{
if (lean_obj_tag(x_2) == 1)
{
uint8_t x_5; 
x_5 = 1;
return x_5;
}
else
{
uint8_t x_6; 
x_6 = 0;
return x_6;
}
}
case 2:
{
if (lean_obj_tag(x_2) == 2)
{
uint8_t x_7; 
x_7 = 1;
return x_7;
}
else
{
uint8_t x_8; 
x_8 = 0;
return x_8;
}
}
case 3:
{
if (lean_obj_tag(x_2) == 3)
{
uint8_t x_9; 
x_9 = 1;
return x_9;
}
else
{
uint8_t x_10; 
x_10 = 0;
return x_10;
}
}
case 4:
{
if (lean_obj_tag(x_2) == 4)
{
uint8_t x_11; 
x_11 = 1;
return x_11;
}
else
{
uint8_t x_12; 
x_12 = 0;
return x_12;
}
}
case 5:
{
if (lean_obj_tag(x_2) == 5)
{
lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; uint8_t x_17; 
x_13 = lean_ctor_get(x_1, 0);
x_14 = lean_ctor_get(x_1, 1);
x_15 = lean_ctor_get(x_2, 0);
x_16 = lean_ctor_get(x_2, 1);
x_17 = l_RIINA_ty__eqb(x_13, x_15);
if (x_17 == 0)
{
uint8_t x_18; 
x_18 = 0;
return x_18;
}
else
{
x_1 = x_14;
x_2 = x_16;
goto _start;
}
}
else
{
uint8_t x_20; 
x_20 = 0;
return x_20;
}
}
case 6:
{
if (lean_obj_tag(x_2) == 6)
{
lean_object* x_21; lean_object* x_22; lean_object* x_23; lean_object* x_24; uint8_t x_25; 
x_21 = lean_ctor_get(x_1, 0);
x_22 = lean_ctor_get(x_1, 1);
x_23 = lean_ctor_get(x_2, 0);
x_24 = lean_ctor_get(x_2, 1);
x_25 = l_RIINA_ty__eqb(x_21, x_23);
if (x_25 == 0)
{
uint8_t x_26; 
x_26 = 0;
return x_26;
}
else
{
x_1 = x_22;
x_2 = x_24;
goto _start;
}
}
else
{
uint8_t x_28; 
x_28 = 0;
return x_28;
}
}
case 7:
{
if (lean_obj_tag(x_2) == 7)
{
lean_object* x_29; lean_object* x_30; lean_object* x_31; lean_object* x_32; uint8_t x_33; 
x_29 = lean_ctor_get(x_1, 0);
x_30 = lean_ctor_get(x_1, 1);
x_31 = lean_ctor_get(x_2, 0);
x_32 = lean_ctor_get(x_2, 1);
x_33 = l_RIINA_ty__eqb(x_29, x_31);
if (x_33 == 0)
{
uint8_t x_34; 
x_34 = 0;
return x_34;
}
else
{
x_1 = x_30;
x_2 = x_32;
goto _start;
}
}
else
{
uint8_t x_36; 
x_36 = 0;
return x_36;
}
}
case 8:
{
if (lean_obj_tag(x_2) == 8)
{
lean_object* x_37; lean_object* x_38; 
x_37 = lean_ctor_get(x_1, 0);
x_38 = lean_ctor_get(x_2, 0);
x_1 = x_37;
x_2 = x_38;
goto _start;
}
else
{
uint8_t x_40; 
x_40 = 0;
return x_40;
}
}
case 9:
{
if (lean_obj_tag(x_2) == 9)
{
lean_object* x_41; lean_object* x_42; 
x_41 = lean_ctor_get(x_1, 0);
x_42 = lean_ctor_get(x_2, 0);
x_1 = x_41;
x_2 = x_42;
goto _start;
}
else
{
uint8_t x_44; 
x_44 = 0;
return x_44;
}
}
case 10:
{
if (lean_obj_tag(x_2) == 10)
{
lean_object* x_45; lean_object* x_46; 
x_45 = lean_ctor_get(x_1, 0);
x_46 = lean_ctor_get(x_2, 0);
x_1 = x_45;
x_2 = x_46;
goto _start;
}
else
{
uint8_t x_48; 
x_48 = 0;
return x_48;
}
}
case 11:
{
if (lean_obj_tag(x_2) == 11)
{
lean_object* x_49; lean_object* x_50; 
x_49 = lean_ctor_get(x_1, 0);
x_50 = lean_ctor_get(x_2, 0);
x_1 = x_49;
x_2 = x_50;
goto _start;
}
else
{
uint8_t x_52; 
x_52 = 0;
return x_52;
}
}
case 12:
{
if (lean_obj_tag(x_2) == 12)
{
lean_object* x_53; lean_object* x_54; 
x_53 = lean_ctor_get(x_1, 0);
x_54 = lean_ctor_get(x_2, 0);
x_1 = x_53;
x_2 = x_54;
goto _start;
}
else
{
uint8_t x_56; 
x_56 = 0;
return x_56;
}
}
case 13:
{
if (lean_obj_tag(x_2) == 13)
{
lean_object* x_57; lean_object* x_58; 
x_57 = lean_ctor_get(x_1, 0);
x_58 = lean_ctor_get(x_2, 0);
x_1 = x_57;
x_2 = x_58;
goto _start;
}
else
{
uint8_t x_60; 
x_60 = 0;
return x_60;
}
}
case 14:
{
if (lean_obj_tag(x_2) == 14)
{
lean_object* x_61; lean_object* x_62; 
x_61 = lean_ctor_get(x_1, 0);
x_62 = lean_ctor_get(x_2, 0);
x_1 = x_61;
x_2 = x_62;
goto _start;
}
else
{
uint8_t x_64; 
x_64 = 0;
return x_64;
}
}
case 15:
{
if (lean_obj_tag(x_2) == 15)
{
lean_object* x_65; lean_object* x_66; 
x_65 = lean_ctor_get(x_1, 0);
x_66 = lean_ctor_get(x_2, 0);
x_1 = x_65;
x_2 = x_66;
goto _start;
}
else
{
uint8_t x_68; 
x_68 = 0;
return x_68;
}
}
case 16:
{
if (lean_obj_tag(x_2) == 16)
{
uint8_t x_69; 
x_69 = 1;
return x_69;
}
else
{
uint8_t x_70; 
x_70 = 0;
return x_70;
}
}
case 17:
{
if (lean_obj_tag(x_2) == 17)
{
uint8_t x_71; 
x_71 = 1;
return x_71;
}
else
{
uint8_t x_72; 
x_72 = 0;
return x_72;
}
}
case 18:
{
if (lean_obj_tag(x_2) == 18)
{
uint8_t x_73; 
x_73 = 1;
return x_73;
}
else
{
uint8_t x_74; 
x_74 = 0;
return x_74;
}
}
case 19:
{
if (lean_obj_tag(x_2) == 19)
{
uint8_t x_75; 
x_75 = 1;
return x_75;
}
else
{
uint8_t x_76; 
x_76 = 0;
return x_76;
}
}
case 20:
{
if (lean_obj_tag(x_2) == 20)
{
lean_object* x_77; lean_object* x_78; 
x_77 = lean_ctor_get(x_1, 0);
x_78 = lean_ctor_get(x_2, 0);
x_1 = x_77;
x_2 = x_78;
goto _start;
}
else
{
uint8_t x_80; 
x_80 = 0;
return x_80;
}
}
default: 
{
if (lean_obj_tag(x_2) == 21)
{
lean_object* x_81; lean_object* x_82; 
x_81 = lean_ctor_get(x_1, 0);
x_82 = lean_ctor_get(x_2, 0);
x_1 = x_81;
x_2 = x_82;
goto _start;
}
else
{
uint8_t x_84; 
x_84 = 0;
return x_84;
}
}
}
}
}
LEAN_EXPORT lean_object* l_RIINA_ty__eqb___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_RIINA_ty__eqb(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7, lean_object* x_8, lean_object* x_9, lean_object* x_10, lean_object* x_11, lean_object* x_12, lean_object* x_13, lean_object* x_14, lean_object* x_15, lean_object* x_16, lean_object* x_17) {
_start:
{
switch (lean_obj_tag(x_1)) {
case 5:
{
lean_object* x_18; lean_object* x_19; uint8_t x_20; lean_object* x_21; lean_object* x_22; 
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
x_18 = lean_ctor_get(x_1, 0);
lean_inc(x_18);
x_19 = lean_ctor_get(x_1, 1);
lean_inc(x_19);
x_20 = lean_ctor_get_uint8(x_1, sizeof(void*)*2);
lean_dec(x_1);
x_21 = lean_box(x_20);
x_22 = lean_apply_3(x_2, x_18, x_19, x_21);
return x_22;
}
case 6:
{
lean_object* x_23; lean_object* x_24; lean_object* x_25; 
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
lean_dec(x_2);
x_23 = lean_ctor_get(x_1, 0);
lean_inc(x_23);
x_24 = lean_ctor_get(x_1, 1);
lean_inc(x_24);
lean_dec(x_1);
x_25 = lean_apply_2(x_5, x_23, x_24);
return x_25;
}
case 7:
{
lean_object* x_26; lean_object* x_27; lean_object* x_28; 
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
lean_dec(x_2);
x_26 = lean_ctor_get(x_1, 0);
lean_inc(x_26);
x_27 = lean_ctor_get(x_1, 1);
lean_inc(x_27);
lean_dec(x_1);
x_28 = lean_apply_2(x_6, x_26, x_27);
return x_28;
}
case 8:
{
lean_object* x_29; lean_object* x_30; 
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
lean_dec(x_2);
x_29 = lean_ctor_get(x_1, 0);
lean_inc(x_29);
lean_dec(x_1);
x_30 = lean_apply_1(x_7, x_29);
return x_30;
}
case 9:
{
lean_object* x_31; lean_object* x_32; 
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
lean_dec(x_2);
x_31 = lean_ctor_get(x_1, 0);
lean_inc(x_31);
lean_dec(x_1);
x_32 = lean_apply_1(x_8, x_31);
return x_32;
}
case 10:
{
lean_object* x_33; uint8_t x_34; lean_object* x_35; lean_object* x_36; 
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
lean_dec(x_2);
x_33 = lean_ctor_get(x_1, 0);
lean_inc(x_33);
x_34 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
lean_dec(x_1);
x_35 = lean_box(x_34);
x_36 = lean_apply_2(x_9, x_33, x_35);
return x_36;
}
case 11:
{
lean_object* x_37; lean_object* x_38; 
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
lean_dec(x_2);
x_37 = lean_ctor_get(x_1, 0);
lean_inc(x_37);
lean_dec(x_1);
x_38 = lean_apply_1(x_10, x_37);
return x_38;
}
case 12:
{
lean_object* x_39; uint8_t x_40; lean_object* x_41; lean_object* x_42; 
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
lean_dec(x_2);
x_39 = lean_ctor_get(x_1, 0);
lean_inc(x_39);
x_40 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
lean_dec(x_1);
x_41 = lean_box(x_40);
x_42 = lean_apply_2(x_11, x_39, x_41);
return x_42;
}
case 13:
{
lean_object* x_43; uint8_t x_44; lean_object* x_45; lean_object* x_46; 
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
lean_dec(x_2);
x_43 = lean_ctor_get(x_1, 0);
lean_inc(x_43);
x_44 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
lean_dec(x_1);
x_45 = lean_box(x_44);
x_46 = lean_apply_2(x_12, x_43, x_45);
return x_46;
}
case 14:
{
lean_object* x_47; lean_object* x_48; lean_object* x_49; 
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
lean_dec(x_2);
x_47 = lean_ctor_get(x_1, 0);
lean_inc(x_47);
x_48 = lean_ctor_get(x_1, 1);
lean_inc(x_48);
lean_dec(x_1);
x_49 = lean_apply_2(x_13, x_47, x_48);
return x_49;
}
case 15:
{
lean_object* x_50; lean_object* x_51; 
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
lean_dec(x_2);
x_50 = lean_ctor_get(x_1, 0);
lean_inc(x_50);
lean_dec(x_1);
x_51 = lean_apply_1(x_14, x_50);
return x_51;
}
case 18:
{
lean_object* x_52; lean_object* x_53; 
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
lean_dec(x_2);
x_52 = lean_ctor_get(x_1, 0);
lean_inc(x_52);
lean_dec(x_1);
x_53 = lean_apply_1(x_3, x_52);
return x_53;
}
case 19:
{
lean_object* x_54; uint8_t x_55; lean_object* x_56; lean_object* x_57; 
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
lean_dec(x_2);
x_54 = lean_ctor_get(x_1, 0);
lean_inc(x_54);
x_55 = lean_ctor_get_uint8(x_1, sizeof(void*)*1);
lean_dec(x_1);
x_56 = lean_box(x_55);
x_57 = lean_apply_2(x_4, x_54, x_56);
return x_57;
}
case 20:
{
lean_object* x_58; lean_object* x_59; 
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
lean_dec(x_2);
x_58 = lean_ctor_get(x_1, 0);
lean_inc(x_58);
lean_dec(x_1);
x_59 = lean_apply_1(x_15, x_58);
return x_59;
}
case 21:
{
lean_object* x_60; lean_object* x_61; 
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
lean_dec(x_2);
x_60 = lean_ctor_get(x_1, 0);
lean_inc(x_60);
lean_dec(x_1);
x_61 = lean_apply_1(x_16, x_60);
return x_61;
}
default: 
{
lean_object* x_62; 
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
x_62 = lean_apply_16(x_17, x_1, lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0));
return x_62;
}
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter___rarg___boxed), 17, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter___rarg___boxed(lean_object** _args) {
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
_start:
{
lean_object* x_18; 
x_18 = l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_first__order__type_match__1_splitter___rarg(x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15, x_16, x_17);
return x_18;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7, lean_object* x_8, lean_object* x_9) {
_start:
{
switch (lean_obj_tag(x_1)) {
case 0:
{
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_inc(x_2);
return x_2;
}
case 1:
{
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_inc(x_3);
return x_3;
}
case 2:
{
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_inc(x_4);
return x_4;
}
case 3:
{
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_inc(x_5);
return x_5;
}
case 4:
{
lean_dec(x_9);
lean_dec(x_8);
lean_dec(x_7);
lean_inc(x_6);
return x_6;
}
case 16:
{
uint8_t x_10; lean_object* x_11; lean_object* x_12; 
lean_dec(x_9);
lean_dec(x_8);
x_10 = lean_ctor_get_uint8(x_1, 0);
lean_dec(x_1);
x_11 = lean_box(x_10);
x_12 = lean_apply_1(x_7, x_11);
return x_12;
}
case 17:
{
lean_object* x_13; lean_object* x_14; 
lean_dec(x_9);
lean_dec(x_7);
x_13 = lean_ctor_get(x_1, 0);
lean_inc(x_13);
lean_dec(x_1);
x_14 = lean_apply_1(x_8, x_13);
return x_14;
}
default: 
{
lean_object* x_15; 
lean_dec(x_8);
lean_dec(x_7);
x_15 = lean_apply_8(x_9, x_1, lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0), lean_box(0));
return x_15;
}
}
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter___rarg___boxed), 9, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6, lean_object* x_7, lean_object* x_8, lean_object* x_9) {
_start:
{
lean_object* x_10; 
x_10 = l___private_RIINA_Properties_FirstOrderComplete_0__RIINA_is__base__type_match__1_splitter___rarg(x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
lean_dec(x_2);
return x_10;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Syntax(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Foundations_Semantics(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_TypeSystem_Typing(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Properties_FirstOrderComplete(uint8_t builtin, lean_object* w) {
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
