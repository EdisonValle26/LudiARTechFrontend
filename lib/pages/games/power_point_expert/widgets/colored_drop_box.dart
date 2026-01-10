import 'package:flutter/material.dart';

class ColoredDropBox extends StatelessWidget {
  final int index;
  final Color color;
  final String? text;
  final Function(String) onAccept;
  final VoidCallback? onRemove;
  final bool? isCorrect;

  const ColoredDropBox({
    super.key,
    required this.index,
    required this.color,
    required this.text,
    required this.onAccept,
    this.onRemove,
    this.isCorrect,
  });

  bool get _canExpandRight =>
      index == 2 || index == 7 || index == 3 || index == 6;

  Color get _finalColor {
    if (isCorrect == null) return color;
    return isCorrect! ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (_) => text == null && isCorrect == null,
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: text != null && isCorrect == null ? onRemove : null,
          child: Container(
            width: _canExpandRight ? 90 : 50,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _finalColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: text == null
                ? const Icon(Icons.add, size: 10, color: Colors.white70)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        text!,
                        textAlign: TextAlign.center,
                        maxLines: _canExpandRight ? 2 : 3,
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.2
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        text!,
                        textAlign: TextAlign.center,
                        maxLines: _canExpandRight ? 2 : 3,
                        style: const TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}