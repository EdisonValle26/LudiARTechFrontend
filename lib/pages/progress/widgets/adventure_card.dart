import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'metallic_progress_bar.dart';

class AdventureCard extends StatelessWidget {
  final Color color;
  final String title;
  final double rating;
  final double progress;
  final double scale;

  const AdventureCard({
    super.key,
    required this.color,
    required this.title,
    required this.rating,
    required this.progress,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final pastelColor = ColorUtils.pastel(color);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15 * scale),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.05 * scale,
        vertical: h * 0.01 * scale,
      ),
      decoration: BoxDecoration(
        color: pastelColor,
        borderRadius: BorderRadius.circular(18 * scale),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: w * 0.045 * scale,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: h * 0.008 * scale),

          Text(
            "Calificación ${rating.toStringAsFixed(1)}/10",
            style: TextStyle(
              fontSize: w * 0.045 * scale,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          SizedBox(height: h * 0.015 * scale),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progreso",
                style: TextStyle(
                  fontSize: w * 0.040 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.black45,
                ),
              ),
              Text(
                "${progress.toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: w * 0.040 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.010 * scale),

          MetallicProgressBar(
            color: color,
            progress: progress / 100,
          ),
        ],
      ),
    );
  }
}
