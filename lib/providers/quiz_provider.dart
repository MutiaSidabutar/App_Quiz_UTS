import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  String _userName = '';
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  final List<int?> _answers = [];

  final List<Question> _questions = [
    Question(
      questionText: 'Apa kepanjangan dari Flutter?',
      options: ['Framework UI', 'Bahasa Pemrograman', 'Database', 'Sistem Operasi'],
      correctIndex: 0,
    ),
    Question(
      questionText: 'Widget untuk tampilan statis di Flutter adalah...',
      options: ['StatefulWidget', 'StatelessWidget', 'InheritedWidget', 'Provider'],
      correctIndex: 1,
    ),
    // tambah 5–8 soal lagi
  ];

  String get userName => _userName;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int? get selectedAnswer => _selectedAnswer;
  List<Question> get questions => _questions;
  Question get currentQuestion => _questions[_currentIndex];
  bool get isFinished => _currentIndex >= _questions.length;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void selectAnswer(int index) {
    _selectedAnswer = index;
    notifyListeners();
  }

  void nextQuestion() {
    if (_selectedAnswer == null) return;
    if (_selectedAnswer == currentQuestion.correctIndex) _score++;
    _answers.add(_selectedAnswer);
    _selectedAnswer = null;
    _currentIndex++;
    notifyListeners();
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _answers.clear();
    notifyListeners();
  }
}