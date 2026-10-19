import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Kartu skor dengan indikator persentase melingkar yang beranimasi.
class ScoreCard extends StatelessWidget {
  final String userName;
  final int score;
  final int total;
  final Color color;

  const ScoreCard({
    super.key,
    required this.userName,
    required this.score,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final ratio = total == 0 ? 0.0 : score / total;
    final ringSize = context.sp(140);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.sp(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName.isEmpty ? 'Skor kamu' : 'Skor $userName',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.sp(16)),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
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
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.15),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(value * 100).round()}%',
                            style: text.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          Text('$score / $total', style: text.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
