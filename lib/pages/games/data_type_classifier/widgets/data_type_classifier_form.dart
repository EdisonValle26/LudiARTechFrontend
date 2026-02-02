import 'dart:async';

import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/game_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:flutter/material.dart';

class DataTypeClassifierForm extends StatefulWidget {
  final double scale;
  final VoidCallback? onExitGame;

  const DataTypeClassifierForm({
    super.key,
    required this.scale,
    this.onExitGame,
  });

  @override
  State<DataTypeClassifierForm> createState() => DataTypeClassifierFormState();
}

class DataTypeClassifierFormState extends State<DataTypeClassifierForm> {
  final GameResultService _gameResultService =
      GameResultService(ApiService(ApiConstants.baseUrl));
  int? _lastScore;
  bool? _streakGained;
  Timer? _timer;
  bool gameStarted = false;
  bool _resultSent = false;

  int remainingSeconds = 180;

  final Map<String, List<DataItem>> dropped = {
    "Número": [],
    "Texto": [],
    "Fecha y Hora": [],
  };

  List<DataItem> available = [];

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
    remainingSeconds = 180;
    gameStarted = false;
    _resultSent = false;

    available = [
      DataItem(
          "Nombre", "Laptop HP", "Texto", Icons.text_fields, Colors.blueAccent),
      DataItem("Stock", "45", "Número", Icons.numbers, Colors.lightGreen),
      DataItem(
          "Precio", "\$899.99", "Número", Icons.attach_money, Colors.yellow),
      DataItem(
          "Ingreso", "10:30:00", "Fecha y Hora", Icons.schedule, Colors.brown),
      DataItem("Categoría", "Tecnología", "Texto", Icons.category,
          Colors.yellowAccent),
    ];

    dropped.forEach((key, value) => value.clear());

    setState(() {});
  }

  void _startTimer() {
    if (gameStarted) return;
    gameStarted = true;

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

  String _formatTime() {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  bool get _canVerify => dropped.values.fold(0, (a, b) => a + b.length) == 5;

  Future<void> _verify() async {
    final canPlay = await _checkLives();
    if (!canPlay) return;

    bool ok = true;
    for (final list in dropped.values) {
      for (final item in list) {
        if (item.correctType != item.type) ok = false;
      }
    }

    if (ok) {
      _timer?.cancel();
      await _sendGameResult("WIN");
      _showWinDialog();
    } else {
      await _sendGameResult("LOSE");
      _showLoseDialog("Clasificación incorrecta");
    }
  }

  Future<void> exitGameAsLose() async {
    _timer?.cancel();
    await _sendGameResult("LOSE");
  }

  Future<GameResultResponse?> _sendGameResult(String status) async {
    if (_resultSent) return null;
    _resultSent = true;

    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final usedTime = 180 - remainingSeconds;

    try {
      final result = await _gameResultService.sendResultTime(
        token: token,
        gameId: 4,
        status: status,
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
            _initGame();
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

  void _showLoseDialog(String msg) {
    AppDialog.show(
      context: context,
      title: "❌ Perdiste una vida",
      content: Text(msg),
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
          text: "Salir",
          onPressed: () async {
            Navigator.pop(context);
            await exitGameAsLose();
            widget.onExitGame?.call();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _showNoLivesDialog() {
    AppDialog.show(
      context: context,
      title: "💔 Sin vidas",
      content: const Text(
          "Te quedaste sin vidas.\n\nDebes esperar 5 minutos para recuperar una vida."),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Tipo de Datos en Microsoft Excel",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22 * widget.scale, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _infoCard(),
          const SizedBox(height: 20),
          _availableDataCard(),
          const SizedBox(height: 20),
          _targetCategoriesCard(),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              _showRestartConfirmDialog();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Reiniciar Juego"),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Planilla de ventas",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Tiempo: ${_formatTime()}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 167, 131, 231),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                  "Registro de producto:\n"
                  "Nombre = 'Laptop HP'\n"
                  "Stock = 45\n"
                  "Precio = \$899.99\n"
                  "Ingreso = '10:30:00'\n"
                  "Categoría = Tecnología",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  )),
            ),
            const SizedBox(height: 10),
            const Text("Clasifica cada dato según su tipo"),
          ],
        ),
      ),
    );
  }

  Widget _availableDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Datos disponibles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Column(
              children: available.map(_draggableItem).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _targetCategoriesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Tipos de Datos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            _dropZone("Número", 2),
            _dropZone("Texto", 2),
            _dropZone("Fecha y Hora", 1),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 160,
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
            )
          ],
        ),
      ),
    );
  }

  Widget _draggableItem(DataItem item) {
    return Draggable<DataItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 300, child: _itemCard(item)),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _itemCard(item)),
      child: _itemCard(item),
    );
  }

  Widget _itemCard(DataItem item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 167, 131, 231),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: item.color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(item.value),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropZone(String type, int limit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Column(
          children: List.generate(limit, (i) {
            return DragTarget<DataItem>(
              onWillAccept: (item) {
                return i >= dropped[type]!.length;
              },
              onAccept: (item) {
                _startTimer();
                setState(() {
                  item.type = type;
                  dropped[type]!.add(item);
                  available.remove(item);
                });
              },
              onLeave: (item) {
                if (item != null &&
                    !available.contains(item) &&
                    !dropped[type]!.contains(item)) {
                  setState(() {
                    available.add(item);
                  });
                }
              },
              builder: (_, __, ___) {
                if (i < dropped[type]!.length) {
                  final item = dropped[type]![i];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        dropped[type]!.remove(item);
                        item.type = "";
                        available.add(item);
                      });
                    },
                    child: _itemCard(item),
                  );
                }

                return Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 167, 131, 231)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Arrastra aquí"),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class DataItem {
  final String title;
  final String value;
  final String correctType;
  final IconData icon;
  final Color color;
  String type = "";

  DataItem(this.title, this.value, this.correctType, this.icon, this.color);
}
