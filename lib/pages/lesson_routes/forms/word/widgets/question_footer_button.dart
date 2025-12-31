import 'package:flutter/material.dart';

class LessonFooterButton extends StatelessWidget {
  final bool enabled;
  final bool isLast;
  final bool reviewMode;
  final VoidCallback onPressed;

  const LessonFooterButton({
    super.key,
    required this.enabled,
    required this.isLast,
    required this.reviewMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String text;

    if (isLast && reviewMode) {
      text = "Finalizar revisión";
    } else if (isLast) {
      text = "Verificar respuestas";
    } else {
      text = "Siguiente";
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(text),
        ),
      ),
    );
  }
}