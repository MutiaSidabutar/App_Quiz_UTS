import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:app_quiz/main.dart';
import 'package:app_quiz/providers/theme_provider.dart';
import 'package:app_quiz/widgets/answer_option.dart';

const sizes = {
  'phone': Size(390, 844),
  'landscape': Size(844, 390),
  'tablet': Size(820, 1180),
  'desktop': Size(1440, 900),
};

/// Menjalankan alur lengkap di berbagai ukuran layar & tema; test gagal
/// bila ada overflow atau error layout.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final dark in [false, true]) {
    for (final e in sizes.entries) {
      final tag = '${e.key}_${dark ? 'dark' : 'light'}';
      testWidgets(tag, (tester) async {
        tester.view.physicalSize = e.value * 2;
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        if (dark) {
          tester.element(find.byType(Scaffold)).read<ThemeProvider>().toggleTheme();
          await tester.pumpAndSettle();
        }
        await tester.enterText(find.byType(TextField), 'Mutia');
        await tester.ensureVisible(find.text('Sains'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Sains'));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
        await tester.pumpAndSettle();
        final start = find.text('Mulai Kuis');
        await tester.ensureVisible(start);
        await tester.pumpAndSettle();
        await tester.tap(start);
        await tester.pumpAndSettle();
        for (var i = 0; i < 10; i++) {
          final option = find.byType(AnswerOption).at(i % 4);
          await tester.ensureVisible(option);
          await tester.pumpAndSettle();
          await tester.tap(option);
          await tester.pumpAndSettle();
          final next = find.text(i == 9 ? 'Kumpulkan' : 'Berikutnya');
          await tester.tap(next);
          await tester.pumpAndSettle();
        }
        await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text('Kumpulkan')));
        await tester.pumpAndSettle();
        final review = find.text('Lihat Pembahasan');
        await tester.ensureVisible(review);
        await tester.pumpAndSettle();
        await tester.tap(review);
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('1. ').first);
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        final history = find.text('Lihat Riwayat');
        await tester.ensureVisible(history);
        await tester.pumpAndSettle();
        await tester.tap(history);
        await tester.pumpAndSettle();
        expect(find.text('Riwayat Kuis'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Kembali ke Beranda').hitTestable().first, warnIfMissed: false);
        await tester.pumpAndSettle();
      });
    }
  }
}
