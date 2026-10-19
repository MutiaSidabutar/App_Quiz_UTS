import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category_model.dart';
import '../utils/responsive.dart';

/// Banner di Home ketika masih ada kuis yang belum selesai.
class ContinueQuizCard extends StatelessWidget {
  final QuizCategory category;
  final int answered;
  final int total;
  final VoidCallback onContinue;

  const ContinueQuizCard({
    super.key,
    required this.category,
    required this.answered,
    required this.total,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      color: category.color.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onContinue,
        borderRadius: BorderRadius.circular(context.sp(20)),
        child: Padding(
          padding: EdgeInsets.all(context.sp(14)),
          child: Row(
            children: [
              SvgPicture.asset(category.imageAsset,
                  width: context.sp(44), height: context.sp(44)),
              SizedBox(width: context.sp(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lanjutkan kuis ${category.name}',
                        style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: context.sp(6)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(context.sp(8)),
                      child: LinearProgressIndicator(
                        value: answered / total,
                        minHeight: context.sp(6),
                        color: category.color,
                        backgroundColor: category.color.withValues(alpha: 0.2),
                      ),
                    ),
                    SizedBox(height: context.sp(4)),
                    Text('$answered dari $total soal terjawab', style: text.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.play_circle_fill_rounded,
                  color: category.color, size: context.sp(40)),
            ],
          ),
        ),
      ),
    );
  }
}
