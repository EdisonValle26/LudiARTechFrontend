import 'package:flutter/material.dart';

class FillBlankQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final Function(double) onScoreCalculated;

  const FillBlankQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.onScoreCalculated,
  });

  @override
  State<FillBlankQuestionCard> createState() =>
      _FillBlankQuestionCardState();
}

class _FillBlankQuestionCardState extends State<FillBlankQuestionCard> {
  late List<String?> answers;
  late List<String> options;
  late List<String> correctAnswers;

  @override
  void initState() {
    super.initState();

    final blanksCount =
        "____".allMatches(widget.question["text"]).length;

    answers = List.filled(blanksCount, null);
    options = List<String>.from(widget.question["options"]);
    correctAnswers =
        List<String>.from(widget.question["correct"]);
  }

  // SELECCIONAR PALABRA
  void selectWord(String word) {
    final emptyIndex = answers.indexOf(null);
    if (emptyIndex == -1) return;

    setState(() {
      answers[emptyIndex] = word;
      calculateScore();
    });
  }

  // QUITAR PALABRA
  void removeWord(int index) {
    setState(() {
      answers[index] = null;
      calculateScore();
    });
  }

  // CALCULAR PUNTAJE (0.25)
  void calculateScore() {
    double score = 0.0;

    for (int i = 0; i < answers.length; i++) {
      if (answers[i] != null &&
          answers[i]!.toLowerCase() ==
              correctAnswers[i].toLowerCase()) {
        score += 0.25;
      }
    }

    if (score > 1.0) score = 1.0;
    widget.onScoreCalculated(score);
  }

  @override
  Widget build(BuildContext context) {
    final textParts =
        widget.question["text"].split("____");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question["question"],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.touch_app, color: Colors.deepPurple),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Selecciona las palabras para completar el texto",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: List.generate(
              textParts.length * 2 - 1,
              (i) {
                if (i.isEven) {
                  return TextSpan(text: textParts[i ~/ 2]);
                } else {
                  final blankIndex = i ~/ 2;
                  final value = answers[blankIndex];

                  return WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: value != null
                          ? () => removeWord(blankIndex)
                          : null,
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          value ?? "______",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: value != null
                                ? Colors.deepPurple
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((word) {
            final isUsed = answers.contains(word);

            return GestureDetector(
              onTap: isUsed ? null : () => selectWord(word),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isUsed
                      ? Colors.grey.shade300
                      : Colors.deepPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isUsed
                        ? Colors.grey
                        : Colors.deepPurple,
                  ),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    color:
                        isUsed ? Colors.grey : Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
