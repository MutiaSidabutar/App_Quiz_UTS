import 'package:flutter/material.dart';

/// Predikat nilai (skala 0–100).
enum Grade {
  a('A', 'Sangat Baik', Color(0xFF16A34A)),
  b('B', 'Baik', Color(0xFF2563EB)),
  c('C', 'Cukup', Color(0xFFCA8A04)),
  d('D', 'Kurang', Color(0xFFEA580C)),
  e('E', 'Sangat Kurang', Color(0xFFDC2626));

  final String letter;
  final String label;
  final Color color;

  const Grade(this.letter, this.label, this.color);

  static Grade fromNilai(int nilai) {
    if (nilai >= 85) return Grade.a;
    if (nilai >= 70) return Grade.b;
    if (nilai >= 55) return Grade.c;
    if (nilai >= 40) return Grade.d;
    return Grade.e;
  }
}

/// Nilai 0–100 dari jumlah jawaban benar.
int calculateNilai(int score, int total) =>
    total == 0 ? 0 : (score * 100 / total).round();
