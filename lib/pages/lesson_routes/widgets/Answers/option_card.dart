import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final bool reviewMode;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.label,
    required this.text,
    required this.selected,
    required this.reviewMode,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  Color get borderColor {
    if (!reviewMode) {
      return selected ? Colors.deepPurple : Colors.grey.shade300;
    }
    if (isCorrect) return Colors.green;
    if (isWrong) return Colors.red;
    return Colors.grey.shade300;
  }

  Color get backgroundColor {
    if (!reviewMode) {
      return selected
          ? Colors.deepPurple.withOpacity(0.15)
          : Colors.white;
    }
    if (isCorrect) return Colors.green.withOpacity(0.15);
    if (isWrong) return Colors.red.withOpacity(0.15);
    return Colors.white;
  }

  IconData? get icon {
    if (!reviewMode) return null;
    if (isCorrect) return Icons.check_circle;
    if (isWrong) return Icons.cancel;
    return null;
  }

  Color get iconColor {
    if (isCorrect) return Colors.green;
    if (isWrong) return Colors.red;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            /// LETTER
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// TEXT
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            /// ICON
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: iconColor),
            ]
          ],
        ),
      ),
    );
  }
}
