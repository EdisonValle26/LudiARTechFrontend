import 'package:LudiArtech/widgets/background.dart';
import 'package:LudiArtech/widgets/dialogs/game_instructions_dialog.dart';
import 'package:flutter/material.dart';

import 'widgets/sliding_puzzle_form.dart';
import 'widgets/sliding_puzzle_header.dart';

class SlidingPuzzleScreen extends StatefulWidget {
  const SlidingPuzzleScreen({super.key});

  @override
  State<SlidingPuzzleScreen> createState() => _SlidingPuzzleScreenState();
}

class _SlidingPuzzleScreenState extends State<SlidingPuzzleScreen> {
  final GlobalKey<SlidingPuzzleFormState> puzzleKey =
      GlobalKey<SlidingPuzzleFormState>();

  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoModal();
    });
  }

  void _showInfoModal() {
    if (_dialogShown) return;

    _dialogShown = true;

    showDialog(
      context: context,
      builder: (_) => const GameInstructionsDialog(
        imagePath: "TECH.png",
        title: "¡Hola! soy TECH",
        description:
            "¡Arma el rompecabezas!\n\nRecuerda: dispones de 10 vidas en total. Cada vez que pierdas una, deberás esperar 5 minutos para que se recupere.",
        instructions: [
          "Observa la imagen desordenada de los pasos para insertar una imagen.",
          "Haz clic en las piezas adyacentes al espacio vacío para moverlas.",
          "Desliza las piezas hasta que todas estén en su lugar correcto.",
          "Tienes 3 minutos para completar el rompecabezas; si se agota el tiempo, perderás 1 vida.",
          "Dispones de 100 movimientos; si superas este límite, perderás 1 vida."
        ],
        finalMessage: "¡Completa el rompecabezas en el menor tiempo posible!",
      ),
    ).then((_) {
      _dialogShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final scale = height < 800 ? height / 800 : 1.0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AppBackground(child: SizedBox()),
            Column(
              children: [
                SlidingPuzzleHeader(
                  scale: scale,
                  onExitConfirmed: () {
                    puzzleKey.currentState?.exitGameAsLose();
                  },
                  onInfoPressed: _showInfoModal,
                ),
                Expanded(
                  child: SlidingPuzzleForm(
                    key: puzzleKey,
                    scale: scale,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
