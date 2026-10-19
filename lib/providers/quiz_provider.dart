import 'dart:async';

import 'package:flutter/material.dart';
import '../data/question_bank.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../models/quiz_history_model.dart';
import '../services/history_storage.dart';
import '../utils/grading.dart';

/// Menyimpan seluruh progres kuis di atas MaterialApp, sehingga
/// jawaban tidak hilang saat layar dirotasi atau berpindah halaman.
///
/// Jawaban baru dinilai setelah kuis dikumpulkan (bukan per soal).
class QuizProvider extends ChangeNotifier {
  /// Jatah waktu per soal; total waktu kuis = jumlah soal x nilai ini.
  static const secondsPerQuestion = 20;

  QuizProvider({HistoryStorage? storage})
      : _storage = storage ?? HistoryStorage() {
    _loadHistory();
  }

  final HistoryStorage _storage;
  List<QuizHistory> _history = [];
  bool _historyLoaded = false;

  String _userName = '';
  QuizCategory? _selectedCategory;
  List<Question> _questions = [];
  List<int?> _answers = [];
  int _currentIndex = 0;
  bool _started = false;
  bool _finished = false;
  bool _timeUp = false;
  bool _isNewBest = false;

  Timer? _timer;
  int _remainingSeconds = 0;
  int _secondsUsed = 0;

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
  bool get isFirstQuestion => _currentIndex == 0;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;

  /// Kuis selesai karena waktu habis (dikumpulkan otomatis).
  bool get isTimeUp => _timeUp;

  int get totalSeconds => _questions.length * secondsPerQuestion;
  int get remainingSeconds => _remainingSeconds;
  int get secondsUsed => _secondsUsed;

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

  /// Nilai akhir skala 0–100 beserta predikatnya.
  int get nilai => calculateNilai(score, _questions.length);
  Grade get grade => Grade.fromNilai(nilai);

  /// Nilai tertinggi yang pernah diraih di suatu kategori.
  int? bestNilaiFor(String categoryId) {
    int? best;
    for (final h in _history) {
      if (h.categoryId == categoryId && (best == null || h.nilai > best)) {
        best = h.nilai;
      }
    }
    return best;
  }

  /// Nilai kuis terakhir memecahkan rekor kategori tersebut.
  bool get isNewBest => _isNewBest;

  /// Riwayat kuis, terbaru di atas.
  List<QuizHistory> get history => List.unmodifiable(_history);
  bool get isHistoryLoaded => _historyLoaded;

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
    _secondsUsed = 0;
    _remainingSeconds = totalSeconds;
    _started = true;
    _finished = false;
    _timeUp = false;
    _stopTimer();
    _startTimer();
    notifyListeners();
  }

  /// Memilih / mengganti jawaban soal aktif. Belum dinilai.
  void selectAnswer(int index) {
    if (!hasQuizInProgress) return;
    _answers[_currentIndex] = index;
    notifyListeners();
  }

  void goToQuestion(int index) {
    if (!hasQuizInProgress || index < 0 || index >= _questions.length) return;
    _currentIndex = index;
    notifyListeners();
  }

  void nextQuestion() => goToQuestion(_currentIndex + 1);
  void previousQuestion() => goToQuestion(_currentIndex - 1);

  /// Mengumpulkan jawaban; penilaian dilakukan di sini.
  void submitQuiz() {
    if (!hasQuizInProgress) return;
    _finish();
    notifyListeners();
  }

  void _finish() {
    _finished = true;
    _stopTimer();
    final category = _selectedCategory!;
    final previousBest = bestNilaiFor(category.id);
    _isNewBest = nilai > 0 && (previousBest == null || nilai > previousBest);
    final now = DateTime.now();
    _history.insert(
      0,
      QuizHistory(
        id: now.microsecondsSinceEpoch.toString(),
        userName: _userName,
        categoryId: category.id,
        categoryName: category.name,
        score: score,
        total: _questions.length,
        nilai: nilai,
        durationSeconds: _secondsUsed,
        date: now,
      ),
    );
    _storage.save(_history);
  }

  void resetQuiz() {
    _stopTimer();
    _questions = [];
    _answers = [];
    _currentIndex = 0;
    _started = false;
    _finished = false;
    _timeUp = false;
    notifyListeners();
  }

  // ---------- Riwayat ----------
  Future<void> _loadHistory() async {
    final loaded = await _storage.load();
    // Gabungkan bila ada kuis yang selesai sebelum data selesai dimuat.
    _history = [..._history, ...loaded];
    _historyLoaded = true;
    notifyListeners();
  }

  void deleteHistory(String id) {
    _history.removeWhere((h) => h.id == id);
    _storage.save(_history);
    notifyListeners();
  }

  void clearHistory() {
    _history = [];
    _storage.save(_history);
    notifyListeners();
  }

  // ---------- Timer ----------
  /// Dipanggil saat meninggalkan layar kuis / aplikasi ke background.
  void pauseTimer() => _stopTimer();

  /// Melanjutkan hitung mundur bila kuis masih berjalan.
  void resumeTimer() {
    if (!hasQuizInProgress || _timer != null) return;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    _remainingSeconds--;
    _secondsUsed++;
    if (_remainingSeconds <= 0) {
      _remainingSeconds = 0;
      _timeUp = true;
      _finish();
    }
    notifyListeners();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
