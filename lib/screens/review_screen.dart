import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_center.dart';
import '../widgets/review_tile.dart';

enum _ReviewFilter { all, correct, wrong }

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  _ReviewFilter _filter = _ReviewFilter.all;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    final questions = p.questions;
    final answers = p.answers;

    final indexes = [
      for (var i = 0; i < questions.length; i++)
        if (switch (_filter) {
          _ReviewFilter.all => true,
          _ReviewFilter.correct => answers[i] == questions[i].correctIndex,
          _ReviewFilter.wrong => answers[i] != questions[i].correctIndex,
        })
          i,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pembahasan')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.sp(12)),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<_ReviewFilter>(
                    segments: [
                      ButtonSegment(
                        value: _ReviewFilter.all,
                        label: Text('Semua (${questions.length})'),
                      ),
                      ButtonSegment(
                        value: _ReviewFilter.correct,
                        label: Text('Benar (${p.score})'),
                      ),
                      ButtonSegment(
                        value: _ReviewFilter.wrong,
                        label: Text('Salah (${questions.length - p.score})'),
                      ),
                    ],
                    selected: {_filter},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) => setState(() => _filter = s.first),
                  ),
                ),
              ),
              Expanded(
                child: indexes.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada soal di kategori ini.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: context.sp(16)),
                        itemCount: indexes.length,
                        itemBuilder: (context, i) {
                          final index = indexes[i];
                          return ReviewTile(
                            number: index + 1,
                            question: questions[index],
                            userAnswer: answers[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
