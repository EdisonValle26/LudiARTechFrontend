import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../forms/excel_form.dart';
import '../forms/powerpoint_form.dart';
import '../forms/word_form.dart';
import '../providers/routes_provider.dart';

class ActivityCenterForm extends StatelessWidget {
  final double scale;
  const ActivityCenterForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
        final selected = context.watch<RoutesProvider>().selected;

    switch (selected) {
      case "excel":
        return ExcelForm(scale: scale);

      case "power_point":
        return PowerPointForm(scale: scale);

      case "word":
      default:
        return WordForm(scale: scale);
    }
  }
}
