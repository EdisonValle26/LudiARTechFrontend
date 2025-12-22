import 'package:flutter/material.dart';

import '../widgets/learning_paths_card.dart';
import '../widgets/nivel_model.dart';

class ExcelForm extends StatelessWidget {
  final double scale;
  const ExcelForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

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
              tituloGeneral: "Aplicaciones Ofimaticas Excel en Línea",
              porcentaje: 65,
              leccionesCompletadas: 13,
              leccionesTotales: 20,
              calificacion: 6.8,
              niveles: [
                NivelModel(
                  completado: true,
                  isLast: false,
                  titulo: "Ejemplo (Introducción a Excel)",
                  subtitulo: "Completado - 100%",
                  etiqueta: "Básico",
                  etiquetaFondo: Colors.greenAccent,
                  etiquetaTexto: Colors.green,
                  numeroColor: Colors.green,
                ),
                NivelModel(
                  completado: false,
                  isLast: false,
                  titulo: "Ejemplo (Gráficos y tablas dinámicas)",
                  subtitulo: "En progreso - 7 de 12 temas",
                  etiqueta: "Intermedio",
                  etiquetaFondo: Colors.yellowAccent,
                  etiquetaTexto: Colors.orange,
                  numeroColor: Colors.yellow,
                ),
                NivelModel(
                  completado: false,
                  isLast: true,
                  titulo: "Ejemplo (Macro VBA)",
                  subtitulo: "Boqueada",
                  etiqueta: "Avanzado",
                  etiquetaFondo: Colors.redAccent.shade100,
                  etiquetaTexto: Colors.red,
                  numeroColor: Colors.redAccent.shade100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
