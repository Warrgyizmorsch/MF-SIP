class RiskSubmitRequest {
  final int userId;
  final List<Map<String, int>> answers;

  RiskSubmitRequest({required this.userId, required this.answers});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "answers": answers,
      };
}