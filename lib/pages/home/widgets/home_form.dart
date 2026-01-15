import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'icon_content.dart';
import 'image_content.dart';
import 'stack_container.dart';

class HomeForm extends StatelessWidget {
  final double scale;
  const HomeForm({super.key, required this.scale});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final sectionSpacing = h * 0.025 * scale;
    return Container(
      width: w,
      padding: EdgeInsets.fromLTRB(
        w * 0.09 * scale,
        h * 0.02 * scale,
        w * 0.09 * scale,
        h * 0.02 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "📚 Actividades y Recursos",
            style: TextStyle(
              fontSize: w * 0.060 * scale,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          SizedBox(height: sectionSpacing),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.videoLibrary);
                  },
                  child: StackContainer(
                    scale: scale,
                    color: Colors.blue.withOpacity(0.3),
                    content: IconContent(
                      scale: scale,
                      icon: Icons.play_circle,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      title: "Vídeos",
                      subtitle: "3 de 6 vídeos",
                      progress: 0.75,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: sectionSpacing),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.activityCenter);
                  },
                  child: StackContainer(
                    scale: scale,
                    color: Colors.deepPurpleAccent.withOpacity(0.3),
                    content: ImageContent(
                      scale: scale,
                      imagePath:
                          "actividades_pantalla_principal.png",
                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.1),
                      title: "Actividades",
                      subtitle: "2 de 6 actividades",
                      progress: 0.55,
                      progressColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                SizedBox(height: sectionSpacing),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.learningPaths);
                  },
                  child: StackContainer(
                    scale: scale,
                    color: Colors.pinkAccent.withOpacity(0.3),
                    content: ImageContent(
                      scale: scale,
                      imagePath:
                          "Lecciones_pantalla_principal.png",
                      backgroundColor: Colors.pinkAccent.withOpacity(0.1),
                      title: "Lecciones",
                      subtitle: "1 de 3 lecciones",
                      progress: 0.25,
                      progressColor: Colors.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
