import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_quiz/main.dart';
import 'package:app_quiz/providers/quiz_provider.dart';
import 'package:app_quiz/widgets/answer_option.dart';
import 'package:app_quiz/widgets/history_tile.dart';
import 'package:app_quiz/widgets/review_tile.dart';

Future<void> _usePhoneScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _startScienceQuiz(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.enterText(find.byType(TextField), 'Budi');
  await _tapText(tester, 'Sains');
  await _tapText(tester, 'Mulai Kuis');
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Home menampilkan kategori dan tombol mulai', (tester) async {
    await _usePhoneScreen(tester);
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pilih Kategori'), findsOneWidget);
    expect(find.text('Teknologi'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);
  });

  testWidgets('Jawaban baru dinilai setelah dikumpulkan', (tester) async {
    await _usePhoneScreen(tester);
    await _startScienceQuiz(tester);

    expect(find.text('Soal 1 dari 10'), findsOneWidget);

    // Memilih jawaban tidak langsung menampilkan benar/salah.
    await tester.tap(find.byType(AnswerOption).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    expect(find.byIcon(Icons.cancel_rounded), findsNothing);

    // Bisa kembali ke soal sebelumnya dan mengganti jawaban.
    await tester.tap(find.text('Berikutnya'));
    await tester.pumpAndSettle();
    expect(find.text('Soal 2 dari 10'), findsOneWidget);
    await tester.tap(find.byTooltip('Sebelumnya'));
    await tester.pumpAndSettle();
    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    await tester.tap(find.byType(AnswerOption).last);
    await tester.pumpAndSettle();

    for (var i = 0; i < 9; i++) {
      await tester.tap(find.text('Berikutnya'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AnswerOption).first);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Kumpulkan'));
    await tester.pumpAndSettle();
    expect(find.text('Kumpulkan jawaban?'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text('Kumpulkan')));
    await tester.pumpAndSettle();

    expect(find.text('Hasil Sains'), findsOneWidget);
    await _tapText(tester, 'Lihat Pembahasan');
    expect(find.text('Pembahasan'), findsOneWidget);
    expect(find.byType(ReviewTile), findsWidgets);
  });

  testWidgets('Jawaban dikumpulkan otomatis saat waktu habis', (tester) async {
    await _usePhoneScreen(tester);
    await _startScienceQuiz(tester);

    // Jeda & keluar ke Home: progres tetap tersimpan, timer berhenti.
    await tester.tap(find.byType(AnswerOption).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Jeda'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Lanjutkan kuis Sains'), findsOneWidget);
    expect(find.text('1 dari 10 soal terjawab'), findsOneWidget);

    await tester.tap(find.text('Lanjutkan kuis Sains'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: QuizProvider.secondsPerQuestion * 10 + 1));
    await tester.pumpAndSettle();

    expect(find.text('Hasil Sains'), findsOneWidget);
    expect(find.text('Waktu habis! Jawaban dikumpulkan otomatis.'), findsOneWidget);
  });

  testWidgets('Kuis selesai tercatat di riwayat dengan nilai', (tester) async {
    await _usePhoneScreen(tester);
    await _startScienceQuiz(tester);

    // Kumpulkan tanpa menjawab: nilai 0, predikat E.
    for (var i = 0; i < 9; i++) {
      await tester.tap(find.text('Berikutnya'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Kumpulkan'));
    await tester.pumpAndSettle();
    expect(find.text('Masih ada 10 soal yang belum dijawab dan akan dianggap salah.'),
        findsOneWidget);
    await tester.tap(
        find.descendant(of: find.byType(AlertDialog), matching: find.text('Kumpulkan')));
    await tester.pumpAndSettle();
    expect(find.text('Predikat E · Sangat Kurang'), findsOneWidget);

    await _tapText(tester, 'Lihat Riwayat');
    expect(find.text('Riwayat Kuis'), findsOneWidget);
    expect(find.byType(HistoryTile), findsOneWidget);
    expect(find.text('Budi'), findsOneWidget);

    // Riwayat tetap ada setelah aplikasi dibuka ulang.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Riwayat'));
    await tester.pumpAndSettle();
    expect(find.byType(HistoryTile), findsOneWidget);
  });
}
