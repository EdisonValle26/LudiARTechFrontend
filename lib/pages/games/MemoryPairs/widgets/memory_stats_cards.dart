import 'package:flutter/material.dart';

class MemoryStatsCards extends StatelessWidget {
  final int errors;
  final int matches;
  final int totalPairs;

  const MemoryStatsCards({
    super.key,
    required this.errors,
    required this.matches,
    required this.totalPairs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _infoCard(
          title: "Aciertos",
          value: "$matches / $totalPairs",
          icon: Icons.check_circle,
        ),
        const SizedBox(width: 8),
        _infoCard(
          title: "Errores",
          value: "$errors / 6",
          icon: Icons.cancel,
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(12),
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