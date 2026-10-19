import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';

/// Sisa waktu kuis (mm:ss); berubah merah saat waktu hampir habis.
class TimerBadge extends StatelessWidget {
  final int remaining;
  final int total;

  const TimerBadge({super.key, required this.remaining, required this.total});

  static String format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final warning = remaining <= 30;
    final color = warning ? AppTheme.wrong : scheme.primary;
    final ringSize = context.sp(20);

    return Semantics(
      label: 'Sisa waktu ${format(remaining)}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: context.sp(10),
          vertical: context.sp(6),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(context.sp(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: ringSize,
              height: ringSize,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: total == 0 ? 0 : remaining / total),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: context.sp(3),
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.2),
                ),
              ),
            ),
            SizedBox(width: context.sp(8)),
            Text(
              format(remaining),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
