import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/responsive.dart';

class QuestionCard extends StatelessWidget {
  final int number;
  final String question;
  final String imageAsset;
  final Color color;

  const QuestionCard({
    super.key,
    required this.number,
    required this.question,
    required this.imageAsset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.sp(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(imageAsset,
                    width: context.sp(36), height: context.sp(36)),
                SizedBox(width: context.sp(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.sp(10),
                    vertical: context.sp(4),
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(context.sp(20)),
                  ),
                  child: Text(
                    'Pertanyaan $number',
                    style: text.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.sp(14)),
            Text(
              question,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
