import 'package:flutter/material.dart';

class DragGroupQuestionCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> question;
  final bool reviewMode;
  final double score;
  final Function(double) onScoreCalculated;

  const DragGroupQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.reviewMode,
    required this.score,
    required this.onScoreCalculated,
  });

  @override
  State<DragGroupQuestionCard> createState() =>
      _DragGroupQuestionCardState();
}

class _DragGroupQuestionCardState
    extends State<DragGroupQuestionCard> {
  late List<String> options;
  late List<Map<String, dynamic>> groups;

  @override
  void initState() {
    super.initState();

    options = List<String>.from(widget.question["options"]);

    groups = (widget.question["groups"] as List)
        .map((g) => {
              "label": g["label"],
              "slots": g["slots"],
              "correct": List<String>.from(g["correct"]),
              "user": List<String>.filled(g["slots"], ""),
            })
        .toList();

    if (widget.reviewMode &&
        widget.question["userGroups"] != null) {
      groups = List<Map<String, dynamic>>.from(
          widget.question["userGroups"]);
      calculateScore();
    }
  }

  // SCORE PROPORCIONAL
  void calculateScore() {
    int total = 0;
    int correct = 0;

    for (final group in groups) {
      for (int i = 0; i < group["slots"]; i++) {
        total++;
        if (group["user"][i] == group["correct"][i]) {
          correct++;
        }
      }
    }

    widget.onScoreCalculated(
        (correct / total).clamp(0, 1));
  }

  bool optionUsed(String option) {
    for (final g in groups) {
      if (g["user"].contains(option)) return true;
    }
    return false;
  }

  void removeOption(String option) {
    for (final g in groups) {
      for (int i = 0; i < g["slots"]; i++) {
        if (g["user"][i] == option) {
          g["user"][i] = "";
        }
      }
    }
  }

  bool isCorrect(group, index) {
    return group["user"][index] == group["correct"][index];
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.reviewMode)
              Text(
                "P: ${widget.score.toStringAsFixed(2)} / 1.00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.score == 1
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        /// INSTRUCCIONES
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple),
          ),
          child: const Row(
            children: [
              Icon(Icons.drag_indicator,
                  color: Colors.deepPurple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Arrastra las opciones a su lugar correcto. "
                  "Toca un slot para cambiar la opción.",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// OPCIONES
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final used = optionUsed(opt);

            return Draggable<String>(
              data: opt,
              feedback: Material(
                color: Colors.transparent,
                child: optionCard(opt,
                    dragging: true),
              ),
              childWhenDragging:
                  optionCard(opt, disabled: true),
              child: optionCard(opt,
                  disabled: used),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        /// GRUPOS
        ...groups.map((group) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// LABEL
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin:
                      const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    group["label"],
                    style: const TextStyle(
                      fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// SLOTS
              Expanded(
                flex: 4,
                child: Row(
                  children: List.generate(group["slots"],
                      (i) {
                    final filled =
                        group["user"][i].isNotEmpty;
                    final correct =
                        widget.reviewMode &&
                            isCorrect(group, i);

                    return Expanded(
                      child: DragTarget<String>(
                        onAccept: (value) {
                          if (widget.reviewMode) return;

                          setState(() {
                            removeOption(value);
                            group["user"][i] = value;
                            widget.question["userGroups"] =
                                List<Map<String, dynamic>>.from(
                                    groups);
                            calculateScore();
                          });
                        },
                        builder: (_, __, ___) {
                          return GestureDetector(
                            onTap: widget.reviewMode ||
                                    !filled
                                ? null
                                : () {
                                    setState(() {
                                      group["user"][i] =
                                          "";
                                      calculateScore();
                                    });
                                  },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(
                                      right: 8,
                                      bottom: 16),
                              padding:
                                  const EdgeInsets.all(
                                      12),
                              decoration: BoxDecoration(
                                color: widget.reviewMode
                                    ? correct
                                        ? Colors.green
                                            .withOpacity(
                                                0.15)
                                        : Colors.red
                                            .withOpacity(
                                                0.15)
                                    : Colors.grey
                                        .withOpacity(
                                            0.1),
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                                border: Border.all(
                                  color: widget.reviewMode
                                      ? correct
                                          ? Colors.green
                                          : Colors.red
                                      : Colors
                                          .deepPurple,
                                ),
                              ),
                              child: Text(
                                filled
                                    ? group["user"][i]
                                    : "Arrastra aquí",
                                textAlign:
                                    TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 10),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget optionCard(String text,
      {bool dragging = false,
      bool disabled = false}) {
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey.shade300
              : Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color:  Colors.white
          ),
        ),
      ),
    );
  }
}
