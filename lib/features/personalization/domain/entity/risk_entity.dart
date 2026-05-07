class RiskOption {
  final String id;
  final String text;
  final int score;

  RiskOption({required this.id, required this.text, this.score = 0});
}

class RiskQuestion {
  final int id;
  final String question;
  final List<RiskOption> options;

  RiskQuestion({required this.id, required this.question, required this.options});
}