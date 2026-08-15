# RIINA Standard Library — Builtin API Reference

> **Generated — do not edit by hand.** This file is produced from the compiler's own builtin registry (`register_builtin_types` in `03_PROTO/crates/riina-typechecker/src/lib.rs`) and the compiled-backend boundary (`riina_codegen::codegen_supports_builtin`) by the test `03_PROTO/crates/riina-typechecker/tests/stdlib_doc.rs`, so it cannot drift from what `riinac` actually accepts or compiles. Regenerate with `REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc`.

Total registered builtins: **373**. Grouped by the effect each performs (`kesan` in a function signature). Types are shown in RIINA surface form (`Teks` = string, `Nombor` = integer, `Tercemar`/`Tainted`, `Rahsia`/`Secret`, …).

## ⚠ Read first: type-checking does not imply compiling

Every builtin below type-checks and runs under `riinac run` (the interpreter). Only **188** of the 373 also compile, and they do NOT all reach the same backends:

| Backend value | Meaning |
|---|---|
| `compiled` | Lowers to C **and** WASM (20 builtins). |
| `native-only` | Lowers to C. The WASM backend **refuses** it (168 builtins). |
| `interp-only` | `riinac run` only (185 builtins). `riinac build` fails with `unbound variable`. |

```
$ riinac check pelayan.rii     # Success!  Effect: Network
$ riinac run   pelayan.rii     # works — serves a real HTTP/1.1 200
$ riinac build pelayan.rii     # Codegen Error: unbound variable: jaring_dengar
```

Both refusals are deliberate: a backend that cannot implement a builtin fails closed rather than miscompiling it. Until 2026-08-11 the WASM backend did NOT do this — it emitted a silent stub, so `teks_huruf_besar("halo")` returned `halo` and `panjang("abcd")` returned `abcd`, while the interpreter and C both gave the right answer (master plan REQ-78).

In practice: the WASM surface is printing, string concatenation, `ke_teks` and the numeric-tower constructors. The wider C surface adds strings, lists, maps, sets, math, conversions and test assertions. **Networking, filesystem, VFS, JSON, time, the durable store and the security/taint sinks are interpreter-only** — closing that is master plan REQ-70.

*Scope note:* this lists the language builtins the typechecker installs. Crypto primitives in `05_TOOLING/crates/riina-core` (AES, SHA-2/3, HMAC/HKDF, X25519, Ed25519, ML-KEM/ML-DSA) are documented with their KAT vectors in that crate, not here.

## Bersih (Pure)

> **Mixed:** 154 of 229 compile; the rest are interpreter-only (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `abs` | `Fn(Nombor, Nombor)` | **native-only** |
| `adalah_kanan` | `Fn(Any, Benar)` | **interp-only** |
| `adalah_keliru` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `adalah_kiri` | `Fn(Any, Benar)` | **interp-only** |
| `assert` | `Fn(Benar, ())` | **native-only** |
| `assert_eq` | `Fn((Any, Any), ())` | **native-only** |
| `assert_false` | `Fn(Benar, ())` | **native-only** |
| `assert_ne` | `Fn((Any, Any), ())` | **native-only** |
| `assert_true` | `Fn(Benar, ())` | **native-only** |
| `baki` | `Fn(Nombor, Nombor)` | **interp-only** |
| `besar` | `Fn(Teks, Besar)` | compiled |
| `bigint` | `Fn(Teks, Besar)` | compiled |
| `binary_fixed` | `Fn((Teks, Nombor), Qmn)` | compiled |
| `bool_ke_nombor` | `Fn(Benar, Nombor)` | **native-only** |
| `bool_to_int` | `Fn(Benar, Nombor)` | **native-only** |
| `buang_null` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `concat` | `Fn((Teks, Teks), Teks)` | compiled |
| `csrf_check_origin` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `csrf_check_referer` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `csrf_sahkan` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `csrf_semak_origin` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `csrf_semak_referer` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `csrf_validate` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `decimal` | `Fn(Teks, Perpuluhan)` | compiled |
| `deserialize_safe` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `email_set_header` | `Fn((Teks, Disanitasi<Teks, EmailValidation>), ())` | **interp-only** |
| `emel_tetap_kepala` | `Fn((Teks, Disanitasi<Teks, EmailValidation>), ())` | **interp-only** |
| `fixed` | `Fn((Teks, Nombor), Wang)` | compiled |
| `gabung_teks` | `Fn((Teks, Teks), Teks)` | compiled |
| `gcd` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `html_papar` | `Fn(Disanitasi<Teks, HtmlEscape>, Teks)` | **interp-only** |
| `html_render` | `Fn(Disanitasi<Teks, HtmlEscape>, Teks)` | **interp-only** |
| `http_balas` | `Fn((Nombor, Teks), Teks)` | **interp-only** |
| `http_build_response` | `Fn((Nombor, Teks), Teks)` | **interp-only** |
| `http_hurai_jasad` | `Fn(Teks, Teks)` | **interp-only** |
| `http_hurai_kaedah` | `Fn(Teks, Teks)` | **interp-only** |
| `http_hurai_kepala` | `Fn((Teks, Teks), Teks)` | **interp-only** |
| `http_hurai_laluan` | `Fn(Teks, Teks)` | **interp-only** |
| `http_parse_body` | `Fn(Teks, Teks)` | **interp-only** |
| `http_parse_header` | `Fn((Teks, Teks), Teks)` | **interp-only** |
| `http_parse_method` | `Fn(Teks, Teks)` | **interp-only** |
| `http_parse_target` | `Fn(Teks, Teks)` | **interp-only** |
| `int_to_string` | `Fn(Nombor, Teks)` | compiled |
| `is_confusable` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `json_ada` | `Fn(Any, Any)` | **native-only** |
| `json_dapat` | `Fn(Any, Any)` | **native-only** |
| `json_get` | `Fn(Any, Any)` | **native-only** |
| `json_has` | `Fn(Any, Any)` | **native-only** |
| `json_ke_teks` | `Fn(Any, Any)` | **native-only** |
| `json_letak` | `Fn(Any, Any)` | **native-only** |
| `json_parse` | `Fn(Any, Any)` | **native-only** |
| `json_parse_safe` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `json_set` | `Fn(Any, Any)` | **native-only** |
| `json_stringify` | `Fn(Any, Any)` | **native-only** |
| `json_urai` | `Fn(Any, Any)` | **native-only** |
| `json_urai_selamat` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `julat` | `Fn((Nombor, Nombor), Senarai<Nombor>)` | **interp-only** |
| `julat_inklusif` | `Fn((Nombor, Nombor), Senarai<Nombor>)` | **interp-only** |
| `ke_bool` | `Fn(Any, Benar)` | **native-only** |
| `ke_nfc` | `Fn(Teks, Teks)` | **interp-only** |
| `ke_nombor` | `Fn(Teks, Nombor)` | **native-only** |
| `ke_teks` | `Fn(Any, Teks)` | compiled |
| `kuasa` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `lcm` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `length` | `Fn(Teks, Nombor)` | **native-only** |
| `list_concat` | `Fn(Any, Any)` | **native-only** |
| `list_contains` | `Fn(Any, Any)` | **native-only** |
| `list_enumerate` | `Fn(Any, Any)` | **native-only** |
| `list_filter` | `Fn(Any, Any)` | **native-only** |
| `list_flatten` | `Fn(Any, Any)` | **native-only** |
| `list_fold` | `Fn(Any, Any)` | **native-only** |
| `list_get` | `Fn(Any, Any)` | **native-only** |
| `list_head` | `Fn(Any, Any)` | **native-only** |
| `list_len` | `Fn(Any, Any)` | **native-only** |
| `list_map` | `Fn(Any, Any)` | **native-only** |
| `list_new` | `Fn(Any, Any)` | **native-only** |
| `list_push` | `Fn(Any, Any)` | **native-only** |
| `list_reverse` | `Fn(Any, Any)` | **native-only** |
| `list_slice` | `Fn(Any, Any)` | **native-only** |
| `list_sort` | `Fn(Any, Any)` | **native-only** |
| `list_tail` | `Fn(Any, Any)` | **native-only** |
| `list_unique` | `Fn(Any, Any)` | **native-only** |
| `list_zip` | `Fn(Any, Any)` | **native-only** |
| `log2` | `Fn(Nombor, Nombor)` | **interp-only** |
| `maksimum` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `map_contains` | `Fn(Any, Any)` | **native-only** |
| `map_get` | `Fn(Any, Any)` | **native-only** |
| `map_insert` | `Fn(Any, Any)` | **native-only** |
| `map_keys` | `Fn(Any, Any)` | **native-only** |
| `map_len` | `Fn(Any, Any)` | **native-only** |
| `map_new` | `Fn(Any, Any)` | **native-only** |
| `map_remove` | `Fn(Any, Any)` | **native-only** |
| `map_values` | `Fn(Any, Any)` | **native-only** |
| `max` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `min` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `minimum` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `money` | `Fn(Teks, Wang)` | compiled |
| `mutlak` | `Fn(Nombor, Nombor)` | **native-only** |
| `nfc` | `Fn(Teks, Teks)` | **interp-only** |
| `nilai_kanan` | `Fn(Any, Any)` | **interp-only** |
| `nilai_kiri` | `Fn(Any, Any)` | **interp-only** |
| `nombor_ke_teks` | `Fn(Nombor, Teks)` | compiled |
| `normal_unicode` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `normalize_unicode` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `nyahsiri_selamat` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `panjang` | `Fn(Teks, Nombor)` | **native-only** |
| `parse_int` | `Fn(Teks, Nombor)` | **native-only** |
| `perpuluhan` | `Fn(Teks, Perpuluhan)` | compiled |
| `peta_baru` | `Fn(Any, Any)` | **native-only** |
| `peta_buang` | `Fn(Any, Any)` | **native-only** |
| `peta_dapat` | `Fn(Any, Any)` | **native-only** |
| `peta_kunci` | `Fn(Any, Any)` | **native-only** |
| `peta_letak` | `Fn(Any, Any)` | **native-only** |
| `peta_mengandungi` | `Fn(Any, Any)` | **native-only** |
| `peta_nilai` | `Fn(Any, Any)` | **native-only** |
| `peta_panjang` | `Fn(Any, Any)` | **native-only** |
| `pow` | `Fn((Nombor, Nombor), Nombor)` | **native-only** |
| `punca` | `Fn(Nombor, Nombor)` | **native-only** |
| `qmn` | `Fn((Teks, Nombor), Qmn)` | compiled |
| `rangka` | `Fn(Teks, Teks)` | **interp-only** |
| `rem` | `Fn(Nombor, Nombor)` | **interp-only** |
| `sahkan_panjang` | `Fn((Tercemar<Teks, UserInput>, Nombor), Mungkin<Tercemar<Teks, UserInput>>)` | **interp-only** |
| `sahkan_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlAllowlist>)` | **interp-only** |
| `sanitasi_css` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CssEscape>)` | **interp-only** |
| `sanitasi_emel` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, EmailValidation>)` | **interp-only** |
| `sanitasi_html` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, HtmlEscape>)` | **interp-only** |
| `sanitasi_js` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsEscape>)` | **interp-only** |
| `sanitasi_json` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsonValidation>)` | **interp-only** |
| `sanitasi_laluan` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, PathTraversal>)` | **interp-only** |
| `sanitasi_ldap` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, LdapEscape>)` | **interp-only** |
| `sanitasi_perintah` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CommandEscape>)` | **interp-only** |
| `sanitasi_sql` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, SqlParam>)` | **interp-only** |
| `sanitasi_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlEncode>)` | **interp-only** |
| `sanitasi_xml` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, XmlEscape>)` | **interp-only** |
| `sanitize_command` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CommandEscape>)` | **interp-only** |
| `sanitize_css` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CssEscape>)` | **interp-only** |
| `sanitize_email` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, EmailValidation>)` | **interp-only** |
| `sanitize_html` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, HtmlEscape>)` | **interp-only** |
| `sanitize_js` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsEscape>)` | **interp-only** |
| `sanitize_json` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsonValidation>)` | **interp-only** |
| `sanitize_ldap` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, LdapEscape>)` | **interp-only** |
| `sanitize_path` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, PathTraversal>)` | **interp-only** |
| `sanitize_sql` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, SqlParam>)` | **interp-only** |
| `sanitize_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlEncode>)` | **interp-only** |
| `sanitize_xml` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, XmlEscape>)` | **interp-only** |
| `senarai_balik` | `Fn(Any, Any)` | **native-only** |
| `senarai_baru` | `Fn(Any, Any)` | **native-only** |
| `senarai_dapat` | `Fn(Any, Any)` | **native-only** |
| `senarai_ekor` | `Fn(Any, Any)` | **native-only** |
| `senarai_kepala` | `Fn(Any, Any)` | **native-only** |
| `senarai_lipat` | `Fn(Any, Any)` | **native-only** |
| `senarai_mengandungi` | `Fn(Any, Any)` | **native-only** |
| `senarai_nombor` | `Fn(Any, Any)` | **native-only** |
| `senarai_panjang` | `Fn(Any, Any)` | **native-only** |
| `senarai_peta` | `Fn(Any, Any)` | **native-only** |
| `senarai_potong` | `Fn(Any, Any)` | **native-only** |
| `senarai_rata` | `Fn(Any, Any)` | **native-only** |
| `senarai_sambung` | `Fn(Any, Any)` | **native-only** |
| `senarai_susun` | `Fn(Any, Any)` | **native-only** |
| `senarai_tapis` | `Fn(Any, Any)` | **native-only** |
| `senarai_tolak` | `Fn(Any, Any)` | **native-only** |
| `senarai_unik` | `Fn(Any, Any)` | **native-only** |
| `senarai_zip` | `Fn(Any, Any)` | **native-only** |
| `set_baru` | `Fn(Any, Any)` | **native-only** |
| `set_buang` | `Fn(Any, Any)` | **native-only** |
| `set_contains` | `Fn(Any, Any)` | **native-only** |
| `set_insert` | `Fn(Any, Any)` | **native-only** |
| `set_intersect` | `Fn(Any, Any)` | **native-only** |
| `set_kesatuan` | `Fn(Any, Any)` | **native-only** |
| `set_len` | `Fn(Any, Any)` | **native-only** |
| `set_letak` | `Fn(Any, Any)` | **native-only** |
| `set_mengandungi` | `Fn(Any, Any)` | **native-only** |
| `set_new` | `Fn(Any, Any)` | **native-only** |
| `set_panjang` | `Fn(Any, Any)` | **native-only** |
| `set_persilangan` | `Fn(Any, Any)` | **native-only** |
| `set_remove` | `Fn(Any, Any)` | **native-only** |
| `set_union` | `Fn(Any, Any)` | **native-only** |
| `skeleton` | `Fn(Teks, Teks)` | **interp-only** |
| `sqrt` | `Fn(Nombor, Nombor)` | **native-only** |
| `str_char_at` | `Fn(Any, Any)` | **native-only** |
| `str_contains` | `Fn(Any, Any)` | **native-only** |
| `str_ends_with` | `Fn(Any, Any)` | **native-only** |
| `str_index_of` | `Fn(Any, Any)` | **native-only** |
| `str_join` | `Fn(Any, Any)` | **native-only** |
| `str_lines` | `Fn(Any, Any)` | **native-only** |
| `str_pad_left` | `Fn(Any, Any)` | **native-only** |
| `str_pad_right` | `Fn(Any, Any)` | **native-only** |
| `str_repeat` | `Fn(Any, Any)` | **native-only** |
| `str_replace` | `Fn(Any, Any)` | **native-only** |
| `str_split` | `Fn(Any, Any)` | **native-only** |
| `str_starts_with` | `Fn(Any, Any)` | **native-only** |
| `str_substring` | `Fn(Any, Any)` | **native-only** |
| `str_to_lower` | `Fn(Any, Any)` | **native-only** |
| `str_to_upper` | `Fn(Any, Any)` | **native-only** |
| `str_trim` | `Fn(Any, Any)` | **native-only** |
| `strip_nulls` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `tegaskan` | `Fn(Benar, ())` | **native-only** |
| `tegaskan_betul` | `Fn(Benar, ())` | **native-only** |
| `tegaskan_beza` | `Fn((Any, Any), ())` | **native-only** |
| `tegaskan_salah` | `Fn(Benar, ())` | **native-only** |
| `tegaskan_sama` | `Fn((Any, Any), ())` | **native-only** |
| `teks_akhir_dengan` | `Fn(Any, Any)` | **native-only** |
| `teks_aksara_di` | `Fn(Any, Any)` | **native-only** |
| `teks_baris` | `Fn(Any, Any)` | **native-only** |
| `teks_belah` | `Fn(Any, Any)` | **native-only** |
| `teks_cantum` | `Fn(Any, Any)` | **native-only** |
| `teks_ganti` | `Fn(Any, Any)` | **native-only** |
| `teks_huruf_besar` | `Fn(Any, Any)` | **native-only** |
| `teks_huruf_kecil` | `Fn(Any, Any)` | **native-only** |
| `teks_indeks` | `Fn(Any, Any)` | **native-only** |
| `teks_mengandungi` | `Fn(Any, Any)` | **native-only** |
| `teks_mula_dengan` | `Fn(Any, Any)` | **native-only** |
| `teks_pad_kanan` | `Fn(Any, Any)` | **native-only** |
| `teks_pad_kiri` | `Fn(Any, Any)` | **native-only** |
| `teks_potong` | `Fn(Any, Any)` | **native-only** |
| `teks_sub` | `Fn(Any, Any)` | **native-only** |
| `teks_ulang` | `Fn(Any, Any)` | **native-only** |
| `titik_tetap` | `Fn((Teks, Nombor), Wang)` | compiled |
| `tls_dasar_ok` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `tls_policy_ok` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `to_bool` | `Fn(Any, Benar)` | **native-only** |
| `to_string` | `Fn(Any, Teks)` | compiled |
| `validate_length` | `Fn((Tercemar<Teks, UserInput>, Nombor), Mungkin<Tercemar<Teks, UserInput>>)` | **interp-only** |
| `validate_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlAllowlist>)` | **interp-only** |
| `wang` | `Fn(Teks, Wang)` | compiled |
| `xml_cari` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` | **interp-only** |
| `xml_parse_safe` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` | **interp-only** |
| `xml_query` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` | **interp-only** |
| `xml_urai_selamat` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` | **interp-only** |

## Baca (Read)

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `fail_baca_selamat` | `Fn(Disanitasi<Teks, PathTraversal>, Any, Baca)` | **interp-only** |
| `file_read_safe` | `Fn(Disanitasi<Teks, PathTraversal>, Any, Baca)` | **interp-only** |
| `vfs_baca` | `Fn(Teks, Teks, Baca)` | **interp-only** |
| `vfs_read` | `Fn(Teks, Teks, Baca)` | **interp-only** |

## Tulis (Write)

> **Mixed:** 4 of 13 compile; the rest are interpreter-only (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `cetak` | `Fn(Any, (), Tulis)` | compiled |
| `cetak_baris` | `Fn(Any, (), Tulis)` | **interp-only** |
| `cetakln` | `Fn(Any, (), Tulis)` | compiled |
| `fail_buang_selamat` | `Fn(Disanitasi<Teks, PathTraversal>, Benar, Tulis)` | **interp-only** |
| `fail_tulis_selamat` | `Fn((Disanitasi<Teks, PathTraversal>, Any), (), Tulis)` | **interp-only** |
| `file_delete_safe` | `Fn(Disanitasi<Teks, PathTraversal>, Benar, Tulis)` | **interp-only** |
| `file_write_safe` | `Fn((Disanitasi<Teks, PathTraversal>, Any), (), Tulis)` | **interp-only** |
| `print` | `Fn(Any, (), Tulis)` | compiled |
| `println` | `Fn(Any, (), Tulis)` | compiled |
| `vfs_delete` | `Fn(Teks, Benar, Tulis)` | **interp-only** |
| `vfs_padam` | `Fn(Teks, Benar, Tulis)` | **interp-only** |
| `vfs_tulis` | `Fn((Teks, Teks), (), Tulis)` | **interp-only** |
| `vfs_write` | `Fn((Teks, Teks), (), Tulis)` | **interp-only** |

## SistemFail (FileSystem)

> **Mixed:** 16 of 36 compile; the rest are interpreter-only (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `fail_ada` | `Fn(Teks, Benar, SistemFail)` | **interp-only** |
| `fail_baca` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` | **interp-only** |
| `fail_baca_baris` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` | **interp-only** |
| `fail_buang` | `Fn(Teks, (), SistemFail)` | **interp-only** |
| `fail_panjang` | `Fn(Teks, Nombor, SistemFail)` | **interp-only** |
| `fail_senarai` | `Fn(Teks, Any, SistemFail)` | **interp-only** |
| `fail_tambah` | `Fn((Teks, Teks), (), SistemFail)` | **interp-only** |
| `fail_tulis` | `Fn((Teks, Teks), (), SistemFail)` | **interp-only** |
| `file_append` | `Fn((Teks, Teks), (), SistemFail)` | **interp-only** |
| `file_delete` | `Fn(Teks, (), SistemFail)` | **interp-only** |
| `file_exists` | `Fn(Teks, Benar, SistemFail)` | **interp-only** |
| `file_list_dir` | `Fn(Teks, Any, SistemFail)` | **interp-only** |
| `file_read` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` | **interp-only** |
| `file_read_lines` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` | **interp-only** |
| `file_size` | `Fn(Teks, Nombor, SistemFail)` | **interp-only** |
| `file_write` | `Fn((Teks, Teks), (), SistemFail)` | **interp-only** |
| `simpan_ada` | `Fn((Nombor, Teks), Benar, SistemFail)` | **native-only** |
| `simpan_buka` | `Fn(Teks, Nombor, SistemFail)` | **native-only** |
| `simpan_dapat` | `Fn((Nombor, Teks), Teks, SistemFail)` | **native-only** |
| `simpan_kunci` | `Fn(Nombor, Senarai<Teks>, SistemFail)` | **native-only** |
| `simpan_letak` | `Fn((Nombor, (Teks, Teks)), Benar, SistemFail)` | **native-only** |
| `simpan_padam` | `Fn((Nombor, Teks), Benar, SistemFail)` | **native-only** |
| `simpan_padat` | `Fn(Nombor, Benar, SistemFail)` | **native-only** |
| `simpan_tutup` | `Fn(Nombor, Benar, SistemFail)` | **native-only** |
| `store_close` | `Fn(Nombor, Benar, SistemFail)` | **native-only** |
| `store_compact` | `Fn(Nombor, Benar, SistemFail)` | **native-only** |
| `store_delete` | `Fn((Nombor, Teks), Benar, SistemFail)` | **native-only** |
| `store_get` | `Fn((Nombor, Teks), Teks, SistemFail)` | **native-only** |
| `store_has` | `Fn((Nombor, Teks), Benar, SistemFail)` | **native-only** |
| `store_keys` | `Fn(Nombor, Senarai<Teks>, SistemFail)` | **native-only** |
| `store_open` | `Fn(Teks, Nombor, SistemFail)` | **native-only** |
| `store_put` | `Fn((Nombor, (Teks, Teks)), Benar, SistemFail)` | **native-only** |
| `vfs_become_user` | `Fn(Nombor, (), SistemFail)` | **interp-only** |
| `vfs_init` | `Fn(Nombor, (), SistemFail)` | **interp-only** |
| `vfs_jadi_pengguna` | `Fn(Nombor, (), SistemFail)` | **interp-only** |
| `vfs_mula` | `Fn(Nombor, (), SistemFail)` | **interp-only** |

## Rangkaian (Network)

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `badan_http` | `Fn(Any, Tercemar<Teks, NetworkExternal>, Rangkaian)` | **interp-only** |
| `email_send` | `Fn((Disanitasi<Teks, EmailValidation>, Teks), Benar, Rangkaian)` | **interp-only** |
| `emel_hantar` | `Fn((Disanitasi<Teks, EmailValidation>, Teks), Benar, Rangkaian)` | **interp-only** |
| `http_ambil_selamat` | `Fn(Disanitasi<Teks, UrlAllowlist>, Any, Rangkaian)` | **interp-only** |
| `http_arah_selamat` | `Fn(Disanitasi<Teks, UrlAllowlist>, (), Rangkaian)` | **interp-only** |
| `http_body` | `Fn(Any, Tercemar<Teks, NetworkExternal>, Rangkaian)` | **interp-only** |
| `http_dapat` | `Fn(Teks, Any, Rangkaian)` | **interp-only** |
| `http_delete` | `Fn((Teks, Teks), Any, Rangkaian)` | **interp-only** |
| `http_fetch_safe` | `Fn(Disanitasi<Teks, UrlAllowlist>, Any, Rangkaian)` | **interp-only** |
| `http_get` | `Fn(Teks, Any, Rangkaian)` | **interp-only** |
| `http_hantar` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` | **interp-only** |
| `http_kemaskini` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` | **interp-only** |
| `http_minta` | `Fn((Teks, Teks), Teks, Rangkaian)` | **interp-only** |
| `http_padam` | `Fn((Teks, Teks), Any, Rangkaian)` | **interp-only** |
| `http_post` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` | **interp-only** |
| `http_put` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` | **interp-only** |
| `http_redirect_safe` | `Fn(Disanitasi<Teks, UrlAllowlist>, (), Rangkaian)` | **interp-only** |
| `http_request` | `Fn((Teks, Teks), Teks, Rangkaian)` | **interp-only** |
| `jaring_alamat` | `Fn(Nombor, Teks, Rangkaian)` | **interp-only** |
| `jaring_dengar` | `Fn(Teks, Nombor, Rangkaian)` | **interp-only** |
| `jaring_hantar` | `Fn((Nombor, Teks), Nombor, Rangkaian)` | **interp-only** |
| `jaring_sambung` | `Fn(Teks, Nombor, Rangkaian)` | **interp-only** |
| `jaring_terima` | `Fn((Nombor, Nombor), Teks, Rangkaian)` | **interp-only** |
| `jaring_terima_sambungan` | `Fn(Nombor, Nombor, Rangkaian)` | **interp-only** |
| `jaring_tutup` | `Fn(Nombor, Benar, Rangkaian)` | **interp-only** |
| `jaring_tutup_dengar` | `Fn(Nombor, Benar, Rangkaian)` | **interp-only** |
| `net_accept` | `Fn(Nombor, Nombor, Rangkaian)` | **interp-only** |
| `net_close` | `Fn(Nombor, Benar, Rangkaian)` | **interp-only** |
| `net_close_listener` | `Fn(Nombor, Benar, Rangkaian)` | **interp-only** |
| `net_connect` | `Fn(Teks, Nombor, Rangkaian)` | **interp-only** |
| `net_listen` | `Fn(Teks, Nombor, Rangkaian)` | **interp-only** |
| `net_local_addr` | `Fn(Nombor, Teks, Rangkaian)` | **interp-only** |
| `net_recv` | `Fn((Nombor, Nombor), Teks, Rangkaian)` | **interp-only** |
| `net_send` | `Fn((Nombor, Teks), Nombor, Rangkaian)` | **interp-only** |

## RangkaianSelamat (NetworkSecure)

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `jaring_tls_disahkan` | `Fn(Nombor, Benar, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_hantar` | `Fn((Nombor, Teks), Nombor, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_identiti` | `Fn(Teks, Teks, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_jabat` | `Fn(Nombor, Benar, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_jabat_sah` | `Fn(Nombor, Benar, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_kunci` | `Fn((Nombor, Teks), Benar, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_percaya` | `Fn(Teks, Benar, RangkaianSelamat)` | **interp-only** |
| `jaring_tls_terima` | `Fn(Nombor, Teks, RangkaianSelamat)` | **interp-only** |
| `net_tls_handshake` | `Fn(Nombor, Benar, RangkaianSelamat)` | **interp-only** |
| `net_tls_handshake_auth` | `Fn(Nombor, Benar, RangkaianSelamat)` | **interp-only** |
| `net_tls_identity` | `Fn(Teks, Teks, RangkaianSelamat)` | **interp-only** |
| `net_tls_is_authenticated` | `Fn(Nombor, Benar, RangkaianSelamat)` | **interp-only** |
| `net_tls_keys` | `Fn((Nombor, Teks), Benar, RangkaianSelamat)` | **interp-only** |
| `net_tls_recv` | `Fn(Nombor, Teks, RangkaianSelamat)` | **interp-only** |
| `net_tls_send` | `Fn((Nombor, Teks), Nombor, RangkaianSelamat)` | **interp-only** |
| `net_tls_trust` | `Fn(Teks, Benar, RangkaianSelamat)` | **interp-only** |

## Kripto (Crypto)

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `cipher` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `guna_kripto` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `hash_dengan` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `hash_with` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `pilih_algo` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `select_algorithm` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `sifer` | `Fn(Teks, Any, Kripto)` | **interp-only** |
| `use_crypto` | `Fn(Teks, Any, Kripto)` | **interp-only** |

## Rawak (Random)

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `csrf_generate` | `Fn((), Teks, Rawak)` | **interp-only** |
| `csrf_jana` | `Fn((), Teks, Rawak)` | **interp-only** |
| `random` | `Fn(Nombor, Nombor, Rawak)` | **interp-only** |
| `rawak` | `Fn(Nombor, Nombor, Rawak)` | **interp-only** |

## Sistem (System)

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `baca_baris` | `Fn((), Tercemar<Teks, UserInput>, Sistem)` | **interp-only** |
| `baca_garisan` | `Fn((), Teks, Sistem)` | **interp-only** |
| `dom_set_attr` | `Fn((Any, (Teks, Disanitasi<Teks, HtmlEscape>)), (), Sistem)` | **interp-only** |
| `dom_set_html` | `Fn((Any, Disanitasi<Teks, HtmlEscape>), (), Sistem)` | **interp-only** |
| `dom_tetap_atribut` | `Fn((Any, (Teks, Disanitasi<Teks, HtmlEscape>)), (), Sistem)` | **interp-only** |
| `dom_tetap_html` | `Fn((Any, Disanitasi<Teks, HtmlEscape>), (), Sistem)` | **interp-only** |
| `js_eval` | `Fn(Disanitasi<Teks, JsEscape>, Any, Sistem)` | **interp-only** |
| `js_nilai` | `Fn(Disanitasi<Teks, JsEscape>, Any, Sistem)` | **interp-only** |
| `ldap_cari` | `Fn(Disanitasi<Teks, LdapEscape>, Any, Sistem)` | **interp-only** |
| `ldap_search` | `Fn(Disanitasi<Teks, LdapEscape>, Any, Sistem)` | **interp-only** |
| `read_line` | `Fn((), Tercemar<Teks, UserInput>, Sistem)` | **interp-only** |
| `shell_exec` | `Fn(Disanitasi<Teks, CommandEscape>, Nombor, Sistem)` | **interp-only** |
| `shell_laksana` | `Fn(Disanitasi<Teks, CommandEscape>, Nombor, Sistem)` | **interp-only** |
| `sql_execute` | `Fn(Disanitasi<Teks, SqlParam>, Any, Sistem)` | **interp-only** |
| `sql_laksana` | `Fn(Disanitasi<Teks, SqlParam>, Any, Sistem)` | **interp-only** |

## Masa (Time)

| Builtin | Type | Backend |
|---|---|---|
| `masa_format` | `Fn((Nombor, Teks), Teks, Masa)` | **native-only** |
| `masa_jam` | `Fn((), Nombor, Masa)` | **native-only** |
| `masa_sekarang` | `Fn((), Nombor, Masa)` | **native-only** |
| `masa_sekarang_ms` | `Fn((), Nombor, Masa)` | **native-only** |
| `masa_tidur` | `Fn(Nombor, (), Masa)` | **native-only** |
| `masa_unix` | `Fn((), Nombor, Masa)` | **native-only** |
| `masa_urai` | `Fn((Teks, Teks), Nombor, Masa)` | **native-only** |
| `time_clock` | `Fn((), Nombor, Masa)` | **native-only** |
| `time_format` | `Fn((Nombor, Teks), Teks, Masa)` | **native-only** |
| `time_now` | `Fn((), Nombor, Masa)` | **native-only** |
| `time_now_ms` | `Fn((), Nombor, Masa)` | **native-only** |
| `time_parse` | `Fn((Teks, Teks), Nombor, Masa)` | **native-only** |
| `time_sleep` | `Fn(Nombor, (), Masa)` | **native-only** |
| `time_unix` | `Fn((), Nombor, Masa)` | **native-only** |

