import 'package:LudiArtech/enum/learning_paths_enum.dart';

class LessonStatusModel {
  final int sectionId;
  final String section;
  final int lessonId;
  final double score;
  final String lesson;
  final LearningStatusEnum estado;

  LessonStatusModel({
    required this.sectionId,
    required this.section,
    required this.lessonId,
    required this.lesson,
    required this.estado,
    required this.score,
  });

  factory LessonStatusModel.fromJson(Map<String, dynamic> json) {
    return LessonStatusModel(
      sectionId: json["sectionId"],
      section: json["section"],
      lessonId: json["lessonId"],
      lesson: json["lesson"],
      score: double.tryParse(json["score"].toString()) ?? 0,
      estado: _mapStatus(json["status"]),
    );
  }

  static LearningStatusEnum _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case "completada":
        return LearningStatusEnum.completada;
      case "desbloqueada":
        return LearningStatusEnum.desbloqueada;
      default:
        return LearningStatusEnum.bloqueada;
    }
  }
}