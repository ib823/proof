# RIINA

**Bahasa pengaturcaraan dengan model teras yang disahkan dalam Coq.**

Peraturan jenis dan kesan teras dibuktikan dalam Coq untuk model bahasa; pengkompil diuji terhadap model itu.

---

## Apa itu RIINA?

RIINA ialah bahasa pengaturcaraan dengan **model teras yang disahkan dalam Coq**. Program yang berjaya dikompilasi lulus semakan jenis dan kesan yang dilaksanakan oleh pengkompil. Coq ialah satu-satunya laluan bukti yang dimekanikkan sepenuhnya; angka semasa ada dalam [README](../../README.md) dan `website/public/metrics.json`.

**Tidak seperti CompCert atau CakeML, pengkompil `riinac` sendiri tidak disahkan secara formal.** Yang dibuktikan dalam Coq ialah model bahasa (jadual di bawah); pengkompil diuji terhadap model itu, bukan dibuktikan melaksanakannya.

| Sifat dalam model bahasa | Status |
|---|---|
| Tiada kebocoran maklumat antara tahap keselamatan | Bukan-gangguan dibuktikan (Coq) untuk teras tanpa rujukan dan tanpa rekursi; dikuatkuasakan oleh ujian di luarnya |
| Tiada pelaksanaan kesan tanpa kebenaran | Algebra pintu kesan dan kebunyian kesan dibuktikan dalam model Coq; pengkompil menguatkuasakan kesan yang diisytiharkan |
| Keselamatan jenis (tiada ralat jenis masa larian) | Teorem Kemajuan + Pemeliharaan (Coq); penyemak jenis pengkompil diuji terhadap model itu |
| Tiada data rahsia dalam output awam | Model deklasifikasi (Coq); penjajaran pengkompil masih dalam proses |
| Penamatan (teras tanpa rujukan dan tanpa `fix` sahaja) | Normalisasi kuat dibuktikan (Coq) untuk teras itu |
| Keselamatan memori tanpa pengutip sampah | Model logik pemisahan (Coq) sahaja — bukan bukti tentang pengkompil yang dikeluarkan |

---

## Mula Pantas

### Pasang

```bash
git clone https://github.com/ib823/riina.git
cd riina/03_PROTO
cargo build --release
```

Binari pengkompil ialah `riinac`. Pengkompil yang dikeluarkan mempunyai sifar kebergantungan luaran pada masa larian. Pembangunan dan CI menggunakan alat berasingan: rantaian alat Rocq, `cc`, `wasmtime`, `z3`, *harness* fuzz dan vektor ujian NIST.

### Hello World

Cipta `hello.rii`:

```riina
fungsi utama() -> Teks kesan Tulis {
    biar mesej = "Selamat datang ke RIINA!";
    cetak(mesej);          // 'cetak' mencetak; kesannya ialah 'Tulis' (Write)
    mesej                  // ungkapan terakhir ialah nilai pulangan (tiada 'pulang;')
}
```

```bash
riinac check hello.rii    # Semak jenis dan sahkan
riinac run hello.rii      # Jalankan terus
riinac build hello.rii    # Kompilasi ke binari natif melalui C
```

### Keselamatan dalam Tindakan

```riina
fungsi proses_pembayaran(kad: Rahsia<Teks>, jumlah: Nombor) -> Teks kesan Kripto {
    biar cap = cincang(kad);                      // OK: cincangan rahsia kekal rahsia
    biar resit = "Jumlah: " + ke_teks(jumlah);    // OK: jumlah ialah awam
    resit                                         // OK: hanya data awam dikembalikan
}
```

```riina error="Security violation in print sink"
fungsi utama() -> Unit kesan Tulis {
    biar kad = sulit "4111 1111 1111 1111";
    cetakln(kad)                                  // RALAT KOMPILASI: rahsia pada sink cetakan
}
```

Kedua-dua blok di atas disemak oleh ujian (`03_PROTO/crates/riinac/tests/doc_snippets.rs`): yang pertama lulus, yang kedua ditolak oleh penyemak.

- **Kriptografi masih eksperimen:** kriptografi dalaman RIINA (`riina-core`) masih eksperimen dan belum diaudit — jangan gunakannya untuk melindungi rahsia sebenar buat masa ini. Tiada audit bebas diterbitkan lagi.
- **Tiada titik terapung, mengikut reka bentuk:** literal titik terapung ialah ralat kompilasi (P0015). Aritmetik integer dan titik tetap yang tepat mengekalkan program dalam lingkungan yang dimodelkan oleh bukti.

---

## Kata Kunci Bahasa Melayu

| RIINA | Inggeris | Contoh |
|-------|---------|--------|
| `fungsi` | fn | `fungsi tambah(x: Nombor) -> Nombor` |
| `biar` | let | `biar nama = "Ahmad";` |
| `kalau` | if | `kalau x > 0 { ... }` |
| `lain` | else | `lain { ... }` |
| `untuk` | for | `untuk x dalam senarai { ... }` |
| `selagi` | while | `selagi aktif { ... }` |
| `pulang` | return | `pulang hasil;` |
| `padan` | match | `padan nilai { ... }` |
| `rahsia` | secret | `biar kunci: Rahsia<Teks>` |
| `dedah` | declassify | `dedah(nilai)` |
| `kesan` | effect | `kesan Tulis` |
| `bersih` | pure | `kesan Bersih` |
| `betul` / `salah` | true / false | Nilai Boolean |
| `ubah` | mut | `biar ubah x = 0;` |

---

## Sumbangan

Lihat [CONTRIBUTING.md](../../CONTRIBUTING.md) untuk panduan sumbangan.

## Lesen

[RIINA Proprietary License](../../LICENSE)

---

*RIINA — Rigorous Immutable Invariant, No Assumptions*

*Q.E.D. Aeternum.*
