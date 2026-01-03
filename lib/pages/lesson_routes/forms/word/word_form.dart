import 'dart:async';

import 'package:LudiArtech/pages/lesson_routes/forms/word/widgets/question_card.dart';
import 'package:LudiArtech/pages/lesson_routes/forms/word/widgets/question_footer_button.dart';
import 'package:LudiArtech/pages/lesson_routes/forms/word/widgets/question_header.dart';
import 'package:LudiArtech/pages/lesson_routes/forms/word/widgets/result_modal.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

class WordForm extends StatefulWidget {
  final double scale;

  const WordForm({super.key, required this.scale});

  @override
  State<WordForm> createState() => _WordFormState();
}

class _WordFormState extends State<WordForm> {
  bool reviewMode = false;
  static const int totalSeconds = 60 * 60;
  late int remainingSeconds;
  Timer? timer;

  int currentPage = 0;
  final Map<int, dynamic> selectedAnswers = {};
  final Map<int, double> questionScores = {};
  final List<Map<String, dynamic>> questions = [
    // {
    //   "type": "drag_group",
    //   "question": "9. Ordena cada ejemplo según su tipo de dato correcto:",
    //   "options": [
    //     "12345",
    //     "Hola mundo",
    //     "25/12/2025",
    //     "14:30:00"
    //   ],
    //   "groups": [
    //     {
    //       "label": "Numero",
    //       "slots": 1,
    //       "correct": ["12345"]
    //     },
    //     {
    //       "label": "Texto",
    //       "slots": 1,
    //       "correct": ["Hola mundo"]
    //     },
    //     {
    //       "label": "Fecha",
    //       "slots": 1,
    //       "correct": [
    //         "25/12/2025"
    //       ]
    //     },
    //     {
    //       "label": "Hora",
    //       "slots": 1,
    //       "correct": ["14:30:00"]
    //     }
    //   ]
    // },
    // {
    //   "type": "drag_group",
    //   "question": "9. Ordena cada campo a su área correspondiente en una Tabla Dinámica:",
    //   "options": [
    //     "Producto",
    //     "Ventas Totales",
    //     "Región",
    //     "Mes"
    //   ],
    //   "groups": [
    //     {
    //       "label": "Filas",
    //       "slots": 2,
    //       "correct": ["Producto", "Región"]
    //     },
    //     {
    //       "label": "Columnas",
    //       "slots": 1,
    //       "correct": ["Mes"]
    //     },
    //     {
    //       "label": "Valores",
    //       "slots": 1,
    //       "correct": [
    //         "Ventas Totales"
    //       ]
    //     }
    //   ]
    // },
    {
      "question":
          "1. ¿En qué pestaña de Microsoft Word se encuentra la opción para insertar imágenes?",
      "options": ["Inicio", "Insertar", "Diseño", "Revisar"],
      "correct": "b",
    },
    {
      "type": "order",
      "question":
          "2. Ordena los pasos correctos para insertar una imagen desde tu computadora:",
      "options": [
        "Navegar y seleccionar la imagen",
        "Ir a la pestaña Insertar",
        "Seleccionar las opción Imágenes",
        "Clic en el botón Insertar",
        "Colocar el cursor donde deseas la imagen"
      ],
      "orderCorrect": [
        "Colocar el cursor donde deseas la imagen",
        "Ir a la pestaña insertar",
        "Seleccionar las opción Imágenes",
        "Navegar y seleccionar la imagen",
        "Clic en el botón Insertar"
      ],
    },
    {
      "type": "fill",
      "question":
          "3. Completa la siguiente información sobre imágenes en línea:",
      "text":
          "Por defecto, Bing solo mostrará imágenes ____ de ____ de ____, que podrás usar sin problema alguno en tus ____.",
      "options": [
        "gratis",
        "libres",
        "proyectos",
        "autor",
        "derechos",
        "ensayos"
      ],
      "correct": ["libres", "derechos", "autor", "proyectos"],
    },
    {
      "question":
          "4. Para ajustar el tamaño de una imagen insertada, ¿qué debes hacer?",
      "options": [
        "Mantener presionado el botón del mouse en una esquina y arrastrar",
        "Hacer doble clic en la imagen",
        "Presionar Ctrl + T",
        "Ir al menú Ver y ajustar zoom"
      ],
      "correct": "a",
    },
    {
      "type": "match",
      "question": "5. Une cada opción con su descripción correcta:",
      "left": [
        "Imágenes",
        "Imágenes en línea",
        "Puntos de control",
        "Formato de imagen",
      ],
      "right": [
        "Permiten cambiar el tamaño de la imagen",
        "Buscar imágenes en internet",
        "Aplicar bordes y efectos a la imagen",
        "Insertar imagen desde el equipo",
      ],
      "correct": {
        "Imágenes": "Insertar imagen desde el equipo",
        "Imágenes en línea": "Buscar imágenes en internet",
        "Puntos de control": "Permiten cambiar el tamaño de la imagen",
        "Formato de imagen": "Aplicar bordes y efectos a la imagen",
      }
    },
    {
      "type": "boolean",
      "question":
          "6. ¿El tamaño de página predeterminado en Microsoft Word puede depender de la región?",
      "options": ["Verdadero", "Falso"],
      "correct": "a",
    },
    {
      "type": "fill",
      "question": "7. Completa la información sobre los márgenes:",
      "text":
          "Los márgenes son los ____ en ____ alrededor del ____. Se pueden personalizar en la pestaña ____.",
      "options": [
        "blanco",
        "disposición",
        "letras",
        "espacios",
        "gris",
        "texto"
      ],
      "correct": ["espacios", "blanco", "texto", "disposición"],
    },
    {
      "type": "match",
      "question": "8. Une cada elemento con su definición correcta:",
      "left": [
        "Márgenes",
        "Orientación",
        "Encabezado",
        "Hipervínculo",
      ],
      "right": [
        "Enlace a otra página",
        "Texto superior de cada página",
        "Puede ser vertical u horizontal",
        "Espacios en blanco alrededor del texto",
      ],
      "correct": {
        "Márgenes": "Espacios en blanco alrededor del texto",
        "Orientación": "Puede ser vertical u horizontal",
        "Encabezado": "Texto superior de cada página",
        "Hipervínculo": "Enlace a otra página",
      }
    },
    {
      "type": "order",
      "question":
          "9. Ordena los pasos para configurar márgenes personalizados:",
      "options": [
        "Modificar valores (Superior, Inferior, Izquierdo, Derecho)",
        "Ir a la pestaña Disposición",
        "Clic en Aceptar",
        "Seleccionar Márgenes personalizados",
        "Clic en Márgenes"
      ],
      "orderCorrect": [
        "Ir a la pestaña Disposición",
        "Clic en Márgenes",
        "Seleccionar Márgenes personalizados",
        "Modificar valores (Superior, Inferior, Izquierdo, Derecho)",
        "Clic en Aceptar"
      ],
    },
    {
      "question":
          "10. ¿Qué orientación es ideal para contenido que abarca mayor ancho?",
      "options": ["Vertical", "Horizontal", "Diagonal", "Cuadrada"],
      "correct": "b",
    },
  ];

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

  void showResultModal() {
    final double totalScore = questionScores.values.fold(0.0, (a, b) => a + b);

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
