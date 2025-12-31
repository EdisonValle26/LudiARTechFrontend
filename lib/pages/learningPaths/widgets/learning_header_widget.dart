import 'package:LudiArtech/enum/learning_paths_enum.dart';
import 'package:LudiArtech/pages/learningPaths/widgets/learning_paths_model.dart';
import 'package:flutter/material.dart';

class LearningPathsHeaderWidget extends StatelessWidget {
  final LearningPathsModel leccion;
  final double scale;

  const LearningPathsHeaderWidget({
    super.key,
    required this.leccion,
    required this.scale,
  });

  IconData get icon {
    switch (leccion.estado) {
      case LearningStatusEnum.completada:
        return Icons.check_circle;
      case LearningStatusEnum.desbloqueada:
        return Icons.schedule;
      case LearningStatusEnum.bloqueada:
        return Icons.lock;
    }
  }

  Color get color {
    switch (leccion.estado) {
      case LearningStatusEnum.completada:
        return Colors.green;
      case LearningStatusEnum.desbloqueada:
        return Colors.blue;
      case LearningStatusEnum.bloqueada:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 42 * scale, color: color),
        SizedBox(width: 5 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leccion.titulo,
                style: TextStyle(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6 * scale),
              Text(
                leccion.subtitulo,
                style: TextStyle(
                  fontSize: 13 * scale,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
