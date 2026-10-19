import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';

/// Umpan balik setelah menjawab: benar / salah / waktu habis + pembahasan.
class FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final bool isTimedOut;
  final String correctAnswer;
  final String explanation;

  const FeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.isTimedOut,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = isCorrect
        ? AppTheme.correct
        : (isTimedOut ? Colors.orange.shade700 : AppTheme.wrong);
    final title = isCorrect
        ? 'Jawaban benar!'
        : (isTimedOut ? 'Waktu habis!' : 'Jawaban kurang tepat');
    final icon = isCorrect
        ? Icons.celebration_rounded
        : (isTimedOut ? Icons.timer_off_rounded : Icons.lightbulb_rounded);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: 0.9 + 0.1 * value,
        child: Opacity(opacity: value.clamp(0, 1), child: child),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.sp(14)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(context.sp(16)),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: context.sp(28)),
            SizedBox(width: context.sp(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: text.titleMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.w700)),
                  if (!isCorrect)
                    Text('Jawaban yang benar: $correctAnswer',
                        style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  if (explanation.isNotEmpty) ...[
                    SizedBox(height: context.sp(4)),
                    Text(explanation, style: text.bodyMedium),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
