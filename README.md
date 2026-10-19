# App_Quiz_UTS

Aplikasi kuis interaktif berbasis Flutter dengan 4 kategori (Teknologi, Sains, Geografi, Sejarah), masing-masing berisi 10 soal beserta pembahasan.

## Fitur

- **Kategori kuis** dengan ilustrasi dan skor terbaik per kategori
- **Jawaban dinilai di akhir**: jawaban bisa diganti dan berpindah soal bebas (Sebelumnya/Berikutnya + daftar nomor soal); benar/salah baru terlihat setelah dikumpulkan
- **Timer total kuis** (20 detik x jumlah soal); jawaban dikumpulkan otomatis saat waktu habis
- **Jeda & lanjutkan kuis**: progres tetap tersimpan saat kembali ke beranda, layar dirotasi, atau aplikasi ditinggal ke background (timer ikut berhenti)
- **Nilai 0–100 dan predikat** A (Sangat Baik) s.d. E (Sangat Kurang)
- **Halaman hasil**: nilai, bintang, statistik (benar, salah, tidak dijawab, waktu pengerjaan), penanda rekor baru
- **Halaman pembahasan** dengan filter Semua / Benar / Salah
- **Riwayat kuis**: tersimpan di perangkat (tetap ada setelah aplikasi ditutup), ringkasan rata-rata & nilai tertinggi, filter per kategori, geser untuk menghapus
- **Mode terang & gelap**
- **Responsif & adaptif**: satu kolom di HP portrait, dua kolom di landscape, tablet, dan web

## Pemenuhan Persyaratan

| Persyaratan | Implementasi |
|---|---|
| StatelessWidget & StatefulWidget | Stateful: `HomeScreen` (input nama), `QuizScreen` (lifecycle timer), `ReviewScreen` & `HistoryScreen` (filter). Stateless: `ResultScreen` dan seluruh widget di `lib/widgets/` |
| Minimal 2 halaman + navigasi | 5 halaman: Home → Quiz → Result → Review, plus History (named routes di `lib/main.dart`) |
| Reusable widget di file terpisah | `lib/widgets/`: `PrimaryButton`, `AnswerOption`, `CategoryCard`, `QuestionCard`, `QuestionNavigator`, `TimerBadge`, `ScoreCard`, `GradeBadge`, `StatTile`, `ReviewTile`, `HistoryTile`, `AppLogo`, dll. |
| Aset gambar/ikon | `assets/images/` (logo & ilustrasi SVG) + Material Icons |
| Font kustom | Poppins (Regular, Medium, SemiBold, Bold) di `assets/fonts/` |
| Ukuran UI dinamis | `lib/utils/responsive.dart`: `context.sp()`, `rw()`, `rh()`, breakpoint perangkat, dan skala teks global |
| State management | `provider`: `QuizProvider` (progres, jawaban, timer, skor) & `ThemeProvider`, dipasang di atas `MaterialApp` |
| Tanpa database | Soal berupa data lokal di `lib/data/question_bank.dart`; riwayat disimpan di `SharedPreferences` (penyimpanan key-value lokal, bukan database) |
| Dual-theme (bonus) | `ThemeProvider` + `AppTheme.light` / `AppTheme.dark` |
| Adaptive & responsive (bonus) | `ResponsiveCenter` + `useTwoColumns()` untuk tablet, landscape, dan web |

## Struktur Folder

```
lib/
├── data/        # bank soal (dummy)
├── models/      # Question, QuizCategory
├── providers/   # QuizProvider, ThemeProvider
├── screens/     # home, quiz, result, review, history
├── services/    # penyimpanan riwayat (SharedPreferences)
├── themes/      # AppTheme
├── utils/       # helper ukuran responsif
└── widgets/     # komponen UI reusable
```

## Menjalankan

```bash
flutter pub get
flutter run          # Android / iOS / desktop
flutter run -d chrome
flutter test         # widget test & test responsif
```

## Lisensi Aset

Font Poppins dilisensikan di bawah SIL Open Font License (`assets/fonts/OFL.txt`). Logo dan ilustrasi SVG dibuat khusus untuk proyek ini.
