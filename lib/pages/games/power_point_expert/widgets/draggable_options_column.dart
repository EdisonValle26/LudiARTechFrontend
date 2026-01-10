import 'package:flutter/material.dart';

class DraggableOptionsColumn extends StatelessWidget {
  final List<String> options;
  final Set<String> usedOptions;

  const DraggableOptionsColumn({
    super.key,
    required this.options,
    required this.usedOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final isUsed = usedOptions.contains(opt);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: isUsed
              ? _OptionCard(
                  text: opt,
                  backgroundColor: Colors.grey.shade400,
                  textColor: Colors.white,
                )
              : Draggable<String>(
                  data: opt,
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 160,
                      child: _OptionCard(
                        text: opt,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.4,
                    child: _OptionCard(
                      text: opt,
                      backgroundColor: Colors.orangeAccent,
                      textColor: Colors.black,
                    ),
                  ),
                  child: _OptionCard(
                    text: opt,
                    backgroundColor: Colors.orangeAccent,
                    textColor: Colors.black,
                  ),
                ),
        );
      }).toList(),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _OptionCard({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
