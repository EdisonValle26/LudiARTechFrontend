import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/back_button.dart';

class MemoryPairsHeader extends StatelessWidget {
  final double scale;
  final VoidCallback onExitConfirmed;
  final VoidCallback onInfoPressed;
  final VoidCallback onGuidePressed;

  const MemoryPairsHeader({
    super.key,
    required this.scale,
    required this.onExitConfirmed,
    required this.onInfoPressed,
    required this.onGuidePressed,
  });

  void showExitConfirmDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      title: "¿Salir del juego?",
      content: const Text(
        "Si sales ahora perderás una vida.\n¿Deseas continuar?",
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
            onExitConfirmed();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            width * 0.04 * scale,
            width * 0.15 * scale,
            width * 0.04 * scale,
            width * 0.03 * scale,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03 * scale,
              vertical: width * 0.035 * scale,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(18 * scale),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.015 * scale),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.collections_rounded,
                    color: Colors.lightBlueAccent,
                    size: width * 0.075 * scale,
                  ),
                ),
                SizedBox(width: width * 0.02 * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Empareja las cartas",
                        style: TextStyle(
                          fontSize: width * 0.055 * scale,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: width * 0.01 * scale),
                      Text(
                        "Tablas Dinámicas en Microsoft Excel",
                        style: TextStyle(
                          fontSize: width * 0.03 * scale,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onGuidePressed,
                      child: Container(
                        padding: EdgeInsets.all(width * 0.015 * scale),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.menu_book_outlined,
                          color: Colors.lightBlueAccent,
                          size: width * 0.05 * scale,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.02 * scale),
                    GestureDetector(
                      onTap: onInfoPressed,
                      child: Container(
                        padding: EdgeInsets.all(width * 0.015 * scale),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.lightBlueAccent,
                          size: width * 0.05 * scale,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        BackButtonWidget(
          scale: scale,
          onTap: () => showExitConfirmDialog(context),
        ),
      ],
    );
  }
}
