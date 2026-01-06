import 'package:flutter/material.dart';

class MatchQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final bool reviewMode;
  final double score;
  final Function(double) onScoreCalculated;

  const MatchQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.reviewMode,
    required this.score,
    required this.onScoreCalculated,
  });

  @override
  State<MatchQuestionCard> createState() => _MatchQuestionCardState();
}

class _MatchQuestionCardState extends State<MatchQuestionCard> {
  String? selectedLeft;
  final Map<String, String> matches = {};

  late List<String> leftItems;
  late List<String> rightItems;
  late Map<String, String> correct;

  static const double radius = 12;
  static const double borderWidth = 2;
  static const double itemHeight = 56;

  static const List<Color> matchColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    leftItems = List<String>.from(widget.question["left"]);
    rightItems = List<String>.from(widget.question["right"]);
    correct = Map<String, String>.from(widget.question["correct"]);

    /// recuperar respuestas del usuario
    if (widget.question["userMatches"] != null) {
      matches.addAll(
        Map<String, String>.from(widget.question["userMatches"]),
      );
    }
  }

  Color colorFor(String key) {
    final index = leftItems.indexOf(key);
    return matchColors[index % matchColors.length];
  }

  void calculateScore() {
    double score = 0.0;

    matches.forEach((l, r) {
      if (correct[l] == r) {
        score += 1 / correct.length;
      }
    });

    if (score > 1.0) score = 1.0;
    widget.onScoreCalculated(score);
  }

  void selectLeft(String value) {
    if (widget.reviewMode) return;
    if (matches.containsKey(value)) return;
    setState(() => selectedLeft = value);
  }

  void selectRight(String value) {
    if (widget.reviewMode) return;
    if (selectedLeft == null) return;
    if (matches.containsValue(value)) return;

    setState(() {
      matches[selectedLeft!] = value;

      /// guardar respuesta
      widget.question["userMatches"] = matches;

      selectedLeft = null;
      calculateScore();
    });
  }

  void removeMatch(String left) {
    if (widget.reviewMode) return;

    setState(() {
      matches.remove(left);
      widget.question["userMatches"] = matches;
      calculateScore();
    });
  }

  Widget buildItem({
    required String text,
    required bool isMatched,
    required bool isCorrect,
    required Color baseColor,
    required VoidCallback? onTap,
  }) {
    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.white;

    if (!widget.reviewMode && isMatched) {
      borderColor = baseColor;
      bgColor = baseColor.withOpacity(0.18);
    }

    if (widget.reviewMode && isMatched) {
      if (isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.18);
      } else {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.18);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: itemHeight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.deepPurple),
          ),
          child: const Row(
            children: [
              Icon(Icons.compare_arrows, color: Colors.deepPurple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Toca un elemento de la izquierda y luego su pareja de la derecha",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT
            Expanded(
              child: Column(
                children: leftItems.map((l) {
                  final isMatched = matches.containsKey(l);
                  final isCorrect =
                      isMatched && matches[l] == correct[l];
                  final color = colorFor(l);

                  return buildItem(
                    text: l,
                    isMatched: isMatched || selectedLeft == l,
                    isCorrect: isCorrect,
                    baseColor: color,
                    onTap: isMatched
                        ? () => removeMatch(l)
                        : () => selectLeft(l),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(width: 16),

            /// RIGHT
            Expanded(
              child: Column(
                children: rightItems.map((r) {
                  final entry = matches.entries.firstWhere(
                    (e) => e.value == r,
                    orElse: () => const MapEntry("", ""),
                  );

                  final isMatched = entry.key.isNotEmpty;
                  final isCorrect =
                      isMatched && correct[entry.key] == r;
                  final color =
                      isMatched ? colorFor(entry.key) : Colors.grey;

                  return buildItem(
                    text: r,
                    isMatched: isMatched,
                    isCorrect: isCorrect,
                    baseColor: color,
                    onTap: isMatched ? null : () => selectRight(r),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
