import 'dart:async';

import 'package:LudiArtech/pages/lesson_routes/widgets/question_card.dart';
import 'package:LudiArtech/pages/lesson_routes/widgets/question_footer_button.dart';
import 'package:LudiArtech/pages/lesson_routes/widgets/question_header.dart';
import 'package:LudiArtech/pages/lesson_routes/widgets/result_modal.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/lesson_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/utils/certificate_pdf.dart';
import 'package:LudiArtech/widgets/dialogs/certificate_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_motivational.dart';
import 'package:flutter/material.dart';

class ExcelForm extends StatefulWidget {
  final double scale;

  const ExcelForm({super.key, required this.scale});

  @override
  State<ExcelForm> createState() => _ExcelFormState();
}

class _ExcelFormState extends State<ExcelForm> {
  bool scoreSaved = false;
  bool reviewMode = false;
  static const int totalSeconds = 60 * 60;
  late int remainingSeconds;
  Timer? timer;

  int currentPage = 0;
  final Map<int, dynamic> selectedAnswers = {};
  final Map<int, double> questionScores = {};
  final List<Map<String, dynamic>> questions = [
    {
      "question":
          "1. ¿Cuál es la principal función de una Tabla Dinámica en Excel?",
      "options": [
        "Crear gráficos automáticamente",
        "Resumir y analizar grandes cantidades de datos",
        "Formatear celdas con colores",
        "Proteger hojas de cálculo"
      ],
      "correct": "b",
    },
    {
      "type": "drag_group",
      "question":
          "2. Ordena cada campo a su área correspondiente en una Tabla Dinámica:",
      "options": ["Producto", "Ventas Totales", "Región", "Mes"],
      "groups": [
        {
          "label": "Filas",
          "slots": 2,
          "correct": ["Producto", "Región"]
        },
        {
          "label": "Columnas",
          "slots": 1,
          "correct": ["Mes"]
        },
        {
          "label": "Valores",
          "slots": 1,
          "correct": ["Ventas Totales"]
        }
      ]
    },
    {
      "type": "fill",
      "question":
          "3. Completa la siguiente información sobre los pasos para insertar una Tabla Dinámica:",
      "text":
          "Para insertar una Tabla Dinámica, debes ir a la pestaña ____ y seleccionar ____.",
      "options": [
        "inicio",
        "datos",
        "tabla dinámica",
        "proyectos",
        "gráfico",
        "insertar"
      ],
      "correct": ["insertar", "tabla dinámica"],
    },
    {
      "type": "match",
      "question":
          "4. Conecta cada elemento con su función en Tablas Dinámicas:",
      "left": [
        "Actualizar",
        "Filtros",
        "Diseño",
        "Segmentadores",
      ],
      "right": [
        "Refrescar datos origen",
        "Filtrado visual interactivo",
        "Cambiar distribución de campos",
        "Restringir datos mostrados",
      ],
      "correct": {
        "Filtros": "Restringir datos mostrados",
        "Segmentadores": "Filtrado visual interactivo",
        "Actualizar": "Refrescar datos origen",
        "Diseño": "Cambiar distribución de campos",
      }
    },
    {
      "question":
          "5. ¿Qué función de resumen NO está disponible por defecto en Tablas Dinámicas?",
      "options": ["Suma", "Promedio", "Concatenar texto", "Contar números"],
      "correct": "c",
    },
    {
      "type": "drag_group",
      "question": "6. Ordena cada ejemplo según su tipo de dato correcto:",
      "options": ["25/12/2025", "12345", "14:30:00", "Hola mundo"],
      "groups": [
        {
          "label": "Numero",
          "slots": 1,
          "correct": ["12345"]
        },
        {
          "label": "Texto",
          "slots": 1,
          "correct": ["Hola mundo"]
        },
        {
          "label": "Fecha",
          "slots": 1,
          "correct": ["25/12/2025"]
        },
        {
          "label": "Hora",
          "slots": 1,
          "correct": ["14:30:00"]
        }
      ]
    },
    {
      "type": "match",
      "question": "7. Conecta cada tipo de dato con su formato de celda:",
      "left": [
        "Número",
        "Porcentaje",
        "Fecha",
        "Texto",
      ],
      "right": [
        "#,##0.00",
        "DD/MM/AAAA",
        "0.00%",
        "@",
      ],
      "correct": {
        "Número": "#,##0.00",
        "Fecha": "DD/MM/AAAA",
        "Texto": "@",
        "Porcentaje": "0.00%",
      }
    },
    {
      "question":
          "8. ¿Qué símbolo debe anteceder a un número para que Excel lo reconozca como texto?",
      "options": [
        'Comilla doble (")',
        "Apóstrofe (')",
        "Signo de igual (=)",
        "Numeral (#)"
      ],
      "correct": "b",
    },
    {
      "type": "fill",
      "question":
          "9. Completa la siguiente información sobre Tipos de Datos en Microsoft Excel:",
      "text":
          "Excel almacena las fechas internamente como ____ y las horas como ____ de un día.",
      "options": [
        "fracciones",
        "proyectos",
        "variables",
        "datos",
        "números",
        "insertar"
      ],
      "correct": ["números", "fracciones"],
    },
    {
      "question":
          '10. Si escribes "01/02" en una celda, ¿cómo lo interpreta Excel por defecto?',
      "options": [
        "Como texto plano",
        "Como 1 de febrero del año actual",
        "Como un error",
        "Como la fracción 1/2"
      ],
      "correct": "b",
    },
  ];

  Future<void> _saveLessonScore(double score) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("Token nulo");
    }

    final api = ApiService(ApiConstants.baseUrl);
    final service = LessonService(api);

    await service.completeLesson(
      token: token,
      lessonId: 2,
      score: double.parse(score.toStringAsFixed(2)),
    );
  }

  @override
  void initState() {
    super.initState();
    remainingSeconds = totalSeconds;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      }
    });
  }

  String get timerText {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  bool get canContinue {
    final start = currentPage * 2;
    return questionScores.containsKey(start) &&
        questionScores.containsKey(start + 1);
  }

  void showResultModal() async {
    final double totalScore = questionScores.values.fold(0.0, (a, b) => a + b);

    if (!scoreSaved) {
      try {
        await _saveLessonScore(totalScore);
        scoreSaved = true;
      } catch (e) {
        debugPrint("Error enviando resultado: $e");
        return;
      }
    }

    if (totalScore < 7) {
      MotivationalDialog.show(
        context: context,
        score: totalScore,
        onReview: () {
          setState(() {
            reviewMode = true;
            currentPage = 0;
          });
        },
        onGoContent: () {
          Navigator.pushNamed(context, AppRoutes.learningPaths);
        },
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResultModal(
        score: totalScore,
        total: questions.length,
        onClose: () {
          Navigator.pop(context);
          setState(() {
            reviewMode = true;
            currentPage = 0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = currentPage * 2;
    final end = start + 2;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              LessonHeader(timerText: timerText),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      2,
                      (i) {
                        final index = start + i;
                        return QuestionCard(
                          key: ValueKey(index),
                          index: index,
                          question: questions[index],
                          selectedValue: selectedAnswers[index],
                          score: questionScores[index] ?? 0.0,
                          reviewMode: reviewMode,
                          onAnswerSelected: (String key, double score) {
                            if (reviewMode) return;

                            setState(() {
                              selectedAnswers[index] = key;
                              questionScores[index] = score;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              LessonFooterButton(
                enabled: canContinue || reviewMode,
                isLast: end >= questions.length,
                reviewMode: reviewMode,
                onPressed: () {
                  if (reviewMode && end >= questions.length) {
                    _checkCertificate();
                    //Navigator.pushNamed(context, AppRoutes.learningPaths);
                    return;
                  }

                  if (end >= questions.length) {
                    showResultModal();
                  } else {
                    setState(() => currentPage++);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkCertificate() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final api = ApiService(ApiConstants.baseUrl);
    final service = LessonService(api);

    final result = await service.getCertificateStatus(token: token);

    if (result.canGet) {
      CertificateDialog.show(
        context: context,
        fullName: result.fullname,
        onDownload: () async {
          await CertificatePDF.generate(result.fullname);
        },
      );
    } else {
      Navigator.pushNamed(context, AppRoutes.learningPaths);
    }
  }
}
