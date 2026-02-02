import 'package:LudiArtech/pages/games/slide_elements/widgets/slide_elements_form.dart';
import 'package:LudiArtech/pages/games/slide_elements/widgets/slide_elements_header.dart';
import 'package:LudiArtech/widgets/background.dart';
import 'package:LudiArtech/widgets/dialogs/game_instructions_dialog.dart';
import 'package:flutter/material.dart';

class SlideElementsScreen extends StatefulWidget {
  const SlideElementsScreen({super.key});

  @override
  State<SlideElementsScreen> createState() => _SlideElementsScreenState();
}

class _SlideElementsScreenState extends State<SlideElementsScreen> {
  final GlobalKey<SlideElementsFormState> puzzleKey =
      GlobalKey<SlideElementsFormState>();

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
        backgroundColor: Color.fromARGB(255, 67, 158, 70),
        title: "¡Hola! soy TECH",
        description:
            "¡Conecta los elementos con sus funciones!\n\nRecuerda: dispones de 10 vidas en total. Cada vez que pierdas una, deberás esperar 5 minutos para que se recupere.",
        instructions: [
          "Conecta cada elemento de diseño con su definición correcta.",
          "Dispones de 2 minutos para resolver cada nivel.",
          "En cada nivel puedes cometer hasta 4 errores; si superas este límite, perderás una vida y deberás comenzar desde el inicio del juego."
        ],
        finalMessage: "¡Conecta los elementos con sus funciones en el menor tiempo posible!",
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
                SlideElementsHeader(
                  scale: scale,
                  onExitConfirmed: () {
                    puzzleKey.currentState?.exitGameAsLose();
                  },
                  onInfoPressed: _showInfoModal,
                ),
                Expanded(
                  child: SlideElementsForm(
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
