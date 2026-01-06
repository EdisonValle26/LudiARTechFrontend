import 'package:flutter/material.dart';

class OrderQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final bool reviewMode;
  final double score;
  final Function(double) onScoreCalculated;

  const OrderQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.reviewMode,
    required this.score,
    required this.onScoreCalculated,
  });

  @override
  State<OrderQuestionCard> createState() => _OrderQuestionCardState();
}

class _OrderQuestionCardState extends State<OrderQuestionCard> {
  late List<String> items;
  late List<String> correctOrder;

  @override
  void initState() {
    super.initState();

    correctOrder = List<String>.from(widget.question["orderCorrect"]);

    /// USAR ORDEN DEL USUARIO EN REVIEW
    if (widget.reviewMode &&
        widget.question["userOrder"] != null) {
      items = List<String>.from(widget.question["userOrder"]);
    } else {
      items = List<String>.from(widget.question["options"]);
    }

    /// recalcular score en review
    if (widget.reviewMode) {
      calculateScore();
    }
  }

  // CALCULAR PUNTAJE
  void calculateScore() {
    double score = 0.0;
    final valuePerItem = 1 / items.length;

    for (int i = 0; i < items.length; i++) {
      if (items[i].trim().toLowerCase() ==
          correctOrder[i].trim().toLowerCase()) {
        score += valuePerItem;
      }
    }

    widget.onScoreCalculated(score.clamp(0, 1));
  }

  bool isCorrectPosition(int index) {
    return items[index].trim().toLowerCase() ==
        correctOrder[index].trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
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
                  color:
                      widget.score == 1.0 ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        /// INSTRUCCIÓN
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
              Icon(Icons.open_with, color: Colors.deepPurple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Arrastra los elementos para ordenarlos correctamente",
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

        /// LISTA
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            if (widget.reviewMode) return;

            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);

              /// GUARDAR ORDEN DEL USUARIO
              widget.question["userOrder"] =
                  List<String>.from(items);

              calculateScore();
            });
          },
          children: List.generate(items.length, (i) {
            final correct = isCorrectPosition(i);

            return Container(
              key: ValueKey(items[i]),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.reviewMode
                    ? correct
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.reviewMode
                      ? correct
                          ? Colors.green
                          : Colors.red
                      : Colors.deepPurple,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.reviewMode
                        ? correct
                            ? Icons.check_circle
                            : Icons.cancel
                        : Icons.drag_indicator,
                    color: widget.reviewMode
                        ? correct
                            ? Colors.green
                            : Colors.red
                        : Colors.deepPurple,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[i],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
