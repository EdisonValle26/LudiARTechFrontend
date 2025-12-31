import 'package:flutter/material.dart';

class TrueFalseQuestionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> question;
  final String? selectedValue;
  final bool reviewMode;
  final double score;
  final Function(String, double) onAnswerSelected;

  const TrueFalseQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.selectedValue,
    required this.reviewMode,
    required this.score,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    const keys = ["a", "b"];
    final correct = question["correct"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          children: [
            Expanded(
              child: Text(
                question["question"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (reviewMode)
              Text(
                "P: ${score.toStringAsFixed(2)} / 1.00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: score == 1.0 ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.deepPurple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Selecciona si la afirmación es verdadera o falsa",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),

        Row(
          children: List.generate(2, (i) {
            final key = keys[i];
            final bool isSelected = selectedValue == key;
            final bool isCorrect = key == correct;

            Color borderColor = Colors.grey.shade300;
            Color bgColor = Colors.white;
            IconData? icon;
            Color? iconColor;

            if (reviewMode && isSelected) {
              if (isCorrect) {
                borderColor = Colors.green;
                bgColor = Colors.green.withOpacity(0.15);
                icon = Icons.check_circle;
                iconColor = Colors.green;
              } else {
                borderColor = Colors.red;
                bgColor = Colors.red.withOpacity(0.15);
                icon = Icons.cancel;
                iconColor = Colors.red;
              }
            } else if (isSelected) {
              borderColor = Colors.deepPurple;
              bgColor = Colors.deepPurple.withOpacity(0.15);
            }

            return Expanded(
              child: GestureDetector(
                onTap: reviewMode
                    ? null
                    : () {
                        final s = key == correct ? 1.0 : 0.0;
                        onAnswerSelected(key, s);
                      },
                child: Container(
                  margin: EdgeInsets.only(right: i == 0 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Icon(icon, color: iconColor, size: 20),
                      if (icon != null) const SizedBox(width: 6),
                      Text(
                        question["options"][i],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: borderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}