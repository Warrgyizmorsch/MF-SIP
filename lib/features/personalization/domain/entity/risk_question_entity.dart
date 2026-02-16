import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/risk_question_model.dart';

class RiskQuestionEntity extends Equatable {
  final bool status;
  final List<QuestionEnitity> data;

  const RiskQuestionEntity({required this.status, required this.data});
  @override
  List<Object?> get props => [status, data];
}

class QuestionEnitity extends Equatable {
  final int id;
  final int questionOrder;
  final String questionText;
  final List<OptionsEntity> options;

  const QuestionEnitity({
    required this.id,
    required this.questionOrder,
    required this.questionText,
    required this.options,
  });
  @override
  List<Object?> get props => [id, questionOrder, questionText, options];
}

class OptionsEntity extends Equatable {
  final int id;
  final String label;
  final String text;
  final int score;

  const OptionsEntity({
    required this.id,
    required this.label,
    required this.text,
    required this.score,
  });

  @override
  List<Object?> get props => [id, label, text, score];
}

extension RiskQuestionModelX on RiskQuestionModel {
  RiskQuestionEntity toEntity() {
    return RiskQuestionEntity(
      status: status,
      data: data.map((e) => e.toEntity()).toList(),
      // data: data.map((e) => e.toEntity()).toList(),
    );
  }
}

extension QuestionModelX on Question {
  QuestionEnitity toEntity() {
    return QuestionEnitity(
      id: id,
      questionOrder: questionOrder,
      questionText: questionText,
      options: options.map((e) => e.toEntity()).toList(),
    );
  }
}

extension OptionModelX on Option {
  OptionsEntity toEntity() {
    return OptionsEntity(id: id, label: label, text: text, score: score);
  }
}
