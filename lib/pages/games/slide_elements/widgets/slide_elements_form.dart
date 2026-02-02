import 'dart:async';

import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/game_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:flutter/material.dart';

class SlideElementsForm extends StatefulWidget {
  final double scale;
  final VoidCallback? onExitGame;

  const SlideElementsForm({
    super.key,
    required this.scale,
    this.onExitGame,
  });

  @override
  State<SlideElementsForm> createState() => SlideElementsFormState();
}

class MatchPair {
  final String left;
  final String right;
  final Color color;

  MatchPair(this.left, this.right, this.color);
}

class SlideElementsFormState extends State<SlideElementsForm> {
  final GameResultService _gameResultService =
      GameResultService(ApiService(ApiConstants.baseUrl));

  Timer? _timer;
  bool _timerStarted = false;
  bool _resultSent = false;

  int? _lastScore;
  bool? _streakGained;

  final int totalSeconds = 120;
  int remainingSeconds = 120;

  int hits = 0;
  int errors = 0;
  final int maxErrors = 3;

  String? selectedLeft;

  final List<MatchPair> matches = [];
  final List<String> errorList = [];

  final List<Color> colors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
  ];

  final List<String> leftItems = [
    "Demasiado texto",
    "Fuentes pequeñas",
    "Muchos colores",
    "Elementos desordenados",
    "Imágenes pixeladas",
    "Sin jerarquía",
  ];

  final List<String> rightItems = [
    "Destacar títulos",
    "Mínimo 24pt",
    "Usar imágenes HD",
    "Resumir en puntos",
    "Usar paleta limitada",
    "Alinear y organizar",
  ];

  final Map<String, String> correctMatches = {
    "Demasiado texto": "Resumir en puntos",
    "Fuentes pequeñas": "Mínimo 24pt",
    "Muchos colores": "Usar paleta limitada",
    "Imágenes pixeladas": "Usar imágenes HD",
    "Sin jerarquía": "Destacar títulos",
    "Elementos desordenados": "Alinear y organizar",
  };

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initGame() {
    _timer?.cancel();
    _timerStarted = false;
    _resultSent = false;

    remainingSeconds = totalSeconds;
    hits = 0;
    errors = 0;
    selectedLeft = null;
    matches.clear();
    errorList.clear();

    setState(() {});
  }

  void _startTimerIfNeeded() {
    if (_timerStarted) return;

    _timerStarted = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        _sendGameResult("LOSE");
        _showLoseDialog("🕕 Se acabó el tiempo");
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime() {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _selectLeft(String value) {
    _startTimerIfNeeded();

    setState(() {
      selectedLeft = value;
    });
  }

  void _selectRight(String value) {
    if (selectedLeft == null) return;

    _startTimerIfNeeded();

    setState(() {
      final toRemove = matches
          .where((e) => e.left == selectedLeft || e.right == value)
          .toList();

      for (final m in toRemove) {
        matches.remove(m);
      }

      final color = colors[matches.length % colors.length];

      matches.add(MatchPair(selectedLeft!, value, color));

      selectedLeft = null;
    });
  }

  bool get _canVerify => matches.length == correctMatches.length;

  void _verify() async {
    _stopTimer();

    hits = 0;
    errors = 0;
    errorList.clear();

    for (final m in matches) {
      if (correctMatches[m.left] == m.right) {
        hits++;
      } else {
        errors++;
        errorList.add("${m.left} → ${m.right}");
      }
    }

    setState(() {});

    await Future.delayed(const Duration(milliseconds: 400));

    if (errors >= maxErrors) {
      await _sendGameResult("LOSE");
      if (mounted) {
        _showLoseDialog("❌ Superaste el máximo de errores");
      }
      return;
    }

    await _sendGameResult("WIN");
    if (mounted) {
      _showWinDialog();
    }
  }

  Future<void> _sendGameResult(String status) async {
    if (_resultSent) return;
    _resultSent = true;

    final token = await TokenStorage.getToken();
    if (token == null) return;

    final usedTime = totalSeconds - remainingSeconds;

    try {
      final result = await _gameResultService.sendResultTimeAndError(
        token: token,
        gameId: 6,
        status: status,
        usedErrors: errors,
        totalErrors: 3,
        usedTime: usedTime,
        totalTime: 120,
      );

      _lastScore = result.score;
      _streakGained = result.streakGained;
    } catch (e) {
      debugPrint("Error enviando resultado: $e");
    }
  }

  Color _colorLeft(String l) {
    if (selectedLeft == l) {
      return colors[leftItems.indexOf(l) % colors.length];
    }

    final m = matches.where((e) => e.left == l);
    return m.isEmpty ? Colors.grey : m.first.color;
  }

  Color _colorRight(String r) {
    final m = matches.where((e) => e.right == r);
    return m.isEmpty ? Colors.grey : m.first.color;
  }

  void _showWinDialog() {
    _stopTimer();

    AppDialog.show(
      context: context,
      title: "🎉 ¡Felicidades!",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            _initGame();
          },
        ),
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

  Future<void> exitGameAsLose() async {
    _timer?.cancel();
    await _sendGameResult("LOSE");
  }

  void _showLoseDialog(String reason) {
    _stopTimer();

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
            _initGame();
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
    _stopTimer();

    AppDialog.show(
      context: context,
      title: "¿Reiniciar juego?",
      content: const Text(
        "Si reinicias perderás una vida.\n¿Deseas continuar?",
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
            await _sendGameResult("LOSE");
            _initGame();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * widget.scale),
      child: Column(
        children: [
          _statsCard(),
          const SizedBox(height: 8),
          _matchBoard(),
          const SizedBox(height: 8),
          _restartButton(),
        ],
      ),
    );
  }

  Widget _statsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _stat("⏱ Tiempo", _formatTime(), Colors.red),
            _stat("✅ Aciertos", "$hits/${correctMatches.length}", Colors.green),
            _stat("❌ Errores", "$errors/$maxErrors", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _stat(String t, String v, Color c) {
    return Column(
      children: [
        Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(v, style: TextStyle(fontSize: 18, color: c)),
      ],
    );
  }

  Widget _matchBoard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                    child: Center(
                        child: Text("ELEMENTOS",
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text("DEFINICIONES",
                            style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _leftColumn()),
                const SizedBox(width: 10),
                Expanded(child: _rightColumn()),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canVerify ? _verify : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Verificar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftColumn() {
    return Column(
      children: leftItems.map((l) {
        return _item(l, _colorLeft(l), () => _selectLeft(l));
      }).toList(),
    );
  }

  Widget _rightColumn() {
    return Column(
      children: rightItems.map((r) {
        return _item(r, _colorRight(r), () => _selectRight(r));
      }).toList(),
    );
  }

  Widget _item(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          color: color.withOpacity(0.15),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }

  Widget _restartButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _showRestartConfirmDialog,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Reinciar Juego", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
