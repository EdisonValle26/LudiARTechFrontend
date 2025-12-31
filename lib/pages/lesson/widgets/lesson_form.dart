import 'package:LudiArtech/models/lesson_args.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';

class LessonForm extends StatelessWidget {
  final double scale;
  final String title;
  final String imagePath;

  const LessonForm({
    super.key,
    required this.scale,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        w * 0.03 * scale,
        h * 0.07 * scale,
        w * 0.03 * scale,
        h * 0 * scale,
      ),
      child: Container(
        width: w,
        padding: EdgeInsets.all(16 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 15 * scale),
            Container(
              padding: EdgeInsets.all(16 * scale),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  FirebaseImage(
                    path: imagePath,
                    width: 170 * scale,
                    height: 160 * scale,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10 * scale),
                  Text(
                    "Instrucciones:",
                    style: TextStyle(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  _instructionItem(
                      "Responde las siguientes preguntas en base a lo practicado."),
                  _instructionItem(
                      "Encontrarás preguntas de selección múltiple, arrastrar y soltar, completar y conectar."),
                  _instructionItem("Tiempo límite: 60 minutos."),
                  _instructionItem("Calificación: 10 puntos."),
                  _instructionItem(
                      "Lee cuidadosamente cada pregunta antes de responder."),
                  _instructionItem(
                    "Una vez finalizada la lección, presiona 'Verificar' para confirmar.",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15 * scale),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14 * scale),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "Al finalizar, recibirás tu calificación de forma inmediata.  Si no apruebas, podrás reintentar la lección utilizando las rachas que hayas acumulado. El número de reintentos dependerá de la cantidad de rachas obtenidas durante tu progreso.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
              ),
            ),
            SizedBox(height: 15 * scale),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16 * scale),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.lessonRoutes,
                      arguments: LessonArgs(
                        selected: _mapTitleToKey(title),
                      ));
                },
                child: Text(
                  "Iniciar lección",
                  style: TextStyle(
                    fontSize: 18 * scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _mapTitleToKey(String title) {
    final t = title.toLowerCase();

    if (t.contains("excel")) return "excel";
    if (t.contains("power")) return "power point";
    return "word";
  }

  Widget _instructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12 * scale),
            ),
          ),
        ],
      ),
    );
  }
}
