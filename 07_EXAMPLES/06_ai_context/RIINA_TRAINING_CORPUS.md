# RIINA Training Corpus for LLM Fine-Tuning

A comprehensive collection of instruction-response pairs for training language models
to understand and generate RIINA code. RIINA uses Bahasa Melayu (Malaysian) keywords
with formal verification and security type guarantees.

---

## 1. Basic Syntax

**Q: Write a function that adds two numbers in RIINA.**
```riina
fungsi tambah(x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    x + y
}
```

**Q: Write a Hello World program in RIINA.**
```riina
modul hello;
guna std::io;

awam fungsi utama() -> kesan Tulis {
    laku Tulis cetak_baris("Selamat datang ke RIINA!");
}
```

**Q: Declare an immutable variable and a mutable variable in RIINA.**
```riina
biar nama = "Ahmad";          // immutable
biar ubah umur = 25;          // mutable
tetap MAKSIMUM = 100;         // constant
```

**Q: Write a function that checks if a number is positive.**
```riina
fungsi ialah_positif(n: Nombor) -> Benar kesan Bersih {
    kalau n > 0 { benar } lain { salah }
}
```

**Q: Write a function that returns the absolute value of a number.**
```riina
fungsi mutlak(n: Nombor) -> Nombor kesan Bersih {
    kalau n < 0 { 0 - n } lain { n }
}
```

---

## 2. Pattern Matching

**Q: Write a pattern match on a number in RIINA.**
```riina
fungsi gambar_nombor(n: Nombor) -> Teks kesan Bersih {
    padan n {
        0 => "kosong",
        1 => "satu",
        2 => "dua",
        _ => "banyak",
    }
}
```

**Q: Write a pattern match on an option type.**
```riina
fungsi buka_mungkin(m: Mungkin<Nombor>) -> Nombor kesan Bersih {
    padan m {
        Ada(n) => n,
        Tiada => 0,
    }
}
```

**Q: Pattern match on a Result type.**
```riina
fungsi proses_hasil(h: Hasil<Nombor, Teks>) -> Nombor kesan Bersih {
    padan h {
        Jadi(n) => n,
        Gagal(e) => 0,
    }
}
```

---

## 3. Loops and Iteration

**Q: Write a for loop over a list in RIINA.**
```riina
fungsi cetak_semua(senarai: Senarai<Nombor>) -> kesan Tulis {
    untuk n dalam senarai {
        laku Tulis cetak_baris(ke_teks(n));
    }
}
```

**Q: Write a while loop that counts down from n.**
```riina
fungsi kira_mundur(n: Nombor) -> kesan Tulis {
    biar ubah i = n;
    selagi i > 0 {
        laku Tulis cetak_baris(ke_teks(i));
        i = i - 1;
    }
}
```

**Q: Sum a list of numbers using a loop.**
```riina
fungsi jumlah(senarai: Senarai<Nombor>) -> Nombor kesan Bersih {
    biar ubah hasil = 0;
    untuk n dalam senarai {
        hasil = hasil + n;
    }
    hasil
}
```

**Q: Use the pipe operator to chain transformations.**
```riina
fungsi proses(data: Senarai<Nombor>) -> Nombor kesan Bersih {
    data
        |> tapis(|x| x > 0)
        |> peta(|x| x * 2)
        |> lipat(0, |acc, x| acc + x)
}
```

---

## 4. Security Types

**Q: Write a function that handles a secret password in RIINA.**
```riina
fungsi proses_kata_laluan(kata: Rahsia<Teks>) -> Nombor kesan Kripto {
    biar hash = kripto::argon2id(kata, "garam_rawak");
    panjang(hash)
}
```

**Q: Write a function that declassifies a secret with proof.**
```riina
fungsi dedah_selamat(rahsia: Rahsia<Teks>, bukti_akses: Bukti<Akses>) -> Teks kesan Bersih {
    dedah rahsia dengan bukti_akses
}
```

**Q: Write a function with security-labeled data.**
```riina
fungsi naik_taraf_label(data: Berlabel<Teks, Awam>) -> Berlabel<Teks, Dalaman> kesan Bersih {
    naik_label(data)
}
```

**Q: Handle tainted user input safely.**
```riina
fungsi proses_input(input: Tercemar<Teks, Web>) -> Disanitasi<Teks, SQL> kesan Bersih {
    biar bersih = sanitasi_sql(input);
    bersih
}
```

**Q: Use constant-time comparison for secrets.**
```riina
fungsi sahkan_token(token: Rahsia<Teks>, dijangka: Rahsia<Teks>) -> Benar kesan Kripto {
    masa_tetap {
        kripto::banding_tetap(token, dijangka)
    }
}
```

---

## 5. Effects

**Q: Write a pure function in RIINA.**
```riina
fungsi kira(x: Nombor) -> Nombor kesan Bersih {
    x * 2
}
```

**Q: Write a function with write effect.**
```riina
fungsi log_mesej(mesej: Teks) -> kesan Tulis {
    laku Tulis cetak_baris(mesej);
}
```

**Q: Write a function with multiple effects.**
```riina
fungsi baca_dan_tulis(laluan: Teks) -> Teks kesan (Baca, Tulis) {
    biar kandungan = laku Baca fail_baca(laluan);
    laku Tulis cetak_baris(kandungan);
    kandungan
}
```

**Q: Write a function with crypto effect.**
```riina
fungsi jana_id() -> Teks kesan Kripto {
    kripto::uuid_v4()
}
```

**Q: Handle an effect using kendali.**
```riina
fungsi dengan_log(f: Fn() -> Nombor kesan Tulis) -> Nombor kesan Bersih {
    kendali f() {
        Tulis(mesej) => {
            // Abaikan output / Discard output
            teruskan
        }
    }
}
```

---

## 6. Structs and Enums

**Q: Define a struct in RIINA.**
```riina
bentuk Pengguna {
    nama: Teks,
    umur: Nombor,
    emel: Rahsia<Teks>,
}
```

**Q: Define an enum in RIINA.**
```riina
pilihan Status {
    Aktif,
    Tidak_Aktif,
    Digantung(Teks),
}
```

**Q: Implement a trait for a struct.**
```riina
sifat Boleh_Cetak {
    fungsi cetak(self) -> Teks;
}

laksana Boleh_Cetak untuk Pengguna {
    fungsi cetak(self) -> Teks kesan Bersih {
        format!("Pengguna: {}", self.nama)
    }
}
```

**Q: Create a struct instance and access its fields.**
```riina
fungsi buat_pengguna() -> Pengguna kesan Bersih {
    biar p = Pengguna {
        nama: "Siti",
        umur: 30,
        emel: rahsia "siti@contoh.com",
    };
    p
}
```

---

## 7. Higher-Order Functions

**Q: Write a higher-order function that applies a function to two numbers.**
```riina
fungsi guna_fungsi(f: Fn(Nombor, Nombor) -> Nombor, x: Nombor, y: Nombor) -> Nombor kesan Bersih {
    f(x, y)
}
```

**Q: Write a function that returns a closure.**
```riina
fungsi buat_penambah(n: Nombor) -> Fn(Nombor) -> Nombor kesan Bersih {
    fungsi(x: Nombor) -> Nombor { x + n }
}
```

**Q: Use map and filter on a list.**
```riina
fungsi nombor_genap_gandakan(senarai: Senarai<Nombor>) -> Senarai<Nombor> kesan Bersih {
    senarai
        |> tapis(|x| x % 2 == 0)
        |> peta(|x| x * 2)
}
```

---

## 8. Actors (JALINAN)

**Q: Create an actor that counts messages.**
```riina
pelakon Pembilang {
    keadaan: Nombor

    kendalikan Tambah(n: Nombor) {
        keadaan + n
    }

    kendalikan Dapatkan() -> Nombor {
        keadaan
    }
}
```

**Q: Spawn an actor and send it a message.**
```riina
fungsi utama() -> kesan (Tulis, Proses) {
    biar p = lahir Pembilang(0);
    hantar p Tambah(1);
    hantar p Tambah(2);
    biar nilai = terima p Dapatkan();
    laku Tulis cetak_baris(ke_teks(nilai));
}
```

**Q: Create a supervisor for fault tolerance.**
```riina
penyelia PenyeliaUtama {
    strategi: MulakanSemula(3, 5000)

    anak [
        Pembilang(0),
        Pembilang(100),
    ]
}
```

**Q: Define a choreography protocol.**
```riina
koreografi Pembelian {
    peranan Pembeli, Penjual, Bank

    Pembeli -> Penjual: Pesanan(item: Teks, kuantiti: Nombor)
    Penjual -> Pembeli: Harga(jumlah: Nombor)
    Pembeli -> Bank: Bayaran(jumlah: Nombor)
    Bank -> Penjual: Pengesahan(id: Teks)
}
```

---

## 9. Content Addressing

**Q: Hash a value in RIINA.**
```riina
fungsi cincang_data(data: Teks) -> Bait kesan Kripto {
    cincang(data)
}
```

**Q: Verify content integrity.**
```riina
fungsi sahkan_integriti(data: Teks, hash_asal: Bait) -> Benar kesan Kripto {
    biar hash_baru = cincang(data);
    sahkan(hash_baru == hash_asal)
}
```

**Q: Use content-addressed storage.**
```riina
fungsi simpan_kandungan(data: Teks) -> KandunganAlamat<Teks> kesan Kripto {
    biar alamat = cincang(data);
    KandunganAlamat { data: data, alamat: alamat }
}
```

**Q: Build a Merkle tree.**
```riina
fungsi bina_pokok(daun: Senarai<Teks>) -> PokokMerkle<Teks> kesan Kripto {
    biar hashes = peta(daun, |d| cincang(d));
    PokokMerkle::baru(hashes)
}
```

---

## 10. UI (CAHAYA)

**Q: Create a simple UI in RIINA.**
```riina
paparan Salam {
    tulisan("Selamat datang!", warna(255, 255, 255));
    butang("Tekan sini", tindakan: || {
        laku Tulis cetak_baris("Ditekan!");
    });
}
```

**Q: Create a form with accessible labels.**
```riina
paparan Borang_Daftar {
    label("Nama:", untuk: "nama_input")
    medan_teks(id: "nama_input", petunjuk: "Masukkan nama anda")

    label("Emel:", untuk: "emel_input")
    medan_teks(id: "emel_input", petunjuk: "Masukkan emel anda")

    butang("Daftar", tindakan: || { hantar_borang() })
}
```

**Q: Create a list display with dynamic data.**
```riina
paparan Senarai_Tugas(tugas: Senarai<Teks>) {
    untuk t dalam tugas {
        baris {
            tulisan(t, saiz: 16);
        }
    }
}
```

---

## 11. Islamic Finance (Syariah)

**Q: Write a zakat calculation in RIINA.**
```riina
fungsi kira_zakat(harta: Nombor, nisab: Nombor) -> Nombor kesan Bersih {
    kalau harta >= nisab {
        harta * 25 / 1000   // 2.5%
    } lain {
        0
    }
}
```

**Q: Model a mudarabah (profit-sharing) contract.**
```riina
kontrak Mudarabah patuh Syariah {
    modal: Nombor,
    nisbah_untung: Nombor,  // profit ratio percentage

    fungsi agih_untung(untung: Nombor) -> (Nombor, Nombor) kesan Bersih {
        biar bahagian_pelabur = untung * nisbah_untung / 100;
        biar bahagian_pengusaha = untung - bahagian_pelabur;
        (bahagian_pelabur, bahagian_pengusaha)
    }

    fungsi agih_rugi(rugi: Nombor) -> (Nombor, Nombor) kesan Bersih {
        // Rugi ditanggung pelabur sahaja / Loss borne by capital provider only
        (rugi, 0)
    }
}
```

**Q: Model a sukuk (Islamic bond) in RIINA.**
```riina
kontrak Sukuk patuh Syariah {
    aset_sandaran: Aset<Hartanah>,
    jumlah_sijil: Nombor,

    fungsi nilai_sijil() -> Nombor kesan Bersih {
        nilai(aset_sandaran) / jumlah_sijil
    }
}
```

**Q: Write a riba (interest) check.**
```riina
fungsi semak_tiada_riba(pinjaman: Nombor, bayaran_balik: Nombor) -> Benar kesan Bersih {
    // Bayaran balik mesti sama dengan pinjaman / Repayment must equal principal
    bayaran_balik == pinjaman
}
```

---

## 12. Linear Types

**Q: Use a linear type that must be consumed exactly once.**
```riina
fungsi guna_sekali(sumber: sekali Fail) -> kesan SistemFail {
    biar kandungan = baca(sumber);
    // sumber tidak boleh digunakan lagi / sumber cannot be used again
    laku Tulis cetak_baris(kandungan);
}
```

**Q: Model a wakaf (irrevocable endowment).**
```riina
fungsi tubuh_wakaf(harta: sekali Aset<Hartanah>) -> Wakaf kesan Bersih {
    // Wakaf tidak boleh ditarik balik / Wakaf is irrevocable
    Wakaf::baru(harta)
}
```

---

## 13. Capabilities

**Q: Use capability-based access control.**
```riina
fungsi baca_fail(laluan: Teks, kap: Keupayaan<BacaFail>) -> Teks kesan Baca {
    perlu kap;
    laku Baca fail_baca(laluan)
}
```

**Q: Grant a capability to a function.**
```riina
fungsi utama() -> kesan (Baca, Tulis) {
    biar kap = beri Keupayaan<BacaFail>;
    biar isi = baca_fail("data.txt", kap);
    laku Tulis cetak_baris(isi);
}
```

---

## 14. Error Handling

**Q: Return a Result type from a function.**
```riina
fungsi bahagi(x: Nombor, y: Nombor) -> Hasil<Nombor, Teks> kesan Bersih {
    kalau y == 0 {
        Gagal("Tidak boleh bahagi dengan sifar")
    } lain {
        Jadi(x / y)
    }
}
```

**Q: Chain Result operations.**
```riina
fungsi kira_selamat(a: Nombor, b: Nombor, c: Nombor) -> Hasil<Nombor, Teks> kesan Bersih {
    biar x = bahagi(a, b)?;
    biar y = bahagi(x, c)?;
    Jadi(y)
}
```

---

## 15. Modules and Imports

**Q: Declare a module and import from it.**
```riina
modul matematik;
guna std::io;
guna koleksi::senarai;

awam fungsi faktorial(n: Nombor) -> Nombor kesan Bersih {
    kalau n <= 1 { 1 } lain { n * faktorial(n - 1) }
}
```

**Q: Use a public function from another module.**
```riina
modul utama;
guna matematik;

fungsi utama() -> kesan Tulis {
    biar hasil = matematik::faktorial(10);
    laku Tulis cetak_baris(ke_teks(hasil));
}
```

---

## 16. Assertions and Testing

**Q: Write assertions in RIINA.**
```riina
fungsi ujian_tambah() -> kesan Bersih {
    tegaskan_sama(tambah(2, 3), 5);
    tegaskan_sama(tambah(0, 0), 0);
    tegaskan_sama(tambah(-1, 1), 0);
}
```

**Q: Write a property-based assertion.**
```riina
fungsi ujian_kalis_sifar(x: Nombor) -> kesan Bersih {
    tegaskan_sama(tambah(x, 0), x);
    tegaskan_sama(tambah(0, x), x);
}
```

---

## 17. FFI (Foreign Function Interface)

**Q: Call an external C function from RIINA.**
```riina
luaran "C" {
    fungsi strlen(s: *Bait) -> Nombor;
}

fungsi panjang_c(s: Teks) -> Nombor kesan Bersih {
    luaran::strlen(ke_bait(s))
}
```

---

## 18. Smart Contracts and Blockchain

**Q: Define a simple token contract.**
```riina
kontrak TokenRIINA {
    lejar baki: Peta<Alamat, Nombor>

    fungsi pindah(dari: Alamat, ke: Alamat, jumlah: Nombor) -> kesan Kripto {
        pastikan baki[dari] >= jumlah;
        baki[dari] = baki[dari] - jumlah;
        baki[ke] = baki[ke] + jumlah;
    }
}
```

**Q: Define a consensus protocol.**
```riina
konsensus BFT {
    perlu 2 * f + 1 daripada 3 * f + 1

    fasa Cadangan(blok: Blok)
    fasa Undi(hash: Bait)
    fasa Komit(tandatangan: Senarai<Tandatangan>)
}
```

---

## Reference

- **File extension**: `.rii`
- **Primary types**: `Nombor`, `Teks`, `Benar`, `Kosong`, `Bait`, `Masa`
- **Wrapper types**: `Rahsia<T>`, `Bukti<T>`, `Mungkin<T>`, `Hasil<T,E>`, `Senarai<T>`
- **Security levels**: `Awam < Dalaman < Sesi < Pengguna < Sistem < Rahsia`
- **Effect levels**: `Bersih < Ubah < Baca < Peruntuk < Tulis < SistemFail < Rangkaian < Kripto < Sistem < Masa`
- **Keywords**: All in Bahasa Melayu — see `RIINA_MASTER_PLAN.md` Part 9
