import 'package:LudiArtech/models/lesson_args.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';
import '../../widgets/background.dart';
import 'widgets/lesson_form.dart';

class LessonScreen extends StatelessWidget {

  const LessonScreen({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LessonArgs;
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
                  child: LessonForm(
                    scale: scale,
                    title: args.title,
                    imagePath: args.imagePath,
                  ),
                ),
              ],
            ),

            BackButtonWidget(scale: scale, routeName: AppRoutes.learningPaths),

          ],
        ),
      ),
    );
  }
}
