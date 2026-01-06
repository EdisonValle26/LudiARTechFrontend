import 'package:flutter/material.dart';

import 'dialog_button.dart';

class AppDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<DialogButton> buttons,
  }) {
    final width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: width * 0.08),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 152, 79, 231), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Contenido
              DefaultTextStyle(
                style: const TextStyle(color: Colors.white, fontSize: 16),
                child: content,
              ),
              const SizedBox(height: 20),
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: buttons.map((btn) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: btn.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btn.isPrimary
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        foregroundColor: btn.isPrimary ? Colors.blue : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: btn.isPrimary ? 5 : 0,
                      ),
                      child: Text(
                        btn.text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: btn.isPrimary ? Colors.blue : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
