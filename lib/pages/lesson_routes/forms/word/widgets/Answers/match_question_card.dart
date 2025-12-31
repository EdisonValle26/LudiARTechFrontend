import 'package:flutter/material.dart';

class MatchQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final Function(double) onScoreCalculated;

  const MatchQuestionCard({
    super.key,
    required this.index,
    required this.question,
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
  }

  Color colorFor(String key) {
    final index = leftItems.indexOf(key);
    return matchColors[index % matchColors.length];
  }

  void calculateScore() {
    double score = 0.0;

    matches.forEach((l, r) {
      if (correct[l] == r) {
        score += 0.25;
      }
    });

    if (score > 1.0) score = 1.0;
    widget.onScoreCalculated(score);
  }

  void selectLeft(String value) {
    if (matches.containsKey(value)) return;
    setState(() => selectedLeft = value);
  }

  void selectRight(String value) {
    if (selectedLeft == null) return;
    if (matches.containsValue(value)) return;

    setState(() {
      matches[selectedLeft!] = value;
      selectedLeft = null;
      calculateScore();
    });
  }

  void removeMatch(String left) {
    setState(() {
      matches.remove(left);
      calculateScore();
    });
  }

  Widget buildItem({
    required String text,
    required bool active,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: itemHeight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.18) : Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: active ? color : Colors.grey.shade300,
            width: borderWidth,
          ),
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
        Text(
          widget.question["question"],
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                  final isSelected = selectedLeft == l;
                  final color = colorFor(l);

                  return buildItem(
                    text: l,
                    active: isMatched || isSelected,
                    color: color,
                    onTap: () =>
                        isMatched ? removeMatch(l) : selectLeft(l),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(width: 16),

            /// RIGHT
            Expanded(
              child: Column(
                children: rightItems.map((r) {
                  final isUsed = matches.containsValue(r);
                  final leftKey = matches.entries
                      .firstWhere(
                        (e) => e.value == r,
                        orElse: () => const MapEntry("", ""),
                      )
                      .key;

                  final color =
                      leftKey.isNotEmpty ? colorFor(leftKey) : Colors.grey;

                  return buildItem(
                    text: r,
                    active: isUsed,
                    color: color,
                    onTap: isUsed ? null : () => selectRight(r),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
