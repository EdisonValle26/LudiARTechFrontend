import 'package:flutter/material.dart';

class FillBlankQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final bool reviewMode;
  final double score;
  final Function(double) onScoreCalculated;

  const FillBlankQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.reviewMode,
    required this.score,
    required this.onScoreCalculated,
  });

  @override
  State<FillBlankQuestionCard> createState() => _FillBlankQuestionCardState();
}

class _FillBlankQuestionCardState extends State<FillBlankQuestionCard> {
  /// CACHE POR PREGUNTA (SOLO PARA REVIEW)
  static final Map<int, List<String?>> _answersCache = {};

  late List<String?> answers;
  late List<String> options;
  late List<String> correctAnswers;

  @override
  void initState() {
    super.initState();

    final blanksCount = "____".allMatches(widget.question["text"]).length;

    if (widget.reviewMode && _answersCache.containsKey(widget.index)) {
      answers = List<String?>.from(_answersCache[widget.index]!);
    } else {
      answers = List<String?>.filled(blanksCount, null);
      _answersCache.remove(widget.index);
    }

    options = List<String>.from(widget.question["options"]);
    correctAnswers = List<String>.from(widget.question["correct"]);
  }

  void _saveAnswers() {
    _answersCache[widget.index] = List.from(answers);
  }

  // SELECCIONAR PALABRA
  void selectWord(String word) {
    if (widget.reviewMode) return;

    final emptyIndex = answers.indexOf(null);
    if (emptyIndex == -1) return;

    setState(() {
      answers[emptyIndex] = word;
      _saveAnswers();
      calculateScore();
    });
  }

  // QUITAR PALABRA
  void removeWord(int index) {
    if (widget.reviewMode) return;

    setState(() {
      answers[index] = null;
      _saveAnswers();
      calculateScore();
    });
  }

  // CALCULAR PUNTAJE
  void calculateScore() {
    double score = 0.0;

    for (int i = 0; i < answers.length; i++) {
      if (answers[i] != null &&
          answers[i]!.trim().toLowerCase() ==
              correctAnswers[i].trim().toLowerCase()) {
        score += 1 / answers.length;
      }
    }

    widget.onScoreCalculated(score.clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    final textParts = widget.question["text"].split("____");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.question["question"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.reviewMode)
              Text(
                "P: ${widget.score.toStringAsFixed(2)} / 1.00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.score == 1.0 ? Colors.green : Colors.red,
                ),
              ),
          ],
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
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: List.generate(
              textParts.length * 2 - 1,
              (i) {
                if (i.isEven) {
                  return TextSpan(text: textParts[i ~/ 2]);
                } else {
                  final index = i ~/ 2;
                  final value = answers[index];
                  final correct = correctAnswers[index];

                  final isCorrect = widget.reviewMode &&
                      value != null &&
                      value.trim().toLowerCase() ==
                          correct.trim().toLowerCase();

                  final isWrong =
                      widget.reviewMode && value != null && !isCorrect;

                  Color color = Colors.deepPurple;
                  if (isCorrect) color = Colors.green;
                  if (isWrong) color = Colors.red;

                  return WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: value != null && !widget.reviewMode
                          ? () => removeWord(index)
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: color, width: 2),
                          ),
                        ),
                        child: Text(
                          value ?? "______",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: value == null ? Colors.grey : color,
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

        /// OPCIONES
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((word) {
            final isUsed = answers.contains(word);

            return GestureDetector(
              onTap:
                  isUsed || widget.reviewMode ? null : () => selectWord(word),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUsed
                      ? Colors.grey.shade300
                      : Colors.deepPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isUsed ? Colors.grey : Colors.deepPurple,
                  ),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    color: isUsed ? Colors.grey : Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
