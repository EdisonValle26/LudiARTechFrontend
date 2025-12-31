class RankingEntry {
  final int position;
  final int userId;
  final String username;
  final String fullname;
  final int points;
  final int streak;

  RankingEntry({
    required this.position,
    required this.userId,
    required this.username,
    required this.fullname,
    required this.points,
    required this.streak,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      position: json['position'],
      userId: json['user_id'],
      username: json['user_username'],
      fullname: json['user_fullname'],
      points: json['points'],
      streak: json['streak'],
    );
  }
}
