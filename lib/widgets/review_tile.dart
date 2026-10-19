import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';

/// Satu butir pembahasan: soal, jawaban pengguna, jawaban benar, penjelasan.
class ReviewTile extends StatelessWidget {
  final int number;
  final Question question;
  final int? userAnswer;

  const ReviewTile({
    super.key,
    required this.number,
    required this.question,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isCorrect = userAnswer == question.correctIndex;
    final color = isCorrect ? AppTheme.correct : AppTheme.wrong;

    return Card(
      margin: EdgeInsets.symmetric(vertical: context.sp(6)),
      child: Theme(
        // Hilangkan garis pemisah bawaan ExpansionTile.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: context.sp(14),
            vertical: context.sp(4),
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            context.sp(14), 0, context.sp(14), context.sp(14),
          ),
          leading: CircleAvatar(
            radius: context.sp(18),
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: color,
              size: context.sp(20),
            ),
          ),
          title: Text('$number. ${question.questionText}',
              style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnswerLine(
              label: 'Jawabanmu',
              value: userAnswer == null
                  ? 'Tidak dijawab (waktu habis)'
                  : question.options[userAnswer!],
              color: color,
            ),
            if (!isCorrect)
              _AnswerLine(
                label: 'Jawaban benar',
                value: question.correctAnswer,
                color: AppTheme.correct,
              ),
            if (question.explanation.isNotEmpty) ...[
              SizedBox(height: context.sp(8)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      size: context.sp(18), color: Colors.amber.shade700),
                  SizedBox(width: context.sp(6)),
                  Expanded(child: Text(question.explanation, style: text.bodyMedium)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AnswerLine({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(top: context.sp(4)),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$label: ', style: text.bodyMedium),
            TextSpan(
              text: value,
              style: text.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
