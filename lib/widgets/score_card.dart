import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final String userName;
  final int score;
  final int total;

  const ScoreCard({
    super.key,
    required this.userName,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nama: $userName'),
            const SizedBox(height: 8),
            Text(
              'Skor: $score / $total',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
