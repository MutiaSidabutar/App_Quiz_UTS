import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';

/// Status tampilan sebuah pilihan jawaban.
enum AnswerStatus { idle, correct, wrong, dimmed }

class AnswerOption extends StatelessWidget {
  final String label; // A, B, C, D
  final String text;
  final AnswerStatus status;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.text,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(context.sp(16));

    final Color accent = switch (status) {
      AnswerStatus.correct => AppTheme.correct,
      AnswerStatus.wrong => AppTheme.wrong,
      _ => scheme.primary,
    };
    final highlighted =
        status == AnswerStatus.correct || status == AnswerStatus.wrong;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.sp(6)),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: status == AnswerStatus.dimmed ? 0.55 : 1,
        child: Material(
          color: highlighted
              ? accent.withValues(alpha: 0.12)
              : scheme.surfaceContainerLow,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: context.sp(14),
                vertical: context.sp(12),
              ),
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  color: highlighted ? accent : scheme.outlineVariant,
                  width: highlighted ? context.sp(2) : 1,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: context.sp(36),
                    height: context.sp(36),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: highlighted ? accent : scheme.primaryContainer,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: highlighted ? Colors.white : scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(width: context.sp(12)),
                  Expanded(
                    child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  if (highlighted)
                    Icon(
                      status == AnswerStatus.correct
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: accent,
                      size: context.sp(26),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
