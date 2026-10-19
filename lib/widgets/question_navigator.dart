import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Deretan nomor soal untuk berpindah soal secara bebas.
/// Nomor yang sudah dijawab diberi warna penuh.
class QuestionNavigator extends StatelessWidget {
  final int total;
  final int current;
  final List<int?> answers;
  final ValueChanged<int> onSelect;

  const QuestionNavigator({
    super.key,
    required this.total,
    required this.current,
    required this.answers,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = context.sp(38);

    return Wrap(
      spacing: context.sp(8),
      runSpacing: context.sp(8),
      children: List.generate(total, (i) {
        final answered = answers[i] != null;
        final isCurrent = i == current;
        return Semantics(
          button: true,
          label: 'Soal ${i + 1}${answered ? ', sudah dijawab' : ''}',
          child: InkWell(
            onTap: () => onSelect(i),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: answered ? scheme.primary : scheme.surfaceContainerHighest,
                border: Border.all(
                  color: isCurrent ? scheme.tertiary : Colors.transparent,
                  width: context.sp(3),
                ),
              ),
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: answered ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
