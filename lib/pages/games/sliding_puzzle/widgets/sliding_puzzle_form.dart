import 'dart:async';
import 'dart:math';

import 'package:LudiArtech/models/puzzle_tile.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/game_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:flutter/material.dart';

import 'puzzle_grid.dart';
import 'puzzle_info_cards.dart';
import 'puzzle_mix_button.dart';

class SlidingPuzzleForm extends StatefulWidget {
  final double scale;
  final VoidCallback? onExitGame;
  const SlidingPuzzleForm({super.key, required this.scale, this.onExitGame});

  @override
  State<SlidingPuzzleForm> createState() => SlidingPuzzleFormState();
}

class SlidingPuzzleFormState extends State<SlidingPuzzleForm> {
  final GameResultService _gameResultService =
      GameResultService(ApiService(ApiConstants.baseUrl));
  int? _lastScore;
  bool? _streakGained;
  static const int gridSize = 3;
  late List<PuzzleTile> tiles;

  bool gameStarted = false;
  bool _resultSent = false;

  int remainingMoves = 100;
  int remainingSeconds = 180;

  Timer? _timer;

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
    gameStarted = false;
    remainingMoves = 100;
    remainingSeconds = 180;
    _resultSent = false;

    tiles = [
      PuzzleTile(value: 1, label: 'Colocar cursor en el documento'),
      PuzzleTile(value: 2, label: 'Ir a pestaña Insertar'),
      PuzzleTile(value: 3, label: 'Clic en Imágenes'),
      PuzzleTile(value: 4, label: 'Seleccionar imagen del equipo'),
      PuzzleTile(value: 5, label: 'Clic en botón Insertar'),
      PuzzleTile(value: 6, label: 'Ajustar tamaño de la imagen'),
      PuzzleTile(value: 7, label: 'Insertar'),
      PuzzleTile(value: 8, label: 'Ajustar imagen'),
      PuzzleTile(value: 0, isEmpty: true),
    ];

    tiles.shuffle(Random());
    setState(() {});
  }

  void exitGameAsLose() {
    _timer?.cancel();
    _sendGameResult("LOSE");
  }

  void _startTimer() {
    _timer?.cancel();
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

  void stopGame() {
    _timer?.cancel();
    _timer = null;
    gameStarted = false;
  }

  String _formatTime() {
    final min = remainingSeconds ~/ 60;
    final sec = remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _onTileTap(int index) async {
    final canPlay = await _checkLives();
    if (!canPlay) return;

    final emptyIndex = tiles.indexWhere((t) => t.isEmpty);
    if (!_isAdjacent(index, emptyIndex)) return;

    if (!gameStarted) {
      gameStarted = true;
      _startTimer();
    }

    setState(() {
      final temp = tiles[index];
      tiles[index] = tiles[emptyIndex];
      tiles[emptyIndex] = temp;
      remainingMoves--;
    });

    if (remainingMoves == 0) {
      _sendGameResult("LOSE");
      _showLoseDialog("🔄 Se acabaron los movimientos");
      return;
    }

    if (_isSolved()) {
  _timer?.cancel();

  final result = await _sendGameResult("WIN");

  if (result != null) {
    _showWinDialog();
  }
}

  }

  bool _isAdjacent(int a, int b) {
    final ax = a % gridSize;
    final ay = a ~/ gridSize;
    final bx = b % gridSize;
    final by = b ~/ gridSize;

    return (ax == bx && (ay - by).abs() == 1) ||
        (ay == by && (ax - bx).abs() == 1);
  }

  bool _isSolved() {
    for (int i = 0; i < 8; i++) {
      if (tiles[i].value != i + 1) return false;
    }
    return true;
  }

  void _showWinDialog() {
    AppDialog.show(
      context: context,
      title: "🎉 ¡Felicidades!",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Completaste el juego correctamente."),
          const SizedBox(height: 8),
          Text("⏱ Tiempo: ${_formatTime()}"),
          const SizedBox(height: 8),
          Text("⭐ Movimientos restantes: $remainingMoves"),
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
          text: "Volver",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.activityCenter);
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

  void _showMixConfirmDialog() {
    AppDialog.show(
      context: context,
      title: "¿Mezclar cartas?",
      content: const Text(
        "Si mezclas las cartas perderás una vida.\n¿Deseas continuar?",
      ),
      buttons: [
        DialogButton(
          text: "No",
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          text: "Sí",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);

            exitGameAsLose();

            _initGame();
          },
        ),
      ],
    );
  }

  void _showNoLivesDialog() {
    AppDialog.show(
      context: context,
      title: "💀 Sin vidas",
      content: const Text(
        "Te quedaste sin vidas.\n\nDebes esperar 5 minutos para recuperar una vida.",
      ),
      buttons: [
        DialogButton(
          text: "Volver",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * widget.scale),
      child: Column(
        children: [
          Text(
            "Proceso de inserción de imagen en Microsoft Word",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.055 * widget.scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          PuzzleInfoCards(
            time: _formatTime(),
            remainingMoves: remainingMoves,
          ),
          const SizedBox(height: 25),
          PuzzleGrid(
            tiles: tiles,
            gridSize: gridSize,
            onTileTap: _onTileTap,
          ),
          const SizedBox(height: 25),
          PuzzleMixButton(
            onPressed: () async {
              final canPlay = await _checkLives();
              if (!canPlay) return;

              _showMixConfirmDialog();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _validateBeforeStart() async {
    final canPlay = await _checkLives();
    if (!canPlay) return;

    _initGame();
  }

  Future<GameResultResponse?> _sendGameResult(String status) async {
    if (_resultSent) return null;
    _resultSent = true;

    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final usedMoves = 100 - remainingMoves;
    final usedTime = 180 - remainingSeconds;

    try {
      final result = await _gameResultService.sendResult(
        token: token,
        gameId: 1,
        status: status,
        usedMoves: usedMoves,
        totalMoves: 100,
        usedTime: usedTime,
        totalTime: 180,
      );

      _lastScore = result.score;
      _streakGained = result.streakGained;

      return result;
    } catch (e) {
      debugPrint("Error enviando resultado: $e");
      return null;
    }
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
}
