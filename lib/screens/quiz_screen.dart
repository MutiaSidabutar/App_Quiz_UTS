import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/answer_option.dart';
import '../widgets/feedback_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/question_card.dart';
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
    } else {
      _quiz.pauseTimer();
    }
  }

  Future<void> _confirmExit() async {
    _quiz.pauseTimer();
    _dialogOpen = true;
    final exit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.pause_circle_rounded),
        title: const Text('Jeda kuis?'),
        content: const Text(
          'Progres kamu tersimpan. Kamu bisa melanjutkannya dari halaman beranda.',
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
    _dialogOpen = false;
    if (!mounted) return;
    if (exit == true) {
      Navigator.pop(context);
    } else {
      _quiz.resumeTimer();
    }
  }

  void _next() {
    final last = _quiz.isLastQuestion;
    _quiz.nextQuestion();
    if (last) Navigator.pushReplacementNamed(context, '/result');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
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
                child: TimerBadge(
                remaining: p.remainingSeconds,
                  total: QuizProvider.secondsPerQuestion,
                ),
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
                  score: p.score,
                  color: category.color,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    // Soal selalu menempel di atas, bukan di tengah layar.
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.topCenter,
                      children: [...previous, ?current],
                    ),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
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
              child: PrimaryButton(
                label: !p.isRevealed
                    ? 'Pilih jawaban'
                    : (p.isLastQuestion ? 'Lihat Hasil' : 'Soal Berikutnya'),
                icon: p.isLastQuestion && p.isRevealed
                    ? Icons.emoji_events_rounded
                    : Icons.arrow_forward_rounded,
                onPressed: p.isRevealed ? _next : null,
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
  final int score;
  final Color color;

  const _ProgressHeader({
    required this.current,
    required this.total,
    required this.score,
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
              Text('Soal $current dari $total',
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.star_rounded, color: Colors.amber, size: context.sp(20)),
              SizedBox(width: context.sp(4)),
              Text('Skor $score', style: text.titleSmall),
            ],
          ),
          SizedBox(height: context.sp(8)),
          TweenAnimationBuilder<double>(
            tween: Tween(end: current / total),
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

/// Isi satu soal: kartu pertanyaan, pilihan jawaban, dan umpan balik.
class _QuestionBody extends StatelessWidget {
  const _QuestionBody({super.key});

  static const _labels = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    final q = p.currentQuestion;
    final category = p.selectedCategory!;

    final question = QuestionCard(
      number: p.currentIndex + 1,
      question: q.questionText,
      imageAsset: category.imageAsset,
      color: category.color,
    );

    final options = Column(
      children: List.generate(q.options.length, (i) {
        final status = !p.isRevealed
            ? AnswerStatus.idle
            : i == q.correctIndex
                ? AnswerStatus.correct
                : i == p.selectedAnswer
                    ? AnswerStatus.wrong
                    : AnswerStatus.dimmed;
        return AnswerOption(
          label: _labels[i],
          text: q.options[i],
          status: status,
          onTap: p.isRevealed
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  p.selectAnswer(i);
                },
        );
      }),
    );

    final feedback = p.isRevealed
        ? Padding(
            padding: EdgeInsets.only(top: context.sp(12)),
            child: FeedbackBanner(
              isCorrect: p.selectedAnswer == q.correctIndex,
              isTimedOut: p.isTimedOut,
              correctAnswer: q.correctAnswer,
              explanation: q.explanation,
            ),
          )
        : const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Layar lebar (tablet / web / landscape): pertanyaan di kiri,
        // pilihan jawaban di kanan.
        if (context.useTwoColumns(constraints.maxWidth)) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: context.sp(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: [question, feedback])),
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
              feedback,
            ],
          ),
        );
      },
    );
  }
}
