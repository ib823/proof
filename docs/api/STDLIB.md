# RIINA Standard Library — Builtin API Reference

> **Generated — do not edit by hand.** This file is produced from the compiler's own builtin registry (`register_builtin_types` in `03_PROTO/crates/riina-typechecker/src/lib.rs`) and the compiled-backend boundary (`riina_codegen::codegen_supports_builtin`) by the test `03_PROTO/crates/riina-typechecker/tests/stdlib_doc.rs`, so it cannot drift from what `riinac` actually accepts or compiles. Regenerate with `REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc`.

Total registered builtins: **329**. Grouped by the effect each performs (`kesan` in a function signature). Types are shown in RIINA surface form (`Teks` = string, `Nombor` = integer, `Tercemar`/`Tainted`, `Rahsia`/`Secret`, …).

## ⚠ Read first: type-checking does not imply compiling

Every builtin below type-checks and runs under `riinac run` (the interpreter). Only **148** of the 329 also compile; the other **181** are **interpreter-only** and make `riinac build`, `riinac emit-c`, and `riinac build --target wasm32/wasm64` **fail closed**:

```
$ riinac check pelayan.rii     # Success!  Effect: Network
$ riinac run   pelayan.rii     # works — serves a real HTTP/1.1 200
$ riinac build pelayan.rii     # Codegen Error: unbound variable: jaring_dengar
```

This is deliberate — lowering refuses to emit a builtin the C/WASM backends do not implement, rather than miscompiling it — but it means a program using ANY `interp-only` builtin has no native or WASM deployment path today. In practice the compilable surface is the pure core: printing, strings, lists, maps, sets, math, conversions, the numeric tower, and test assertions. **Networking, filesystem, VFS, JSON, time, and the security/taint sinks are all interpreter-only.**

The `Backend` column in every table below records this per builtin. Closing the gap is master plan **REQ-70** (Gate C); the exit criteria require a compiled, multi-file, networked, persistent reference service.

| Backend value | Meaning |
|---|---|
| `compiled` | Lowers to C and WASM. Safe for `riinac build`. |
| `interp-only` | `riinac run` only. `riinac build` fails with `unbound variable`. |

*Scope note:* this lists the language builtins the typechecker installs. Crypto primitives in `05_TOOLING/crates/riina-core` (AES, SHA-2/3, HMAC/HKDF, X25519, Ed25519, ML-KEM/ML-DSA) are documented with their KAT vectors in that crate, not here.

## Bersih (Pure)

> **Mixed:** 144 of 220 compile; the rest are interpreter-only (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `abs` | `Fn(Nombor, Nombor)` | compiled |
| `adalah_kanan` | `Fn(Any, Benar)` | **interp-only** |
| `adalah_keliru` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `adalah_kiri` | `Fn(Any, Benar)` | **interp-only** |
| `assert` | `Fn(Benar, ())` | compiled |
| `assert_eq` | `Fn((Any, Any), ())` | compiled |
| `assert_false` | `Fn(Benar, ())` | compiled |
| `assert_ne` | `Fn((Any, Any), ())` | compiled |
| `assert_true` | `Fn(Benar, ())` | compiled |
| `baca_garisan` | `Teks` | **interp-only** |
| `baki` | `Fn(Nombor, Nombor)` | **interp-only** |
| `besar` | `Fn(Teks, Besar)` | compiled |
| `bigint` | `Fn(Teks, Besar)` | compiled |
| `binary_fixed` | `Fn((Teks, Nombor), Qmn)` | compiled |
| `bool_ke_nombor` | `Fn(Benar, Nombor)` | compiled |
| `bool_to_int` | `Fn(Benar, Nombor)` | compiled |
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
| `gcd` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `html_papar` | `Fn(Disanitasi<Teks, HtmlEscape>, Teks)` | **interp-only** |
| `html_render` | `Fn(Disanitasi<Teks, HtmlEscape>, Teks)` | **interp-only** |
| `int_to_string` | `Fn(Nombor, Teks)` | compiled |
| `is_confusable` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `json_ada` | `Fn(Any, Any)` | **interp-only** |
| `json_dapat` | `Fn(Any, Any)` | **interp-only** |
| `json_get` | `Fn(Any, Any)` | **interp-only** |
| `json_has` | `Fn(Any, Any)` | **interp-only** |
| `json_ke_teks` | `Fn(Any, Any)` | **interp-only** |
| `json_letak` | `Fn(Any, Any)` | **interp-only** |
| `json_parse` | `Fn(Any, Any)` | **interp-only** |
| `json_parse_safe` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `json_set` | `Fn(Any, Any)` | **interp-only** |
| `json_stringify` | `Fn(Any, Any)` | **interp-only** |
| `json_urai` | `Fn(Any, Any)` | **interp-only** |
| `json_urai_selamat` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `julat` | `Fn((Nombor, Nombor), Senarai<Nombor>)` | **interp-only** |
| `julat_inklusif` | `Fn((Nombor, Nombor), Senarai<Nombor>)` | **interp-only** |
| `ke_bool` | `Fn(Any, Benar)` | compiled |
| `ke_nfc` | `Fn(Teks, Teks)` | **interp-only** |
| `ke_nombor` | `Fn(Teks, Nombor)` | compiled |
| `ke_teks` | `Fn(Any, Teks)` | compiled |
| `kuasa` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `lcm` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `length` | `Fn(Teks, Nombor)` | compiled |
| `list_concat` | `Fn(Any, Any)` | compiled |
| `list_contains` | `Fn(Any, Any)` | compiled |
| `list_enumerate` | `Fn(Any, Any)` | compiled |
| `list_filter` | `Fn(Any, Any)` | compiled |
| `list_flatten` | `Fn(Any, Any)` | compiled |
| `list_fold` | `Fn(Any, Any)` | compiled |
| `list_get` | `Fn(Any, Any)` | compiled |
| `list_head` | `Fn(Any, Any)` | compiled |
| `list_len` | `Fn(Any, Any)` | compiled |
| `list_map` | `Fn(Any, Any)` | compiled |
| `list_new` | `Fn(Any, Any)` | compiled |
| `list_push` | `Fn(Any, Any)` | compiled |
| `list_reverse` | `Fn(Any, Any)` | compiled |
| `list_slice` | `Fn(Any, Any)` | compiled |
| `list_sort` | `Fn(Any, Any)` | compiled |
| `list_tail` | `Fn(Any, Any)` | compiled |
| `list_unique` | `Fn(Any, Any)` | compiled |
| `list_zip` | `Fn(Any, Any)` | compiled |
| `log2` | `Fn(Nombor, Nombor)` | **interp-only** |
| `maksimum` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `map_contains` | `Fn(Any, Any)` | compiled |
| `map_get` | `Fn(Any, Any)` | compiled |
| `map_insert` | `Fn(Any, Any)` | compiled |
| `map_keys` | `Fn(Any, Any)` | compiled |
| `map_len` | `Fn(Any, Any)` | compiled |
| `map_new` | `Fn(Any, Any)` | compiled |
| `map_remove` | `Fn(Any, Any)` | compiled |
| `map_values` | `Fn(Any, Any)` | compiled |
| `max` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `min` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `minimum` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `money` | `Fn(Teks, Wang)` | compiled |
| `mutlak` | `Fn(Nombor, Nombor)` | compiled |
| `nfc` | `Fn(Teks, Teks)` | **interp-only** |
| `nilai_kanan` | `Fn(Any, Any)` | **interp-only** |
| `nilai_kiri` | `Fn(Any, Any)` | **interp-only** |
| `nombor_ke_teks` | `Fn(Nombor, Teks)` | compiled |
| `normal_unicode` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `normalize_unicode` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `nyahsiri_selamat` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` | **interp-only** |
| `panjang` | `Fn(Teks, Nombor)` | compiled |
| `parse_int` | `Fn(Teks, Nombor)` | compiled |
| `perpuluhan` | `Fn(Teks, Perpuluhan)` | compiled |
| `peta_baru` | `Fn(Any, Any)` | compiled |
| `peta_buang` | `Fn(Any, Any)` | compiled |
| `peta_dapat` | `Fn(Any, Any)` | compiled |
| `peta_kunci` | `Fn(Any, Any)` | compiled |
| `peta_letak` | `Fn(Any, Any)` | compiled |
| `peta_mengandungi` | `Fn(Any, Any)` | compiled |
| `peta_nilai` | `Fn(Any, Any)` | compiled |
| `peta_panjang` | `Fn(Any, Any)` | compiled |
| `pow` | `Fn((Nombor, Nombor), Nombor)` | compiled |
| `punca` | `Fn(Nombor, Nombor)` | compiled |
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
| `senarai_balik` | `Fn(Any, Any)` | compiled |
| `senarai_baru` | `Fn(Any, Any)` | compiled |
| `senarai_dapat` | `Fn(Any, Any)` | compiled |
| `senarai_ekor` | `Fn(Any, Any)` | compiled |
| `senarai_kepala` | `Fn(Any, Any)` | compiled |
| `senarai_lipat` | `Fn(Any, Any)` | compiled |
| `senarai_mengandungi` | `Fn(Any, Any)` | compiled |
| `senarai_nombor` | `Fn(Any, Any)` | compiled |
| `senarai_panjang` | `Fn(Any, Any)` | compiled |
| `senarai_peta` | `Fn(Any, Any)` | compiled |
| `senarai_potong` | `Fn(Any, Any)` | compiled |
| `senarai_rata` | `Fn(Any, Any)` | compiled |
| `senarai_sambung` | `Fn(Any, Any)` | compiled |
| `senarai_susun` | `Fn(Any, Any)` | compiled |
| `senarai_tapis` | `Fn(Any, Any)` | compiled |
| `senarai_tolak` | `Fn(Any, Any)` | compiled |
| `senarai_unik` | `Fn(Any, Any)` | compiled |
| `senarai_zip` | `Fn(Any, Any)` | compiled |
| `set_baru` | `Fn(Any, Any)` | compiled |
| `set_buang` | `Fn(Any, Any)` | compiled |
| `set_contains` | `Fn(Any, Any)` | compiled |
| `set_insert` | `Fn(Any, Any)` | compiled |
| `set_intersect` | `Fn(Any, Any)` | compiled |
| `set_kesatuan` | `Fn(Any, Any)` | compiled |
| `set_len` | `Fn(Any, Any)` | compiled |
| `set_letak` | `Fn(Any, Any)` | compiled |
| `set_mengandungi` | `Fn(Any, Any)` | compiled |
| `set_new` | `Fn(Any, Any)` | compiled |
| `set_panjang` | `Fn(Any, Any)` | compiled |
| `set_persilangan` | `Fn(Any, Any)` | compiled |
| `set_remove` | `Fn(Any, Any)` | compiled |
| `set_union` | `Fn(Any, Any)` | compiled |
| `skeleton` | `Fn(Teks, Teks)` | **interp-only** |
| `sqrt` | `Fn(Nombor, Nombor)` | compiled |
| `str_char_at` | `Fn(Any, Any)` | compiled |
| `str_contains` | `Fn(Any, Any)` | compiled |
| `str_ends_with` | `Fn(Any, Any)` | compiled |
| `str_index_of` | `Fn(Any, Any)` | compiled |
| `str_join` | `Fn(Any, Any)` | compiled |
| `str_lines` | `Fn(Any, Any)` | compiled |
| `str_pad_left` | `Fn(Any, Any)` | compiled |
| `str_pad_right` | `Fn(Any, Any)` | compiled |
| `str_repeat` | `Fn(Any, Any)` | compiled |
| `str_replace` | `Fn(Any, Any)` | compiled |
| `str_split` | `Fn(Any, Any)` | compiled |
| `str_starts_with` | `Fn(Any, Any)` | compiled |
| `str_substring` | `Fn(Any, Any)` | compiled |
| `str_to_lower` | `Fn(Any, Any)` | compiled |
| `str_to_upper` | `Fn(Any, Any)` | compiled |
| `str_trim` | `Fn(Any, Any)` | compiled |
| `strip_nulls` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` | **interp-only** |
| `tegaskan` | `Fn(Benar, ())` | compiled |
| `tegaskan_betul` | `Fn(Benar, ())` | compiled |
| `tegaskan_beza` | `Fn((Any, Any), ())` | compiled |
| `tegaskan_salah` | `Fn(Benar, ())` | compiled |
| `tegaskan_sama` | `Fn((Any, Any), ())` | compiled |
| `teks_akhir_dengan` | `Fn(Any, Any)` | compiled |
| `teks_aksara_di` | `Fn(Any, Any)` | compiled |
| `teks_baris` | `Fn(Any, Any)` | compiled |
| `teks_belah` | `Fn(Any, Any)` | compiled |
| `teks_cantum` | `Fn(Any, Any)` | compiled |
| `teks_ganti` | `Fn(Any, Any)` | compiled |
| `teks_huruf_besar` | `Fn(Any, Any)` | compiled |
| `teks_huruf_kecil` | `Fn(Any, Any)` | compiled |
| `teks_indeks` | `Fn(Any, Any)` | compiled |
| `teks_mengandungi` | `Fn(Any, Any)` | compiled |
| `teks_mula_dengan` | `Fn(Any, Any)` | compiled |
| `teks_pad_kanan` | `Fn(Any, Any)` | compiled |
| `teks_pad_kiri` | `Fn(Any, Any)` | compiled |
| `teks_potong` | `Fn(Any, Any)` | compiled |
| `teks_sub` | `Fn(Any, Any)` | compiled |
| `teks_ulang` | `Fn(Any, Any)` | compiled |
| `titik_tetap` | `Fn((Teks, Nombor), Wang)` | compiled |
| `tls_dasar_ok` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `tls_policy_ok` | `Fn((Teks, Teks), Benar)` | **interp-only** |
| `to_bool` | `Fn(Any, Benar)` | compiled |
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

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

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
| `http_padam` | `Fn((Teks, Teks), Any, Rangkaian)` | **interp-only** |
| `http_post` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` | **interp-only** |
| `http_put` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` | **interp-only** |
| `http_redirect_safe` | `Fn(Disanitasi<Teks, UrlAllowlist>, (), Rangkaian)` | **interp-only** |
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

> **Entirely interpreter-only.** No builtin in this section compiles — a program using any of them runs under `riinac run` but cannot be built for native or WASM (REQ-70).

| Builtin | Type | Backend |
|---|---|---|
| `masa_format` | `Fn((Nombor, Teks), Teks, Masa)` | **interp-only** |
| `masa_jam` | `Fn((), Nombor, Masa)` | **interp-only** |
| `masa_sekarang` | `Fn((), Nombor, Masa)` | **interp-only** |
| `masa_sekarang_ms` | `Fn((), Nombor, Masa)` | **interp-only** |
| `masa_tidur` | `Fn(Nombor, (), Masa)` | **interp-only** |
| `masa_unix` | `Fn((), Nombor, Masa)` | **interp-only** |
| `masa_urai` | `Fn((Teks, Teks), Nombor, Masa)` | **interp-only** |
| `time_clock` | `Fn((), Nombor, Masa)` | **interp-only** |
| `time_format` | `Fn((Nombor, Teks), Teks, Masa)` | **interp-only** |
| `time_now` | `Fn((), Nombor, Masa)` | **interp-only** |
| `time_now_ms` | `Fn((), Nombor, Masa)` | **interp-only** |
| `time_parse` | `Fn((Teks, Teks), Nombor, Masa)` | **interp-only** |
| `time_sleep` | `Fn(Nombor, (), Masa)` | **interp-only** |
| `time_unix` | `Fn((), Nombor, Masa)` | **interp-only** |

