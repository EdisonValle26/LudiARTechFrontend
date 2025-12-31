import 'package:LudiArtech/enum/learning_paths_enum.dart';
import 'package:flutter/material.dart';

class LearningInstructionsCard extends StatelessWidget {
  final LearningStatusEnum estado;
  final double scale;

  const LearningInstructionsCard({
    super.key,
    required this.estado,
    required this.scale,
  });

  List<String> get instructions {
    switch (estado) {
      case LearningStatusEnum.desbloqueada:
        return [
          "Lea atentamente el contenido de la lección antes de iniciar.",
          "La lección es de manera individual, aplicando lo aprendido.",
          "Revise sus respuestas antes de enviar la lección.",
          "La lección cuenta con un intento inicial; los reintentos estarán disponibles únicamente si dispone de rachas acumuladas.",
        ];
      case LearningStatusEnum.completada:
        return [
          "La lección ha sido completada correctamente.",
          "Revise el contenido si desea reforzar o aclarar algún concepto.",
          "Recuerde que los reintentos estarán disponibles únicamente si dispone de rachas acumuladas.",
          "Continúe con la siguiente lección para avanzar en su ruta de aprendizaje.",
        ];
      case LearningStatusEnum.bloqueada:
        return [
          "Esta lección se encuentra bloqueada.",
          "Complete los juegos correspondientes para poder acceder.",
          "Recuerde que los reintentos estarán disponibles únicamente si dispone de rachas acumuladas.",
        ];
    }
  }

  Color get color {
    switch (estado) {
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
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instrucciones",
            style: TextStyle(
              fontSize: 16 * scale,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 12 * scale),
          ...instructions.map(
            (text) => Padding(
              padding: EdgeInsets.only(bottom: 8 * scale),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8 * scale, color: color),
                  SizedBox(width: 10 * scale),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 15 * scale),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
