import 'package:flutter/material.dart';

class TrueFalseQuestionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> question;
  final String? selectedValue;
  final Function(String, double) onAnswerSelected;

  const TrueFalseQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.selectedValue,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    const keys = ["a", "b"];
    final correct = question["correct"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// QUESTION
        Text(
          question["question"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        /// INSTRUCTION
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
            final isSelected = selectedValue == key;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  final score = key == correct ? 1.0 : 0.0;
                  onAnswerSelected(key, score);
                },
                child: Container(
                  margin: EdgeInsets.only(right: i == 0 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurple.withOpacity(0.15)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected ? Colors.deepPurple : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      question["options"][i],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.deepPurple : Colors.black,
                      ),
                    ),
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
