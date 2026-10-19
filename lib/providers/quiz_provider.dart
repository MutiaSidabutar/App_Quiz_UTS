import 'package:flutter/material.dart';
import '../data/question_bank.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';

/// Menyimpan seluruh progres kuis di atas MaterialApp, sehingga
/// jawaban tidak hilang saat layar dirotasi atau berpindah halaman.
class QuizProvider extends ChangeNotifier {
  String _userName = '';
  QuizCategory? _selectedCategory;
  List<Question> _questions = [];
  List<int?> _answers = [];
  int _currentIndex = 0;
  bool _started = false;
  bool _finished = false;
  final Map<String, int> _bestScores = {};

  // ---------- Getter ----------
  String get userName => _userName;
  List<QuizCategory> get categories => quizCategories;
  QuizCategory? get selectedCategory => _selectedCategory;
  List<Question> get questions => List.unmodifiable(_questions);
  List<int?> get answers => List.unmodifiable(_answers);
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  Question get currentQuestion => _questions[_currentIndex];
  int? get selectedAnswer => _answers.isEmpty ? null : _answers[_currentIndex];

  bool get isFinished => _finished;
  bool get hasQuizInProgress => _started && !_finished;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;

  /// Jawaban soal aktif sudah dikunci (benar/salah sudah ditampilkan).
  bool get isRevealed => selectedAnswer != null;

  int get score {
    var total = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) total++;
    }
    return total;
  }

  int get answeredCount => _answers.where((a) => a != null).length;
  int get wrongCount => answeredCount - score;
  int get unansweredCount => _answers.where((a) => a == null).length;
  double get percentage => _questions.isEmpty ? 0 : score / _questions.length;

  int? bestScoreFor(String categoryId) => _bestScores[categoryId];

  // ---------- Aksi ----------
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void selectCategory(QuizCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void startQuiz() {
    final category = _selectedCategory;
    if (category == null) return;
    _questions = [...category.questions]..shuffle();
    _answers = List<int?>.filled(_questions.length, null);
    _currentIndex = 0;
    _started = true;
    _finished = false;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (!hasQuizInProgress || isRevealed) return;
    _answers[_currentIndex] = index;
    notifyListeners();
  }

  void nextQuestion() {
    if (!hasQuizInProgress || !isRevealed) return;
    if (isLastQuestion) {
      _finish();
    } else {
      _currentIndex++;
    }
    notifyListeners();
  }

  void _finish() {
    _finished = true;
    final id = _selectedCategory!.id;
    if (score > (_bestScores[id] ?? -1)) _bestScores[id] = score;
  }

  void resetQuiz() {
    _questions = [];
    _answers = [];
    _currentIndex = 0;
    _started = false;
    _finished = false;
    notifyListeners();
  }
}
