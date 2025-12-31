import 'package:flutter/material.dart';

class PuzzleInfoCards extends StatelessWidget {
  final String time;
  final int remainingMoves;

  const PuzzleInfoCards({
    super.key,
    required this.time,
    required this.remainingMoves,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _infoCard(
          title: "Tiempo",
          value: time,
          icon: Icons.timer,
        ),
        const SizedBox(width: 12),
        _infoCard(
          title: "Movimientos",
          value: "$remainingMoves / 100",
          icon: Icons.swap_horiz,
        ),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
