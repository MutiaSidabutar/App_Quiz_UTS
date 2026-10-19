import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_history_model.dart';

/// Menyimpan riwayat kuis di penyimpanan lokal perangkat
/// (SharedPreferences, bukan database) agar tetap ada setelah aplikasi ditutup.
class HistoryStorage {
  static const _key = 'quiz_history';

  Future<List<QuizHistory>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => QuizHistory.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<void> save(List<QuizHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(history.map((h) => h.toJson()).toList()),
    );
  }
}
