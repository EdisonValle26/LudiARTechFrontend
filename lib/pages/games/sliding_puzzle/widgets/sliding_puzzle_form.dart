import 'dart:async';
import 'dart:math';

import 'package:LudiArtech/models/puzzle_tile.dart';
import 'package:flutter/material.dart';

import 'puzzle_tile_widget.dart';

class SlidingPuzzleForm extends StatefulWidget {
  final double scale;
  const SlidingPuzzleForm({super.key, required this.scale});

  @override
  State<SlidingPuzzleForm> createState() => _SlidingPuzzleFormState();
}

class _SlidingPuzzleFormState extends State<SlidingPuzzleForm> {
  static const int gridSize = 3;

  late List<PuzzleTile> tiles;

  int remainingMoves = 20;
  int remainingSeconds = 180; // 3 minutos
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initGame();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ------------------ GAME INIT ------------------
  void _initGame() {
    remainingMoves = 20;
    remainingSeconds = 180;

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

  // ------------------ TIMER ------------------
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        _showLoseDialog("⏱ Se acabó el tiempo");
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  String _formatTime() {
    final min = remainingSeconds ~/ 60;
    final sec = remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  // ------------------ MOVEMENT ------------------
  void _onTileTap(int index) {
    final emptyIndex = tiles.indexWhere((t) => t.isEmpty);
    if (!_isAdjacent(index, emptyIndex)) return;

    setState(() {
      final temp = tiles[index];
      tiles[index] = tiles[emptyIndex];
      tiles[emptyIndex] = temp;
      remainingMoves--;
    });

    if (remainingMoves == 0) {
      _showLoseDialog("🔄 Se acabaron los movimientos");
      return;
    }

    if (_isSolved()) {
      _timer?.cancel();
      _showWinDialog();
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

  // ------------------ DIALOGS ------------------
  void _showLoseDialog(String reason) {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("❌ Perdiste una vida"),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGame();
              _startTimer();
            },
            child: const Text("Reiniciar"),
          )
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 ¡Felicidades!"),
        content: const Text("Completaste el proceso correctamente."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGame();
              _startTimer();
            },
            child: const Text("Reiniciar"),
          )
        ],
      ),
    );
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * widget.scale),
      child: Column(
        children: [
          // ---------- TITULO ----------
          Text(
            "Proceso de inserción de imagen en Microsoft Word",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.045 * widget.scale,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // ---------- INFO CARDS ----------
          Row(
            children: [
              _infoCard(
                title: "Tiempo",
                value: _formatTime(),
                icon: Icons.timer,
              ),
              const SizedBox(width: 12),
              _infoCard(
                title: "Movimientos",
                value: "$remainingMoves / 20",
                icon: Icons.swap_horiz,
              ),
            ],
          ),

          const SizedBox(height: 25),

          // ---------- PUZZLE ----------
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return PuzzleTileWidget(
                  tile: tiles[index],
                  onTap: () => _onTileTap(index),
                );
              },
            ),
          ),

          const SizedBox(height: 25),

          // ---------- MIX BUTTON ----------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shuffle),
              label: const Text("Mezclar"),
              onPressed: () {
                _initGame();
                _startTimer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(icon, size: 24, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
