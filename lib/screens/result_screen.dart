import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/primary_button.dart';
import '../widgets/responsive_center.dart';
import '../widgets/score_card.dart';
import '../widgets/stat_tile.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static ({String title, String message, int stars}) _grade(double ratio) {
    if (ratio >= 0.9) {
      return (title: 'Luar biasa!', message: 'Kamu menguasai materi ini.', stars: 3);
    }
    if (ratio >= 0.7) {
      return (title: 'Hebat!', message: 'Sedikit lagi menuju sempurna.', stars: 2);
    }
    if (ratio >= 0.5) {
      return (title: 'Lumayan!', message: 'Pelajari pembahasan untuk hasil lebih baik.', stars: 1);
    }
    return (title: 'Tetap semangat!', message: 'Coba lagi, kamu pasti bisa.', stars: 0);
  }

  void _goHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
    context.read<QuizProvider>().resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    final category = p.selectedCategory;
    if (category == null || p.totalQuestions == 0) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final grade = _grade(p.percentage);
    final text = Theme.of(context).textTheme;

    final summary = Column(
      children: [
        SvgPicture.asset(
          'assets/images/trophy.svg',
          height: context.screenSize.shortestSide * (context.isLandscape ? 0.22 : 0.3),
        ),
        SizedBox(height: context.sp(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + i * 250),
              curve: Curves.elasticOut,
              builder: (context, v, child) => Transform.scale(scale: v, child: child),
              child: Icon(
                i < grade.stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: Colors.amber,
                size: context.sp(40),
              ),
            ),
          ),
        ),
        Text(grade.title,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        Text(grade.message, textAlign: TextAlign.center, style: text.bodyMedium),
        if (p.isNewBest && p.score > 0) ...[
          SizedBox(height: context.sp(8)),
          Chip(
            avatar: const Icon(Icons.workspace_premium_rounded, color: Colors.amber),
            label: Text('Rekor baru kategori ${category.name}!'),
          ),
        ],
        SizedBox(height: context.sp(12)),
        ScoreCard(
          userName: p.userName,
          score: p.score,
          total: p.totalQuestions,
          color: category.color,
        ),
      ],
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatGrid(
          spacing: context.sp(10),
          children: [
            StatTile(
              icon: Icons.check_circle_rounded,
              value: '${p.score}',
              label: 'Benar',
              color: AppTheme.correct,
            ),
            StatTile(
              icon: Icons.cancel_rounded,
              value: '${p.wrongCount}',
              label: 'Salah',
              color: AppTheme.wrong,
            ),
            StatTile(
              icon: Icons.timer_off_rounded,
              value: '${p.unansweredCount}',
              label: 'Waktu habis',
              color: Colors.orange.shade700,
            ),
            StatTile(
              icon: Icons.speed_rounded,
              value: '${p.averageSeconds.toStringAsFixed(1)} dtk',
              label: 'Rata-rata / soal',
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        SizedBox(height: context.sp(20)),
        PrimaryButton(
          label: 'Lihat Pembahasan',
          icon: Icons.menu_book_rounded,
          onPressed: () => Navigator.pushNamed(context, '/review'),
        ),
        SizedBox(height: context.sp(10)),
        PrimaryButton(
          label: 'Ulangi Kuis',
          icon: Icons.replay_rounded,
          outlined: true,
          onPressed: () {
            context.read<QuizProvider>().startQuiz();
            Navigator.pushReplacementNamed(context, '/quiz');
          },
        ),
        SizedBox(height: context.sp(10)),
        PrimaryButton(
          label: 'Kembali ke Beranda',
          icon: Icons.home_rounded,
          outlined: true,
          onPressed: () => _goHome(context),
        ),
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hasil ${category.name}'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: context.sp(16)),
            child: ResponsiveCenter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: summary),
                        SizedBox(width: context.sp(24)),
                        Expanded(child: details),
                      ],
                    );
                  }
                  return Column(
                    children: [summary, SizedBox(height: context.sp(20)), details],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid 2 kolom yang tingginya mengikuti isi (tidak overflow saat teks besar).
class _StatGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const _StatGrid({required this.children, required this.spacing});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      if (i > 0) rows.add(SizedBox(height: spacing));
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: children[i]),
            SizedBox(width: spacing),
            Expanded(
              child: i + 1 < children.length ? children[i + 1] : const SizedBox(),
            ),
          ],
        ),
      ));
    }
    return Column(children: rows);
  }
}
