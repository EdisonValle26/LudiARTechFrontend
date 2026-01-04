class LessonStatModel {
  final String name;
  final double score;

  LessonStatModel({
    required this.name,
    required this.score,
  });

  factory LessonStatModel.fromJson(Map<String, dynamic> json) {
    final num rawScore = json["score"] ?? 0;

    return LessonStatModel(
      name: json["name"],
      score: rawScore.toDouble(),
    );
  }
}
