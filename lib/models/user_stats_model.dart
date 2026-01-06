import 'lesson_stat_model.dart';

class UserStatsModel {
  final String username;
  final String fullname;
  final String badge;
  final String ranking;
  final int level;
  final String progress;
  final int points;
  final int lives;
  final int streak;
  final int badges;
  final double lessonAverage;
  final List<LessonStatModel> lessons;

  UserStatsModel({
    required this.username,
    required this.fullname,
    required this.badge,
    required this.ranking,
    required this.level,
    required this.progress,
    required this.points,
    required this.lives,
    required this.streak,
    required this.badges,
    required this.lessonAverage,
    required this.lessons,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      username: json["username"],
      fullname: json["fullname"],
      badge: json["badge"],
      ranking: json["ranking"],
      level: json["level"],
      progress: json["progress"],
      points: json["points"],
      lives: json["lives"] ?? 0,
      streak: json["streak"],
      badges: json["badges"],
      lessonAverage: double.parse(json["lesson_average"].toString()),
      lessons: (json["lessons"] as List)
          .map((e) => LessonStatModel.fromJson(e))
          .toList(),
    );
  }

  int get maxPoints {
    final parts = progress.split("/");
    return int.parse(parts[1]);
  }

  double get progressValue => points / maxPoints;
}
