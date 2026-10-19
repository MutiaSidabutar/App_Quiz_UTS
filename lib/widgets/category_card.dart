import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category_model.dart';
import '../utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final bool isSelected;
  final int? bestScore;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.sp(20));

    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected
            ? category.color.withValues(alpha: 0.12)
            : scheme.surfaceContainerLow,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(context.sp(14)),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: isSelected ? category.color : scheme.outlineVariant,
                width: isSelected ? context.sp(2.5) : 1,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      category.imageAsset,
                      width: context.sp(56),
                      height: context.sp(56),
                    ),
                    SizedBox(height: context.sp(10)),
                    Text(
                      category.name,
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.help_outline_rounded,
                            size: context.sp(16), color: category.color),
                        SizedBox(width: context.sp(4)),
                        Expanded(
                          child: Text(
                            '${category.questions.length} soal',
                            style: text.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (bestScore != null) ...[
                          Icon(Icons.emoji_events_rounded,
                              size: context.sp(16), color: Colors.amber),
                          SizedBox(width: context.sp(2)),
                          Text('$bestScore', style: text.labelMedium),
                        ],
                      ],
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(Icons.check_circle_rounded,
                        color: category.color, size: context.sp(24)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
