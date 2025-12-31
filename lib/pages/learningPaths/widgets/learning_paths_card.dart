import 'package:LudiArtech/models/lesson_args.dart';
import 'package:LudiArtech/pages/learningPaths/widgets/instructions_card.dart';
import 'package:LudiArtech/pages/learningPaths/widgets/learning_header_widget.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';

import 'data_box.dart';
import 'learning_paths_model.dart';

class LearningPathsCard extends StatelessWidget {
  final double scale;

  final String tituloGeneral;
  final String imagePath;
  final int imageSize;
  final int porcentaje;
  final int leccionesCompletadas;
  final int leccionesTotales;
  final double calificacion;
  final int calificacionesTotales;
  final LearningPathsModel leccion;
  final bool isEnabled;

  const LearningPathsCard({
    super.key,
    required this.scale,
    required this.tituloGeneral,
    required this.imagePath,
    required this.imageSize,
    required this.porcentaje,
    required this.leccionesCompletadas,
    required this.leccionesTotales,
    required this.calificacion,
    required this.calificacionesTotales,
    required this.leccion,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final sectionSpacing = h * 0.02 * scale;

    return Container(
      width: w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white,
          width: 2 * scale,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        w * 0.04 * scale,
        h * 0.03 * scale,
        w * 0.04 * scale,
        h * 0 * scale,
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: FirebaseImage(
                    path: imagePath,
                    width: scale * imageSize,
                    height: scale * imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12 * scale),
                Text(
                  tituloGeneral,
                  style: TextStyle(
                    fontSize: 22 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: sectionSpacing * 1.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DataBox(
                      scale: scale,
                      title: "$porcentaje%",
                      subtitle: "Completado",
                      color: Colors.purple,
                      small: true,
                    ),
                    DataBox(
                      scale: scale,
                      title: "$leccionesCompletadas/$leccionesTotales",
                      subtitle: "Lecciones",
                      color: Colors.green,
                      small: true,
                    ),
                    DataBox(
                      scale: scale,
                      title: "$calificacion/$calificacionesTotales",
                      subtitle: "  Calificación",
                      color: Colors.amber,
                      icon: Icons.star,
                      small: true,
                    ),
                  ],
                ),
                SizedBox(height: sectionSpacing * 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LearningPathsHeaderWidget(
                      leccion: leccion,
                      scale: scale,
                    ),
                    SizedBox(height: 20 * scale),
                    LearningInstructionsCard(
                      estado: leccion.estado,
                      scale: scale,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: sectionSpacing * 2),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16 * scale),
                backgroundColor: isEnabled
                    ? Colors.deepPurple.shade300
                    : Colors.grey.shade400,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: Icon(
                Icons.bar_chart,
                color: isEnabled ? Colors.white : Colors.grey.shade700,
              ),
              label: Text(
                "Continuar Lección",
                style: TextStyle(
                  fontSize: 17 * scale,
                  color: isEnabled ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: isEnabled
                  ? () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.lesson,
                        arguments: LessonArgs(
                          title: 'Lección de $tituloGeneral',
                          imagePath: 'Tech_instrucciones_leccion.png',
                        ),
                      );
                    }
                  : null,
            ),
          ),
          SizedBox(height: sectionSpacing * 4),
        ],
      ),
    );
  }
}
