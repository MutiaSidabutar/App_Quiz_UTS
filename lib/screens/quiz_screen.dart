import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option.dart';
import '../widgets/primary_button.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    if (!p.hasQuizInProgress) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = p.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ${p.currentIndex + 1}/${p.totalQuestions}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (p.currentIndex) / p.questions.length,
            ),
            const SizedBox(height: 20),
            Text(q.questionText, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (i) {
              return AnswerOption(
                text: q.options[i],
                isSelected: p.selectedAnswer == i,
                onTap: () => p.selectAnswer(i),
              );
            }),
            const Spacer(),
            PrimaryButton(
              label: 'Lanjut',
              onPressed: p.selectedAnswer == null
                  ? null
                  : () {
                      final last = p.isLastQuestion;
                      p.nextQuestion();
                      if (last) Navigator.pushReplacementNamed(context, '/result');
                    },
            ),
          ],
        ),
      ),
    );
  }
}
