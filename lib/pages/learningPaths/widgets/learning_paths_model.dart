import 'package:LudiArtech/enum/learning_paths_enum.dart';

class LearningPathsModel {
  final String titulo;
  final String subtitulo;
  final LearningStatusEnum estado;

  LearningPathsModel({
    required this.titulo,
    required this.subtitulo,
    required this.estado,
  });
}
