import 'package:LudiArtech/widgets/background.dart';
import 'package:LudiArtech/widgets/dialogs/game_instructions_dialog.dart';
import 'package:flutter/material.dart';

import 'widgets/data_type_classifier_form.dart';
import 'widgets/data_type_classifier_header.dart';

class DataTypeClassifierScreen extends StatefulWidget {
  const DataTypeClassifierScreen({super.key});

  @override
  State<DataTypeClassifierScreen> createState() => _DataTypeClassifierScreenState();
}

class _DataTypeClassifierScreenState extends State<DataTypeClassifierScreen> {
  final GlobalKey<DataTypeClassifierFormState> puzzleKey =
      GlobalKey<DataTypeClassifierFormState>();

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
        backgroundColor: Color.fromARGB(255, 144, 107, 209),
        title: "¡Hola! soy TECH",
        description:
            "¡Clasifica los datos de manera correcta!\n\nRecuerda: dispones de 10 vidas en total. Cada vez que pierdas una, deberás esperar 5 minutos para que se recupere.",
        instructions: [
          "Clasifica datos según su tipo en Excel.",
          "Arrastra cada dato a su categoría correcta:\nNÚMERO (valores)\nTEXTO (palabras)\nFECHA Y HORA",
          "Dispones de 3 minutos para completar la actividad; si no lo logras, perderás una vida."       ],
        finalMessage: "¡Clasifica los datos de manera correcta en el menor tiempo posible!",
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
                DataTypeClassifierHeader(
                  scale: scale,
                  onExitConfirmed: () {
                    puzzleKey.currentState?.exitGameAsLose();
                  },
                  onInfoPressed: _showInfoModal,
                ),
                Expanded(
                  child: DataTypeClassifierForm(
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
