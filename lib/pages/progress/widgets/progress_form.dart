import 'package:LudiArtech/models/user_stats_model.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:flutter/material.dart';

import 'adventure_card.dart';

class ProgressForm extends StatelessWidget {
  final double scale;

  const ProgressForm({
    super.key,
    required this.scale,
  });

  Future<UserStatsModel> _loadStats() async {
    final token = await TokenStorage.getToken();
    final api = ApiService(ApiConstants.baseUrl);
    final service = UserService(api);

    return service.getUserStats(token: token!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    final List<Color> adventureColors = [
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.orange,
    ];

    return FutureBuilder<UserStatsModel>(
      future: _loadStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data!;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 15 * w,
            vertical: 20 * h,
          ),
          child: Column(
            children: [
              Text(
                "Rutas de Aventura",
                style: TextStyle(
                  fontSize: 26 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 10 * h),

              ...stats.lessons.asMap().entries.map((entry) {
                final index = entry.key;
                final lesson = entry.value;

                final double progress = (lesson.score / 10) * 100;

                return AdventureCard(
                  color: adventureColors[index % adventureColors.length],
                  title: lesson.name,
                  rating: lesson.score,
                  progress: progress,
                  scale: scale,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
