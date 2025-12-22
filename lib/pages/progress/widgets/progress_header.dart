import 'package:flutter/material.dart';

import 'metallic_progress_bar.dart';
import 'profile_avatar.dart';
import 'stat_card.dart';
import 'stat_card_data.dart';

class ProgressHeader extends StatelessWidget {
  final double scale;

  const ProgressHeader({
    super.key,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    const String nombre = "María Gómez";
    const String rol = "Explorador Académico";
    const String ranking = "2";
    const String rankingTotal = "30";

    const int nivel = 15;
    const double puntuacionActual = 8.75;
    const double puntuacionTotal = 10.00;
    const double progreso = 0.87;
    const Color progressColor = Colors.amber;

    final List<StatCardData> statCards = [
      StatCardData(
        color: Colors.greenAccent.shade100,
        icon: Icons.military_tech,
        iconColor: Colors.amber,
        numero: "2",
        titulo: "Insignias",
      ),
      StatCardData(
        color: Colors.orangeAccent.shade100,
        icon: Icons.favorite,
        iconColor: Colors.red,
        numero: "1/5",
        titulo: "Vidas",
      ),
      StatCardData(
        color: Colors.blueAccent.shade100,
        icon: Icons.local_fire_department,
        iconColor: Colors.orange,
        numero: "18",
        titulo: "Racha",
      ),
      StatCardData(
        color: Colors.purpleAccent.shade100,
        icon: Icons.check,
        iconColor: Colors.green,
        numero: "12",
        titulo: "Aciertos",
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
              ProfileAvatar(radius: w * 0.1 * scale),

              SizedBox(width: w * 0.02 * scale),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: TextStyle(
                      fontSize: w * 0.060 * scale,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    rol,
                    style: TextStyle(
                      fontSize: w * 0.045 * scale,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text: "#$ranking",
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " de $rankingTotal",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        fontSize: w * 0.040 * scale,
                        fontWeight: FontWeight.w700,
                      ),
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
                "Nivel $nivel",
                style: TextStyle(
                  fontSize: w * 0.055 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                "${puntuacionActual.toStringAsFixed(2)}/${puntuacionTotal.toStringAsFixed(2)} P",
                style: TextStyle(
                  fontSize: w * 0.050 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: w * 0.02 * scale),

          const MetallicProgressBar(
            color: progressColor,
            progress: progreso,
          ),

          SizedBox(height: w * 0.05 * scale),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: statCards.map((card) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
  }
}
