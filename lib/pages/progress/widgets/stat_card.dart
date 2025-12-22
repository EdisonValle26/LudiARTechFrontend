import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String numero;
  final String titulo;
  final double scale;

  const StatCard({
    super.key,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.numero,
    required this.titulo,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12 * scale),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14 * scale),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: w * 0.08 * scale,
            color: iconColor,
          ),

          SizedBox(height: 5),

          Text(
            numero,
            style: TextStyle(
              fontSize: w * 0.060 * scale,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Text(
            titulo,
            style: TextStyle(
              fontSize: w * 0.040 * scale,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
