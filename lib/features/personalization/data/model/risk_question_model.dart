import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class RiskQuestionModel {
  final bool status;
  final List<Question> data;

  RiskQuestionModel({required this.status, required this.data});

  factory RiskQuestionModel.fromJson(Map<String, dynamic> json) {
    return RiskQuestionModel(
      status: json.parse<bool>('status') ?? false,
      data:
          json.parseListOf<Question>('data', (e) => Question.fromJson(e)) ?? [],
    );
  }
}

class Question {
  final int id;
  final int questionOrder;
  final String questionText;
  final List<Option> options;

  Question({
    required this.id,
    required this.questionOrder,
    required this.questionText,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json.parse<int>('id') ?? 0,
      questionOrder: json.parse<int>('question_order') ?? 0,
      questionText: json.parse<String>('question_text') ?? '',
      options:
          json.parseListOf<Option>('options', (e) => Option.fromJson(e)) ?? [],
    );
  }
}

class Option {
  final int id;
  final String label;
  final String text;
  final int score;

  Option({
    required this.id,
    required this.label,
    required this.text,
    required this.score,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json.parse<int>('id') ?? 0,
      label: json.parse<String>('label') ?? "",
      text: json.parse<String>('text') ?? '',
      score: json.parse<int>('score') ?? 0,
    );
  }
}
