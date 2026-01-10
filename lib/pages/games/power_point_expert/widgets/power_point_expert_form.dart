import 'dart:async';

import 'package:LudiArtech/pages/games/power_point_expert/widgets/colored_drop_box.dart';
import 'package:LudiArtech/pages/games/power_point_expert/widgets/draggable_options_column.dart';
import 'package:LudiArtech/pages/games/power_point_expert/widgets/time_remaining_card.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/game_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';

class PowerPointExpertForm extends StatefulWidget {
  final double scale;
  final VoidCallback? onExitGame;

  const PowerPointExpertForm({
    super.key,
    required this.scale,
    this.onExitGame,
  });

  @override
  PowerPointExpertFormState createState() => PowerPointExpertFormState();
}

class PowerPointExpertFormState extends State<PowerPointExpertForm> {
  final GameResultService _gameResultService =
      GameResultService(ApiService(ApiConstants.baseUrl));
  final Set<String> usedOptions = {};
  final Map<int, bool> verificationResults = {};
  bool isVerified = false;
  int _incorrectCount = 0;
  bool _verificationInProgress = false;
  static const int maxErrors = 5; // Límite de errores permitidos
  int remainingSeconds = 300; // 5 minutos
  Timer? _timer;
  bool _resultSent = false;
  bool get isGameComplete => usedOptions.length == options.length;

  int? _lastScore;
  bool? _streakGained;

  List<String> get leftOptions {
    final half = (options.length / 2).ceil();
    return options.take(half).toList();
  }

  List<String> get rightOptions {
    final half = (options.length / 2).ceil();
    return options.skip(half).toList();
  }

  /// Opciones (NO eliminadas)
  final List<String> options = [
    "Barra de acceso rápido",
    "Cinta de opciones",
    "Botones de control",
    "Barra de título",
    "Panel de diapositivas",
    "Barra de estado",
    "Panel de notas",
    "Vista",
    "Zoom",
    "Diapositiva"
  ];

  final Map<int, String> correctAnswers = {
    0: "Cinta de opciones",
    1: "Botones de control",
    2: "Barra de acceso rápido",
    3: "Barra de estado",
    4: "Panel de notas",
    5: "Diapositiva",
    6: "Barra de título",
    7: "Panel de diapositivas",
    8: "Vista",
    9: "Zoom"
  };

  final Map<int, String?> placements = {};

  void _verifyAnswers() async {
    if (_verificationInProgress) return;
    _verificationInProgress = true;

    _timer?.cancel();

    verificationResults.clear();
    _incorrectCount = 0;

    for (final entry in placements.entries) {
      final index = entry.key;
      final value = entry.value;

      if (value == null) continue;

      final isCorrect = correctAnswers[index] == value;
      verificationResults[index] = isCorrect;

      if (!isCorrect) {
        _incorrectCount++;
      }
    }

    setState(() {
      isVerified = true;
    });

    // Espera visual como en puzzle
    await Future.delayed(const Duration(milliseconds: 1500));

    if (_incorrectCount >= maxErrors) {
      await _sendGameResult("LOSE");

      _showLoseDialog(
        "Perdiste por cometer más de $maxErrors errores.",
      );
    } else {
      final result = await _sendGameResult("WIN");
      _showWinDialog();
    }

    _verificationInProgress = false;
  }

  void exitGameAsLose() {
    _timer?.cancel();
    _sendGameResult("LOSE");
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    remainingSeconds = 300;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;
      });

      if (remainingSeconds <= 0) {
        timer.cancel();
        _sendGameResult("LOSE");
        _showLoseDialog("🕕 Se acabó el tiempo");
      }
    });
  }

  String _formatTime() {
    final min = remainingSeconds ~/ 60;
    final sec = remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  Future<GameResultResponse?> _sendGameResult(String status) async {
    if (_resultSent) return null;
    _resultSent = true;

    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final usedTime = 300 - remainingSeconds;

    try {
      final result = await _gameResultService.sendResult(
        token: token,
        gameId: 5,
        status: status,
        usedMoves: _incorrectCount,
        totalMoves: maxErrors,
        usedTime: usedTime,
        totalTime: 300,
      );

      _lastScore = result.score;
      _streakGained = result.streakGained;

      return result;
    } catch (e) {
      debugPrint("Error enviando resultado: $e");
      return null;
    }
  }

  void _showWinDialogTemporary() {
    AppDialog.show(
      context: context,
      title: "🎉 ¡Felicidades!",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Respondiste todo correctamente."),
          const SizedBox(height: 8),
          Text("⏱ Tiempo : ${_formatTime()}"),
          const SizedBox(height: 8),
          const Text("🏆 Puntaje obtenido: 0"),
          const SizedBox(height: 8),
          const Text("🔥 ¡Ganaste +1 racha!"),
        ],
      ),
      buttons: [
        DialogButton(
          text: "Volver",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            widget.onExitGame?.call();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _showWinDialog() {
    AppDialog.show(
      context: context,
      title: "🎉 ¡Felicidades!",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Completaste el juego correctamente."),
          const SizedBox(height: 8),
          Text("⏱ Tiempo restante: ${_formatTime()}"),
          const SizedBox(height: 8),
          Text("🏆 Puntaje obtenido: ${_lastScore ?? 0}"),
          const SizedBox(height: 8),
          if (_streakGained == true)
            const Text("🔥 ¡Ganaste +1 racha!")
          else
            const Text("❌ No se ganó racha esta vez"),
        ],
      ),
      buttons: [
        DialogButton(
          text: "Reiniciar",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              placements.clear();
              _resultSent = false;
              _startTimer();
            });
          },
        ),
        DialogButton(
          text: "Volver",
          onPressed: () {
            Navigator.pop(context);
            widget.onExitGame?.call();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _showRestartConfirmDialog() {
    AppDialog.show(
      context: context,
      title: "¿Reiniciar juego?",
      content: const Text(
        "Si reinicias el juego perderás una vida.\n¿Deseas continuar?",
      ),
      buttons: [
        DialogButton(
          text: "No",
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          text: "Sí",
          isPrimary: true,
          onPressed: () async {
            Navigator.pop(context);

            _timer?.cancel();
            await _sendGameResult("LOSE");

            setState(() {
              placements.clear();
              usedOptions.clear();
              verificationResults.clear();
              isVerified = false;
              _incorrectCount = 0;
              _resultSent = false;
              _startTimer();
            });
          },
        ),
      ],
    );
  }

  void _showLoseDialog(String reason) {
    _timer?.cancel();

    AppDialog.show(
      context: context,
      title: "❌ Perdiste una vida",
      content: Text(reason),
      buttons: [
        DialogButton(
          text: "Reiniciar",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              placements.clear();
              usedOptions.clear();
              verificationResults.clear();
              isVerified = false;
              _resultSent = false;
              _startTimer();
            });
          },
        ),
        DialogButton(
          text: "Volver",
          onPressed: () {
            Navigator.pop(context);
            widget.onExitGame?.call();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _openFullScreenImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Imagen PowerPoint"),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: const FirebaseImage(
                path: "interfaz_power_point.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDrop({
    required int index,
    required String value,
  }) async {
    // validar vidas ANTES de permitir jugar
    final canPlay = await _checkLives();
    if (!canPlay) return;

    // Si ya hay algo colocado, no permitir
    if (placements[index] != null) return;

    setState(() {
      placements[index] = value;
      usedOptions.add(value);
    });
  }

  Future<bool> _checkLives() async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    final api = ApiService(ApiConstants.baseUrl);
    final userService = UserService(api);

    try {
      final stats = await userService.getUserStats(token: token);

      if (stats.lives <= 0) {
        _showNoLivesDialog();
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("Error obteniendo vidas: $e");
      return false;
    }
  }

  void _showNoLivesDialog() {
    AppDialog.show(
      context: context,
      title: "💔 Sin vidas",
      content: const Text(
        "Te quedaste sin vidas.\n\nDebes esperar 5 minutos para recuperar una vida.",
      ),
      buttons: [
        DialogButton(
          text: "Volver",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            widget.onExitGame?.call();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final rectColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pinkAccent,
      Colors.limeAccent,
      Colors.deepPurple,
      Colors.lightBlueAccent,
      Colors.yellow,
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(10 * widget.scale),
      child: Column(
        children: [
          Text(
            "Interfaz de PowerPoint",
            style: TextStyle(
              fontSize: w * 0.065 * widget.scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          TimeRemainingCard(
            timeText: _formatTime(),
          ),
          const SizedBox(height: 5),

          /// IMAGEN + RECTÁNGULOS
          GestureDetector(
            onTap: _openFullScreenImage,
            child: Stack(
              children: [
                const FirebaseImage(
                  path: "interfaz_power_point.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 230,
                  top: 69,
                  child: ColoredDropBox(
                    index: 0,
                    color: rectColors[0],
                    text: placements[0],
                    isCorrect: isVerified ? verificationResults[0] : null,
                    onAccept: (value) {
                      _handleDrop(index: 0, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[0];
                        placements[0] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 260,
                  top: 1,
                  child: ColoredDropBox(
                    index: 1,
                    color: rectColors[1],
                    text: placements[1],
                    isCorrect: isVerified ? verificationResults[1] : null,
                    onAccept: (value) {
                      _handleDrop(index: 1, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[1];
                        placements[1] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 79,
                  top: 44,
                  child: ColoredDropBox(
                    index: 2,
                    color: rectColors[2],
                    text: placements[2],
                    isCorrect: isVerified ? verificationResults[2] : null,
                    onAccept: (value) {
                      _handleDrop(index: 2, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[2];
                        placements[2] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 70,
                  top: 172,
                  child: ColoredDropBox(
                    index: 3,
                    color: rectColors[3],
                    text: placements[3],
                    isCorrect: isVerified ? verificationResults[3] : null,
                    onAccept: (value) {
                      _handleDrop(index: 3, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[3];
                        placements[3] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 172,
                  top: 155,
                  child: ColoredDropBox(
                    index: 4,
                    color: rectColors[4],
                    text: placements[4],
                    isCorrect: isVerified ? verificationResults[4] : null,
                    onAccept: (value) {
                      _handleDrop(index: 4, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[4];
                        placements[4] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 90,
                  top: 138,
                  child: ColoredDropBox(
                    index: 5,
                    color: rectColors[5],
                    text: placements[5],
                    isCorrect: isVerified ? verificationResults[5] : null,
                    onAccept: (value) {
                      _handleDrop(index: 5, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[5];
                        placements[5] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 120,
                  top: 0,
                  child: ColoredDropBox(
                    index: 6,
                    color: rectColors[6],
                    text: placements[6],
                    isCorrect: isVerified ? verificationResults[6] : null,
                    onAccept: (value) {
                      _handleDrop(index: 6, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[6];
                        placements[6] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 62,
                  top: 65,
                  child: ColoredDropBox(
                    index: 7,
                    color: rectColors[7],
                    text: placements[7],
                    isCorrect: isVerified ? verificationResults[7] : null,
                    onAccept: (value) {
                      _handleDrop(index: 7, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[7];
                        placements[7] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 230,
                  top: 153,
                  child: ColoredDropBox(
                    index: 8,
                    color: rectColors[8],
                    text: placements[8],
                    isCorrect: isVerified ? verificationResults[8] : null,
                    onAccept: (value) {
                      _handleDrop(index: 8, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[8];
                        placements[8] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 158,
                  child: ColoredDropBox(
                    index: 9,
                    color: rectColors[9],
                    text: placements[9],
                    isCorrect: isVerified ? verificationResults[9] : null,
                    onAccept: (value) {
                      _handleDrop(index: 9, value: value);
                    },
                    onRemove: () {
                      setState(() {
                        final removed = placements[9];
                        placements[9] = null;
                        if (removed != null) {
                          usedOptions.remove(removed);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// OPCIONES
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DraggableOptionsColumn(
                  options: leftOptions,
                  usedOptions: usedOptions,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DraggableOptionsColumn(
                  options: rightOptions,
                  usedOptions: usedOptions,
                ),
              ),
            ],
          ),

          /// BOTÓN REINICIAR
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isGameComplete && !isVerified) {
                  _verifyAnswers();
                } else {
                  _showRestartConfirmDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isGameComplete && !isVerified ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isGameComplete && !isVerified ? "Verificar" : "Reiniciar juego",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
