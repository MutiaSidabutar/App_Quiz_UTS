import 'package:flutter/material.dart';
import '../utils/grading.dart';
import '../utils/responsive.dart';

/// Lencana nilai: angka 0–100 dengan huruf predikat berwarna.
class GradeBadge extends StatelessWidget {
  final int nilai;

  /// Diameter lencana sebelum diskalakan (dp).
  final double size;

  const GradeBadge({super.key, required this.nilai, this.size = 52});

  @override
  Widget build(BuildContext context) {
    final grade = Grade.fromNilai(nilai);
    final d = context.sp(size);
    return Semantics(
      label: 'Nilai $nilai, predikat ${grade.letter}',
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: grade.color.withValues(alpha: 0.14),
          border: Border.all(color: grade.color, width: context.sp(2)),
        ),
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(d * 0.18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$nilai',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: grade.color,
                    height: 1.1,
                  ),
                ),
                Text(
                  grade.letter,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: grade.color,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
