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
import 'package:flutter/material.dart';

class PowerPointForm extends StatefulWidget {
  final double scale;

  const PowerPointForm({super.key, required this.scale});

  @override
  State<PowerPointForm> createState() => _PowerPointFormState();
}

class _PowerPointFormState extends State<PowerPointForm> {
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
      "type": "fill",
      "question":
          "1. Completa la siguiente información sobre el diseño de diapositivas:",
      "text":
          "La regla ____ sugiere usar máximo ____ líneas de texto por diapositiva para mantener la atención.",
      "options": [
        "cinco",
        "6x6",
        "número",
        "10x10",
        "diez",
        "seis"
      ],
      "correct": ["6x6", "seis"],
    },
    {
      "type": "match",
      "question": "2. Conecta cada tipo de diseño con su mejor uso:",
      "left": [
        "Dos Contenidos",
        "Solo Título",
        "Título",
        "En Blanco",
      ],
      "right": [
        "Portada de sección",
        "Comparar dos conceptos",
        "Máxima personalización",
        "Agregar imágenes grandes",
      ],
      "correct": {
        "Título": "Portada de sección",
        "Dos Contenidos": "Comparar dos conceptos",
        "Solo Título": "Agregar imágenes grandes",
        "En Blanco": "Máxima personalización",
      }
    },
    {
      "type": "boolean",
      "question":
          "3. El atajo SHIFT + F5 inicia la presentación desde la diapositiva actual, mientras que F5 la inicia desde el principio, lo que permite previsualizar rápidamente el trabajo sin usar el mouse.",
      "options": ["Verdadero", "Falso"],
      "correct": "a",
    },
    {
      "question":
          "4. ¿Cuál es el nombre del panel donde se muestran todas las diapositivas en miniatura?",
      "options": ["Panel de Notas", "Panel de Diapositivas", "Cinta de Opciones", "Barra de Herramientas"],
      "correct": "b",
    },
    {
      "type": "drag_group",
      "question": "5. Ordena cada campo a su área correspondiente en un diseño de Power Point:",
      "options": [
        "Contraste",
        "Alineación",
        "Proximidad",
        "Repetición"
      ],
      "groups": [
        {
          "label": "Elementos relacionados juntos:",
          "slots": 1,
          "correct": ["Proximidad"]
        },
        {
          "label": "Elementos en orden visual:",
          "slots": 1,
          "correct": ["Alineación"]
        },
        {
          "label": "Mismo estilo en toda presentación:",
          "slots": 1,
          "correct": [
            "Repetición"
          ]
        },
        {
          "label": "Diferencia para destacar elementos:",
          "slots": 1,
          "correct": ["Contraste"]
        }
      ]
    },
    {
      "question":
          "6. ¿Qué orientación es ideal para contenido que abarca mayor ancho?",
      "options": ["Vertical", "Horizontal", "Diagonal", "Cuadrada"],
      "correct": "b",
    },
    {
      "question":
          "7. ¿Qué orientación es ideal para contenido que abarca mayor ancho?",
      "options": ["Vertical", "Horizontal", "Diagonal", "Cuadrada"],
      "correct": "b",
    },
    {
      "question":
          "8. ¿Qué orientación es ideal para contenido que abarca mayor ancho?",
      "options": ["Vertical", "Horizontal", "Diagonal", "Cuadrada"],
      "correct": "b",
    },
    {
      "question":
          "9. ¿Qué orientación es ideal para contenido que abarca mayor ancho?",
      "options": ["Vertical", "Horizontal", "Diagonal", "Cuadrada"],
      "correct": "b",
    },
    {
      "question":
          "10. ¿Qué orientación es ideal para contenido que abarca mayor ancho?",
      "options": ["Vertical", "Horizontal", "Diagonal", "Cuadrada"],
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
      lessonId: 3,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al guardar la calificación"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
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
                    Navigator.pushNamed(context, AppRoutes.learningPaths);
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
}
