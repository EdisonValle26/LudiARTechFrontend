import 'package:LudiArtech/models/ranking_entry.dart';

import '../services/api_service.dart';
import '../utils/api_constants.dart';

class RankingService {
  final ApiService api;

  RankingService(this.api);

  Future<List<RankingEntry>> getRanking({
    required String token,
  }) async {
    final response = await api.getAuth(
      ApiConstants.rankingGet,
      token: token,
    );

    final List list = response as List;

    return list
        .map((e) => RankingEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
