import 'dart:math';

import 'package:LudiArtech/pages/games/MemoryPairs/widgets/memory_grid.dart';
import 'package:LudiArtech/pages/games/MemoryPairs/widgets/memory_restart_button.dart';
import 'package:LudiArtech/pages/games/MemoryPairs/widgets/memory_stats_cards.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/game_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:flutter/material.dart';

class MemoryPairsForm extends StatefulWidget {
  final double scale;
  final VoidCallback? onExitGame;

  const MemoryPairsForm({
    super.key,
    required this.scale,
    this.onExitGame,
  });

  @override
  MemoryPairsFormState createState() => MemoryPairsFormState();
}

class MemoryPairsFormState extends State<MemoryPairsForm> {
  final GameResultService _gameResultService =
      GameResultService(ApiService(ApiConstants.baseUrl));

  static const int totalPairs = 6;
  static const int maxErrors = 6;

  int _errors = 0;
  int _matches = 0;
  bool _busy = false;
  bool _resultSent = false;

  int? _lastScore;
  bool? _streakGained;

  List<_MemoryCard> _cards = [];
  _MemoryCard? _first;
  _MemoryCard? _second;

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  void _resetGame() {
    setState(() {
      _errors = 0;
      _matches = 0;
      _busy = false;
      _resultSent = false;
      _lastScore = null;
      _streakGained = null;
      _first = null;
      _second = null;
      _initCards();
    });
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
            await _sendGameResult("LOSE");
            _resetGame();
          },
        ),
      ],
    );
  }

  void _initCards() {
    final data = [
      (
        Icons.table_chart,
        Colors.blue,
        "Tabla dinámica",
        "Herramienta que resume y analiza datos"
      ),
      (
        Icons.filter_alt,
        Colors.green,
        "Segmentación de datos",
        "Botones para filtrar rápidamente"
      ),
      (
        Icons.bar_chart,
        Colors.orange,
        "Filtros",
        "Selecciona datos específicos"
      ),
      (
        Icons.calculate,
        Colors.purple,
        "Filas y Columnas",
        "Organizan la estructura de datos"
      ),
      (
        Icons.functions,
        Colors.red,
        "Gráficos Dinámicos",
        "Se actualizan cuando cambian los datos o filtros"
      ),
      (
        Icons.view_column,
        Colors.teal,
        "Valores",
        "Calcula: Suma, Promedio, Máximo y mínimo"
      ),
    ];

    List<_MemoryCard> temp = [];

    for (var i = 0; i < data.length; i++) {
      temp.add(
        _MemoryCard(
          pairId: i,
          icon: data[i].$1,
          color: data[i].$2,
          title: data[i].$3,
        ),
      );

      temp.add(
        _MemoryCard(
          pairId: i,
          icon: data[i].$1,
          color: data[i].$2,
          title: data[i].$4,
        ),
      );
    }

    temp.shuffle(Random());
    _cards = temp;
  }

  Future<void> _onTap(_MemoryCard card) async {
    final canPlay = await _checkLives();
    if (!canPlay) return;

    if (_busy || card.isMatched || card == _first) return;

    setState(() {
      card.isFlipped = true;
      if (_first == null) {
        _first = card;
      } else {
        _second = card;
        _busy = true;
      }
    });

    if (_first != null && _second != null) {
      await Future.delayed(const Duration(milliseconds: 700));

      if (_first!.pairId == _second!.pairId) {
        setState(() {
          _first!.isMatched = true;
          _second!.isMatched = true;
          _matches++;
        });

        if (_matches == totalPairs) {
          final result = await _sendGameResult("WIN");
          if (result != null) {
            _showWinDialog();
          }
        }
      } else {
        setState(() {
          _first!.isFlipped = false;
          _second!.isFlipped = false;
          _errors++;
        });

        if (_errors >= maxErrors) {
          await _sendGameResult("LOSE");
          _showLoseDialog();
        }
      }

      setState(() {
        _first = null;
        _second = null;
        _busy = false;
      });
    }
  }

  Future<GameResultResponse?> _sendGameResult(String status) async {
    if (_resultSent) return null;
    _resultSent = true;

    final token = await TokenStorage.getToken();
    if (token == null) return null;

    try {
      final result = await _gameResultService.sendResultOnlyErrors(
        token: token,
        gameId: 3,
        status: status,
        usedErrors: _errors,
        totalErrors: maxErrors,
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
          Text("✅ Aciertos: $_matches / $totalPairs"),
          Text("❌ Errores: $_errors / $maxErrors"),
          const SizedBox(height: 8),
          Text("🏆 Puntaje obtenido: ${_lastScore ?? 0}"),
          const SizedBox(height: 6),
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
            _resetGame();
          },
        ),
        DialogButton(
          text: "Volver",
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void exitGameAsLose() {
    _sendGameResult("LOSE");
  }

  void _showLoseDialog() {
    AppDialog.show(
      context: context,
      title: "❌ Perdiste",
      content: const Text("Alcanzaste el máximo de errores."),
      buttons: [
        DialogButton(
          text: "Reiniciar",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            _resetGame();
          },
        ),
        DialogButton(
          text: "Volver",
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
            "Tablas Dinámicas de Microsoft Excel",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.050 * widget.scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          MemoryStatsCards(
            errors: _errors,
            matches: _matches,
            totalPairs: totalPairs,
          ),
          const SizedBox(height: 8),
          MemoryGrid(
            cards: _cards,
            onTap: _onTap,
          ),
          const SizedBox(height: 8),
          MemoryRestartButton(
            onRestart: _showRestartConfirmDialog,
          ),
        ],
      ),
    );
  }
}

class _MemoryCard {
  final int pairId;
  final IconData icon;
  final String title;
  final Color color;

  bool isFlipped = false;
  bool isMatched = false;

  _MemoryCard({
    required this.pairId,
    required this.icon,
    required this.title,
    required this.color,
  });
}
