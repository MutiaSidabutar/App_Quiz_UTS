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

| Aset | Sumber |
|------|--------|
| Font Poppins | [Google Fonts — Poppins](https://fonts.google.com/specimen/Poppins) |
| Logo |https://i.pinimg.com/1200x/c9/1f/a3/c91fa32aa73351f1da262d0c3abeb4de.jpg|
| Gambar ilustrasi | [Sumber gambar, misal: Freepik / Unsplash — cantumkan link] |
| Referensi kode | [Dokumentasi Flutter](https://docs.flutter.dev), [Provider package](https://pub.dev/packages/provider) |

### ii. Screenshot Tiap Page Aplikasi

| Home Screen | Quiz Screen | Result Screen |
|-------------|-------------|---------------|
| ![Home](screenshots/home.png) | ![Quiz](screenshots/quiz.png) | ![Result](screenshots/result.png) |

| Dark Mode | Light Mode | Tablet / Web View |
|-----------|------------|-------------------|
| ![Dark](screenshots/dark.png) | ![Light](screenshots/light.png) | ![Tablet](screenshots/tablet.png) |

### iii. Link Mockup / Prototype Aplikasi
- **Figma / Mockup:** [https://figma.com/...](#) *(isi jika ada; jika tidak, tulis: "-")*
