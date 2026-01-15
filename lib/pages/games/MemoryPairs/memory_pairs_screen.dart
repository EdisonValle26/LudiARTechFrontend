import 'package:LudiArtech/widgets/background.dart';
import 'package:LudiArtech/widgets/dialogs/game_instructions_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/memory_pairs_guide_dialog.dart';
import 'package:flutter/material.dart';

import 'widgets/memory_pairs_form.dart';
import 'widgets/memory_pairs_header.dart';

class MemoryPairsScreen extends StatefulWidget {
  const MemoryPairsScreen({super.key});

  @override
  State<MemoryPairsScreen> createState() => _MemoryPairsScreenState();
}

class _MemoryPairsScreenState extends State<MemoryPairsScreen> {
  final GlobalKey<MemoryPairsFormState> memoryKey =
      GlobalKey<MemoryPairsFormState>();

  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoModal();
    });
  }

  void _showGuideModal() {
    showDialog(
      context: context,
      builder: (_) => const MemoryPairsGuideDialog(),
    );
  }

  void _showInfoModal() {
    if (_dialogShown) return;

    _dialogShown = true;

    showDialog(
      context: context,
      builder: (_) => const GameInstructionsDialog(
        imagePath: "TECH.png",
        backgroundColor: Colors.lightBlueAccent,
        title: "¡Hola! soy TECH",
        description:
            "¡Empareja las cartas!\n\nRecuerda: dispones de 10 vidas en total. Cada vez que pierdas una, deberás esperar 5 minutos para que se recupere.",
        instructions: [
          "Empareja cada CONCEPTO (nombre) y su DEFINICIÓN correcta.",
          "Toca 2 cartas. Una debe ser el CONCEPTO (nombre) y la otra su DEFINICIÓN.",
          "Lee cuidadosamente antes de realizar cada emparejamiento.",
          "Dispones de hasta 6 errores; si los superas, perderás una vida."
        ],
        finalMessage: "¡Empareja las cartas con los menores errores posibles!",
      ),
    ).then((_) {
      _dialogShown = false;

      Future.delayed(const Duration(milliseconds: 100), () {
      _showGuideModal();
    });
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
                MemoryPairsHeader(
                  scale: scale,
                  onExitConfirmed: () {
                    memoryKey.currentState?.exitGameAsLose();
                  },
                  onInfoPressed: _showInfoModal,
                  onGuidePressed: _showGuideModal
                ),
                Expanded(
                  child: MemoryPairsForm(
                    key: memoryKey,
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
