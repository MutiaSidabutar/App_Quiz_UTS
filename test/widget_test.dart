import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_quiz/main.dart';
import 'package:app_quiz/providers/quiz_provider.dart';
import 'package:app_quiz/widgets/answer_option.dart';
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
  testWidgets('Home menampilkan kategori dan tombol mulai', (tester) async {
    await _usePhoneScreen(tester);
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pilih Kategori'), findsOneWidget);
    expect(find.text('Teknologi'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);
  });

  testWidgets('Alur kuis lengkap sampai pembahasan', (tester) async {
    await _usePhoneScreen(tester);
    await _startScienceQuiz(tester);

    expect(find.text('Soal 1 dari 10'), findsOneWidget);

    for (var i = 0; i < 10; i++) {
      await tester.tap(find.byType(AnswerOption).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(i == 9 ? 'Lihat Hasil' : 'Soal Berikutnya'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Hasil Sains'), findsOneWidget);
    await _tapText(tester, 'Lihat Pembahasan');
    expect(find.text('Pembahasan'), findsOneWidget);
    expect(find.byType(ReviewTile), findsWidgets);
  });

  testWidgets('Soal terkunci saat waktu habis', (tester) async {
    await _usePhoneScreen(tester);
    await _startScienceQuiz(tester);

    await tester.pump(const Duration(seconds: QuizProvider.secondsPerQuestion + 1));
    await tester.pumpAndSettle();

    expect(find.text('Waktu habis!'), findsOneWidget);
    expect(find.text('Soal Berikutnya'), findsOneWidget);

    // Jeda & keluar ke Home: progres tetap tersimpan.
    await tester.tap(find.byTooltip('Jeda'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Lanjutkan kuis Sains'), findsOneWidget);
  });
}
