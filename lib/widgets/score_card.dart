import 'package:flutter/material.dart';
import '../utils/grading.dart';
import '../utils/responsive.dart';

/// Kartu nilai (0–100) dengan cincin beranimasi dan predikat.
class ScoreCard extends StatelessWidget {
  final String userName;
  final int score;
  final int total;

  const ScoreCard({
    super.key,
    required this.userName,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final nilai = calculateNilai(score, total);
    final grade = Grade.fromNilai(nilai);
    final ringSize = context.sp(150);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.sp(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName.isEmpty ? 'Nilai kamu' : 'Nilai $userName',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.sp(16)),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: nilai / 100),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => SizedBox(
                width: ringSize,
                height: ringSize,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: context.sp(12),
                      strokeCap: StrokeCap.round,
                      color: grade.color,
                      backgroundColor: grade.color.withValues(alpha: 0.15),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(value * 100).round()}',
                            style: text.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: grade.color,
                            ),
                          ),
                          Text('dari 100', style: text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.sp(16)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.sp(14),
                vertical: context.sp(6),
              ),
              decoration: BoxDecoration(
                color: grade.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(context.sp(20)),
              ),
              child: Text(
                'Predikat ${grade.letter} · ${grade.label}',
                style: text.titleSmall?.copyWith(
                  color: grade.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: context.sp(6)),
            Text('$score dari $total jawaban benar', style: text.bodyMedium),
          ],
        ),
      ),
    );
  }
}
