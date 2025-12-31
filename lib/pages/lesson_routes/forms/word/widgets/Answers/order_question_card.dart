import 'package:flutter/material.dart';

class OrderQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final Function(double) onScoreCalculated;

  const OrderQuestionCard({
    super.key,
    required this.index,
    required this.question,
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
    items = List<String>.from(widget.question["options"]);
    correctOrder = List<String>.from(widget.question["orderCorrect"]);
  }

  void calculateScore() {
    double score = 0.0;

    for (int i = 0; i < items.length; i++) {
      if (items[i].toLowerCase() ==
          correctOrder[i].toLowerCase()) {
        score += 0.20;
      }
    }

    if (score > 1.0) score = 1.0;
    widget.onScoreCalculated(score);
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

        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
              calculateScore();
            });
          },
          children: List.generate(items.length, (i) {
            return Container(
              key: ValueKey(items[i]),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.drag_indicator,
                      color: Colors.deepPurple),
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
