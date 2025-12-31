import 'package:flutter/material.dart';

import '../forms/excel/excel_form.dart';
import '../forms/power_point/powerpoint_form.dart';
import '../forms/word/word_form.dart';


class LessonRoutesForm extends StatelessWidget {
  final double scale;
  final String selected;

  const LessonRoutesForm({
    super.key,
    required this.scale,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    switch (selected) {
      case "excel":
        return ExcelForm(scale: scale);

      case "power point":
        return PowerPointForm(scale: scale);

      case "word":
      default:
        return WordForm(scale: scale);
    }
  }
}

