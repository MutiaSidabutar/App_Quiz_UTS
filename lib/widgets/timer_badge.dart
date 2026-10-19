import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';

/// Indikator hitung mundur melingkar; berubah merah saat waktu hampir habis.
class TimerBadge extends StatelessWidget {
  final int remaining;
  final int total;

  const TimerBadge({super.key, required this.remaining, required this.total});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final warning = remaining <= 5;
    final color = warning ? AppTheme.wrong : scheme.primary;
    final size = context.sp(40);

    return Semantics(
      label: 'Sisa waktu $remaining detik',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(end: remaining / total),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, _) => CircularProgressIndicator(
                value: value,
                strokeWidth: context.sp(4),
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            Center(
              child: Text(
                '$remaining',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
