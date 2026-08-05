# RIINA Standard Library — Builtin API Reference

> **Generated — do not edit by hand.** This file is produced from the compiler's own builtin registry (`register_builtin_types` in `03_PROTO/crates/riina-typechecker/src/lib.rs`) by the test `03_PROTO/crates/riina-typechecker/tests/stdlib_doc.rs`, so it cannot drift from what `riinac` actually accepts. Regenerate with `REGEN_STDLIB_DOC=1 cargo test -p riina-typechecker --test stdlib_doc`.

Total registered builtins: **309**. Grouped by the effect each performs (`kesan` in a function signature). Types are shown in RIINA surface form (`Teks` = string, `Nombor` = integer, `Tercemar`/`Tainted`, `Rahsia`/`Secret`, …).

*Scope note:* this lists the language builtins the typechecker installs. Crypto primitives in `05_TOOLING/crates/riina-core` (AES, SHA-2/3, HMAC/HKDF, X25519, Ed25519, ML-KEM/ML-DSA) are documented with their KAT vectors in that crate, not here.

## Bersih (Pure)

| Builtin | Type |
|---|---|
| `abs` | `Fn(Nombor, Nombor)` |
| `adalah_kanan` | `Fn(Any, Benar)` |
| `adalah_keliru` | `Fn((Teks, Teks), Benar)` |
| `adalah_kiri` | `Fn(Any, Benar)` |
| `assert` | `Fn(Benar, ())` |
| `assert_eq` | `Fn((Any, Any), ())` |
| `assert_false` | `Fn(Benar, ())` |
| `assert_ne` | `Fn((Any, Any), ())` |
| `assert_true` | `Fn(Benar, ())` |
| `baca_garisan` | `Teks` |
| `baki` | `Fn(Nombor, Nombor)` |
| `besar` | `Fn(Teks, Besar)` |
| `bigint` | `Fn(Teks, Besar)` |
| `binary_fixed` | `Fn((Teks, Nombor), Qmn)` |
| `bool_ke_nombor` | `Fn(Benar, Nombor)` |
| `bool_to_int` | `Fn(Benar, Nombor)` |
| `buang_null` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` |
| `concat` | `Fn((Teks, Teks), Teks)` |
| `csrf_check_origin` | `Fn((Teks, Teks), Benar)` |
| `csrf_check_referer` | `Fn((Teks, Teks), Benar)` |
| `csrf_sahkan` | `Fn((Teks, Teks), Benar)` |
| `csrf_semak_origin` | `Fn((Teks, Teks), Benar)` |
| `csrf_semak_referer` | `Fn((Teks, Teks), Benar)` |
| `csrf_validate` | `Fn((Teks, Teks), Benar)` |
| `decimal` | `Fn(Teks, Perpuluhan)` |
| `deserialize_safe` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` |
| `email_set_header` | `Fn((Teks, Disanitasi<Teks, EmailValidation>), ())` |
| `emel_tetap_kepala` | `Fn((Teks, Disanitasi<Teks, EmailValidation>), ())` |
| `fixed` | `Fn((Teks, Nombor), Wang)` |
| `gabung_teks` | `Fn((Teks, Teks), Teks)` |
| `gcd` | `Fn((Nombor, Nombor), Nombor)` |
| `html_papar` | `Fn(Disanitasi<Teks, HtmlEscape>, Teks)` |
| `html_render` | `Fn(Disanitasi<Teks, HtmlEscape>, Teks)` |
| `int_to_string` | `Fn(Nombor, Teks)` |
| `is_confusable` | `Fn((Teks, Teks), Benar)` |
| `json_ada` | `Fn(Any, Any)` |
| `json_dapat` | `Fn(Any, Any)` |
| `json_get` | `Fn(Any, Any)` |
| `json_has` | `Fn(Any, Any)` |
| `json_ke_teks` | `Fn(Any, Any)` |
| `json_letak` | `Fn(Any, Any)` |
| `json_parse` | `Fn(Any, Any)` |
| `json_parse_safe` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` |
| `json_set` | `Fn(Any, Any)` |
| `json_stringify` | `Fn(Any, Any)` |
| `json_urai` | `Fn(Any, Any)` |
| `json_urai_selamat` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` |
| `julat` | `Fn((Nombor, Nombor), Senarai<Nombor>)` |
| `julat_inklusif` | `Fn((Nombor, Nombor), Senarai<Nombor>)` |
| `ke_bool` | `Fn(Any, Benar)` |
| `ke_nfc` | `Fn(Teks, Teks)` |
| `ke_nombor` | `Fn(Teks, Nombor)` |
| `ke_teks` | `Fn(Any, Teks)` |
| `kuasa` | `Fn((Nombor, Nombor), Nombor)` |
| `lcm` | `Fn((Nombor, Nombor), Nombor)` |
| `length` | `Fn(Teks, Nombor)` |
| `list_concat` | `Fn(Any, Any)` |
| `list_contains` | `Fn(Any, Any)` |
| `list_enumerate` | `Fn(Any, Any)` |
| `list_filter` | `Fn(Any, Any)` |
| `list_flatten` | `Fn(Any, Any)` |
| `list_fold` | `Fn(Any, Any)` |
| `list_get` | `Fn(Any, Any)` |
| `list_head` | `Fn(Any, Any)` |
| `list_len` | `Fn(Any, Any)` |
| `list_map` | `Fn(Any, Any)` |
| `list_new` | `Fn(Any, Any)` |
| `list_push` | `Fn(Any, Any)` |
| `list_reverse` | `Fn(Any, Any)` |
| `list_slice` | `Fn(Any, Any)` |
| `list_sort` | `Fn(Any, Any)` |
| `list_tail` | `Fn(Any, Any)` |
| `list_unique` | `Fn(Any, Any)` |
| `list_zip` | `Fn(Any, Any)` |
| `log2` | `Fn(Nombor, Nombor)` |
| `maksimum` | `Fn((Nombor, Nombor), Nombor)` |
| `map_contains` | `Fn(Any, Any)` |
| `map_get` | `Fn(Any, Any)` |
| `map_insert` | `Fn(Any, Any)` |
| `map_keys` | `Fn(Any, Any)` |
| `map_len` | `Fn(Any, Any)` |
| `map_new` | `Fn(Any, Any)` |
| `map_remove` | `Fn(Any, Any)` |
| `map_values` | `Fn(Any, Any)` |
| `max` | `Fn((Nombor, Nombor), Nombor)` |
| `min` | `Fn((Nombor, Nombor), Nombor)` |
| `minimum` | `Fn((Nombor, Nombor), Nombor)` |
| `money` | `Fn(Teks, Wang)` |
| `mutlak` | `Fn(Nombor, Nombor)` |
| `nfc` | `Fn(Teks, Teks)` |
| `nilai_kanan` | `Fn(Any, Any)` |
| `nilai_kiri` | `Fn(Any, Any)` |
| `nombor_ke_teks` | `Fn(Nombor, Teks)` |
| `normal_unicode` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` |
| `normalize_unicode` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` |
| `nyahsiri_selamat` | `Fn(Disanitasi<Teks, JsonValidation>, Any)` |
| `panjang` | `Fn(Teks, Nombor)` |
| `parse_int` | `Fn(Teks, Nombor)` |
| `perpuluhan` | `Fn(Teks, Perpuluhan)` |
| `peta_baru` | `Fn(Any, Any)` |
| `peta_buang` | `Fn(Any, Any)` |
| `peta_dapat` | `Fn(Any, Any)` |
| `peta_kunci` | `Fn(Any, Any)` |
| `peta_letak` | `Fn(Any, Any)` |
| `peta_mengandungi` | `Fn(Any, Any)` |
| `peta_nilai` | `Fn(Any, Any)` |
| `peta_panjang` | `Fn(Any, Any)` |
| `pow` | `Fn((Nombor, Nombor), Nombor)` |
| `punca` | `Fn(Nombor, Nombor)` |
| `qmn` | `Fn((Teks, Nombor), Qmn)` |
| `rangka` | `Fn(Teks, Teks)` |
| `rem` | `Fn(Nombor, Nombor)` |
| `sahkan_panjang` | `Fn((Tercemar<Teks, UserInput>, Nombor), Mungkin<Tercemar<Teks, UserInput>>)` |
| `sahkan_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlAllowlist>)` |
| `sanitasi_css` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CssEscape>)` |
| `sanitasi_emel` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, EmailValidation>)` |
| `sanitasi_html` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, HtmlEscape>)` |
| `sanitasi_js` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsEscape>)` |
| `sanitasi_json` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsonValidation>)` |
| `sanitasi_laluan` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, PathTraversal>)` |
| `sanitasi_ldap` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, LdapEscape>)` |
| `sanitasi_perintah` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CommandEscape>)` |
| `sanitasi_sql` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, SqlParam>)` |
| `sanitasi_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlEncode>)` |
| `sanitasi_xml` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, XmlEscape>)` |
| `sanitize_command` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CommandEscape>)` |
| `sanitize_css` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, CssEscape>)` |
| `sanitize_email` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, EmailValidation>)` |
| `sanitize_html` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, HtmlEscape>)` |
| `sanitize_js` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsEscape>)` |
| `sanitize_json` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, JsonValidation>)` |
| `sanitize_ldap` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, LdapEscape>)` |
| `sanitize_path` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, PathTraversal>)` |
| `sanitize_sql` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, SqlParam>)` |
| `sanitize_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlEncode>)` |
| `sanitize_xml` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, XmlEscape>)` |
| `senarai_balik` | `Fn(Any, Any)` |
| `senarai_baru` | `Fn(Any, Any)` |
| `senarai_dapat` | `Fn(Any, Any)` |
| `senarai_ekor` | `Fn(Any, Any)` |
| `senarai_kepala` | `Fn(Any, Any)` |
| `senarai_lipat` | `Fn(Any, Any)` |
| `senarai_mengandungi` | `Fn(Any, Any)` |
| `senarai_nombor` | `Fn(Any, Any)` |
| `senarai_panjang` | `Fn(Any, Any)` |
| `senarai_peta` | `Fn(Any, Any)` |
| `senarai_potong` | `Fn(Any, Any)` |
| `senarai_rata` | `Fn(Any, Any)` |
| `senarai_sambung` | `Fn(Any, Any)` |
| `senarai_susun` | `Fn(Any, Any)` |
| `senarai_tapis` | `Fn(Any, Any)` |
| `senarai_tolak` | `Fn(Any, Any)` |
| `senarai_unik` | `Fn(Any, Any)` |
| `senarai_zip` | `Fn(Any, Any)` |
| `set_baru` | `Fn(Any, Any)` |
| `set_buang` | `Fn(Any, Any)` |
| `set_contains` | `Fn(Any, Any)` |
| `set_insert` | `Fn(Any, Any)` |
| `set_intersect` | `Fn(Any, Any)` |
| `set_kesatuan` | `Fn(Any, Any)` |
| `set_len` | `Fn(Any, Any)` |
| `set_letak` | `Fn(Any, Any)` |
| `set_mengandungi` | `Fn(Any, Any)` |
| `set_new` | `Fn(Any, Any)` |
| `set_panjang` | `Fn(Any, Any)` |
| `set_persilangan` | `Fn(Any, Any)` |
| `set_remove` | `Fn(Any, Any)` |
| `set_union` | `Fn(Any, Any)` |
| `skeleton` | `Fn(Teks, Teks)` |
| `sqrt` | `Fn(Nombor, Nombor)` |
| `str_char_at` | `Fn(Any, Any)` |
| `str_contains` | `Fn(Any, Any)` |
| `str_ends_with` | `Fn(Any, Any)` |
| `str_index_of` | `Fn(Any, Any)` |
| `str_join` | `Fn(Any, Any)` |
| `str_lines` | `Fn(Any, Any)` |
| `str_pad_left` | `Fn(Any, Any)` |
| `str_pad_right` | `Fn(Any, Any)` |
| `str_repeat` | `Fn(Any, Any)` |
| `str_replace` | `Fn(Any, Any)` |
| `str_split` | `Fn(Any, Any)` |
| `str_starts_with` | `Fn(Any, Any)` |
| `str_substring` | `Fn(Any, Any)` |
| `str_to_lower` | `Fn(Any, Any)` |
| `str_to_upper` | `Fn(Any, Any)` |
| `str_trim` | `Fn(Any, Any)` |
| `strip_nulls` | `Fn(Tercemar<Teks, UserInput>, Tercemar<Teks, UserInput>)` |
| `tegaskan` | `Fn(Benar, ())` |
| `tegaskan_betul` | `Fn(Benar, ())` |
| `tegaskan_beza` | `Fn((Any, Any), ())` |
| `tegaskan_salah` | `Fn(Benar, ())` |
| `tegaskan_sama` | `Fn((Any, Any), ())` |
| `teks_akhir_dengan` | `Fn(Any, Any)` |
| `teks_aksara_di` | `Fn(Any, Any)` |
| `teks_baris` | `Fn(Any, Any)` |
| `teks_belah` | `Fn(Any, Any)` |
| `teks_cantum` | `Fn(Any, Any)` |
| `teks_ganti` | `Fn(Any, Any)` |
| `teks_huruf_besar` | `Fn(Any, Any)` |
| `teks_huruf_kecil` | `Fn(Any, Any)` |
| `teks_indeks` | `Fn(Any, Any)` |
| `teks_mengandungi` | `Fn(Any, Any)` |
| `teks_mula_dengan` | `Fn(Any, Any)` |
| `teks_pad_kanan` | `Fn(Any, Any)` |
| `teks_pad_kiri` | `Fn(Any, Any)` |
| `teks_potong` | `Fn(Any, Any)` |
| `teks_sub` | `Fn(Any, Any)` |
| `teks_ulang` | `Fn(Any, Any)` |
| `titik_tetap` | `Fn((Teks, Nombor), Wang)` |
| `to_bool` | `Fn(Any, Benar)` |
| `to_string` | `Fn(Any, Teks)` |
| `validate_length` | `Fn((Tercemar<Teks, UserInput>, Nombor), Mungkin<Tercemar<Teks, UserInput>>)` |
| `validate_url` | `Fn(Tercemar<Teks, UserInput>, Disanitasi<Teks, UrlAllowlist>)` |
| `wang` | `Fn(Teks, Wang)` |
| `xml_cari` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` |
| `xml_parse_safe` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` |
| `xml_query` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` |
| `xml_urai_selamat` | `Fn(Disanitasi<Teks, XmlEscape>, Any)` |

## Baca (Read)

| Builtin | Type |
|---|---|
| `fail_baca_selamat` | `Fn(Disanitasi<Teks, PathTraversal>, Any, Baca)` |
| `file_read_safe` | `Fn(Disanitasi<Teks, PathTraversal>, Any, Baca)` |
| `vfs_baca` | `Fn(Teks, Teks, Baca)` |
| `vfs_read` | `Fn(Teks, Teks, Baca)` |

## Tulis (Write)

| Builtin | Type |
|---|---|
| `cetak` | `Fn(Any, (), Tulis)` |
| `cetak_baris` | `Fn(Any, (), Tulis)` |
| `cetakln` | `Fn(Any, (), Tulis)` |
| `fail_buang_selamat` | `Fn(Disanitasi<Teks, PathTraversal>, Benar, Tulis)` |
| `fail_tulis_selamat` | `Fn((Disanitasi<Teks, PathTraversal>, Any), (), Tulis)` |
| `file_delete_safe` | `Fn(Disanitasi<Teks, PathTraversal>, Benar, Tulis)` |
| `file_write_safe` | `Fn((Disanitasi<Teks, PathTraversal>, Any), (), Tulis)` |
| `print` | `Fn(Any, (), Tulis)` |
| `println` | `Fn(Any, (), Tulis)` |
| `vfs_delete` | `Fn(Teks, Benar, Tulis)` |
| `vfs_padam` | `Fn(Teks, Benar, Tulis)` |
| `vfs_tulis` | `Fn((Teks, Teks), (), Tulis)` |
| `vfs_write` | `Fn((Teks, Teks), (), Tulis)` |

## SistemFail (FileSystem)

| Builtin | Type |
|---|---|
| `fail_ada` | `Fn(Teks, Benar, SistemFail)` |
| `fail_baca` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` |
| `fail_baca_baris` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` |
| `fail_buang` | `Fn(Teks, (), SistemFail)` |
| `fail_panjang` | `Fn(Teks, Nombor, SistemFail)` |
| `fail_senarai` | `Fn(Teks, Any, SistemFail)` |
| `fail_tambah` | `Fn((Teks, Teks), (), SistemFail)` |
| `fail_tulis` | `Fn((Teks, Teks), (), SistemFail)` |
| `file_append` | `Fn((Teks, Teks), (), SistemFail)` |
| `file_delete` | `Fn(Teks, (), SistemFail)` |
| `file_exists` | `Fn(Teks, Benar, SistemFail)` |
| `file_list_dir` | `Fn(Teks, Any, SistemFail)` |
| `file_read` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` |
| `file_read_lines` | `Fn(Teks, Tercemar<Teks, FileSystem>, SistemFail)` |
| `file_size` | `Fn(Teks, Nombor, SistemFail)` |
| `file_write` | `Fn((Teks, Teks), (), SistemFail)` |
| `vfs_become_user` | `Fn(Nombor, (), SistemFail)` |
| `vfs_init` | `Fn(Nombor, (), SistemFail)` |
| `vfs_jadi_pengguna` | `Fn(Nombor, (), SistemFail)` |
| `vfs_mula` | `Fn(Nombor, (), SistemFail)` |

## Rangkaian (Network)

| Builtin | Type |
|---|---|
| `badan_http` | `Fn(Any, Tercemar<Teks, NetworkExternal>, Rangkaian)` |
| `email_send` | `Fn((Disanitasi<Teks, EmailValidation>, Teks), Benar, Rangkaian)` |
| `emel_hantar` | `Fn((Disanitasi<Teks, EmailValidation>, Teks), Benar, Rangkaian)` |
| `http_ambil_selamat` | `Fn(Disanitasi<Teks, UrlAllowlist>, Any, Rangkaian)` |
| `http_arah_selamat` | `Fn(Disanitasi<Teks, UrlAllowlist>, (), Rangkaian)` |
| `http_body` | `Fn(Any, Tercemar<Teks, NetworkExternal>, Rangkaian)` |
| `http_dapat` | `Fn(Teks, Any, Rangkaian)` |
| `http_delete` | `Fn((Teks, Teks), Any, Rangkaian)` |
| `http_fetch_safe` | `Fn(Disanitasi<Teks, UrlAllowlist>, Any, Rangkaian)` |
| `http_get` | `Fn(Teks, Any, Rangkaian)` |
| `http_hantar` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` |
| `http_kemaskini` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` |
| `http_padam` | `Fn((Teks, Teks), Any, Rangkaian)` |
| `http_post` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` |
| `http_put` | `Fn((Teks, (Any, Teks)), Any, Rangkaian)` |
| `http_redirect_safe` | `Fn(Disanitasi<Teks, UrlAllowlist>, (), Rangkaian)` |

## Kripto (Crypto)

| Builtin | Type |
|---|---|
| `cipher` | `Fn(Teks, Any, Kripto)` |
| `guna_kripto` | `Fn(Teks, Any, Kripto)` |
| `hash_dengan` | `Fn(Teks, Any, Kripto)` |
| `hash_with` | `Fn(Teks, Any, Kripto)` |
| `pilih_algo` | `Fn(Teks, Any, Kripto)` |
| `select_algorithm` | `Fn(Teks, Any, Kripto)` |
| `sifer` | `Fn(Teks, Any, Kripto)` |
| `use_crypto` | `Fn(Teks, Any, Kripto)` |

## Rawak (Random)

| Builtin | Type |
|---|---|
| `csrf_generate` | `Fn((), Teks, Rawak)` |
| `csrf_jana` | `Fn((), Teks, Rawak)` |
| `random` | `Fn(Nombor, Nombor, Rawak)` |
| `rawak` | `Fn(Nombor, Nombor, Rawak)` |

## Sistem (System)

| Builtin | Type |
|---|---|
| `baca_baris` | `Fn((), Tercemar<Teks, UserInput>, Sistem)` |
| `dom_set_attr` | `Fn((Any, (Teks, Disanitasi<Teks, HtmlEscape>)), (), Sistem)` |
| `dom_set_html` | `Fn((Any, Disanitasi<Teks, HtmlEscape>), (), Sistem)` |
| `dom_tetap_atribut` | `Fn((Any, (Teks, Disanitasi<Teks, HtmlEscape>)), (), Sistem)` |
| `dom_tetap_html` | `Fn((Any, Disanitasi<Teks, HtmlEscape>), (), Sistem)` |
| `js_eval` | `Fn(Disanitasi<Teks, JsEscape>, Any, Sistem)` |
| `js_nilai` | `Fn(Disanitasi<Teks, JsEscape>, Any, Sistem)` |
| `ldap_cari` | `Fn(Disanitasi<Teks, LdapEscape>, Any, Sistem)` |
| `ldap_search` | `Fn(Disanitasi<Teks, LdapEscape>, Any, Sistem)` |
| `read_line` | `Fn((), Tercemar<Teks, UserInput>, Sistem)` |
| `shell_exec` | `Fn(Disanitasi<Teks, CommandEscape>, Nombor, Sistem)` |
| `shell_laksana` | `Fn(Disanitasi<Teks, CommandEscape>, Nombor, Sistem)` |
| `sql_execute` | `Fn(Disanitasi<Teks, SqlParam>, Any, Sistem)` |
| `sql_laksana` | `Fn(Disanitasi<Teks, SqlParam>, Any, Sistem)` |

## Masa (Time)

| Builtin | Type |
|---|---|
| `masa_format` | `Fn((Nombor, Teks), Teks, Masa)` |
| `masa_jam` | `Fn((), Nombor, Masa)` |
| `masa_sekarang` | `Fn((), Nombor, Masa)` |
| `masa_sekarang_ms` | `Fn((), Nombor, Masa)` |
| `masa_tidur` | `Fn(Nombor, (), Masa)` |
| `masa_urai` | `Fn((Teks, Teks), Nombor, Masa)` |
| `time_clock` | `Fn((), Nombor, Masa)` |
| `time_format` | `Fn((Nombor, Teks), Teks, Masa)` |
| `time_now` | `Fn((), Nombor, Masa)` |
| `time_now_ms` | `Fn((), Nombor, Masa)` |
| `time_parse` | `Fn((Teks, Teks), Nombor, Masa)` |
| `time_sleep` | `Fn(Nombor, (), Masa)` |

