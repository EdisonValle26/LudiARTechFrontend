import 'package:LudiArtech/pages/lesson_routes/forms/word/widgets/Answers/match_question_card.dart';
import 'package:LudiArtech/pages/lesson_routes/forms/word/widgets/Answers/true_false_question_card.dart';
import 'package:flutter/material.dart';

import 'Answers/fill_blank_question_card.dart';
import 'Answers/option_card.dart';
import 'Answers/order_question_card.dart';

class QuestionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> question;
  final String? selectedValue;
  final double score;
  final bool reviewMode;
  final Function(String, double) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.selectedValue,
    required this.score,
    required this.reviewMode,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final type = question["type"] ?? "multiple";

    if (type == "order") {
      return OrderQuestionCard(
        index: index,
        question: question,
        onScoreCalculated: (s) => onAnswerSelected("order", s),
      );
    }

    if (type == "fill") {
      return FillBlankQuestionCard(
        index: index,
        question: question,
        onScoreCalculated: (s) => onAnswerSelected("fill", s),
      );
    }

    if (type == "match") {
      return MatchQuestionCard(
        index: index,
        question: question,
        onScoreCalculated: (s) => onAnswerSelected("match", s),
      );
    }

    if (type == "boolean") {
      return TrueFalseQuestionCard(
        index: index,
        question: question,
        selectedValue: selectedValue,
        onAnswerSelected: onAnswerSelected,
        // reviewMode: reviewMode,
        // score: score,
      );
    }

    /// MULTIPLE CHOICE
    final keys = ["a", "b", "c", "d"];
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

        /// OPTIONS
        ...List.generate(4, (i) {
          final key = keys[i];

          final bool userSelected = selectedValue == key;

          return OptionCard(
            label: key,
            text: question["options"][i],
            selected: userSelected,
            reviewMode: reviewMode,
            isCorrect: reviewMode && userSelected && key == correct,
            isWrong: reviewMode && userSelected && key != correct,
            onTap: reviewMode
                ? null
                : () {
                    final s = key == correct ? 1.0 : 0.0;
                    onAnswerSelected(key, s);
                  },
          );
        }),

        const SizedBox(height: 16),
      ],
    );
  }
}
