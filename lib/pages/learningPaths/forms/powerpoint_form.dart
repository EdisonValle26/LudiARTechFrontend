import 'package:LudiArtech/enum/learning_paths_enum.dart';
import 'package:LudiArtech/models/lesson_status_model.dart';
import 'package:LudiArtech/pages/learningPaths/widgets/learning_paths_model.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/lesson_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:flutter/material.dart';

import '../widgets/learning_paths_card.dart';

class PowerPointForm extends StatelessWidget {
  final double scale;

  const PowerPointForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return FutureBuilder<LessonStatusModel>(
      future: _loadLesson("PowerPoint"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Sin datos"));
        }

        final lesson = snapshot.data!;
        final estado = lesson.estado;

        final leccion = LearningPathsModel(
          titulo: "Lección de Microsoft Power Point",
          subtitulo: estado.name,
          estado: estado,
        );

        final bool isEnabled = estado == LearningStatusEnum.desbloqueada ||
            estado == LearningStatusEnum.completada;

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
                  imagePath: "MS_PP.png",
                  imageSize: 70,
                  tituloGeneral: "Microsoft Power Point",
                  porcentaje: estado == LearningStatusEnum.completada ? 100 : 0,
                  leccionesCompletadas:
                      estado == LearningStatusEnum.completada ? 1 : 0,
                  leccionesTotales: 1,
                  calificacion: lesson.score,
                  calificacionesTotales: 10,
                  leccion: leccion,
                  isEnabled: isEnabled,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<LessonStatusModel> _loadLesson(String section) async {
  final token = await TokenStorage.getToken();

  if (token == null) {
    throw Exception("Token nulo");
  }

  final api = ApiService(ApiConstants.baseUrl);
  final service = LessonService(api);

  final list = await service.getLessonStatus(token: token);

  final lesson = list.firstWhere(
    (e) => e.section.trim().toLowerCase() == section.trim().toLowerCase(),
    orElse: () {
      throw Exception("No se encontró la sección: $section");
    },
  );

  return lesson;
}