import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/answer_option.dart';
import '../widgets/primary_button.dart';
import '../widgets/question_card.dart';
import '../widgets/question_navigator.dart';
import '../widgets/responsive_center.dart';
import '../widgets/timer_badge.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  late final QuizProvider _quiz;
  bool _dialogOpen = false;
  bool _navigatedToResult = false;

  @override
  void initState() {
    super.initState();
    _quiz = context.read<QuizProvider>();
    WidgetsBinding.instance.addObserver(this);
    // Lanjutkan timer saat kembali dari Home ("Lanjutkan kuis").
    WidgetsBinding.instance.addPostFrameCallback((_) => _quiz.resumeTimer());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _quiz.pauseTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Timer tidak berjalan saat aplikasi di background.
    if (state == AppLifecycleState.resumed && !_dialogOpen) {
      _quiz.resumeTimer();
    } else if (state != AppLifecycleState.resumed) {
      _quiz.pauseTimer();
    }
  }

  Future<bool?> _showPausedDialog(WidgetBuilder builder) async {
    _quiz.pauseTimer();
    _dialogOpen = true;
    final result = await showDialog<bool>(context: context, builder: builder);
    _dialogOpen = false;
    return result;
  }

  Future<void> _confirmExit() async {
    final exit = await _showPausedDialog(
      (ctx) => AlertDialog(
        icon: const Icon(Icons.pause_circle_rounded),
        title: const Text('Jeda kuis?'),
        content: const Text(
          'Jawabanmu tersimpan. Kamu bisa melanjutkannya dari halaman beranda.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (exit == true) {
      Navigator.pop(context);
    } else {
      _quiz.resumeTimer();
    }
  }

  Future<void> _confirmSubmit() async {
    final unanswered = _quiz.unansweredCount;
    final submit = await _showPausedDialog(
      (ctx) => AlertDialog(
        icon: const Icon(Icons.assignment_turned_in_rounded),
        title: const Text('Kumpulkan jawaban?'),
        content: Text(
          unanswered == 0
              ? 'Semua soal sudah dijawab. Jawaban tidak dapat diubah setelah dikumpulkan.'
              : 'Masih ada $unanswered soal yang belum dijawab dan akan dianggap salah.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Periksa lagi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Kumpulkan'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (submit == true) {
      _quiz.submitQuiz();
    } else {
      _quiz.resumeTimer();
    }
  }

  void _goToResult() {
    if (_navigatedToResult) return;
    _navigatedToResult = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_quiz.isTimeUp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waktu habis! Jawaban dikumpulkan otomatis.')),
        );
      }
      Navigator.pushReplacementNamed(context, '/result');
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    if (p.isFinished) _goToResult();
    if (!p.hasQuizInProgress) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final category = p.selectedCategory!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Jeda',
            icon: const Icon(Icons.close_rounded),
            onPressed: _confirmExit,
          ),
          title: Text(category.name),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: context.sp(12)),
              child: Center(
                child: TimerBadge(remaining: p.remainingSeconds, total: p.totalSeconds),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: ResponsiveCenter(
            child: Column(
              children: [
                _ProgressHeader(
                  current: p.currentIndex + 1,
                  total: p.totalQuestions,
                  answered: p.answeredCount,
                  color: category.color,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    // Soal selalu menempel di atas, bukan di tengah layar.
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.topCenter,
                      children: [...previous, ?current],
                    ),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: _QuestionBody(key: ValueKey(p.currentIndex)),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: ResponsiveCenter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.sp(12)),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'Sebelumnya',
                      icon: Icons.arrow_back_rounded,
                      outlined: true,
                      onPressed: p.isFirstQuestion ? null : p.previousQuestion,
                    ),
                  ),
                  SizedBox(width: context.sp(12)),
                  Expanded(
                    child: p.isLastQuestion
                        ? PrimaryButton(
                            label: 'Kumpulkan',
                            icon: Icons.send_rounded,
                            onPressed: _confirmSubmit,
                          )
                        : PrimaryButton(
                            label: 'Berikutnya',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: p.nextQuestion,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int current;
  final int total;
  final int answered;
  final Color color;

  const _ProgressHeader({
    required this.current,
    required this.total,
    required this.answered,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.sp(8)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Soal $current dari $total',
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.task_alt_rounded, color: color, size: context.sp(18)),
              SizedBox(width: context.sp(4)),
              Text('$answered/$total terjawab', style: text.titleSmall),
            ],
          ),
          SizedBox(height: context.sp(8)),
          TweenAnimationBuilder<double>(
            tween: Tween(end: answered / total),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(context.sp(8)),
              child: LinearProgressIndicator(
                value: value,
                minHeight: context.sp(8),
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Isi satu soal: kartu pertanyaan, pilihan jawaban, dan navigator soal.
class _QuestionBody extends StatelessWidget {
  const _QuestionBody({super.key});

  static const _labels = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    final q = p.currentQuestion;
    final category = p.selectedCategory!;
    final text = Theme.of(context).textTheme;

    final question = QuestionCard(
      number: p.currentIndex + 1,
      question: q.questionText,
      imageAsset: category.imageAsset,
      color: category.color,
    );

    final options = Column(
      children: List.generate(q.options.length, (i) {
        return AnswerOption(
          label: _labels[i],
          text: q.options[i],
          status: p.selectedAnswer == i ? AnswerStatus.selected : AnswerStatus.idle,
          onTap: () {
            HapticFeedback.selectionClick();
            p.selectAnswer(i);
          },
        );
      }),
    );

    final navigator = Card(
      child: Padding(
        padding: EdgeInsets.all(context.sp(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar soal',
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: context.sp(10)),
            QuestionNavigator(
              total: p.totalQuestions,
              current: p.currentIndex,
              answers: p.answers,
              onSelect: p.goToQuestion,
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Layar lebar: pertanyaan + navigator di kiri, pilihan di kanan.
        if (context.useTwoColumns(constraints.maxWidth)) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: context.sp(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(children: [
                    question,
                    SizedBox(height: context.sp(8)),
                    navigator,
                  ]),
                ),
                SizedBox(width: context.sp(20)),
                Expanded(child: options),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: context.sp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              question,
              SizedBox(height: context.sp(8)),
              options,
              SizedBox(height: context.sp(12)),
              navigator,
            ],
          ),
        );
      },
    );
  }
}
