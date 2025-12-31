import 'package:LudiArtech/enum/learning_paths_enum.dart';
import 'package:LudiArtech/pages/learningPaths/widgets/learning_paths_card.dart';
import 'package:LudiArtech/pages/learningPaths/widgets/learning_paths_model.dart';
import 'package:flutter/material.dart';


class ExcelForm extends StatelessWidget {
  final double scale;
  const ExcelForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final leccion = LearningPathsModel(
      titulo: "Lección de Microsoft Excel dentro de Excel",
      subtitulo: "Completada",
      estado: LearningStatusEnum.completada,
    );

    final bool isEnabled = leccion.estado == LearningStatusEnum.completada;

    return Container(
      width: w,
      padding: EdgeInsets.fromLTRB(
        w * 0.09 * scale,
        0,
        w * 0.09 * scale,
        h * 0.02 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.45),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            LearningPathsCard(
              scale: scale,
              imagePath: "MS_Excel.png",
              imageSize: 70,
              tituloGeneral: "Microsoft Excel",
              porcentaje: 65,
              leccionesCompletadas: 0,
              leccionesTotales: 1,
              calificacion: 6.8,
              calificacionesTotales: 10,
              leccion: leccion,
              isEnabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
