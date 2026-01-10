import 'package:LudiArtech/pages/games/power_point_expert/widgets/power_point_expert_form.dart';
import 'package:LudiArtech/pages/games/power_point_expert/widgets/power_point_expert_header.dart';
import 'package:LudiArtech/widgets/background.dart';
import 'package:LudiArtech/widgets/dialogs/game_instructions_dialog.dart';
import 'package:flutter/material.dart';

class PowerPointExpertScreen extends StatefulWidget {
  const PowerPointExpertScreen({super.key});

  @override
  State<PowerPointExpertScreen> createState() => _PowerPointExpertScreenState();
}

class _PowerPointExpertScreenState extends State<PowerPointExpertScreen> {
  final GlobalKey<PowerPointExpertFormState> gameKey =
      GlobalKey<PowerPointExpertFormState>();

  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  void _showInstructions() {
    if (_dialogShown) return;
    _dialogShown = true;

    showDialog(
      context: context,
      builder: (_) => const GameInstructionsDialog(
        imagePath: "TECH.png",
        backgroundColor: Colors.orange,
        title: "¡Hola! soy TECH",
        description:
            "¡Clasifica las partes de la interfaz de manera correcta!\n\nRecuerda: dispones de 10 vidas en total. Cada vez que pierdas una, deberás esperar 5 minutos para que se recupere.",
        instructions: [
          "Toca primero la etiqueta correcta que aparece en la parte inferior.",
          "Luego, arrastrala lugar exacto donde se encuentra esa parte dentro de la interfaz de PowerPoint.",
          "Cada acierto te permitirá avanzar en el juego.",
          "Si te equivocas, deberás interntar nuevamente.",
          "Dispondrás de 5 minutos para finalizar el juego."
        ],
        finalMessage: "¡Completa el juego en el menor tiempo posible!",
      ),
    ).then((_) => _dialogShown = false);
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
                PowerPointExpertHeader(
                  scale: scale,
                  onExitConfirmed: () {
                    gameKey.currentState?.exitGameAsLose();
                  },
                  onInfoPressed: _showInstructions,
                ),
                Expanded(
                  child: PowerPointExpertForm(
                    key: gameKey,
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
