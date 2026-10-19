/// Satu catatan kuis yang sudah selesai dikerjakan.
class QuizHistory {
  final String id;
  final String userName;
  final String categoryId;
  final String categoryName;
  final int score;
  final int total;
  final int nilai;
  final int durationSeconds;
  final DateTime date;

  const QuizHistory({
    required this.id,
    required this.userName,
    required this.categoryId,
    required this.categoryName,
    required this.score,
    required this.total,
    required this.nilai,
    required this.durationSeconds,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'score': score,
        'total': total,
        'nilai': nilai,
        'durationSeconds': durationSeconds,
        'date': date.toIso8601String(),
      };

  factory QuizHistory.fromJson(Map<String, dynamic> json) => QuizHistory(
        id: json['id'] as String,
        userName: json['userName'] as String,
        categoryId: json['categoryId'] as String,
        categoryName: json['categoryName'] as String,
        score: json['score'] as int,
        total: json['total'] as int,
        nilai: json['nilai'] as int,
        durationSeconds: json['durationSeconds'] as int,
        date: DateTime.parse(json['date'] as String),
      );
}
