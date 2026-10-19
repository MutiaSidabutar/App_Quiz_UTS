# App_Quiz_UTS

Aplikasi kuis interaktif berbasis Flutter dengan 4 kategori (Teknologi, Sains, Geografi, Sejarah), masing-masing berisi 10 soal beserta pembahasan.

## Fitur

- **Kategori kuis** dengan ilustrasi dan skor terbaik per kategori
- **Timer 20 detik per soal**; soal terkunci otomatis saat waktu habis
- **Umpan balik langsung**: jawaban benar/salah ditandai warna, disertai pembahasan
- **Jeda & lanjutkan kuis**: progres tetap tersimpan saat kembali ke beranda, layar dirotasi, atau aplikasi ditinggal ke background (timer ikut berhenti)
- **Halaman hasil**: persentase skor, bintang, statistik (benar, salah, waktu habis, rata-rata waktu), penanda rekor baru
- **Halaman pembahasan** dengan filter Semua / Benar / Salah
- **Mode terang & gelap**
- **Responsif & adaptif**: satu kolom di HP portrait, dua kolom di landscape, tablet, dan web

## Pemenuhan Persyaratan

| Persyaratan | Implementasi |
|---|---|
| StatelessWidget & StatefulWidget | Stateful: `HomeScreen` (input nama), `QuizScreen` (lifecycle timer), `ReviewScreen` (filter). Stateless: `ResultScreen` dan seluruh widget di `lib/widgets/` |
| Minimal 2 halaman + navigasi | 4 halaman: Home → Quiz → Result → Review (named routes di `lib/main.dart`) |
| Reusable widget di file terpisah | `lib/widgets/`: `PrimaryButton`, `AnswerOption`, `CategoryCard`, `QuestionCard`, `TimerBadge`, `FeedbackBanner`, `ScoreCard`, `StatTile`, `ReviewTile`, `AppLogo`, dll. |
| Aset gambar/ikon | `assets/images/` (logo & ilustrasi SVG) + Material Icons |
| Font kustom | Poppins (Regular, Medium, SemiBold, Bold) di `assets/fonts/` |
| Ukuran UI dinamis | `lib/utils/responsive.dart`: `context.sp()`, `rw()`, `rh()`, breakpoint perangkat, dan skala teks global |
| State management | `provider`: `QuizProvider` (progres, jawaban, timer, skor) & `ThemeProvider`, dipasang di atas `MaterialApp` |
| Tanpa database | Soal berupa data lokal di `lib/data/question_bank.dart` |
| Dual-theme (bonus) | `ThemeProvider` + `AppTheme.light` / `AppTheme.dark` |
| Adaptive & responsive (bonus) | `ResponsiveCenter` + `useTwoColumns()` untuk tablet, landscape, dan web |

## Struktur Folder

```
lib/
├── data/        # bank soal (dummy)
├── models/      # Question, QuizCategory
├── providers/   # QuizProvider, ThemeProvider
├── screens/     # home, quiz, result, review
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
