class ApiConstants {
  static const String baseUrl = "http://192.168.100.33:3002";

  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String requestPassword = "/auth/request-password-reset";
  static const String resetPassword = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";

  // Users
  static const String userCreate = "/users/";
  static const String userGet = "/users/me";
  static const String userUpdate = "/users/update";
  static const String userStats = "/users/stats";

  // Ranking
  static const String rankingGet = "/ranking";

  // Games
  static const String games = "/games";

  // Lesson
  static const String lessonStatus = "/lessons/status";
  static const String lessonComplete = "/lessons/complete";

}
