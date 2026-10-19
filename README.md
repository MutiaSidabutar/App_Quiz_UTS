# Quiz App — UTS Lab Pemrograman Mobile

## a. Identitas Mahasiswa

| Keterangan | Data |
|------------|------|
| **Nama** | Mutia Elshaday Sidabutar |
| **NIM** | 241401133 |
| **Lab** |  PM 2 |

---

## b. Informasi Aplikasi

### i. Nama Aplikasi
**Quiz App** (app_Quiz)

### ii. Deskripsi Singkat Aplikasi
Quiz App adalah aplikasi kuis pilihan ganda berbasis Flutter yang memungkinkan pengguna memasukkan nama, menjawab serangkaian pertanyaan, dan meliat pogress akhir serta mengerjakan berdasarkan waktu. Aplikasi menerapkan state management menggunakan Provider sehingga progres jawaban tetap terjaga saat perangkat dirotasi atau berpindah halaman. Data soal bersifat lokal (dummy), tanpa database.

### iii. Fitur-fitur yang Tersedia

**Fitur Wajib:**
-Input nama pengguna sebelum memulai kuis
-Pilihan 4 kategori kuis (Teknologi, Sains, Geografi, Sejarah), masing-masing 10 soal
-Halaman kuis dengan soal pilihan ganda, progress bar, dan jumlah soal terjawab
-Halaman hasil yang menampilkan nama, nilai akhir, dan statistik jawaban
-Navigasi antarhalaman menggunakan Navigator (named routes): Beranda → Kuis → Hasil → Pembahasan, plus halaman Riwayat
-StatelessWidget dan StatefulWidget sesuai kebutuhan (misalnya HomeScreen dan QuizScreen stateful, ResultScreen stateless)
-Reusable widget dalam file terpisah di lib/widgets/ (PrimaryButton, AnswerOption, CategoryCard, QuestionCard, QuestionNavigator, TimerBadge, ScoreCard, GradeBadge, StatTile, ReviewTile, HistoryTile, AppLogo, dll.)
-Aset gambar berupa logo dan ilustrasi kategori (SVG), ditambah ikon Material
-Font kustom Poppins yang disimpan di aset aplikasi, bukan font bawaan Flutter
-UI responsif dengan MediaQuery dan LayoutBuilder; ukuran elemen dan teks menyesuaikan layar, tanpa ukuran hardcode
-State management dengan Provider, sehingga jawaban, posisi soal, dan sisa waktu tidak hilang saat layar dirotasi atau berpindah halaman
-Data soal dummy lokal

**Fitur Kuis:**

-Jawaban baru dinilai setelah dikumpulkan; selama kuis jawaban bisa diganti
-Bebas berpindah soal lewat tombol Sebelumnya/Berikutnya atau daftar nomor soal
-Timer total kuis (20 detik × jumlah soal); jawaban dikumpulkan otomatis saat waktu habis
-Konfirmasi sebelum mengumpulkan, termasuk peringatan jika masih ada soal kosong
-Kuis bisa dijeda dan dilanjutkan dari beranda; timer berhenti saat aplikasi ditinggal
-Urutan soal diacak setiap kali kuis dimulai

**Fitur Penilaian & Riwayat:**

-Nilai skala 0–100 dengan predikat A (Sangat Baik) sampai E (Sangat Kurang)
-Statistik hasil: jumlah benar, salah, tidak dijawab, dan waktu pengerjaan
-Penanda rekor baru dan nilai terbaik per kategori di beranda
-Halaman pembahasan berisi jawaban pengguna, jawaban benar, dan penjelasan, dengan filter Semua/Benar/Salah
-Riwayat kuis tersimpan di perangkat (tetap ada setelah aplikasi ditutup), dengan ringkasan rata-rata dan nilai tertinggi, filter per kategori, serta hapus per item atau semua

**Fitur Bonus:**
- Dual theme (Dark & Light Mode) dengan tombol toggle di AppBar
- Adaptive & responsive design untuk perangkat tablet dan web view

---

## c. Dokumentasi

### i. Credit Sumber Aset

### i. Credit Sumber Aset

| Aset | Sumber / Pembuat | Lisensi |
|------|------------------|---------|
| Font Poppins (Regular, Medium, SemiBold, Bold) | Indian Type Foundry & Jonny Pinhorn, diunduh dari [Google Fonts](https://fonts.google.com/specimen/Poppins) | SIL Open Font License 1.1 (salinan di `assets/fonts/OFL.txt`) |
| Material Icons (ikon di seluruh aplikasi) | Google, bawaan Flutter ([fonts.google.com/icons](https://fonts.google.com/icons)) | Apache License 2.0 |
| Logo stopwatch "QUIZ" dan ilustrasi kategori (laptop, atom, globe, buku, trofi) dalam format SVG  | Milik proyek |
| Package `provider` (state management) | Remi Rousselet, [pub.dev](https://pub.dev/packages/provider) | MIT |
| Package `flutter_svg` (menampilkan gambar SVG) | Dan Field / Flutter community, [pub.dev](https://pub.dev/packages/flutter_svg) | MIT |
| Package `shared_preferences` (menyimpan riwayat) | Flutter Team (Google), [pub.dev](https://pub.dev/packages/shared_preferences) | BSD 3-Clause |
| Soal & pembahasan kuis | Disusun untuk proyek ini dari pengetahuan umum | — |

### ii. Screenshot Tiap Page Aplikasi

|https://drive.google.com/drive/folders/1_H3SvMLeNWUsG6RaNrbMHOqXtfabtWar|


### iii. Link Mockup / Prototype Aplikasi
- **Figma / Mockup:** [https://figma.com/...](#) *(isi jika ada; jika tidak, tulis: "-")*
