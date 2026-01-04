import 'package:LudiArtech/models/user_stats_model.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

import 'metallic_progress_bar.dart';
import 'stat_card.dart';
import 'stat_card_data.dart';

class ProgressHeader extends StatelessWidget {
  final double scale;

  const ProgressHeader({
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
    final w = MediaQuery.of(context).size.width;

    return FutureBuilder<UserStatsModel>(
      future: _loadStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final stats = snapshot.data!;
        final parts = stats.fullname.split(" ");
        final name = parts.isNotEmpty ? parts.first : "U";
        final lastName = parts.length > 1 ? parts.last : "";

        final List<StatCardData> statCards = [
          StatCardData(
            color: Colors.greenAccent.shade100,
            icon: Icons.military_tech,
            iconColor: Colors.amber,
            numero: stats.badges.toString(),
            titulo: "Insignias",
          ),
          StatCardData(
            color: Colors.orangeAccent.shade100,
            icon: Icons.favorite,
            iconColor: Colors.red,
            numero: "${stats.lives}/10",
            titulo: "Vidas",
          ),
          StatCardData(
            color: Colors.blueAccent.shade100,
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            numero: stats.streak.toString(),
            titulo: "Racha",
          ),
          StatCardData(
            color: Colors.purpleAccent.shade100,
            icon: Icons.check,
            iconColor: Colors.green,
            numero: stats.lessonAverage.toStringAsFixed(2),
            titulo: "Nota",
          ),
        ];

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            w * 0.06 * scale,
            w * 0.06 * scale,
            w * 0.06 * scale,
            w * 0.06 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatar(
                    radius: w * 0.1 * scale,
                    name: name,
                    lastName: lastName,
                  ),
                  SizedBox(width: w * 0.02 * scale),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stats.fullname,
                        style: TextStyle(
                          fontSize: w * 0.060 * scale,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        stats.badge,
                        style: TextStyle(
                          fontSize: w * 0.045 * scale,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "#${stats.ranking}",
                        style: TextStyle(
                          fontSize: w * 0.040 * scale,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: w * 0.02 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nivel ${stats.level}",
                    style: TextStyle(
                      fontSize: w * 0.055 * scale,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${stats.points}/${stats.maxPoints} P",
                    style: TextStyle(
                      fontSize: w * 0.050 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: w * 0.02 * scale),
              MetallicProgressBar(
                color: Colors.amber,
                progress: stats.progressValue.clamp(0, 1),
              ),
              SizedBox(height: w * 0.05 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: statCards.map((card) {
                  return Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      child: StatCard(
                        color: card.color,
                        icon: card.icon,
                        iconColor: card.iconColor,
                        numero: card.numero,
                        titulo: card.titulo,
                        scale: scale,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
