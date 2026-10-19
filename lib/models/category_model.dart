import 'package:flutter/material.dart';
import 'question_model.dart';

class QuizCategory {
  final String id;
  final String name;
  final String description;
  final String imageAsset;
  final Color color;
  final List<Question> questions;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.color,
    required this.questions,
  });
}
