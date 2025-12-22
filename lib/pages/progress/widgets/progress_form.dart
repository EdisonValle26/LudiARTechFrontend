import 'package:flutter/material.dart';

import 'adventure_card.dart';

class ProgressForm extends StatelessWidget {
  final double scale;
  const ProgressForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

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

          SizedBox(height: 5 * h),

          AdventureCard(
            color: Colors.pinkAccent,
            title: "Ejemplo (Kahoot sobre tal tema)",
            rating: 8.5,
            progress: 85,
            scale: scale,
          ),

          AdventureCard(
            color: Colors.blueAccent,
            title: "Ejemplo (Rompecabeza sobre tal tema)",
            rating: 10,
            progress: 100,
            scale: scale,
          ),

          AdventureCard(
            color: Colors.orange,
            title: "Ejemplo (Quiz sobre tal tema)",
            rating: 9,
            progress: 90,
            scale: scale,
          ),

        ],
      ),
    );
  }
}
