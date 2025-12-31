import 'package:flutter/material.dart';

import 'dialog_button.dart';

class AppDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<DialogButton> buttons,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: content,
        actions: buttons.map((btn) {
          return TextButton(
            onPressed: btn.onPressed,
            style: btn.isPrimary
                ? TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  )
                : null,
            child: Text(btn.text),
          );
        }).toList(),
      ),
    );
  }
}
