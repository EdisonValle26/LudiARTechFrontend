import '../services/api_service.dart';
import '../utils/api_constants.dart';

class GameResultResponse {
  final int score;
  final bool streakGained;

  GameResultResponse({
    required this.score,
    required this.streakGained,
  });

  factory GameResultResponse.fromJson(Map<String, dynamic> json) {
    return GameResultResponse(
      score: json['score'],
      streakGained: json['streak_gained'],
    );
  }
}

class GameResultService {
  final ApiService api;

  GameResultService(this.api);

  Future<GameResultResponse> sendResult({
    required String token,
    required int gameId,
    required String status,
    required int usedMoves,
    required int totalMoves,
    required int usedTime,
    required int totalTime,
  }) async {
    final response = await api.postAuth(
      '${ApiConstants.games}/$gameId/result',
      token: token,
      body: {
        "status": status,
        "movements": {
          "used": usedMoves,
          "total": totalMoves,
        },
        "time": {
          "used": usedTime,
          "total": totalTime,
        },
      },
    );

    return GameResultResponse.fromJson(response);
  }
}
