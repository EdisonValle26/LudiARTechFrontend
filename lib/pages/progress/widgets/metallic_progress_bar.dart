import 'package:flutter/material.dart';

import 'color_utils.dart';

class MetallicProgressBar extends StatelessWidget {
  final Color color;
  final double progress;

  const MetallicProgressBar({
    super.key,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 13,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ),

            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      color.withOpacity(0.6),
                      color,
                      ColorUtils.darkMetal(color, 0.65),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
