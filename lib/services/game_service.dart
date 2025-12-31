import '../services/api_service.dart';
import '../utils/api_constants.dart';

class GameResultService {
  final ApiService api;

  GameResultService(this.api);

  Future<void> sendResult({
    required String token,
    required int gameId,
    required String status, // "WIN" | "LOSE"
    required int usedMoves,
    required int totalMoves,
    required int usedTime,
    required int totalTime,
  }) async {
    await api.postAuth(
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
  }
}
