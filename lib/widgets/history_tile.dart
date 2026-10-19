import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category_model.dart';
import '../models/quiz_history_model.dart';
import '../utils/date_format.dart';
import '../utils/grading.dart';
import '../utils/responsive.dart';
import 'grade_badge.dart';
import 'timer_badge.dart';

/// Satu baris riwayat kuis: kategori, nama, tanggal, skor, durasi, nilai.
class HistoryTile extends StatelessWidget {
  final QuizHistory entry;
  final QuizCategory? category;

  const HistoryTile({super.key, required this.entry, this.category});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final grade = Grade.fromNilai(entry.nilai);

    return Card(
      margin: EdgeInsets.symmetric(vertical: context.sp(6)),
      child: Padding(
        padding: EdgeInsets.all(context.sp(14)),
        child: Row(
          children: [
            if (category != null)
              SvgPicture.asset(category!.imageAsset,
                  width: context.sp(46), height: context.sp(46))
            else
              Icon(Icons.quiz_rounded, size: context.sp(46)),
            SizedBox(width: context.sp(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.categoryName,
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  if (entry.userName.isNotEmpty)
                    Text(entry.userName, style: text.bodyMedium),
                  SizedBox(height: context.sp(4)),
                  Wrap(
                    spacing: context.sp(10),
                    runSpacing: context.sp(2),
                    children: [
                      _Meta(
                        icon: Icons.check_circle_outline_rounded,
                        label: '${entry.score}/${entry.total} benar',
                      ),
                      _Meta(
                        icon: Icons.timer_outlined,
                        label: TimerBadge.format(entry.durationSeconds),
                      ),
                    ],
                  ),
                  SizedBox(height: context.sp(2)),
                  Text(formatDateTime(entry.date),
                      style: text.bodySmall?.copyWith(color: muted)),
                ],
              ),
            ),
            SizedBox(width: context.sp(8)),
            Column(
              children: [
                GradeBadge(nilai: entry.nilai),
                SizedBox(height: context.sp(4)),
                Text(grade.label,
                    style: text.labelSmall?.copyWith(color: grade.color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Meta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.sp(15), color: muted),
        SizedBox(width: context.sp(3)),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: muted),
          ),
        ),
      ],
    );
  }
}
