// models/option.dart
class Option {
  final String label;

  Option({required this.label,});
}

// models/question_model.dart
class QuestionModel {
  final int step;
  final String title;
  final String subtitle;
  final List<Option> options;

  QuestionModel({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.options,
  });
}