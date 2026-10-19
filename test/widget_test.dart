import 'package:flutter_test/flutter_test.dart';

import 'package:app_quiz/main.dart';

void main() {
  testWidgets('Home screen tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Quiz App'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);
  });
}
