import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/review_screen.dart';
import 'themes/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Quiz App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.themeMode,
          // Skala teks global mengikuti ukuran layar (tetap menghormati
          // pengaturan ukuran font dari sistem).
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            final factor = (mq.size.shortestSide / 390).clamp(0.9, 1.25);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: TextScaler.linear(mq.textScaler.scale(1) * factor),
              ),
              child: child!,
            );
          },
          initialRoute: '/',
          routes: {
            '/': (_) => const HomeScreen(),
            '/quiz': (_) => const QuizScreen(),
            '/result': (_) => const ResultScreen(),
            '/review': (_) => const ReviewScreen(),
          },
        ),
      ),
    );
  }
}
