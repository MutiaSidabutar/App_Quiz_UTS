class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });

  String get correctAnswer => options[correctIndex];
}
