import 'package:flutter/material.dart';

class LessonHeader extends StatelessWidget {
  final String timerText;

  const LessonHeader({super.key, required this.timerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Lección",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(timerText),
          ),
        ],
      ),
    );
  }
}
