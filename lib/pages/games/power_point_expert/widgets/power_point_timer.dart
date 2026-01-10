import 'package:flutter/material.dart';

class PowerPointTimer extends StatelessWidget {
  final int remainingSeconds;
  final double scale;

  const PowerPointTimer({
    super.key,
    required this.remainingSeconds,
    required this.scale,
  });

  String _formatTime() {
    final min = remainingSeconds ~/ 60;
    final sec = remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "⏱ Tiempo restante: ${_formatTime()}",
      style: TextStyle(fontSize: 16 * scale),
    );
  }
}
