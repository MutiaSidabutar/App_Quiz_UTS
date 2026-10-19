import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Kotak statistik kecil (ikon, nilai, label) di halaman hasil.
class StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(context.sp(12)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.sp(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: context.sp(26)),
          SizedBox(height: context.sp(4)),
          Text(value,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: color)),
          Text(label,
              style: text.bodySmall, textAlign: TextAlign.center, maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
