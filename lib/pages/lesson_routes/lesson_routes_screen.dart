import 'package:LudiArtech/models/lesson_args.dart';
import 'package:LudiArtech/widgets/background.dart';
import 'package:flutter/material.dart';

import 'widgets/lesson_routes_form.dart';

class LessonRoutesScreen extends StatelessWidget {
  const LessonRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LessonArgs;

    final height = MediaQuery.of(context).size.height;
    final scale = height < 800 ? height / 800 : 1.0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AppBackground(child: SizedBox()),
            Column(
              children: [
                Expanded(
                  child: LessonRoutesForm(
                    scale: scale,
                    selected: args.selected,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
