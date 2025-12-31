import 'package:flutter/material.dart';

class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  DialogButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  });
}
